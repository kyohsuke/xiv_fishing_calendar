require_relative '../lib/calendar_builder'

module Calendar
  class Base
    ATTEMPTS_PER_DAY_IN_THE_EARTH = 61

    GENERATED_BEFORE_DAYS = 14.days
    GENERATED_AFTER_DAYS = 31.days
    ATTEMPTS = ((GENERATED_BEFORE_DAYS + 1.day + GENERATED_AFTER_DAYS).in_days * ATTEMPTS_PER_DAY_IN_THE_EARTH).to_i

    attr_reader :title, :timezone, :now

    def initialize(title:, timezone:, now: nil)
      @title = title
      @timezone = timezone
      @now = now
    end

    def generate(with_all_day: true)
      ical = CalendarBuilder.new(title: title, timezone: timezone)

      last_date = nil
      attempts.each do |attempt|
        start_time = attempt.start_time.dup.localtime
        end_time = attempt.end_time.dup.localtime

        if with_all_day
          curr_date = start_time.to_date
          if last_date != curr_date
            last_date = curr_date
            ical.add(title: '[XIV] 紅龍の出る日', start_date: start_time)
          end
        end

        ical.add(title: '[XIV] 紅龍', start_date: start_time, end_date: end_time)
      end
      ical.to_ical
    end

    def attempts
      raise NotImplementedError
    end

    def start_time(time: nil)
      time ||= Time.now
      (time - GENERATED_BEFORE_DAYS).utc
    end
  end
end
