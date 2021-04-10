module Calendar
  class TheRubyDragon < Base
    def attempts
      @attempts ||= EorzeaWeather.find(:clouds, :the_ruby_sea, max_attempts: ATTEMPTS, time: start_time(time: now)).select do |w|
        w.start_hour.zero? && w.prev.weather == :thunder
      end
    end
  end
end
