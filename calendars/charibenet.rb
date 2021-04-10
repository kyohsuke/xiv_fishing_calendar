module Calendar
  class Charibenet < Base
    def event_title
      'シャリベネ'
    end

    def area
      :coerthas_western_highlands
    end

    def weather
      :blizzards
    end

    def attempt?(weather)
      weather.start_hour.zero?
    end

    def start_offset(_)
      0
    end

    def end_offset(_)
      -5
    end
  end
end
