require 'digest'
require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative 'calendars'
Calendar.classes.each do |cls|
  cls.new(timezone: 'Asia/Tokyo').then do |cal|
    File.open("./public/#{cls.name.demodulize.underscore}.ics", 'w').write(cal.generate)
  end
end
