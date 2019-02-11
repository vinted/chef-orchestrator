describe file('/root/.my.cnf') do
  it { should exist }
end

describe service('mysql-orchestrator') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
