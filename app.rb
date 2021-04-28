require 'digest'
require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative 'calendars'
Calendar.classes.each do |cls|
  cal = cls.new(timezone: 'Asia/Tokyo')
  next if ENV['DEBUG'] && ENV['DEBUG'] != cal.underscore

  ical = cal.generate
  File.open("./public/#{cal.filename}", 'w').write(ical)
end
