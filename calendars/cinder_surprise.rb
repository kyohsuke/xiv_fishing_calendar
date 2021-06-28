module Calendar
  class CinderSurprise < Base
    def event_title
      'サプライズエッグ'
    end

    def area
      :amh_araeng
    end

    def weather
      :heat_waves
    end

    def duration(_)
      5.minutes
    end

    def attempt?(weather)
      return weather if weather.start_hour.zero? && weather.prev.weather == :dust_storms
    end
  end
end
