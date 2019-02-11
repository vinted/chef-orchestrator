default['orchestrator']['config']['Debug'] = true
default['orchestrator']['config']['EnableSyslog'] = false
default['orchestrator']['config']['ListenAddress'] = ':3000'
default['orchestrator']['config']['AgentsServerPort'] = ':3001'
default['orchestrator']['config']['RaftEnabled'] = true
default['orchestrator']['config']['RaftDataDir'] = '/var/lib/orchestrator'
default['orchestrator']['config']['RaftBind'] = node['ipaddress']
default['orchestrator']['config']['DefaultRaftPort'] = 10_008
default['orchestrator']['config']['MySQLTopologyCredentialsConfigFile'] = ''
default['orchestrator']['config']['MySQLTopologySSLPrivateKeyFile'] = ''
default['orchestrator']['config']['MySQLTopologySSLCertFile'] = ''
default['orchestrator']['config']['MySQLTopologySSLCAFile'] = ''
default['orchestrator']['config']['MySQLTopologySSLSkipVerify'] = true
default['orchestrator']['config']['MySQLTopologyUseMutualTLS'] = false
default['orchestrator']['config']['MySQLTopologyMaxPoolConnections'] = 3
default['orchestrator']['config']['DatabaselessMode__experimental'] = false
default['orchestrator']['config']['MySQLOrchestratorHost'] = '127.0.0.1'
default['orchestrator']['config']['MySQLOrchestratorPort'] = 3306
default['orchestrator']['config']['MySQLOrchestratorCredentialsConfigFile'] = ''
default['orchestrator']['config']['MySQLOrchestratorSSLPrivateKeyFile'] = ''
default['orchestrator']['config']['MySQLOrchestratorSSLCertFile'] = ''
default['orchestrator']['config']['MySQLOrchestratorSSLCAFile'] = ''
default['orchestrator']['config']['MySQLOrchestratorSSLSkipVerify'] = true
default['orchestrator']['config']['MySQLOrchestratorUseMutualTLS'] = false
default['orchestrator']['config']['MySQLConnectTimeoutSeconds'] = 1
default['orchestrator']['config']['DefaultInstancePort'] = 3306
default['orchestrator']['config']['SkipOrchestratorDatabaseUpdate'] = false
default['orchestrator']['config']['SlaveLagQuery'] = ''
default['orchestrator']['config']['SlaveStartPostWaitMilliseconds'] = 1000
default['orchestrator']['config']['DiscoverByShowSlaveHosts'] = true
default['orchestrator']['config']['InstancePollSeconds'] = 12
default['orchestrator']['config']['ReadLongRunningQueries'] = true
default['orchestrator']['config']['UnseenInstanceForgetHours'] = 240
default['orchestrator']['config']['SnapshotTopologiesIntervalHours'] = 0
default['orchestrator']['config']['DiscoveryPollSeconds'] = 5
default['orchestrator']['config']['InstanceBulkOperationsWaitTimeoutSeconds'] = 10
default['orchestrator']['config']['ActiveNodeExpireSeconds'] = 12
default['orchestrator']['config']['HostnameResolveMethod'] = 'none'
default['orchestrator']['config']['MySQLHostnameResolveMethod'] = 'none'
default['orchestrator']['config']['SkipBinlogServerUnresolveCheck'] = true
default['orchestrator']['config']['ExpiryHostnameResolvesMinutes'] = 60
default['orchestrator']['config']['RejectHostnameResolvePattern'] = ''
default['orchestrator']['config']['ReasonableReplicationLagSeconds'] = 10
default['orchestrator']['config']['ProblemIgnoreHostnameFilters'] = []
default['orchestrator']['config']['VerifyReplicationFilters'] = false
default['orchestrator']['config']['MaintenanceOwner'] = 'orchestrator'
default['orchestrator']['config']['ReasonableMaintenanceReplicationLagSeconds'] = 20
default['orchestrator']['config']['MaintenanceExpireMinutes'] = 10
default['orchestrator']['config']['MaintenancePurgeDays'] = 365
default['orchestrator']['config']['CandidateInstanceExpireMinutes'] = 60
default['orchestrator']['config']['AuditLogFile'] =
  '/tmp/orchestrator-audit.log'
default['orchestrator']['config']['AuditToSyslog'] = false
default['orchestrator']['config']['AuditPageSize'] = 20
default['orchestrator']['config']['AuditPurgeDays'] = 365
default['orchestrator']['config']['RemoveTextFromHostnameDisplay'] =
  '.vinted.net:3306'
default['orchestrator']['config']['ReadOnly'] = false
default['orchestrator']['config']['AuthenticationMethod'] = 'multi'
default['orchestrator']['config']['AuthUserHeader'] = ''
default['orchestrator']['config']['PowerAuthUsers'] = ['*']
default['orchestrator']['config']['ClusterNameToAlias'] =
  { '127.0.0.1' => 'test suite' }
default['orchestrator']['config']['DetectClusterAliasQuery'] =
  'SELECT value FROM _vt.local_metadata WHERE name=\'ClusterAlias\''
default['orchestrator']['config']['DetectClusterDomainQuery'] = ''
default['orchestrator']['config']['DetectInstanceAliasQuery'] =
  'SELECT value FROM _vt.local_metadata WHERE name=\'Alias\''
default['orchestrator']['config']['DetectPromotionRuleQuery'] =
  'SELECT value FROM _vt.local_metadata WHERE name=\'PromotionRule\''
default['orchestrator']['config']['DataCenterPattern'] =
  '[.]([^.]+)[.][^.]+[.]vinted[.]net'
default['orchestrator']['config']['PhysicalEnvironmentPattern'] =
  '[.]([^.]+[.][^.]+)[.]vinted[.]net'
default['orchestrator']['config']['PromotionIgnoreHostnameFilters'] = []
default['orchestrator']['config']['DetectSemiSyncEnforcedQuery'] =
  'SELECT @@global.rpl_semi_sync_master_wait_no_slave AND @@global.rpl_semi_sync_master_timeout'\
  ' > 1000000'
default['orchestrator']['config']['ServeAgentsHttp'] = false
default['orchestrator']['config']['AgentsUseSSL'] = false
default['orchestrator']['config']['AgentsUseMutualTLS'] = false
default['orchestrator']['config']['AgentSSLSkipVerify'] = false
default['orchestrator']['config']['AgentSSLPrivateKeyFile'] = ''
default['orchestrator']['config']['AgentSSLCertFile'] = ''
default['orchestrator']['config']['AgentSSLCAFile'] = ''
default['orchestrator']['config']['AgentSSLValidOUs'] = []
default['orchestrator']['config']['UseSSL'] = false
default['orchestrator']['config']['UseMutualTLS'] = false
default['orchestrator']['config']['SSLSkipVerify'] = false
default['orchestrator']['config']['SSLPrivateKeyFile'] = ''
default['orchestrator']['config']['SSLCertFile'] = ''
default['orchestrator']['config']['SSLCAFile'] = ''
default['orchestrator']['config']['SSLValidOUs'] = []
default['orchestrator']['config']['StatusEndpoint'] = '/api/status'
default['orchestrator']['config']['StatusSimpleHealth'] = true
default['orchestrator']['config']['StatusOUVerify'] = false
default['orchestrator']['config']['HttpTimeoutSeconds'] = 60
default['orchestrator']['config']['AgentPollMinutes'] = 60
default['orchestrator']['config']['AgentAutoDiscover'] = false
default['orchestrator']['config']['UnseenAgentForgetHours'] = 6
default['orchestrator']['config']['StaleSeedFailMinutes'] = 60
default['orchestrator']['config']['SeedAcceptableBytesDiff'] = 8192
default['orchestrator']['config']['PseudoGTIDPattern'] =
  'drop view if exists .*?`_pseudo_gtid_hint__'
default['orchestrator']['config']['PseudoGTIDMonotonicHint'] = 'asc:'
default['orchestrator']['config']['DetectPseudoGTIDQuery'] = ''
default['orchestrator']['config']['BinlogEventsChunkSize'] = 10_000
default['orchestrator']['config']['BufferBinlogEvents'] = true
default['orchestrator']['config']['SkipBinlogEventsContaining'] = []
default['orchestrator']['config']['ReduceReplicationAnalysisCount'] = true
default['orchestrator']['config']['FailureDetectionPeriodBlockMinutes'] = 60
default['orchestrator']['config']['RecoveryPollSeconds'] = 10
default['orchestrator']['config']['RecoveryPeriodBlockMinutes'] = 1
default['orchestrator']['config']['RecoveryPeriodBlockSeconds'] = 60
default['orchestrator']['config']['RecoveryIgnoreHostnameFilters'] = []
default['orchestrator']['config']['RecoverMasterClusterFilters'] = ['.*']
default['orchestrator']['config']['RecoverIntermediateMasterClusterFilters'] =
  ['_intermediate_master_pattern_']
default['orchestrator']['config']['OnFailureDetectionProcesses'] = [
  "echo 'Detected {failureType} on {failureCluster}. Affected replicas: {countSlaves}' >> "\
  '/tmp/recovery.log'
]
default['orchestrator']['config']['PreFailoverProcesses'] = [
  "echo 'Will recover from {failureType} on {failureCluster}' >> /tmp/recovery.log"
]
default['orchestrator']['config']['PostFailoverProcesses'] = [
  "echo '(for all types) Recovered from {failureType} on {failureCluster}. "\
  'Failed: {failedHost}:{failedPort}; '\
  "Successor: {successorHost}:{successorPort}' >> /tmp/recovery.log"
]
default['orchestrator']['config']['PostUnsuccessfulFailoverProcesses'] = []
default['orchestrator']['config']['PostMasterFailoverProcesses'] = [
  "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; "\
  "Promoted: {successorHost}:{successorPort}' >> /tmp/recovery.log",
  'vtctlclient -server vtctld:15999 TabletExternallyReparented {successorAlias}'
]
default['orchestrator']['config']['PostIntermediateMasterFailoverProcesses'] = [
  "echo 'Recovered from {failureType} on {failureCluster}. Failed: {failedHost}:{failedPort}; "\
  "Successor: {successorHost}:{successorPort}' >> /tmp/recovery.log"
]
default['orchestrator']['config']['CoMasterRecoveryMustPromoteOtherCoMaster'] = true
default['orchestrator']['config']['DetachLostSlavesAfterMasterFailover'] =
  true
default['orchestrator']['config']['ApplyMySQLPromotionAfterMasterFailover'] = true
default['orchestrator']['config']['MasterFailoverLostInstancesDowntimeMinutes'] = 0
default['orchestrator']['config']['PostponeSlaveRecoveryOnLagMinutes'] = 0
default['orchestrator']['config']['OSCIgnoreHostnameFilters'] = []
default['orchestrator']['config']['GraphiteAddr'] = ''
default['orchestrator']['config']['GraphitePath'] = ''
default['orchestrator']['config']['GraphiteConvertHostnameDotsToUnderscores'] = true
