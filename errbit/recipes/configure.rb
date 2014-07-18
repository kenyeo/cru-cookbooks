include_recipe "deploy"
include_recipe "rails::configure"

deploy = node[:deploy][:errbit]

directory "#{deploy[:deploy_to]}" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end


directory "#{deploy[:deploy_to]}/shared" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end

directory "#{deploy[:deploy_to]}/shared/config" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end

directory "#{deploy[:deploy_to]}/shared/config/initializers" do
  action :create
  recursive true
  mode "0770"
  group deploy[:group]
  owner deploy[:user]
end

execute "generate session token" do
  command "cd #{deploy[:deploy_to]} && echo \"Errbit::Application.config.secret_token = '$(bundle exec rake secret)'\" > #{deploy[:deploy_to]}/shared/config/initializers/__secret_token.rb"
  action :run
  not_if { ::File.exists?("#{deploy[:deploy_to]}/shared/config/initializers/__secret_token.rb") }
end


execute "precompile assets" do
  command "cd #{deploy[:deploy_to]} && bundle exec rake assets:precompile RAILS_ENV=production"
  action :run
  not_if { ::File.exists?("#{deploy[:deploy_to]}/shared/config/initializers/__secret_token.rb") }
end


