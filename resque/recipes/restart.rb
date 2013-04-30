include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  resque_config path: deploy[:deploy_to], owner: deploy[:user], group: deploy[:group], bundler: true

  execute "restart resque for #{application}" do
    cwd deploy[:current_path]
    command "bluepill restart resque"
    action :nothing
  end

end
