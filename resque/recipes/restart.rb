include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  resque_config do
    path deploy[:deploy_to]
    owner deploy[:user]
    group deploy[:group]
    bundler true
  end

  execute "restart resque for #{application}" do
    cwd deploy[:current_path]
    command "bluepill restart resque"
    action :nothing
  end

end
