source "https://api.berkshelf.com"

metadata

def custom_cookbook(name, version = '>= 0.0.0', options = {})
  cookbook name, github: 'lokerd/cru-testing', branch: 'master', rel: name 
end

custom_cookbook 'chef-errbit-master'
