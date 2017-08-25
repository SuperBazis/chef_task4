#
# Cookbook:: task4_nginx
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'nginx'

service 'nginx' do
  action [:enable,:start]
  supports :restart => true, :reload => true
end

nginx_lb 'change_lb' do
  role 'apache_server'
  action :attach
  notifies :restart, 'service[nginx]'
end

nginx_lb 'change_lb' do
  role 'jboss_server'
  action :attach
  notifies :restart, 'service[nginx]'
end
