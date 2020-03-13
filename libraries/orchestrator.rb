require 'poise'
require 'chef/resource'
require 'chef/provider'

class Chef
  class Resource
    # Orchestrator service installation and configuration resource
    class OrchestratorService < Chef::Resource
      include Poise
      require 'securerandom'

      provides(:orchestrator_service)
      actions(:install)

      attribute(
        :database_backend,
        kind_of: String,
        default: lazy { node['orchestrator']['database_backend'] }
      )
      attribute(
        :install_mysql,
        kind_of: [TrueClass, FalseClass],
        default: true
      )
      attribute(
        :mysql_root_password,
        kind_of: String,
        default: lazy { random_password }
      )
      attribute(
        :orchestrator_database_name,
        kind_of: String,
        default: lazy { node['orchestrator']['database']['name'] }
      )
      attribute(
        :orchestrator_database_user,
        kind_of: String,
        default: lazy { node['orchestrator']['database']['user'] }
      )
      attribute(
        :orchestrator_database_password,
        kind_of: String,
        default: lazy { 'secret' }
      )
      attribute(
        :mysql_topology_user,
        kind_of: String,
        default: lazy { 'topology' }
      )
      attribute(
        :mysql_topology_password,
        kind_of: String,
        default: lazy { 'secret' }
      )
      attribute(
        :http_user,
        kind_of: String,
        default: lazy { 'http_user' }
      )
      attribute(
        :http_password,
        kind_of: String,
        default: lazy { 'secret' }
      )
      attribute(
        :mysql_socket,
        kind_of: String,
        default: lazy { '/var/run/mysql-orchestrator/mysqld.sock' }
      )
      attribute(
        :raft_nodes,
        kind_of: Array,
        default: []
      )
      attribute(
        :reload_on_config_change,
        kind_of: [TrueClass, FalseClass],
        default: false
      )

      def random_password
        SecureRandom.hex
      end
    end
  end

  class Provider
    # Orchestrator service installation and configuration resource
    # rubocop:disable Metrics/ClassLength
    class OrchestratorService < Chef::Provider
      include Poise

      provides(:orchestrator_service)

      def action_install
        dependencies_install
        orchestrator_install
        orchestrator_system_user
        create_raft_directory
        mysql_db_install if install_mysql?
        mysql_db_setup if new_resource.database_backend == 'mysql'
        sqlite_db_install if new_resource.database_backend == 'sqlite'
        orchestrator_config
        orchestrator_service
      end

      def install_mysql?
        return true if new_resource.install_mysql && new_resource.database_backend == 'mysql'
      end

      # rubocop:disable Metrics/AbcSize
      def create_orchestrator_db_command
        backend_db_host = node['orchestrator']['config']['MySQLOrchestratorHost']
        <<~MYSQL
          "CREATE USER '#{new_resource.orchestrator_database_user}'@'#{backend_db_host}'
            IDENTIFIED BY '#{new_resource.orchestrator_database_password}';
          CREATE DATABASE #{node['orchestrator']['database']['name']} CHARACTER SET utf8mb4;
          GRANT ALL PRIVILEGES ON #{node['orchestrator']['database']['name']}.* TO
            '#{new_resource.orchestrator_database_user}'@'#{backend_db_host}';
          FLUSH PRIVILEGES;"
        MYSQL
      end
      # rubocop:enable Metrics/AbcSize

      def orchestrator_package(package)
        return node['orchestrator']['rpm_package'][package] if platform_family?('rhel')
        return node['orchestrator']['deb_package'][package] if platform_family?('debian')
      end

      def orchestrator_installed(package)
        return "rpm -qa | grep -q '^#{package}'" if platform_family?('rhel')
        return "dpkg -l | grep -q '#{package}'" if platform_family?('debian')
      end

      def sqlite_package_name
        return 'sqlite' if platform_family?('rhel')
        return 'sqlite3' if platform_family?('debian')
      end

      # Fix: for mysql community cookbook on Ubuntu Linux
      # https://github.com/sous-chefs/mysql/issues/539
      def update_root_password
        <<~MYSQL
          ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY
          '#{new_resource.mysql_root_password}';
        MYSQL
      end

      def reload_on_config_change
        new_resource.reload_on_config_change
      end

      def orchestrator_service_action
        reload_on_config_change ? :reload : :nothing
      end

      protected

      # Fix: mysql community cookbook does not set mysql community repo by default
      # https://github.com/sous-chefs/mysql/issues/443
      def set_mysql_community_repo
        mysql_version = node['orchestrator']['mysql']['version']
        yum_repository 'mysql-community' do
          baseurl "https://repo.mysql.com/yum/mysql-#{mysql_version}"\
            '-community/el/$releasever/$basearch/'
          gpgcheck false
          only_if { platform_family?('rhel') }
        end
      end

      def dependencies_install
        if platform_family?('rhel')
          package 'epel-release' do
            not_if 'yum repolist enabled | grep epel'
          end
        end
        package 'jq'
      end

      # rubocop:disable Metrics/AbcSize
      def mysql_db_install
        # Fix: mysql community cookbook does not set mysql community repo by default
        set_mysql_community_repo if platform_family?('rhel')
        mysql_service 'orchestrator' do
          version node['orchestrator']['mysql']['version']
          initial_root_password new_resource.mysql_root_password
          data_dir '/var/lib/mysql'
          action %i[create start]
        end
        update_root_password if platform_family?('debian') && !::File.exist?('/root/.my.cnf')
      end
      # rubocop:enable Metrics/AbcSize

      def sqlite_db_install
        package sqlite_package_name
        create_sqlite_data_directory
      end

      def mysql_db_setup
        create_credentials_file
        create_orchestrator_db
      end

      def create_sqlite_data_directory
        directory node['orchestrator']['sqlite']['data_dir'] do
          owner node['orchestrator']['user']
          group node['orchestrator']['group']
          mode 0o755
        end
      end

      def create_credentials_file
        template '/root/.my.cnf' do
          source 'root_my_cnf.erb'
          mode 0o644
          variables root_pass: new_resource.mysql_root_password
          not_if { ::File.exist?('/root/.my.cnf') }
          cookbook 'orchestrator'
          sensitive true
        end
      end

      def create_orchestrator_db
        execute 'create_orchestrator_database' do
          command "mysql -S #{new_resource.mysql_socket} "\
            "-e #{create_orchestrator_db_command}"
          sensitive true
          not_if "mysql -h #{node['orchestrator']['config']['MySQLOrchestratorHost']} -u "\
            "#{new_resource.orchestrator_database_user} " \
            "--password=#{new_resource.orchestrator_database_password} -e 'SELECT version()'"
        end
      end

      # rubocop:disable Metrics/AbcSize
      def orchestrator_install
        %w[
          orchestrator
          orchestrator-client
        ].each do |package|
          package_url = orchestrator_package(package)
          package_file = ::File.join(Chef::Config[:file_cache_path], ::File.basename(package_url))
          remote_file "Remote_file: #{package_url}" do
            path package_file
            source package_url
            not_if orchestrator_installed(package)
            mode 0o644
          end
          orhcestrator_package_rpm(package_file, package) if platform_family?('rhel')
          orhcestrator_package_deb(package_file, package) if platform_family?('debian')
        end
      end
      # rubocop:enable Metrics/AbcSize

      def orhcestrator_package_rpm(package_file, package)
        package "RPM package: #{package}" do
          source package_file
          not_if orchestrator_installed(package)
        end
      end

      def orhcestrator_package_deb(package_file, package)
        package 'jq'
        dpkg_package "DPKG package: #{package}" do
          source package_file
          not_if orchestrator_installed(package)
        end
      end

      def orchestrator_system_user
        group node['orchestrator']['group']

        user node['orchestrator']['user'] do
          comment 'Orchestrator daemon user'
          group node['orchestrator']['group']
          shell '/bin/false'
        end
      end

      def create_raft_directory
        directory node['orchestrator']['config']['RaftDataDir'] do
          owner node['orchestrator']['user']
          group node['orchestrator']['group']
          mode 0o755
        end
      end

      # rubocop:disable Metrics/AbcSize
      def orchestrator_config
        config = node['orchestrator']['config'].dup
        if new_resource.database_backend == 'mysql'
          config['MySQLOrchestratorDatabase'] = node['orchestrator']['database']['name']
          config['MySQLOrchestratorUser'] = new_resource.orchestrator_database_user
          config['MySQLOrchestratorPassword'] = new_resource.orchestrator_database_password
        else
          config['BackendDB'] = 'sqlite'
          config['SQLite3DataFile'] = "#{node['orchestrator']['sqlite']['data_dir']}/data.db"
        end
        config['MySQLTopologyUser'] = new_resource.mysql_topology_user
        config['MySQLTopologyPassword'] = new_resource.mysql_topology_password
        config['HTTPAuthUser'] = new_resource.http_user
        config['HTTPAuthPassword'] = new_resource.http_password
        config['RaftNodes'] = new_resource.raft_nodes
        generate_orchestrator_config(config)
      end
      # rubocop:enable Metrics/AbcSize

      def generate_orchestrator_config(config)
        file '/etc/orchestrator.conf.json' do
          sensitive true
          content JSON.pretty_generate(config)
          owner node['orchestrator']['user']
          group node['orchestrator']['group']
        end
      end

      def orchestrator_service
        delete_orchestrator_init_script
        systemd_unit 'orchestrator.service' do
          content <<-SYSTEMD
            [Unit]
            Description=vinted-orchestrator service
            After=network-online.target
            Wants=network-online.target
            [Service]
            ExecStart=/usr/local/orchestrator/orchestrator --verbose http
            ExecStop=/bin/kill -TERM $MAINPID
            ExecReload=/bin/kill -HUP $MAINPID
            Restart=always
            User=#{node['orchestrator']['user']}
            Group=#{node['orchestrator']['group']}
            WorkingDirectory=/usr/local/orchestrator
            [Install]
            WantedBy=multi-user.target
          SYSTEMD
          action %i[create enable start]
        end
        service 'orchestrator' do
          subscribes orchestrator_service_action, 'file[/etc/orchestrator.conf.json]'
        end
      end

      def delete_orchestrator_init_script
        file '/etc/init.d/orchestrator' do
          action :delete
          only_if { ::File.exist? '/etc/init.d/orchestrator' }
        end
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
