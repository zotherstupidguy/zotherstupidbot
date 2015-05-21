
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
