# TimeBoss
A gem providing convenient navigation of the [Broadcast Calendar](https://en.wikipedia.org/wiki/Broadcast_calendar).

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
Supports `year`, `quarter`, `month`, `week` (partial) and `date`.

```ruby
period = TimeBoss::BroadcastCalendar.parse('2019Q4') # or '2018', or '2018M3', or '2019-12-21', or '2020W32', or '2020M3W2'
# => #<struct TimeBoss::BroadcastCalendar::Quarter year=2019, index=4, start_date=#<Date: 2019-09-30 ((2458757j,0s,0n),+0s,2299161j)>, end_date=#<Date: 2019-12-29 ((2458847j,0s,0n),+0s,2299161j)>>
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

TimeBoss::BroadcastCalendar.this_month_last_year.to_s
# => "2018M12: 2018-11-26 thru 2018-12-30"

TimeBoss::BroadcastCalendar.year_for(Date.parse('2018-12-31')).to_s
# => "2019: 2018-12-31 thru 2019-12-29"

TimeBoss::BroadcastCalendar.this_month.to_s # your results may vary
# => "2019M12: 2019-11-25 thru 2019-12-29"

TimeBoss::BroadcastCalendar.years_back(2).map(&:start_date)
# => [#<Date: 2018-01-01 ((2458120j,0s,0n),+0s,2299161j)>, #<Date: 2018-12-31 ((2458484j,0s,0n),+0s,2299161j)>]
```

Additionally, each `year`, `quarter`, and `month` period support fetching of the constituent `weeks`.

```ruby
TimeBoss::BroadcastCalendar.this_month.weeks.map(&:to_s)
# => ["2020M1W1: 2019-12-30 thru 2020-01-05", "2020M1W2: 2020-01-06 thru 2020-01-12", "2020M1W3: 2020-01-13 thru 2020-01-19", "2020M1W4: 2020-01-20 thru 2020-01-26"]

TimeBoss::BroadcastCalendar.this_year.weeks.last.to_s
# => "2020W52: 2020-12-21 thru 2020-12-27"
```

For more examples, check out the unit tests at [spec/broadcast_calendar_spec.rb](spec/broadcast_calendar_spec.rb).
