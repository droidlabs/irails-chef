define :setup_app_folders do
  app = node.run_state[:current_app]
  deploy_username = node[:deploy_user][:username]

  directory "/data/#{app[:name]}" do
    owner deploy_username
    group deploy_username
    mode "0770"
    action :create
  end

  directory "/data/#{app[:name]}/shared" do
    owner deploy_username
    group deploy_username
    mode "0770"
    action :create
  end

  directory "/data/#{app[:name]}/shared/config" do
    owner deploy_username
    group deploy_username
    mode "0770"
    action :create
  end

  directory "/data/#{app[:name]}/shared/log" do
    owner deploy_username
    group deploy_username
    mode "0770"
    action :create
  end

  directory "/data/#{app[:name]}/shared/tmp" do
    owner deploy_username
    group deploy_username
    mode "0770"
    action :create
  end

  include_recipe "logrotate"

  logrotate_app "rails_#{app[:name]}" do
    path "/data/#{app[:name]}/shared/log/*.log /data/#{app[:name]}/shared/log/*/*.log"
    rotate 12
  end
end