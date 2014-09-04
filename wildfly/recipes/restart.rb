service 'wildfly' do
  service_name node['wildfly']['service_name']

  action :restart
end