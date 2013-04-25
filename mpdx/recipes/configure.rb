include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/config.yml" do
    source "config.yml.erb"
    cookbook 'mpdx'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:config => deploy[:config], :environment => deploy[:rails_env])

    notifies :run, resources(:execute => "restart Rails app #{application}")

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

end
