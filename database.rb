require 'data_mapper'
require 'dm-postgres-adapter'

DataMapper.setup :default, ENV['HEROKU_POSTGRESQL_WHITE_URL']

class Transaction
  include DataMapper::Resource

  property :id, Serial
  property :transaction_id, String
  property :to_address, String
  property :from_address, String
  property :from_name, String
  property :created_at, DateTime, :default => ->(r,b) { Time.now }

  has 1, :confirmation

  def send_card; end
end

class Confirmation
  include DataMapper::Resource

  property :id, Serial
  property :key, String

  belongs_to :transaction
end

DataMapper.finalize
DataMapper.auto_upgrade!
