# TimeBoss
A gem providing convenient navigation of the [Broadcast Calendar](https://en.wikipedia.org/wiki/Broadcast_calendar).

_This is a work in progress. Check back soon for the initial release!_

## Installation
Add this line to your application's Gemfile:
```ruby
# update with the version of your choice
gem 'timeboss', '0.0.1', git: "https://github.com/kevinstuffandthings/timeboss.git"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install timeboss
```

## Usage
Supports `year`, `half`, `quarter`, `month`, `week`, and `date`.

```ruby
calendar = TimeBoss::BroadcastCalendar.new
# => #<TimeBoss::BroadcastCalendar:0x007f82d50f0af0 @basis=TimeBoss::BroadcastCalendar::Basis>

period = calendar.parse('2019Q4') # or '2018', or '2018M3', or '2019-12-21', or '2020W32', or '2020M3W2'
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

Additionally, each type of period can give you information about its constituent periods

```ruby
calendar.this_month.weeks.map(&:to_s)
# => ["2020M1W1: 2019-12-30 thru 2020-01-05", "2020M1W2: 2020-01-06 thru 2020-01-12", "2020M1W3: 2020-01-13 thru 2020-01-19", "2020M1W4: 2020-01-20 thru 2020-01-26"]

calendar.this_year.weeks.last.to_s
# => "2020W52: 2020-12-21 thru 2020-12-27"

calendar.parse('2020Q1').months.map(&:name)
# => ["2020M1", "2020M2", "2020M3"]
```

Period shifting is easy:

```ruby
calendar.parse('Q3').years_ago(5).title
# => "Q3 2015"

calendar.this_week.next_year.to_s # run 2020W29
# => "2021W29: 2021-07-12 thru 2021-07-18"
```

Complicated range expressions can be parsed using the `..` range operator:

```ruby
calendar.parse('2020M1 .. 2020M2').weeks.map(&:title)
# => ["Week of December 30, 2019", "Week of January 6, 2020", "Week of January 13, 2020", "Week of January 20, 2020", "Week of January 27, 2020", "Week of February 3, 2020", "Week of February 10, 2020", "Week of February 17, 2020"]

calendar.parse('this_quarter .. this_quarter+2').months.map(&:name) # run in 2020Q3
# => ["2020M7", "2020M8", "2020M9", "2020M10", "2020M11", "2020M12", "2021M1", "2021M2", "2021M3"]

period = calendar.parse('2020W3..2020Q1')
"#{period.name}: from #{period.start_date} thru #{period.end_date} (current=#{period.current?})"
# => "2020W3 .. 2020Q1: from 2020-01-13 thru 2020-03-29 (current=false)"
```

The examples above are just samples. Try different periods, operators, etc.

### Shell
To open an IRB shell for the broadcast calendar, use the `timeboss:broadcast_calendar:shell` rake task:
```bash
$ rake timeboss:broadcast_calendar:shell
2.4.1 :001 > next_quarter
 => #<TimeBoss::Calendar::Quarter:0x007fe04c16a1c8 @calendar=#<TimeBoss::BroadcastCalendar:0x007fe04c1a0458 @basis=TimeBoss::BroadcastCalendar::Basis>, @year_index=2020, @index=4, @start_date=#<Date: 2020-09-28 ((2459121j,0s,0n),+0s,2299161j)>, @end_date=#<Date: 2020-12-27 ((2459211j,0s,0n),+0s,2299161j)>>
2.4.1 :002 > last_year
 => #<TimeBoss::Calendar::Year:0x007fe04c161ca8 @calendar=#<TimeBoss::BroadcastCalendar:0x007fe04c1a0458 @basis=TimeBoss::BroadcastCalendar::Basis>, @year_index=2019, @index=1, @start_date=#<Date: 2018-12-31 ((2458484j,0s,0n),+0s,2299161j)>, @end_date=#<Date: 2019-12-29 ((2458847j,0s,0n),+0s,2299161j)>>
2.4.1 :003 > parse('this_quarter .. this_quarter+4').months.map(&:name)
 => ["2020M7", "2020M8", "2020M9", "2020M10", "2020M11", "2020M12", "2021M1", "2021M2", "2021M3", "2021M4", "2021M5", "2021M6", "2021M7", "2021M8", "2021M9"]
```
