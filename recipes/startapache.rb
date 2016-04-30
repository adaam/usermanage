#
# Cookbook Name:: usermanage
# Recipe:: startapache
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
execute 'start_apache' do
  command 'httpd -k start'
  user 'root'
  group 'root'
  action :run
end
