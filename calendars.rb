require_relative 'calendars/base'
Dir.glob("#{__dir__}/calendars/*.rb").reject { |path| Pathname.new(path).basename.to_s.match? 'base.rb' }.each do |path|
  require path
end

module Calendar
  def self.classes
    Dir.glob("#{__dir__}/calendars/*.rb").reject { |path| Pathname.new(path).basename.to_s.match? 'base.rb' }.map do |path|
      "Calendar::#{Pathname.new(path).basename('.*').to_s.camelize}".constantize
    end
  end
end
