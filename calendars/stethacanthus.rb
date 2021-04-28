module Calendar
  class Stethacanthus < Base
    def event_title
      'ステタカントゥス'
    end

    def area
      :the_lochs
    end

    def weather
      nil
    end

    def attempt?(weather)
      return weather if innner_attempt?(weather) && !ongoing?(weather)
    end

    def start_offset(weather)
      weather.start_hour == 8 ? 4 : 0
    end

    def duration(weather)
      weather.weather == :thunderstorms ? 5.minutes : 2.minutes
    end

    private

    def innner_attempt?(weather)
      weather.start_hour == 16 && (scluptor?(weather) || scluptor?(weather.prev))
    end

    def scluptor?(weather)
      (weather.weather == :thunderstorms) && (weather.start_hour == 8 || weather.start_hour == 16)
    end
  end
end
