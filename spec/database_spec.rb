require 'spec_helper'

describe 'database' do
  before do
    mock_config do
      use_recipe :database
      set :deploy_to, '/foo/bar'
    end
  end

  describe 'database:configure' do
    it 'uploads config/database.yml' do
      mock_config.expects(:upload)
      cli_execute 'database:configure'
    end
  end
end