#
# Cookbook Name:: jboss7
# Attributes:: default
# Author:: Sascha Moellering


default['jboss']['home'] = "/srv/jboss"
default['jboss']['path'] = "jboss-as-7.1.1.Final"
default['jboss']['version'] = "7.1.1"
default['jboss']['url'] = "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip" 
default['jboss']['tarball'] = "jboss-as-7.1.1.Final.zip"
default['jboss']['user'] = "jboss"
default['jboss']['application'] = 'jboss'
default['jboss']['config'] = 'standalone'
default['jboss']['script'] = 'standalone.sh'
default['jboss']['manage_config_file'] = true

node.override[:java][:jdk_version] = '7'
node.override[:java][:install_flavor] = "oracle"
node.override[:java][:oracle][:accept_oracle_download_terms] = true

default['aws']['s3']['access_key'] = ""
default['aws']['s3']['secret_access_key'] = ""
default['aws']['s3']['bucket'] = ""

