# TimeBoss ![Build Status](https://github.com/kevinstuffandthings/timeboss/actions/workflows/ruby.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/timeboss.svg)](https://badge.fury.io/rb/timeboss)

A gem providing convenient navigation of the [Broadcast Calendar](https://en.wikipedia.org/wiki/Broadcast_calendar), the standard Gregorian calendar, and is easily extensible to support multiple financial calendars.

Originally developed for [Simulmedia](https://simulmedia.com).

## Installation
Add this line to your application's Gemfile:

```ruby
# update with the version of your choice
gem 'timeboss'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install timeboss
```

## Usage
Supports `year`, `half`, `quarter`, `month`, `week`, and `day`.

Prepare your calendar for use:

```ruby
require 'timeboss/calendars/broadcast'

calendar = TimeBoss::Calendars::Broadcast.new
# => #<TimeBoss::Calendars::Broadcast:0x007f82d50f0af0 @basis=TimeBoss::Calendars::Broadcast::Basis>
```

You can ask simple questions of the calendar:

```ruby
period = calendar.parse('2019Q4') # or '2018', or '2019-12-21', or '2020W32', or '2020M3W2'
# => #<TimeBoss::Calendar::Quarter start_date=2019-09-30, end_date=2019-12-29>
period.to_s
# => "2019Q4: 2019-09-30 thru 2019-12-29"
period.next.start_date.to_s # try previous, too!
# => "2019-12-30"
(period + 3).start_date.to_s # try subtraction, too!
# => "2020-06-29"
period.offset(3).start_date.to_s # works with negatives, too!
# => "2020-06-29"
period.current? # does today fall within this period?
# => false

calendar.year_for(Date.parse('2018-12-31')).to_s
# => "2019: 2018-12-31 thru 2019-12-29"

calendar.this_month.to_s # your results may vary
# => "2019M12: 2019-11-25 thru 2019-12-29"

calendar.years_back(2).map { |y| y.start_date.to_s } # run in 2020
# => ["2018-12-31", "2019-12-30"]

calendar.months_ago(3).name # run in 2020M7
# => "2020M4"

calendar.weeks_ahead(3).name # run in 2020W29
# => "2020W32"
```

The resulting periods can be formatted a variety of (parsable) ways:

```ruby
entry = calendar.parse('2020W24')
entry.format
# => "2020H1Q2M3W2"

entry.format(:quarter)
# => "2020Q2W11"

entry.format(:quarter, :month)
# => "2020Q2M3W2"
```

_Note: all parsable descriptors should be ordered by chronological specificity (from least to most)_

Each type of period can give you information about its constituent periods:

```ruby
calendar.this_month.weeks.map(&:to_s)
# => ["2020M1W1: 2019-12-30 thru 2020-01-05", "2020M1W2: 2020-01-06 thru 2020-01-12", "2020M1W3: 2020-01-13 thru 2020-01-19", "2020M1W4: 2020-01-20 thru 2020-01-26"]

calendar.this_year.weeks.last.to_s
# => "2020W52: 2020-12-21 thru 2020-12-27"

calendar.last_month.quarter.title # today is 2020-07-15
# => "Q2 2020"

calendar.parse('2020Q1').months.map(&:name)
# => ["2020M1", "2020M2", "2020M3"]
```

Period shifting is easy. Note that the shifts are relative to today, not the base date. A shift examines the base period to find its offset into the shifting period size, and project it relative to now.

```ruby
calendar.parse('Q3').years_ago(5).title
# => "Q3 2015"

week = calendar.this_week # run 2020W29
"#{week.name}: #{week.in_quarter} of #{week.quarter.name}; #{week.in_year} of #{week.year.name}"
# => "2020W29: 3 of 2020Q3; 29 of 2020"

# run 2020W29, this generates the same as above, because shifts are relative to date run!
week = calendar.parse('2014W29').this_week
"#{week.name}: #{week.in_quarter} of #{week.quarter.name}; #{week.in_year} of #{week.year.name}"
# => "2020W29: 3 of 2020Q3; 29 of 2020"

calendar.this_week.next_year.to_s # run 2020W29
# => "2021W29: 2021-07-12 thru 2021-07-18"

calendar.week(2016, this_week.in_year) # run 2020-07-22
# => #<TimeBoss::Calendar::Week start_date=2016-07-18, end_date=2016-07-24>
```

Complicated range expressions can be parsed using the `..` range operator, or evaluated with `thru`:

```ruby
calendar.parse('2020M1 .. 2020M2').weeks.map(&:title)
# => ["Week of December 30, 2019", "Week of January 6, 2020", "Week of January 13, 2020", "Week of January 20, 2020", "Week of January 27, 2020", "Week of February 3, 2020", "Week of February 10, 2020", "Week of February 17, 2020"]

calendar.this_quarter.thru(calendar.this_quarter+2).months.map(&:name) # run in 2020Q3
# => ["2020M7", "2020M8", "2020M9", "2020M10", "2020M11", "2020M12", "2021M1", "2021M2", "2021M3"]

period = calendar.parse('2020W3..2020Q1')
"#{period.name}: from #{period.start_date} thru #{period.end_date} (current=#{period.current?})"
# => "2020W3 .. 2020Q1: from 2020-01-13 thru 2020-03-29 (current=false)"
```

The examples above are just samples. Try different periods, operators, etc. All of the non-week-based operations will work similarly on the `TimeBoss::Calendars::Gregorian` calendar.

### REPL
To open a [REPL](https://repl.it/github/kevinstuffandthings/timeboss) locally for the broadcast calendar, use the `tbsh` executable, or the `timeboss:calendars:broadcast:repl` rake task.

For the Gregorian calendar (or any other implemented calendars), supply the name on the command line.
- `tbsh gregorian`
- `rake timeboss:calendars:gregorian:repl`

You will find yourself in the context of an instantiated `TimeBoss::Calendar` object:

```bash
$ tbsh
2.4.1 :001 > next_quarter
 => #<TimeBoss::Calendar::Quarter start_date=2020-09-28, end_date=2020-12-27>
2.4.1 :002 > last_year
 => #<TimeBoss::Calendar::Year start_date=2018-12-31, end_date=2019-12-29>
2.4.1 :003 > parse('this_quarter .. this_quarter+4').months.map(&:name)
 => ["2020M7", "2020M8", "2020M9", "2020M10", "2020M11", "2020M12", "2021M1", "2021M2", "2021M3", "2021M4", "2021M5", "2021M6", "2021M7", "2021M8", "2021M9"]
```

If you want to try things out locally without installing the gem or updating your ruby environment, you can use [Docker](https://docker.com):

```bash
$ docker run --rm -it ruby:3.0-slim /bin/bash -c "gem install timeboss shellable >/dev/null && tbsh"
```

_Having trouble with the REPL? If you are using the examples from the [Usage](#Usage) section, keep in mind that the REPL is already in the context of the calendar -- so you don't need to specify the receiver!_

## Creating new calendars
To create a custom calendar, simply extend the `TimeBoss::Calendar` class, and implement a new `TimeBoss::Calendar::Support::MonthBasis` for it.

```ruby
require 'timeboss/calendar'
require 'timeboss/calendar/support/has_fiscal_weeks'

module MyCalendars
  class AugustFiscal < TimeBoss::Calendar
    # The calendar we wish to implement has "fiscal weeks", meaning that the weeks start on
    # the day of the containing period.
    include TimeBoss::Calendar::Support::HasFiscalWeeks

    def initialize
      # For each calendar, operation, the class will be instantiated with an ordinal value
      # for `year` and `month`. It is the instance's job to translate those ordinals into
      # `start_date` and `end_date` values, based on the desired behavior of the calendar.
      # With month rules defined, TimeBoss will be able to navigate all the relative periods
      # within the calendar.
      super(basis: Basis)
    end

    private

    class Basis < TimeBoss::Calendar::Support::MonthBasis
      # In this example, August is the first month of the fiscal year. So an incoming 2020/1
      # value would translate to a gregorian 2019/8.
      START_MONTH = 8

      def start_date
        @_start_date ||= begin
                           date = Date.civil(year_index, month_index, 1)
                           date - (date.wday + 7) % 7 # In this calendar, months start Sunday.
                         end
      end

      def end_date
        @_end_date ||= begin
                         date = Date.civil(year_index, month_index, -1)
                         date - (date.wday + 1)
                       end
      end

      private

      def month_index
        ((month + START_MONTH - 2) % 12) + 1
      end

      def year_index
        month >= START_MONTH ? year : year - 1
      end
    end
  end
end
```

With the new calendar implemented, it can be accessed in one of 2 ways:

- via traditional instantiation:

    ```ruby
    calendar = MyCalendars::AugustFiscal.new
    calendar.this_year
    ```

- via `TimeBoss::Calendars`:

    ```ruby
    require 'timeboss/calendars'
    TimeBoss::Calendars.register(:august_fiscal, MyCalendars::AugustFiscal)

    # You'll get a cached instance of your calendar here.
    # Handy when switching back and forth between different calendar implementations.
    calendar = TimeBoss::Calendars[:august_fiscal]
    calendar.this_year
    ```

# Problems?
Please submit an [issue](https://github.com/kevinstuffandthings/timeboss/issues).
We'll figure out how to get you up and running with TimeBoss as smoothly as possible.
