require 'data_mapper'
require 'dm-postgres-adapter'

DataMapper.setup :default, ENV['HEROKU_POSTGRES_WHITE_URL']

class Transaction
  include DataMapper::Resource

  property :id, Serial
  property :transaction_id, String
  property :to_address, String
  property :from_address, String
  property :from_name, String
  property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!
