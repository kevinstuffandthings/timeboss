# TimeBoss [![Build Status](https://travis-ci.com/kevinstuffandthings/timeboss.svg?branch=master)](https://travis-ci.com/kevinstuffandthings/timeboss) [![Gem Version](https://badge.fury.io/rb/timeboss.svg)](https://badge.fury.io/rb/timeboss)
A gem providing convenient navigation of the [Broadcast Calendar](https://en.wikipedia.org/wiki/Broadcast_calendar).

_This is a work in progress. Check back soon for the initial release!_

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

You can find the gem on [RubyGems](https://rubygems.org/gems/timeboss).

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
# => #<TimeBoss::Calendar::Quarter:0x007f82d50e2478>
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

calendar.weeks_hence(3).name # run in 2020W29
# => "2020W32"
```

The resulting periods can be formatted a variety of (parsable) ways:
```ruby
entry = calendar.parse('2020M24')
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

The examples above are just samples. Try different periods, operators, etc.

### Shell
To open an IRB shell for the broadcast calendar, use the `timeboss:calendars:broadcast:shell` rake task.
You will find yourself in the context of an instantiated `TimeBoss::Calendars::Broadcast` object:
```bash
$ rake timeboss:calendars:broadcast:shell
2.4.1 :001 > next_quarter
 => #<TimeBoss::Calendar::Quarter:0x007fe04c16a1c8 @calendar=#<TimeBoss::Calendars::Broadcast:0x007fe04c1a0458 @basis=TimeBoss::Calendars::Broadcast::Basis>, @year_index=2020, @index=4, @start_date=#<Date: 2020-09-28 ((2459121j,0s,0n),+0s,2299161j)>, @end_date=#<Date: 2020-12-27 ((2459211j,0s,0n),+0s,2299161j)>>
2.4.1 :002 > last_year
 => #<TimeBoss::Calendar::Year:0x007fe04c161ca8 @calendar=#<TimeBoss::Calendars::Broadcast:0x007fe04c1a0458 @basis=TimeBoss::Calendars::Broadcast::Basis>, @year_index=2019, @index=1, @start_date=#<Date: 2018-12-31 ((2458484j,0s,0n),+0s,2299161j)>, @end_date=#<Date: 2019-12-29 ((2458847j,0s,0n),+0s,2299161j)>>
2.4.1 :003 > parse('this_quarter .. this_quarter+4').months.map(&:name)
 => ["2020M7", "2020M8", "2020M9", "2020M10", "2020M11", "2020M12", "2021M1", "2021M2", "2021M3", "2021M4", "2021M5", "2021M6", "2021M7", "2021M8", "2021M9"]
```

_Having trouble with the shell? If you are using the examples from the [Usage](#Usage) section, keep in mind that the shell is already in the context of the calendar -- so you don't need to specify the receiver!_

## Creating new calendars
To create a custom calendar, simply extend the `TimeBoss::Calendar` class, and implement a new `TimeBoss::Calendar::Support::MonthBasis` for it.

```ruby
require 'timeboss/calendar'

module MyCalendars
  class AugustFiscal < TimeBoss::Calendar
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
  calendar = TimeBoss::Calendars[:august_fiscal]
  calendar.this_year
  ```

## TODO
- [x] Add gem deployment via [Travis-CI](https://docs.travis-ci.com/user/deployment/rubygems/#:~:text=Travis%20CI%20can%20automatically%20release,RubyGems%20after%20a%20successful%20build.&text=If%20you%20tag%20a%20commit,tags%20are%20uploaded%20to%20GitHub.&text=You%20will%20be%20prompted%20to,key%20on%20the%20command%20line.)
