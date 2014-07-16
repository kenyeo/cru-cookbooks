execute "add-apt-repository ppa:vbernat/haproxy-1.5 -y" do
  user "root"
end

execute "apt-get update" do
  user "root"
end

package 'haproxy' do
  action :install
  options '--force-yes'
end

if platform?('debian','ubuntu')
  template '/etc/default/haproxy' do
    source 'haproxy-default.erb'
    owner 'root'
    group 'root'
    mode 0644
  end
end

include_recipe 'haproxy::service'

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[haproxy]"
end

service 'haproxy' do
  action [:enable, :start]
end
