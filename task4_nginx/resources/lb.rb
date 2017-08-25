resource_name :nginx_lb
property :role,  String, default: 'bla-bla'

action :attach do

  template '/etc/nginx/nginx.conf' do
    source 'nginx.conf'
  end

  directory '/etc/nginx/lb' do
  user 'nginx'
  group 'nginx'
  mode '0775'
  action :create
  end

  template '/etc/nginx/conf.d/lb.conf' do
    source 'lb.conf.erb'
  end

  lb_nodes = search(:node, "role:#{role}")

  lb_nodes.each do |lb_node|
    file "/etc/nginx/lb/#{lb_node['network']['interfaces']['enp0s8']['routes'][0]['src']}.lb" do
      content "server #{lb_node['network']['interfaces']['enp0s8']['routes'][0]['src']};"
      action :create
    end
  end
end

action :detach do

  lb_nodes = search(:node, "role:#{role}")

  lb_nodes.each do |lb_node|
    file "/etc/nginx/lb/#{lb_node['network']['interfaces']['enp0s8']['routes'][0]['src']}.lb" do
      content "server #{lb_node['network']['interfaces']['enp0s8']['routes'][0]['src']};"
      action :delete
    end
  end
end
