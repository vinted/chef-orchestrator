default['orchestrator']['database_backend'] = 'mysql'
default['orchestrator']['mysql']['version'] = '5.7'
default['orchestrator']['database']['name'] = 'orchestrator'
default['orchestrator']['database']['user'] = 'orchestrator'
default['orchestrator']['sqlite']['data_dir'] = '/var/lib/orchestrator/db'
default['orchestrator']['percona']['repo-package-url'] =
  'https://www.percona.com/redir/downloads/percona-release/redhat/0.1-6/'\
  'percona-release-0.1-6.noarch.rpm'
default['orchestrator']['database']['name'] = 'orchestrator'

default['orchestrator']['user'] = 'orchestrator'
default['orchestrator']['group'] = 'orchestrator'

default['orchestrator']['rpm_package']['orchestrator'] =
  'https://github.com/github/orchestrator/releases/download/v3.2.2/'\
  'orchestrator-3.2.2-1.x86_64.rpm'
default['orchestrator']['rpm_package']['orchestrator-client'] =
  'https://github.com/github/orchestrator/releases/download/v3.2.2/'\
  'orchestrator-client-3.2.2-1.x86_64.rpm'
default['orchestrator']['deb_package']['orchestrator'] =
  'https://github.com/openark/orchestrator/releases/download/v3.2.2/orchestrator_3.2.2_amd64.deb'
default['orchestrator']['deb_package']['orchestrator-client'] =
  'https://github.com/github/orchestrator/releases/download/v3.2.2/'\
  'orchestrator-client_3.2.2_amd64.deb'
