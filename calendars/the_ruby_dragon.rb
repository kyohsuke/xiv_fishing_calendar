module Calendar
  class TheRubyDragon < Base
    def event_title
      '紅龍'
    end

    def area
      :the_ruby_sea
    end

    def weather
      :clouds
    end

    def attempt?(weather)
      weather.start_hour.zero? && weather.prev.weather == :thunder
    end
  end
end
