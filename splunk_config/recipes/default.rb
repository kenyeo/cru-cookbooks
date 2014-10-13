# Cookbook Name:: splunk_config
# Recipe:: default
#


#configure splunk
user = node['splunk']['auth']
pass = node['splunk']['pass']
newpass = node['splunk']['newpass']
splunk_dir = node['splunk']['install_path']

begin
    resources('service[splunk]')
    rescue Chef::Exceptions::ResourceNotFound
    service 'splunk'
end

directory "#{splunk_dir}/etc/system/local" do
    recursive true
    owner node['splunk']['user']['username']
    group node['splunk']['user']['username']
end

directory "#{splunk_dir}/etc/apps/search/local" do
    recursive true
    owner node['splunk']['user']['username']
    group node['splunk']['user']['username']
    action :create
end

bash 'setup_as_service' do
if !File.exists?('/etc/init.d/splunk')
  user "root"
  cwd "#{splunk_dir}/bin"
  code <<-EOH
  ./splunk enable boot-start --accept-license --answer-yes
   EOH
  end
end

service 'splunk' do
  supports :status => true, :restart => true
  provider Chef::Provider::Service::Init
  action :start
end

bash 'change-admin-user-password-from-default' do
    if !File.exists?("#{splunk_dir}/etc/.setup_#{user}_password")
    user "root"
    cwd "#{splunk_dir}/bin"
    code <<-EOH
    ./splunk edit user #{user} -password #{newpass} -auth #{user}:#{pass}

    EOH
    end
end

file "#{splunk_dir}/etc/.setup_#{user}_password" do
    content 'true\n'
    owner 'root'
    group 'root'
    mode 00600
end

template "#{splunk_dir}/etc/system/local/outputs.conf" do
    source 'outputs.conf.erb'
    mode 0644
    variables(
    :default_group => node['splunk']['group'],
    :splunk_servers => node['splunk']['forward_server'],
    :splunk_port => node['splunk']['receiver_port']
             )
    notifies :restart, 'service[splunk]'
end

template "#{splunk_dir}/etc/apps/search/local/inputs.conf" do
    source 'inputs.conf.erb'
    mode 0644
    variables(
    :monitor_path => node['splunk']['monitor_path']
             )
    notifies :restart, 'service[splunk]'
end
