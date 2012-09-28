#!/usr/bin/env ruby

require 'uservoice-ruby'
require 'yaml'

EMAIL_FORMAT = %r{^(\w[-+.\w!\#\$%&'\*\+\-/=\?\^_`\{\|\}~]*@([-\w]*\.)+[a-zA-Z]{2,9})$}
InvalidConfig = Class.new(RuntimeError)
begin
  config = YAML.load_file(File.expand_path('.uservoicerc', ENV['HOME']))

  unless config['subdomain_name'] && config['api_key'] && config['api_secret']
    puts "You didn't include these in your .uservoicerc:"
    %w(subdomain_name api_key api_secret).each do |attr|
      puts "  #{attr} was not set"
    end
    raise InvalidConfig
  end

  client = UserVoice::Client.new(config['subdomain_name'], config['api_key'], config['api_secret'])
  access_token = nil

  method, path, json_string = ARGV
  raise "Bad HTTP verb #{method}" unless %w(get put post delete).include?(method)
  raise "Bad path #{path}" unless path && path =~ /^\//

  access_token = client.login_with_access_token(config['access_token'], config['access_token_secret']) if config['access_token'] && config['access_token_secret']

  p (access_token || client).request(method, path, (JSON.parse(json_string) rescue nil))
rescue UserVoice::Unauthorized => e
  if e.to_s =~ /No user/
    puts "You are making requests as no user. Request an access token."
    puts "Type the email of the user whose access token you want (default: owner):"
    email = STDIN.gets.to_s.strip
    if access_token = case email
                      when EMAIL_FORMAT
                        puts "Ok, generating access token for #{email}."
                        client.login_as(email)
                      when nil, '', 'owner'
                        puts "Ok, generating access token for the subdomain owner. Be careful!"
                        client.login_as_owner
                      else
                        puts "Invalid email address, try again"
                      end
      puts "Perfect! Now add these two lines to your $HOME/.uservoice.rc:"
      puts "access_token: #{access_token.token}"
      puts "access_token_secret: #{access_token.secret}"
    end
  else
    puts e.to_s
  end
rescue Errno::ENOENT, InvalidConfig
  puts "A template of .uservoicerc in your home directory:"
  puts "subdomain_name: uservoice-subdomain"
  puts "api_key: YOUR-API-KEY-ADMIN-CONS"
  puts "api_secret: YOUR-API-SECRET-FROM-ADMIN-CONSOLE-HERE--"
end

