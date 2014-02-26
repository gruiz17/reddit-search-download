require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'json'

def reddit_search_download(title,file_format,subreddit,query,sort,t)
  def listy(subreddit,query,sort,t)
    fullname_list = []
    current_fullname = ''
    count = 0
    current_url = "http://www.reddit.com/r/#{subreddit}/search.json?q=#{query}&restrict_sr=on&sort=#{sort}&t=#{t}&limit=100"
    current_resp = Net::HTTP.get_response(URI.parse(current_url))
    buffer = current_resp.body
    current_json = JSON.parse(buffer)
    while !(current_fullname.nil?)
      count += 100
      current_fullname = current_json['data']['after']
      if !(current_fullname.nil?)
        puts "parsing #{current_fullname}"
        fullname_list << current_fullname
        current_url = "http://www.reddit.com/r/#{subreddit}/search.json?q=#{query}&restrict_sr=on&sort=#{sort}&t=#{t}&limit=100&count=#{count}&after=#{current_fullname}"
        current_resp = Net::HTTP.get_response(URI.parse(current_url))
        buffer = current_resp.body
        current_json = JSON.parse(buffer)
      end
    end
    return fullname_list
  end

  fullname_list = listy(file_format,subreddit,query,sort,t)

  if (file_format == "json")
    count = 0
    json_file = File.new("#{title}.json", "w")
    url = "http://www.reddit.com/r/#{subreddit}/search.json?q=#{query}&restrict_sr=on&sort=#{sort}&t=#{t}&limit=100"
    current_resp = Net::HTTP.get_response(URI.parse(url))
    buffer = current_resp.body
    current_json = JSON.parse(buffer)
    data = []
    current_json['data']['children'].each do |child|
      data << child['data']
    end

    fullname_list.each do |fullname|
      count += 100
      url = "http://www.reddit.com/r/#{subreddit}/search.json?q=#{query}&restrict_sr=on&sort=#{sort}&t=#{t}&limit=100&count=#{count}&after=#{fullname}"
      current_resp = Net::HTTP.get_response(URI.parse(url))
      buffer = current_resp.body
      current_json = JSON.parse(buffer)
      current_json['data']['children'].each do |child|
        data << child['data']
      end
    end
    json_hash = {"posts" => data}.to_json
    json_file << json_hash
    json_file.close

  elsif (file_format == "xml")
    xml_file = File.new("#{title}.xml", "w")
    xml_file << "<?xml version=\"1.0\"?>\n<posts>\n"
    count = 0
    url = "http://www.reddit.com/r/#{subreddit}/search.xml?q=#{query}&restrict_sr=on&sort=#{sort}&t=#{t}&limit=100"
    current_xml = Nokogiri::HTML(open(url))
    current_xml.css("item").each do |item|
      xml_file << "\n" unless (item == current_xml.css("item")[0])
      xml_file << item.to_xml
    end

    fullname_list.each do |fullname|
      count += 100
      url = "http://www.reddit.com/r/#{subreddit}/search.xml?q=#{query}&restrict_sr=on&sort=#{sort}&t=#{t}&limit=100&count=#{count}&after=#{fullname}"
      current_xml = Nokogiri::HTML(open(url))
      current_xml.css("item").each do |item|
        xml_file << "\n"
        xml_file << item.to_xml
      end
    end
    xml_file << "\n</posts>"
    xml_file.close
  end
end
