require 'open-uri'
require 'json'

def get_all_attributes(json, values=[], attr_name="text")
    json.map do |k, v|
        if k == attr_name
            values << v
        elsif v.is_a?(Hash)
            get_all_attributes(v, values, attr_name)
        elsif v.is_a?(Array)
            v.map {|item| get_all_attributes(item, values, attr_name)}
        end
    end
    values
end

tag_name = ARGV[0]
response = open("https://www.instagram.com/explore/tags/#{tag_name}/?__a=1").read
json = JSON.parse(response)
full_text = get_all_attributes(json).join(" ")
tag_pattern = /(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/
tags = full_text.scan(tag_pattern).uniq
puts "Tags: #{tags.join(" ")}"
puts "Found #{tags.length} tags"
