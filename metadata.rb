name 'orchestrator'
maintainer 'Vinted SRE'
maintainer_email 'sre@vinted.com'
license 'MIT'
description 'Installs/Configures github orchestrator'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/vinted/chef-orchestrator/issues'
source_url 'https://github.com/vinted/chef-orchestrator'
chef_version '>= 12.1' if respond_to?(:chef_version)
version '0.2.0'

supports 'redhat'
supports 'centos'
supports 'ubuntu'
supports 'debian'

depends 'poise', '~> 2.8.2'
depends 'mysql', '~> 8.5.1'
