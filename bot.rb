# This bot logs into an irc channel, gets a list of all the IPs, run geolocation on them, and provides Stats about locations.

require 'geoip'
require 'cinch'
require "cinch/plugins/identify"
require 'yaml'

config = YAML.load_file("access.yml") 

@bot = Cinch::Bot.new do
  configure do |c|
    # add all required options here
    c.plugins.plugins = [Cinch::Plugins::Identify] # optionally add more plugins
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => config["env"]["nick"],
      :password => config["env"]["password"],
      :type     => :nickserv,
    }
    c.nick = "zotherstupidbot"
    c.server = "irc.freenode.org"
    c.channels = ["#anime"]
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"

    p "##################"
    p @bot.user_list

    @bot.user_list.each do |u|
      #p u.in_whois  
      p u.nick + " from " + u.host
      #p u.online?
      #p u.channels
      #p u.data
    end 
  end
end
@bot.start

=begin
Country = Struct.new(:name, :users, :number) do
  def Greetings 
    "Hello from #{name} ~ #{users}!"
  end
end

@countries = {}
File.readlines('ips').each do |line|
  begin
    # Use the country database:
    c = GeoIP.new('GeoLiteCity.dat').country(line)
    if @countries[c.country_name].nil? 
      @countries[c.country_name].number = 1 
    else
      @countries[c.country_name].number += 1
    end
    @countries[c.country_name].users += line 
    p c.country_name
  rescue
    print line +  " is difficult!"
  end
end

p @countries
=end
