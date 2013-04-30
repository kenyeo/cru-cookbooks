include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  directory "/var/bluepill" do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    recursive true
  end

  execute "touch /var/log/bluepill.log; chown #{deploy[:user]}:#{deploy[:group]} /var/log/bluepill.log"

  resque_config

end
