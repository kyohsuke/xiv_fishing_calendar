require_relative '../lib/calendar_builder'

module Calendar
  class Base
    ONE_HOUR_IN_EORZEA = 175.seconds
    ATTEMPTS_PER_DAY_IN_THE_EARTH = 61

    GENERATED_BEFORE_DAYS = 14.days
    GENERATED_AFTER_DAYS = 31.days
    ATTEMPTS = ((GENERATED_BEFORE_DAYS + 1.day + GENERATED_AFTER_DAYS).in_days * ATTEMPTS_PER_DAY_IN_THE_EARTH).to_i

    attr_reader :timezone, :now

    def initialize(timezone:, now: nil)
      @timezone = timezone
      @now = now
    end

    def generate(all_day: true)
      ical = CalendarBuilder.new(title: calendar_title, timezone: timezone)

      last_date = nil
      weathers.each do |weathers|
        start_time = weathers.start_time.dup.localtime
        end_time = weathers.end_time.dup.localtime

        if all_day
          curr_date = start_time.to_date
          if last_date != curr_date
            last_date = curr_date
            ical.add(title: "[XIV] #{all_day_title}", start_date: start_time)
          end
        end

        ical.add(
          title: "[XIV] #{event_title}",
          start_date: start_time + (start_offset(weather) * ONE_HOUR_IN_EORZEA),
          end_date: end_time + (end_offset(weather) * ONE_HOUR_IN_EORZEA)
        )
      end
      ical.to_ical
    end

    def weathers
      @weathers ||= EorzeaWeather.find(weather, area, max_attempts: ATTEMPTS, time: start_time(time: now)).select do |weather|
        attempt?(weather)
      end
    end

    def start_offset(_)
      0
    end

    def end_offset(_)
      0
    end

    def attempt?(_)
      true
    end

    def calendar_title
      "#{event_title}カレンダー"
    end

    def all_day_title
      "#{event_title}の出る日"
    end

    def event_title
      raise NotImplementedError
    end

    def start_time(time: nil)
      time ||= Time.now
      (time - GENERATED_BEFORE_DAYS).utc
    end
  end
end
