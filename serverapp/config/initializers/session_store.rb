# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_serverapp_session',
  :secret      => 'b4b6e69e95f9da214e62c5f0ee67beca8c6c74a7664f2d5b6a776c903d46aab2ba7079592a607f07815055da19935acee2a395c411514f8ed0f4918560691bda'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
