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
      #Resolv::DNS.new.each_address(u.host) { |addr| @countryk (u.nick + " from " + GeoIP.new('GeoLiteCity.dat').country(addr.to_s).country_name.to_s)}
      #Resolv::DNS.new.each_address(u.host) do |addr| 
      #@country[GeoIP.new('GeoLiteCity.dat').country(addr.to_s).country_name.to_s] = u.nick
      begin 
	#if @country[GeoIP.new('GeoLiteCity.dat').country(Resolv.getaddress(u.host.to_s)).country_name.to_s].nil? 
	p u.nick
	p u.host
	p @country[GeoIP.new('GeoLiteCity.dat').country(u.host).country_name.to_s] = [u.nick]
	#else
	#  @country[GeoIP.new('GeoLiteCity.dat').country( Resolv.getaddress(u.host.to_s))country_name.to_s] << u.nick
	#end

	#p GeoIP.new('GeoLiteCity.dat').country(m.user.host).country_name.to_s
	#m.reply "hey #{m.user.nick}, it seems that you are from #{GeoIP.new('GeoLiteCity.dat').country(m.user.host).country_name.to_s}" #, nearby there are #{@country[Resolv.getaddress(m.user.host).to_s].uniq!}"
      rescue Exception 
	#puts "#{$!} (#{$!.class})"
	#$stdout.flush
	#raise $!
	skip
      end
    end
  end 
  #m.reply "Hello, #{m.user.nick}"

  #p u.in_whois  
  #p u.nick + " from " + Resolv::DNS.new.each_address(u.host) { |addr| p addr }
  #Resolv::DNS.new.each_address(u.host) { |addr| m.reply(u.nick + " from " + addr.to_s) }
  #Resolv::DNS.new.each_address(u.host) { |addr| m.reply(u.nick + " from " + GeoIP.new('GeoLiteCity.dat').country(addr.to_s).country_name.to_s)}
  #p u.online?
  #p u.channels
  #p u.data
end
@bot.start
