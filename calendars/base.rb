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

    def filename
      "#{underscore}.ics"
    end

    def underscore
      self.class.name.demodulize.underscore
    end

    def generate(all_day: true)
      ical = CalendarBuilder.new(title: calendar_title, timezone: timezone)

      last_date = nil
      weathers.each do |target_weather|
        start_time = target_weather.start_time.dup.localtime
        end_time = target_weather.end_time.dup.localtime

        if all_day
          curr_date = start_time.to_date
          if last_date != curr_date
            last_date = curr_date
            puts "[XIV] #{curr_date} #{all_day_title}" if ENV['DEBUG']
            ical.add(title: "[XIV] #{all_day_title}", start_date: start_time)
          end
        end

        start_date = start_time + (start_offset(target_weather) * ONE_HOUR_IN_EORZEA)
        end_date = end_time + (end_offset(target_weather) * ONE_HOUR_IN_EORZEA)
        dur = duration(target_weather)
        end_date = start_date + dur unless dur.nil?

        ical.add(title: "[XIV] #{event_title}", start_date: start_date, end_date: end_date)
      end
      ical.to_ical
    end

    def weathers
      @weathers ||= find_weather
        .map { |weather| attempt?(weather) }
        .uniq { |weather| weather&.start_time&.to_s }
        .compact
    end

    def start_offset(_)
      0
    end

    def end_offset(_)
      0
    end

    def attempt?(_)
      false
    end

    def duration(_)
      nil
    end

    def ongoing?(weather)
      attempt?(weather.prev)
    end

    def continue?(weather)
      attempt?(weather.succ)
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

    private

    def find_weather
      if weather.nil?
        return EorzeaWeather.forecasts(area, time: Time.now.utc, count: 100) if ENV['DEBUG']

        EorzeaWeather.forecasts(area, time: start_time(time: now), count: ATTEMPTS)
      else
        EorzeaWeather.find(weather, area, max_attempts: ATTEMPTS, time: start_time(time: now))
      end
    end
  end
end
