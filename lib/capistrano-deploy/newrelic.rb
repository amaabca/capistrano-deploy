require 'new_relic/recipes'
module CapistranoDeploy
  module Newrelic
    def self.load_into(configuration)
      configuration.load do

        set(:new_relic_stages) { %w(production) }
        set(:new_relic_user) { (%x(git config user.name)).chomp }
        set(:current_revision) { capture("cd #{deploy_to} && git rev-parse HEAD").chomp }
        set(:link) { "https://api.newrelic.com/deployments.xml" }

        namespace :newrelic do

          task :notice_deployment, roles: :notification, only: { primary: true } do
            if new_relic_stages.include? current_stage
            run "curl -sH '#{new_relic_api_key}'
                -d 'deployment[app_name]=#{new_relic_app_name}'
                -d 'deployment[revision]=#{current_revision}'
                -d 'deployment[user]=#{new_relic_user}' #{link}"
            end
          end
        end

        after 'unicorn:reexec', 'newrelic:notice_deployment'
      end
    end
  end
end