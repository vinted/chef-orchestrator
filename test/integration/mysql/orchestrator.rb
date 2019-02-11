describe file('/usr/local/orchestrator/orchestrator') do
  it { should exist }
end

describe file('/usr/bin/orchestrator-client') do
  it { should exist }
end

describe directory('/var/lib/orchestrator') do
  it { should exist }
  its('group') { should eq 'orchestrator' }
  its('owner') { should eq 'orchestrator' }
end

describe service('orchestrator') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Wait for orchestrator service to come online
sleep(10)

describe http('http://localhost:3000/api/status',
              auth: { user: 'readonly', pass: 'any' },
              enable_remote_worker: true) do
  its('status') { should cmp 200 }
  its('body') { should include '"Code":"OK"' }
end
