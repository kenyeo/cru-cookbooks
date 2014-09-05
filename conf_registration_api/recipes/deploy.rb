
def json
  environment = {
    :name => 'targetEnvironment', :value => node['crs-api']['continuous-integration']['environment']
  }
  ip = {
    :name => 'targetServerIP', :value => node['opsworks']['instance']['private_ip']
  }
  password = {
    :name => 'deployerPassword', :value => node['wildfly']['deploy-password']
  }
  database_migration = {
    :name => 'databaseMigration', :value => node['crs-api']['continuous-integration']['database-migration']
  }

  json['parameter'] = Array.(environment,ip,password,database_migration)

end

execute 'deploy-from-jenkins' do
  puts(json)
  command 'curl -X POST ' + node['crs-api']['continuous-integration']['build-url'] + ' -d token=' + node['crs-api']['continuous-integration']['api-token'] + ' --data-urlencode json="' + json + '"'
end