# This bot logs into an irc channel, gets a list of all the IPs, run geolocation on them, and provides Stats about locations.

require 'geoip'
require 'cinch'
require "cinch/plugins/identify"
require 'yaml'
require 'resolv'

config = YAML.load_file("access.yml") 

@bot = Cinch::Bot.new do
  configure do |c|
    c.plugins.plugins = [Cinch::Plugins::Identify] # optionally add more plugins
    c.plugins.options[Cinch::Plugins::Identify] = {
      :username => config["env"]["nick"],
      :password => config["env"]["password"],
      :type     => :nickserv,
    }
    c.nick = "zotherstupidbot"
    c.server = "irc.freenode.org"
    c.channels = ["#bots"]
  end

  on :message, "nearby!" do |m|
    @country = {} 

    @bot.user_list.each do |u|
      begin 
	if @country[GeoIP.new('GeoLiteCity.dat').country(Resolv.getaddress(u.host.to_s)).country_name.to_s].nil? 
	  p u.nick
	  p u.host
	  @country[GeoIP.new('GeoLiteCity.dat').country(u.host).country_name.to_s] = [u.nick]
	else
	  @country[GeoIP.new('GeoLiteCity.dat').country(Resolv.getaddress(u.host)).country_name.to_s] << u.nick
	end
      rescue Exception 
	next
      end
    end
    p @country
    m.reply "#{m.user.nick}, it seems that you are in #{GeoIP.new('GeoLiteCity.dat').country(m.user.host).country_name.to_s}, nearby #{@@country[Resolv.getaddress(m.user.host).to_s]}" 
  end 

end

@bot.start
