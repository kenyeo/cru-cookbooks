chef_gem 'jenkins_api_client'

ruby_block 'deploy-from-jenkins' do
  require 'jenkins_api_client'

  # these variables have not been checked against the stack settings!!
  
  @client = JenkinsApi::Client.new(:server_ip => node['crs-api']['continuous_integration']['hostname'],
                                   :username => node['crs-api']['continuous_integration']['username'],
                                   :password => node['crs-api']['continuous_integration']['password'])

  job_params = Hash.new()
  job_params['targetEnvironment'] = node['crs-api']['continuous_integration']['target_environment']
  job_params['targetServerIP'] = node['opsworks']['instance']['private_ip']
  job_params['databaseMigration'] = node['crs-api']['continuous_integration']['database_migration']
  job_params['deployerPassword'] = node['crs-api']['wildfly']['deploy_password']

  @client.job.build(node['crs-api']['continuous_integration']['job_name'], job_params, {})
end