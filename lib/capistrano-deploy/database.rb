module CapistranoDeploy
  module Database
    def self.load_into(configuration)
      configuration.load do
        namespace :database do
          desc 'Generate database.yml'
          task :configure, :roles => :app, :except => {:no_release => true} do
            database_yml = <<-EOF
#{ENV['DB_ENV']}:
  adapter: #{ENV['DB_ADAPTER']}
  host: #{ENV['DB_HOST']}
  port: #{ENV['DB_PORT']}
  encoding: #{ENV['DB_ENCODING']}
  database: #{ENV['DB_NAME']}
  pool: #{ENV['DB_POOL']}
  username: #{ENV['DB_USER']}
  password: #{ENV['DB_PASSWORD']}
            EOF

            put database_yml, "#{deploy_to}/config/database.yml"
          end
        end
      end
    end
  end
end