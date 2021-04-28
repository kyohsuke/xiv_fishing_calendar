require 'icalendar'
require 'icalendar/tzinfo'
require 'digest'

class CalendarBuilder

  def initialize(title:, timezone: nil)
    @logger = Logger.new($stdout)

    @ical = Icalendar::Calendar.new.tap do |cal|
      cal.append_custom_property('X-WR-CALNAME;VALUE=TEXT', title)
    end
    @ical_timezone = TZInfo::Timezone.get(timezone).ical_timezone(Time.now)
    @ical.add_timezone @ical_timezone
  end

  def add(title:, start_date:, end_date: nil)
    if end_date
      add_event(title: title, start_date: start_date, end_date: end_date)
    else
      add_all_day_event(title: title, start_date: start_date)
    end
  end

  def to_ical
    ical.publish
    ical.to_ical
  end

  private

  attr_reader :ical, :ical_timezone, :logger


  def add_all_day_event(title:, start_date:)
    dtstart = start_date.to_datetime
    ical.event do |e|
      e.summary = title
      e.dtstart = Icalendar::Values::DateOrDateTime.new(dtstart.beginning_of_day.strftime('%Y%m%d'))
      e.dtend = Icalendar::Values::DateOrDateTime.new(dtstart.beginning_of_day.tomorrow.strftime('%Y%m%d')).call
      e.uid = digest(start_date: start_date, prefix: 'all-day')
    end
  end

  def add_event(title:, start_date:, end_date:)
    puts("#{title}, #{start_date.to_s(:db)} - #{end_date.to_s(:db)}") && return if ENV['DEBUG']

    dtstart = start_date.to_datetime
    dtend = end_date.to_datetime

    ical.event do |e|
      e.summary = title
      e.dtstart = Icalendar::Values::DateTime.new(dtstart, 'tzid' => dtstart.zone)
      e.dtend = Icalendar::Values::DateTime.new(dtend, 'tzid' => dtend.zone)
      e.uid = digest(start_date: start_date, end_date: end_date, prefix: 'event')
    end
  end

  def digest(start_date:, prefix:, end_date: nil)
    Digest::SHA256.hexdigest("#{prefix}:#{start_date.dup.utc}-#{end_date&.dup&.utc}")
  end
end
