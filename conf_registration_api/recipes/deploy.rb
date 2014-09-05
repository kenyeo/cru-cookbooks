chef_gem 'json'

execute 'deploy-from-jenkins' do
  require 'json'

  environment = {
      :name => 'targetEnvironment', :value => node['crs-api']['continuous-integration']['environment']
  }
  ip = {
      :name => 'targetServerIP', :value => node['opsworks']['instance']['private_ip']
  }
  password = {
      :name => 'deployerPassword', :value => node['wildfly']['deploy_password']
  }
  database_migration = {
      :name => 'databaseMigration', :value => node['crs-api']['continuous-integration']['database-migration']
  }

  json = Hash.new()
  json['parameter'] = Array.new()
  json['parameter'].push(environment)
  json['parameter'].push(ip)
  json['parameter'].push(password)
  json['parameter'].push(database_migration)

  puts(%Q[JSON.generate(json, quirks_mode: true)])
  puts('curl -X POST ' + node['crs-api']['continuous-integration']['build-url'] + ' -d json=' + %Q[JSON.generate(json, quirks_mode: true)])
  command 'curl -X POST ' + node['crs-api']['continuous-integration']['build-url'] + ' -d json=' + %Q[JSON.generate(json, quirks_mode: true])
  :run
end