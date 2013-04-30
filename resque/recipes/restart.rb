include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application] || {}
  bluepill = deploy[application][:bluepill] || {}

  resque_config application do
    path deploy[:deploy_to]
    owner deploy[:user]
    group deploy[:group]
    bundler true
    envs [deploy[:rails_env]]
  end

  execute "load bluepill file for #{application}" do
    cwd deploy[:current_path]
    command "bundle exec bluepill load #{path}/shared/resque.pill"
    action :nothing
  end

  execute "restart resque for #{application}" do
    cwd deploy[:current_path]
    command "bundle exec bluepill restart resque"
    action :nothing
  end

end
