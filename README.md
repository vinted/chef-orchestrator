# orchestrator

Cookbook provides resource for creating github-orchestrator instances
https://github.com/github/orchestrator


**Usage**

```
 orchestrator_service 'default' do
   database_backend 'mysql/sqlite'
   install_mysql true/false
   mysql_root_password 'password'
   orchestrator_database_name 'orchestrator'
   orchestrator_database_user 'orchestrator'
   orchestrator_database_password 'secret'
   mysql_topology_user 'topology'
   mysql_topology_password 'password'
   http_user 'http_user'
   http_password 'secret'
   raft_nodes []
 end
 ```
Cookbook will install fresh mysql instance and configure it to serve orchestrator node.

 All of the above attributes are optional, though recommended for production.
 If `mysql_root_password` is not defined, random mysql root password will be generated upon installation and saved into `/root/.my.cnf` credentials file.
 If you want to manually setup mysql instance, you can skip mysql installation by setting `install_mysql` to `false`.

**Cookbook dependencies**

Depends on:
`mysql`
`poise`


[![Build Status](https://travis-ci.org/vinted/chef-orchestrator.svg?branch=master)](https://travis-ci.org/vinted/chef-orchestrator)
