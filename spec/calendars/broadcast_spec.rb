module TimeBoss
  describe Calendars::Broadcast do
    let(:subject) { described_class.new }

    context 'days' do
      it 'can get today' do
        day = subject.today
        expect(day).to be_instance_of(TimeBoss::Calendar::Day)
        expect(day.start_date).to eq Date.today
      end

      it 'can get yesterday' do
        day = subject.yesterday
        expect(day).to be_instance_of(TimeBoss::Calendar::Day)
        expect(day.start_date).to eq Date.yesterday
      end

      it 'can get tomorrow' do
        day = subject.tomorrow
        expect(day).to be_instance_of(TimeBoss::Calendar::Day)
        expect(day.start_date).to eq Date.tomorrow
      end
    end

    context 'quarters' do
      describe '#quarter' do
        it 'knows 2017Q2' do
          quarter = subject.quarter(2017, 2)
          expect(quarter.name).to eq '2017Q2'
          expect(quarter.title).to eq 'Q2 2017'
          expect(quarter.year_index).to eq 2017
          expect(quarter.index).to eq 2
          expect(quarter.start_date).to eq Date.parse('2017-03-27')
          expect(quarter.end_date).to eq Date.parse('2017-06-25')
          expect(quarter.to_range).to eq quarter.start_date..quarter.end_date
        end

        it 'knows 2018Q3' do
          quarter = subject.quarter(2018, 3)
          expect(quarter.name).to eq '2018Q3'
          expect(quarter.title).to eq 'Q3 2018'
          expect(quarter.year_index).to eq 2018
          expect(quarter.index).to eq 3
          expect(quarter.start_date).to eq Date.parse('2018-06-25')
          expect(quarter.end_date).to eq Date.parse('2018-09-30')
          expect(quarter.to_range).to eq quarter.start_date..quarter.end_date
        end

        it 'knows 2019Q4' do
          quarter = subject.quarter(2019, 4)
          expect(quarter.year_index).to eq 2019
          expect(quarter.index).to eq 4
          expect(quarter.name).to eq '2019Q4'
          expect(quarter.title).to eq 'Q4 2019'
          expect(quarter.start_date).to eq Date.parse('2019-09-30')
          expect(quarter.end_date).to eq Date.parse('2019-12-29')
          expect(quarter.to_range).to eq quarter.start_date..quarter.end_date
        end
      end

      describe '#quarter_for' do
        it 'knows what quarter 2018-06-27 is in' do
          quarter = subject.quarter_for(Date.parse('2018-06-27'))
          expect(quarter.name).to eq '2018Q3'
        end

        it 'knows what quarter 2018-06-22 is in' do
          quarter = subject.quarter_for(Date.parse('2018-06-22'))
          expect(quarter.name).to eq '2018Q2'
        end
      end

      describe '#quarters_for' do
        it 'knows what quarters are in 2020' do
          basis = subject.year(2020)
          periods = subject.quarters_for(basis)
          expect(periods.map(&:name)).to eq %w[2020Q1 2020Q2 2020Q3 2020Q4]
        end

        it 'knows what quarter 2018M7 is in' do
          basis = subject.month(2018, 7)
          periods = subject.quarters_for(basis)
          expect(periods.map(&:name)).to eq %w[2018Q3]
        end
      end

      describe '#this_quarter' do
        let(:today) { double }
        let(:quarter) { double }

        it 'gets the quarter for today' do
          allow(Date).to receive(:today).and_return today
          expect(subject).to receive(:quarter_for).with(today).and_return quarter
          expect(subject.this_quarter).to eq quarter
        end
      end

      describe '#format' do
        let(:entry) { subject.quarter(2015, 3) }

        it 'can do a default format' do
          expect(entry.format).to eq '2015H2Q1'
        end

        it 'can format with only the quarter' do
          expect(entry.format(:quarter)).to eq '2015Q3'
        end

        it 'ignores stupidity' do
          expect(entry.format(:day, :banana)).to eq '2015Q3'
        end
      end

      context 'relative' do
        let(:this_quarter) { subject.quarter(2015, 3) }
        let(:quarter) { double }
        before(:each) { allow(subject).to receive(:this_quarter).and_return this_quarter }

        it 'can get the last quarter' do
          allow(this_quarter).to receive(:previous).and_return quarter
          expect(subject.last_quarter).to eq quarter
        end

        it 'can get the next quarter' do
          allow(this_quarter).to receive(:next).and_return quarter
          expect(subject.next_quarter).to eq quarter
        end

        it 'can get some number of quarters' do
          quarters = subject.quarters(5)
          expect(quarters.length).to eq 5
          quarters.each { |q| expect(q).to be_a TimeBoss::Calendar::Quarter }
          expect(quarters.map(&:name)).to eq ['2015Q3', '2015Q4', '2016Q1', '2016Q2', '2016Q3']
        end

        it 'can get a quarter ahead' do
          quarter = subject.quarters_ahead(4)
          expect(quarter).to be_a TimeBoss::Calendar::Quarter
          expect(quarter.name).to eq '2016Q3'
        end

        it 'can get some number of quarters back' do
          quarters = subject.quarters_back(5)
          expect(quarters.length).to eq 5
          quarters.each { |q| expect(q).to be_a TimeBoss::Calendar::Quarter }
          expect(quarters.map(&:name)).to eq ['2014Q3', '2014Q4', '2015Q1', '2015Q2', '2015Q3']
        end

        it 'can get a quarter ago' do
          quarter = subject.quarters_ago(4)
          expect(quarter).to be_a TimeBoss::Calendar::Quarter
          expect(quarter.name).to eq '2014Q3'
        end
      end
    end

    context 'months' do
      describe '#month' do
        it 'knows 2017M2' do
          month = subject.month(2017, 2)
          expect(month.name).to eq '2017M2'
          expect(month.title).to eq 'February 2017'
          expect(month.year_index).to eq 2017
          expect(month.index).to eq 2
          expect(month.start_date).to eq Date.parse('2017-01-30')
          expect(month.end_date).to eq Date.parse('2017-02-26')
          expect(month.to_range).to eq month.start_date..month.end_date
        end

        it 'knows 2018M3' do
          month = subject.month(2018, 3)
          expect(month.name).to eq '2018M3'
          expect(month.title).to eq 'March 2018'
          expect(month.year_index).to eq 2018
          expect(month.index).to eq 3
          expect(month.start_date).to eq Date.parse('2018-02-26')
          expect(month.end_date).to eq Date.parse('2018-03-25')
          expect(month.to_range).to eq month.start_date..month.end_date
        end

        it 'knows 2019M11' do
          month = subject.month(2019, 11)
          expect(month.year_index).to eq 2019
          expect(month.index).to eq 11
          expect(month.name).to eq '2019M11'
          expect(month.title).to eq 'November 2019'
          expect(month.start_date).to eq Date.parse('2019-10-28')
          expect(month.end_date).to eq Date.parse('2019-11-24')
          expect(month.to_range).to eq month.start_date..month.end_date
        end
      end

      describe '#month_for' do
        it 'knows what month 2018-06-27 is in' do
          month = subject.month_for(Date.parse('2018-06-27'))
          expect(month.name).to eq '2018M7'
        end

        it 'knows what month 2018-06-22 is in' do
          month = subject.month_for(Date.parse('2018-06-22'))
          expect(month.name).to eq '2018M6'
        end
      end

      describe '#months_for' do
        it 'knows what months are in 2020' do
          basis = subject.year(2020)
          periods = subject.months_for(basis)
          expect(periods.map(&:name)).to eq %w[2020M1 2020M2 2020M3 2020M4 2020M5 2020M6 2020M7 2020M8 2020M9 2020M10 2020M11 2020M12]
        end

        it 'knows what months are in 2018Q2' do
          basis = subject.parse('2018Q2')
          periods = subject.months_for(basis)
          expect(periods.map(&:name)).to eq %w[2018M4 2018M5 2018M6]
        end

        it 'knows what month 2019-12-12 is in' do
          basis = subject.parse('2019-12-12')
          periods = subject.months_for(basis)
          expect(periods.map(&:name)).to eq %w[2019M12]
        end
      end

      describe '#this_month' do
        let(:today) { double }
        let(:month) { double }

        it 'gets the month for today' do
          allow(Date).to receive(:today).and_return today
          expect(subject).to receive(:month_for).with(today).and_return month
          expect(subject.this_month).to eq month
        end
      end

      describe '#format' do
        let(:entry) { subject.month(2015, 8) }

        it 'can do a default format' do
          expect(entry.format).to eq '2015H2Q1M2'
        end

        it 'can format with only the quarter' do
          expect(entry.format(:quarter)).to eq '2015Q3M2'
        end

        it 'ignores stupidity' do
          expect(entry.format(:banana, :half, :week)).to eq '2015H2M2'
        end
      end

      context 'relative' do
        let(:this_month) { subject.month(2015, 3) }
        let(:month) { double }
        before(:each) { allow(subject).to receive(:this_month).and_return this_month }

        it 'can get the last month' do
          allow(this_month).to receive(:previous).and_return month
          expect(subject.last_month).to eq month
        end

        it 'can get the next month' do
          allow(this_month).to receive(:next).and_return month
          expect(subject.next_month).to eq month
        end

        it 'can get some number of months' do
          months = subject.months(5)
          expect(months.length).to eq 5
          months.each { |m| expect(m).to be_a TimeBoss::Calendar::Month }
          expect(months.map(&:name)).to eq ['2015M3', '2015M4', '2015M5', '2015M6', '2015M7']
        end

        it 'can get a month ahead' do
          month = subject.months_ahead(4)
          expect(month).to be_a TimeBoss::Calendar::Month
          expect(month.name).to eq '2015M7'
        end

        it 'can get some number of months back' do
          months = subject.months_back(5)
          expect(months.length).to eq 5
          months.each { |m| expect(m).to be_a TimeBoss::Calendar::Month }
          expect(months.map(&:name)).to eq ['2014M11', '2014M12', '2015M1', '2015M2', '2015M3']
        end

        it 'can get a month ago' do
          month = subject.months_ago(4)
          expect(month).to be_a TimeBoss::Calendar::Month
          expect(month.name).to eq '2014M11'
        end
      end
    end

    context 'weeks' do
      before(:each) { allow(Date).to receive(:today).and_return Date.parse('2019-08-23') }

      it 'knows this week 'do
        expect(subject.this_week.name).to eq '2019W34'
        expect(subject.this_week.title).to eq 'Week of August 19, 2019'
      end

      it 'knows last week' do
        expect(subject.last_week.name).to eq '2019W33'
        expect(subject.last_week.title).to eq 'Week of August 12, 2019'
      end

      it 'knows next week' do
        expect(subject.next_week.name).to eq '2019W35'
        expect(subject.next_week.title).to eq 'Week of August 26, 2019'
      end
    end

    context 'years' do
      describe '#year' do
        it 'knows 2016' do
          year = subject.year(2016)
          expect(year.name).to eq '2016'
          expect(year.title).to eq '2016'
          expect(year.year_index).to eq 2016
          expect(year.index).to eq 1
          expect(year.start_date).to eq Date.parse('2015-12-28')
          expect(year.end_date).to eq Date.parse('2016-12-25')
          expect(year.to_range).to eq year.start_date..year.end_date
        end

        it 'knows 2017' do
          year = subject.year(2017)
          expect(year.name).to eq '2017'
          expect(year.title).to eq '2017'
          expect(year.year_index).to eq 2017
          expect(year.index).to eq 1
          expect(year.start_date).to eq Date.parse('2016-12-26')
          expect(year.end_date).to eq Date.parse('2017-12-31')
          expect(year.to_range).to eq year.start_date..year.end_date
        end

        it 'knows 2018' do
          year = subject.year(2018)
          expect(year.name).to eq '2018'
          expect(year.title).to eq '2018'
          expect(year.year_index).to eq 2018
          expect(year.index).to eq 1
          expect(year.start_date).to eq Date.parse('2018-01-01')
          expect(year.end_date).to eq Date.parse('2018-12-30')
          expect(year.to_range).to eq year.start_date..year.end_date
        end
      end

      describe '#year_for' do
        it 'knows what year 2018-04-07 is in' do
          year = subject.year_for(Date.parse('2018-04-07'))
          expect(year.name).to eq '2018'
        end

        it 'knows what year 2016-12-27 is in' do
          year = subject.year_for(Date.parse('2016-12-27'))
          expect(year.name).to eq '2017'
        end
      end

      describe '#years_for' do
        it 'knows what years are in 2020 (duh)' do
          basis = subject.year(2020)
          periods = subject.years_for(basis)
          expect(periods.map(&:name)).to eq %w[2020]
        end

        it 'knows what year 2018Q2 is in' do
          basis = subject.parse('2018Q2')
          periods = subject.years_for(basis)
          expect(periods.map(&:name)).to eq %w[2018]
        end

        it 'knows what years 2019-12-12 is in' do
          basis = subject.parse('2019-12-12')
          periods = subject.years_for(basis)
          expect(periods.map(&:name)).to eq %w[2019]
        end
      end

      describe '#this_year' do
        let(:today) { double }
        let(:year) { double }

        it 'gets the year for today' do
          allow(Date).to receive(:today).and_return today
          expect(subject).to receive(:year_for).with(today).and_return year
          expect(subject.this_year).to eq year
        end
      end

      describe '#format' do
        let(:entry) { subject.parse('2020W24') }

        it 'can do a default format' do
          expect(entry.format).to eq '2020H1Q2M3W2'
        end

        it 'can format with only the quarter' do
          expect(entry.format(:quarter)).to eq '2020Q2W11'
        end

        it 'can format with only the quarter + month' do
          expect(entry.format(:quarter, :month)).to eq '2020Q2M3W2'
          expect(entry.format(:month, :quarter)).to eq '2020Q2M3W2'
        end

        it 'ignores stupidity' do
          expect(entry.format(:day, :month, :banana)).to eq '2020M6W2'
        end
      end

      context 'relative' do
        let(:this_year) { subject.year(2015) }
        let(:year) { double }
        before(:each) { allow(subject).to receive(:this_year).and_return this_year }

        it 'can get the last year' do
          allow(this_year).to receive(:previous).and_return year
          expect(subject.last_year).to eq year
        end

        it 'can get the next year' do
          allow(this_year).to receive(:next).and_return year
          expect(subject.next_year).to eq year
        end

        it 'can get some number of years' do
          years = subject.years(5)
          expect(years.length).to eq 5
          years.each { |y| expect(y).to be_a TimeBoss::Calendar::Year }
          expect(years.map(&:name)).to eq ['2015', '2016', '2017', '2018', '2019']
        end

        it 'can get some number of years back' do
          years = subject.years_back(5)
          expect(years.length).to eq 5
          years.each { |y| expect(y).to be_a TimeBoss::Calendar::Year }
          expect(years.map(&:name)).to eq ['2011', '2012', '2013', '2014', '2015']
        end
      end
    end

    describe '#parse' do
      it 'can parse a year' do
        date = subject.parse('2018')
        expect(date).to be_a TimeBoss::Calendar::Year
        expect(date.name).to eq '2018'
      end

      it 'can parse a quarter identifier' do
        date = subject.parse('2017Q2')
        expect(date).to be_a TimeBoss::Calendar::Quarter
        expect(date.name).to eq '2017Q2'
      end

      it 'can parse a month identifier' do
        date = subject.parse('2017M4')
        expect(date).to be_a TimeBoss::Calendar::Month
        expect(date.name).to eq '2017M4'
      end

      it 'can parse a week within a year' do
        date = subject.parse('2018W37')
        expect(date).to be_a TimeBoss::Calendar::Week
        expect(date.name).to eq '2018W37'
      end

      it 'can parse a week within a quarter' do
        date = subject.parse('2017Q2W2')
        expect(date).to be_a TimeBoss::Calendar::Week
        expect(date.name).to eq '2017W15'
      end

      it 'can parse a week within a month' do
        date = subject.parse('2017M4W1')
        expect(date).to be_a TimeBoss::Calendar::Week
        expect(date.name).to eq '2017W14'
      end

      it 'can parse a date' do
        date = subject.parse('2017-04-08')
        expect(date).to be_a TimeBoss::Calendar::Day
        expect(date.start_date).to eq Date.parse('2017-04-08')
        expect(date.end_date).to eq Date.parse('2017-04-08')
      end

      it 'can parse an aesthetically displeasing date' do
        date = subject.parse('20170408')
        expect(date).to be_a TimeBoss::Calendar::Day
        expect(date.start_date).to eq Date.parse('2017-04-08')
        expect(date.end_date).to eq Date.parse('2017-04-08')
      end

      it 'gives you nothing if you give it nothing' do
        expect(subject.parse(nil)).to be nil
        expect(subject.parse('')).to be nil
      end
    end

    context 'expressions' do
      it 'can parse waypoints' do
        result = subject.parse('this_year')
        expect(result).to be_a TimeBoss::Calendar::Year
        expect(result).to be_current
      end

      it 'can parse mathematic expressions' do
        result = subject.parse('this_month + 2')
        expect(result).to be_a TimeBoss::Calendar::Month
        expect(result).to eq subject.months_ahead(2)
      end

      context 'ranges' do
        before(:each) { allow(subject).to receive(:this_year).and_return subject.year(2018) }
        let(:result) { subject.parse('this_year-2 .. this_year') }

        it 'can parse range expressions' do
          expect(result).to be_a TimeBoss::Calendar::Period
          expect(result.to_s).to eq "2016: 2015-12-28 thru 2016-12-25 .. 2018: 2018-01-01 thru 2018-12-30"
        end

        it 'can get an overall start date for a range' do
          expect(result.start_date).to eq Date.parse('2015-12-28')
        end

        it 'can get an overall end date for a range' do
          expect(result.end_date).to eq Date.parse('2018-12-30')
        end

        context 'sub-periods' do
          it 'can get the months included in a range' do
            entries = result.months
            entries.each { |e| expect(e).to be_a TimeBoss::Calendar::Month }
            expect(entries.map(&:name)).to include('2016M1', '2016M9', '2017M3', '2018M12')
          end

          it 'can get the weeks included in a range' do
            entries = result.weeks
            entries.each { |e| expect(e).to be_a TimeBoss::Calendar::Week }
            expect(entries.map(&:name)).to include('2016W1', '2016W38', '2017W15', '2017W53', '2018W52')
          end

          it 'can get the days included in a range' do
            entries = result.days
            entries.each { |e| expect(e).to be_a TimeBoss::Calendar::Day }
            expect(entries.map(&:name)).to include('2015-12-28', '2016-04-30', '2017-09-22', '2018-12-30')
          end
        end
      end
    end

    context 'shifting' do
      context 'from day' do
        let(:basis) { subject.parse('2020-04-21') }

        it 'can shift to a different week' do
          allow(subject).to receive(:this_week).and_return subject.parse('2020W23')
          result = basis.last_week
          expect(result).to be_a TimeBoss::Calendar::Day
          expect(result.to_s).to eq '2020-05-26'
          expect(basis.in_week).to eq 2
        end

        it 'can shift to a different quarter' do
          allow(subject).to receive(:this_quarter).and_return subject.parse('2020Q3')
          result = basis.quarters_ago(2)
          expect(result).to be_a TimeBoss::Calendar::Day
          expect(result.to_s).to eq '2020-01-21'
          expect(basis.in_quarter).to eq 23
        end

        it 'can shift to a different year' do
          allow(subject).to receive(:this_year).and_return subject.parse('2019')
          result = basis.years_ahead(3)
          expect(result).to be_a TimeBoss::Calendar::Day
          expect(result.to_s).to eq '2022-04-19'
          expect(basis.in_year).to eq 114
        end
      end

      context 'from week' do
        let(:basis) { subject.parse('2017W8') }

        it 'cannot shift to a different day' do
          expect(basis.last_day).to be nil
          expect(basis.in_day).to be nil
        end

        it 'can shift to a different month' do
          allow(subject).to receive(:this_month).and_return subject.parse('2020M4')
          result = basis.next_month
          expect(result).to be_a TimeBoss::Calendar::Week
          expect(result.to_s).to eq '2020W20: 2020-05-11 thru 2020-05-17'
          expect(basis.in_month).to eq 3
        end

        it 'can shift to a different half' do
          allow(subject).to receive(:this_half).and_return subject.parse('2019H1')
          result = basis.last_half
          expect(result).to be_a TimeBoss::Calendar::Week
          expect(result.to_s).to eq '2018W33: 2018-08-13 thru 2018-08-19'
          expect(basis.in_half).to eq 8
        end
      end

      context 'from month' do
        let(:basis) { subject.parse('2017M4') }

        it 'cannot shift to a different week' do
          expect(basis.last_week).to be nil
          expect(basis.in_week).to be nil
        end

        it 'can shift to a different year' do
          allow(subject).to receive(:this_year).and_return subject.parse('2020')
          result = basis.years_ahead(4)
          expect(result).to be_a TimeBoss::Calendar::Month
          expect(result.name).to eq '2024M4'
          expect(basis.in_year).to eq 4
        end
      end

      context 'from quarter' do
        let(:basis) { subject.parse('2018Q2') }

        it 'cannot shift to a different month' do
          expect(basis.months_ago(4)).to be nil
          expect(basis.in_month).to be nil
        end

        it 'can shift to a different half' do
          allow(subject).to receive(:this_half).and_return subject.parse('2020H1')
          result = basis.last_half
          expect(result).to be_a TimeBoss::Calendar::Quarter
          expect(result.name).to eq '2019Q4'
          expect(basis.in_half).to eq 2
        end
      end

      context 'from year' do
        let(:basis) { subject.parse('2014') }

        it 'cannot shift to a different half' do
          expect(basis.next_half).to be nil
          expect(basis.in_half).to be nil
        end

        it 'shifts to a different year, but knows how useless that is' do
          allow(subject).to receive(:this_year).and_return subject.parse('2020')
          result = basis.years_ago(2)
          expect(result).to be_a TimeBoss::Calendar::Year
          expect(result.name).to eq '2018'
          expect(basis.in_year).to eq 1
        end
      end
    end

    context 'units' do
      let(:calendar) { described_class.new }

      context 'day' do
        let(:start_date) { Date.parse('2019-09-30') }
        let(:subject) { TimeBoss::Calendar::Day.new(calendar, start_date) }

        context 'links' do
          it 'can get its previous' do
            expect(subject.previous.name).to eq '2019-09-29'
          end

          it 'can get its next' do
            expect(subject.next.name).to eq '2019-10-01'
          end

          it 'can offset backwards' do
            expect(subject.offset(-3).name).to eq '2019-09-27'
            expect((subject - 3).name).to eq '2019-09-27'
          end

          it 'can offset forwards' do
            expect(subject.offset(4).name).to eq '2019-10-04'
            expect((subject + 4).name).to eq '2019-10-04'
          end
        end
      end

      context 'week' do
        context 'links' do
          context 'within year' do
            let(:parent) { calendar.parse('2020') }
            let(:week) { parent.weeks.first }

            it 'knows itself first' do
              expect(week.to_s).to include('2020W1', '2019-12-30', '2020-01-05')
            end

            it 'can get its next week' do
              subject = week.next
              expect(subject).to be_a TimeBoss::Calendar::Week
              expect(subject.to_s).to include('2020W2', '2020-01-06', '2020-01-12')
            end

            it 'can get its previous week' do
              subject = week.previous
              expect(subject).to be_a TimeBoss::Calendar::Week
              expect(subject.to_s).to include('2019W52', '2019-12-23', '2019-12-29')
            end

            it 'can offset backwards' do
              expect(week.offset(-4).name).to eq '2019W49'
              expect((week - 4).name).to eq '2019W49'
            end

            it 'can offset forwards' do
              expect((week + 2).name).to eq '2020W3'
            end
          end

          context 'within quarter' do
            let(:parent) { calendar.parse('2019Q3') }
            let(:week) { parent.weeks.last }

            it 'knows itself first' do
              expect(week.to_s).to include('2019W39', '2019-09-23', '2019-09-29')
            end

            it 'can get its next week' do
              subject = week.next
              expect(subject).to be_a TimeBoss::Calendar::Week
              expect(subject.to_s).to include('2019W40', '2019-09-30', '2019-10-06')
            end

            it 'can get its previous week' do
              subject = week.previous
              expect(subject).to be_a TimeBoss::Calendar::Week
              expect(subject.to_s).to include('2019W38', '2019-09-16', '2019-09-22')
            end

            it 'can offset backwards' do
              expect(week.offset(-4).name).to eq '2019W35'
              expect((week - 4).name).to eq '2019W35'
            end

            it 'can offset forwards' do
              expect((week + 2).name).to eq '2019W41'
            end
          end
        end
      end

      context 'quarter' do
        let(:start_date) { Date.parse('2019-09-30') }
        let(:end_date) { Date.parse('2019-12-29') }
        let(:subject) { TimeBoss::Calendar::Quarter.new(calendar, 2019, 4, start_date, end_date) }

        context 'links' do
          it 'can get the next quarter' do
            quarter = subject.next
            expect(quarter.to_s).to include('2020Q1', '2019-12-30', '2020-03-29')
          end

          it 'can get the next next quarter' do
            quarter = subject.next.next
            expect(quarter.to_s).to include('2020Q2', '2020-03-30', '2020-06-28')
          end

          it 'can get the next next previous quarter' do
            quarter = subject.next.next.previous
            expect(quarter.to_s).to include('2020Q1', '2019-12-30', '2020-03-29')
          end

          it 'can get the next previous quarter' do
            quarter = subject.next.previous
            expect(quarter.to_s).to eq subject.to_s
          end

          it 'can get the previous quarter' do
            quarter = subject.previous
            expect(quarter.to_s).to include('2019Q3', '2019-07-01', '2019-09-29')
          end

          it 'can offset backwards' do
            expect(subject.offset(-4).name).to eq '2018Q4'
            expect((subject - 4).name).to eq '2018Q4'
          end

          it 'can offset forwards' do
            expect(subject.offset(2).name).to eq '2020Q2'
            expect((subject + 2).name).to eq '2020Q2'
          end
        end
      end
    end
  end
end
