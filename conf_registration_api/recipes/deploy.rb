execute 'deploy-from-jenkins' do

  environment = "{\"name\": \"targetEnvironment\", \"value\" : \"" + node['crs-api']['continuous-integration']['environment'] + "\"}"
  ip = "{\"name\": \"targetServerIP\", \"value\" : \"" + node['opsworks']['instance']['private_ip'] + "\"}"
  password = "{\"name\": \"deployerPassword\", \"value\" : \"" + node['wildfly']['deploy_password'] + "\"}"
  database_migration = "{\"name\": \"databaseMigration\", \"value\" : \"" + node['crs-api']['continuous-integration']['database-migration'] + "\"}"

  json = "{ \"parameter\" :[" + environment + ',' + ip + ',' + password + ',' + database_migration + ']}'

  puts(json)
  puts('curl -X POST ' + node['crs-api']['continuous-integration']['build-url'] + ' -d json=' + json)
  command 'curl -X POST ' + node['crs-api']['continuous-integration']['build-url'] + ' -d json=' + json
  :run
end