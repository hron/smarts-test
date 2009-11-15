# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_calculator_session',
  :secret      => '0170ca1c4a6afc0574bca35029c8a6a1f94b1ef8eebbf3b4eda8289f58ec55511b2dca78e6d3efa054ba6e81e104c7b71098b72157c94bd2c3988f9bcdf6d8f3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
