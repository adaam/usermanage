#
# Cookbook Name:: usermanage
# Recipe:: installapache
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe 'apache2::default'
include_recipe 'usermanage::startapache'
