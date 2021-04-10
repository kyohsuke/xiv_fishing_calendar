require 'digest'
require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative 'lib/calendar_builder'
Dir.glob("#{__dir__}/calendars/*.rb").each do |calendar|
  require calendar
end

Calendar::TheRubyDragon.new(title: '紅龍カレンダー', timezone: 'Asia/Tokyo').then do |cal|
  File.open('./public/the_ruby_dragon.ics', 'w').write(cal.generate)
end

