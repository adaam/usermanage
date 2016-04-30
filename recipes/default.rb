#
# Cookbook Name:: usermanage
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

users = data_bag('users')
users.each do |login|
  user = data_bag_item('users', login)
  home = "/home/#{login}"
  user(login) do
    uid       user['uid']
    gid       user['gid']
    shell     user['shell']
    password  user['password']
    comment   user['comment']
    home      home
    supports  :manage_home => true
  end
  
        directory "#{home}/.ssh" do
          owner user['uid'] ? validate_id(user['uid']) : user['username']
          group validate_id(user['gid']) if user['gid']
          mode '0700'
          only_if { user['ssh_keys'] || user['ssh_private_key'] || user['ssh_public_key'] }
        end

        template "#{home}/.ssh/authorized_keys" do
          source 'authorized_keys.erb'
          owner user['uid'] ? validate_id(user['uid']) : user['username']
          group validate_id(user['gid']) if user['gid']
          mode '0600'
          variables ssh_keys: user['ssh_keys']
          only_if { user['ssh_keys'] }
        end

        if user['ssh_private_key']
          key_type = user['ssh_private_key'].include?('BEGIN RSA PRIVATE KEY') ? 'rsa' : 'dsa'
          template "#{home}/.ssh/id_#{key_type}" do
            source 'private_key.erb'
            owner user['uid'] ? validate_id(user['uid']) : user['username']
            group validate_id(user['gid']) if user['gid']
            mode '0400'
            variables private_key: user['ssh_private_key']
          end
        end

        if user['ssh_public_key']
          key_type = user['ssh_public_key'].include?('ssh-rsa') ? 'rsa' : 'dsa'
          template "#{home}/.ssh/id_#{key_type}.pub" do
            source 'public_key.pub.erb'
            owner user['uid'] ? validate_id(user['uid']) : user['username']
            group validate_id(user['gid']) if user['gid']
            mode '0400'
            variables public_key: user['ssh_public_key']
          end
        end

end

user 'testing' do
  comment 'A random user'
  home '/home/testing'
  shell '/bin/bash'
  password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end

users_manage 'testgroup2' do
  action [:create]
  data_bag 'users'
end
