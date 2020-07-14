module TimeBoss
  describe BroadcastCalendar do
    context 'quarters' do
      describe '#quarter' do
        it 'knows 2017Q2' do
          quarter = described_class.quarter(2017, 2)
          expect(quarter.name).to eq '2017Q2'
          expect(quarter.title).to eq 'Q2 2017'
          expect(quarter.year).to eq 2017
          expect(quarter.index).to eq 2
          expect(quarter.start_date).to eq Date.parse('2017-03-27')
          expect(quarter.end_date).to eq Date.parse('2017-06-25')
          expect(quarter.range).to eq quarter.start_date..quarter.end_date
        end

        it 'knows 2018Q3' do
          quarter = described_class.quarter(2018, 3)
          expect(quarter.name).to eq '2018Q3'
          expect(quarter.title).to eq 'Q3 2018'
          expect(quarter.year).to eq 2018
          expect(quarter.index).to eq 3
          expect(quarter.start_date).to eq Date.parse('2018-06-25')
          expect(quarter.end_date).to eq Date.parse('2018-09-30')
          expect(quarter.range).to eq quarter.start_date..quarter.end_date
        end

        it 'knows 2019Q4' do
          quarter = described_class.quarter(2019, 4)
          expect(quarter.year).to eq 2019
          expect(quarter.index).to eq 4
          expect(quarter.name).to eq '2019Q4'
          expect(quarter.title).to eq 'Q4 2019'
          expect(quarter.start_date).to eq Date.parse('2019-09-30')
          expect(quarter.end_date).to eq Date.parse('2019-12-29')
          expect(quarter.range).to eq quarter.start_date..quarter.end_date
        end
      end

      describe '#quarter_for' do
        it 'knows what quarter 2018-06-27 is in' do
          quarter = described_class.quarter_for(Date.parse('2018-06-27'))
          expect(quarter.name).to eq '2018Q3'
        end

        it 'knows what quarter 2018-06-22 is in' do
          quarter = described_class.quarter_for(Date.parse('2018-06-22'))
          expect(quarter.name).to eq '2018Q2'
        end
      end

      describe '#quarters_for' do
        it 'knows what quarters are in 2020' do
          basis = described_class.year(2020)
          periods = described_class.quarters_for(basis)
          expect(periods.map(&:name)).to eq %w[2020Q1 2020Q2 2020Q3 2020Q4]
        end

        it 'knows what quarter 2018M7 is in' do
          basis = described_class.month(2018, 7)
          periods = described_class.quarters_for(basis)
          expect(periods.map(&:name)).to eq %w[2018Q3]
        end
      end

      describe '#this_quarter' do
        let(:today) { double }
        let(:quarter) { double }

        it 'gets the quarter for today' do
          allow(Date).to receive(:today).and_return today
          expect(described_class::Waypoints).to receive(:quarter_for).with(today).and_return quarter
          expect(described_class.this_quarter).to eq quarter
        end
      end

      context 'relative' do
        let(:this_quarter) { described_class.quarter(2015, 3) }
        let(:quarter) { double }
        before(:each) { allow(described_class::Waypoints).to receive(:this_quarter).and_return this_quarter }

        it 'can get the last quarter' do
          allow(this_quarter).to receive(:previous).and_return quarter
          expect(described_class.last_quarter).to eq quarter
        end

        it 'can get the next quarter' do
          allow(this_quarter).to receive(:next).and_return quarter
          expect(described_class.next_quarter).to eq quarter
        end

        it 'can get this quarter last year' do
          quarter = described_class.this_quarter_last_year
          expect(quarter).to be_a described_class::Quarter
          expect(quarter.name).to eq '2014Q3'
        end

        it 'can get some number of quarters' do
          quarters = described_class.quarters(5)
          expect(quarters.length).to eq 5
          quarters.each { |q| expect(q).to be_a described_class::Quarter }
          expect(quarters.map(&:name)).to eq ['2015Q3', '2015Q4', '2016Q1', '2016Q2', '2016Q3']
        end

        it 'can get some number of quarters back' do
          quarters = described_class.quarters_back(5)
          expect(quarters.length).to eq 5
          quarters.each { |q| expect(q).to be_a described_class::Quarter }
          expect(quarters.map(&:name)).to eq ['2014Q3', '2014Q4', '2015Q1', '2015Q2', '2015Q3']
        end
      end
    end

    context 'months' do
      describe '#month' do
        it 'knows 2017M2' do
          month = described_class.month(2017, 2)
          expect(month.name).to eq '2017M2'
          expect(month.title).to eq 'February 2017'
          expect(month.year).to eq 2017
          expect(month.index).to eq 2
          expect(month.start_date).to eq Date.parse('2017-01-30')
          expect(month.end_date).to eq Date.parse('2017-02-26')
          expect(month.range).to eq month.start_date..month.end_date
        end

        it 'knows 2018M3' do
          month = described_class.month(2018, 3)
          expect(month.name).to eq '2018M3'
          expect(month.title).to eq 'March 2018'
          expect(month.year).to eq 2018
          expect(month.index).to eq 3
          expect(month.start_date).to eq Date.parse('2018-02-26')
          expect(month.end_date).to eq Date.parse('2018-03-25')
          expect(month.range).to eq month.start_date..month.end_date
        end

        it 'knows 2019M11' do
          month = described_class.month(2019, 11)
          expect(month.year).to eq 2019
          expect(month.index).to eq 11
          expect(month.name).to eq '2019M11'
          expect(month.title).to eq 'November 2019'
          expect(month.start_date).to eq Date.parse('2019-10-28')
          expect(month.end_date).to eq Date.parse('2019-11-24')
          expect(month.range).to eq month.start_date..month.end_date
        end
      end

      describe '#month_for' do
        it 'knows what month 2018-06-27 is in' do
          month = described_class.month_for(Date.parse('2018-06-27'))
          expect(month.name).to eq '2018M7'
        end

        it 'knows what month 2018-06-22 is in' do
          month = described_class.month_for(Date.parse('2018-06-22'))
          expect(month.name).to eq '2018M6'
        end
      end

      describe '#months_for' do
        it 'knows what months are in 2020' do
          basis = described_class.year(2020)
          periods = described_class.months_for(basis)
          expect(periods.map(&:name)).to eq %w[2020M1 2020M2 2020M3 2020M4 2020M5 2020M6 2020M7 2020M8 2020M9 2020M10 2020M11 2020M12]
        end

        it 'knows what months are in 2018Q2' do
          basis = described_class.parse('2018Q2')
          periods = described_class.months_for(basis)
          expect(periods.map(&:name)).to eq %w[2018M4 2018M5 2018M6]
        end

        it 'knows what month 2019-12-12 is in' do
          basis = described_class.parse('2019-12-12')
          periods = described_class.months_for(basis)
          expect(periods.map(&:name)).to eq %w[2019M12]
        end
      end

      describe '#this_month' do
        let(:today) { double }
        let(:month) { double }

        it 'gets the month for today' do
          allow(Date).to receive(:today).and_return today
          expect(described_class::Waypoints).to receive(:month_for).with(today).and_return month
          expect(described_class.this_month).to eq month
        end
      end

      context 'relative' do
        let(:this_month) { described_class.month(2015, 3) }
        let(:month) { double }
        before(:each) { allow(described_class::Waypoints).to receive(:this_month).and_return this_month }

        it 'can get the last month' do
          allow(this_month).to receive(:previous).and_return month
          expect(described_class.last_month).to eq month
        end

        it 'can get the next month' do
          allow(this_month).to receive(:next).and_return month
          expect(described_class.next_month).to eq month
        end

        it 'can get this month last year' do
          month = described_class.this_month_last_year
          expect(month).to be_a described_class::Month
          expect(month.name).to eq '2014M3'
        end

        it 'can get some number of months' do
          months = described_class.months(5)
          expect(months.length).to eq 5
          months.each { |m| expect(m).to be_a described_class::Month }
          expect(months.map(&:name)).to eq ['2015M3', '2015M4', '2015M5', '2015M6', '2015M7']
        end

        it 'can get some number of months back' do
          months = described_class.months_back(5)
          expect(months.length).to eq 5
          months.each { |m| expect(m).to be_a described_class::Month }
          expect(months.map(&:name)).to eq ['2014M11', '2014M12', '2015M1', '2015M2', '2015M3']
        end
      end
 
    end

    context 'weeks' do
      before(:each) { allow(Date).to receive(:today).and_return Date.parse('2019-08-23') }

      it 'knows this week 'do
        expect(described_class.this_week.name).to eq '2019W34'
        expect(described_class.this_week.title).to eq 'Week of August 19, 2019'
      end

      it 'knows last week' do
        expect(described_class.last_week.name).to eq '2019W33'
        expect(described_class.last_week.title).to eq 'Week of August 12, 2019'
      end

      it 'knows next week' do
        expect(described_class.next_week.name).to eq '2019W35'
        expect(described_class.next_week.title).to eq 'Week of August 26, 2019'
      end
    end

    context 'years' do
      describe '#year' do
        it 'knows 2016' do
          year = described_class.year(2016)
          expect(year.name).to eq '2016'
          expect(year.title).to eq '2016'
          expect(year.year).to eq 2016
          expect(year.index).to eq 1
          expect(year.start_date).to eq Date.parse('2015-12-28')
          expect(year.end_date).to eq Date.parse('2016-12-25')
          expect(year.range).to eq year.start_date..year.end_date
        end

        it 'knows 2017' do
          year = described_class.year(2017)
          expect(year.name).to eq '2017'
          expect(year.title).to eq '2017'
          expect(year.year).to eq 2017
          expect(year.index).to eq 1
          expect(year.start_date).to eq Date.parse('2016-12-26')
          expect(year.end_date).to eq Date.parse('2017-12-31')
          expect(year.range).to eq year.start_date..year.end_date
        end

        it 'knows 2018' do
          year = described_class.year(2018)
          expect(year.name).to eq '2018'
          expect(year.title).to eq '2018'
          expect(year.year).to eq 2018
          expect(year.index).to eq 1
          expect(year.start_date).to eq Date.parse('2018-01-01')
          expect(year.end_date).to eq Date.parse('2018-12-30')
          expect(year.range).to eq year.start_date..year.end_date
        end
      end

      describe '#year_for' do
        it 'knows what year 2018-04-07 is in' do
          year = described_class.year_for(Date.parse('2018-04-07'))
          expect(year.name).to eq '2018'
        end

        it 'knows what year 2016-12-27 is in' do
          year = described_class.year_for(Date.parse('2016-12-27'))
          expect(year.name).to eq '2017'
        end
      end

      describe '#years_for' do
        it 'knows what years are in 2020 (duh)' do
          basis = described_class.year(2020)
          periods = described_class.years_for(basis)
          expect(periods.map(&:name)).to eq %w[2020]
        end

        it 'knows what year 2018Q2 is in' do
          basis = described_class.parse('2018Q2')
          periods = described_class.years_for(basis)
          expect(periods.map(&:name)).to eq %w[2018]
        end

        it 'knows what years 2019-12-12 is in' do
          basis = described_class.parse('2019-12-12')
          periods = described_class.years_for(basis)
          expect(periods.map(&:name)).to eq %w[2019]
        end
      end

      describe '#this_year' do
        let(:today) { double }
        let(:year) { double }

        it 'gets the year for today' do
          allow(Date).to receive(:today).and_return today
          expect(described_class::Waypoints).to receive(:year_for).with(today).and_return year
          expect(described_class.this_year).to eq year
        end
      end

      context 'relative' do
        let(:this_year) { described_class.year(2015) }
        let(:year) { double }
        before(:each) { allow(described_class::Waypoints).to receive(:this_year).and_return this_year }

        it 'can get the last year' do
          allow(this_year).to receive(:previous).and_return year
          expect(described_class.last_year).to eq year
        end

        it 'can get the next year' do
          allow(this_year).to receive(:next).and_return year
          expect(described_class.next_year).to eq year
        end

        it 'can get this year last year' do
          year = described_class.this_year_last_year
          expect(year).to be_a described_class::Year
          expect(year.name).to eq '2014'
        end

        it 'can get some number of years' do
          years = described_class.years(5)
          expect(years.length).to eq 5
          years.each { |y| expect(y).to be_a described_class::Year }
          expect(years.map(&:name)).to eq ['2015', '2016', '2017', '2018', '2019']
        end

        it 'can get some number of years back' do
          years = described_class.years_back(5)
          expect(years.length).to eq 5
          years.each { |y| expect(y).to be_a described_class::Year }
          expect(years.map(&:name)).to eq ['2011', '2012', '2013', '2014', '2015']
        end
      end
    end

    describe '#parse' do
      it 'can parse a year' do
        date = described_class.parse('2018')
        expect(date).to be_a described_class::Year
        expect(date.name).to eq '2018'
      end

      it 'can parse a quarter identifier' do
        date = described_class.parse('2017Q2')
        expect(date).to be_a described_class::Quarter
        expect(date.name).to eq '2017Q2'
      end

      it 'can parse a month identifier' do
        date = described_class.parse('2017M4')
        expect(date).to be_a described_class::Month
        expect(date.name).to eq '2017M4'
      end

      it 'can parse a week within a year' do
        date = described_class.parse('2018W37')
        expect(date).to be_a described_class::Week
        expect(date.parent.name).to eq '2018'
        expect(date.name).to eq '2018W37'
      end

      it 'can parse a week within a quarter' do
        date = described_class.parse('2017Q2W2')
        expect(date).to be_a described_class::Week
        expect(date.parent.name).to eq '2017Q2'
        expect(date.name).to eq '2017Q2W2'
      end

      it 'can parse a week within a month' do
        date = described_class.parse('2017M4W1')
        expect(date).to be_a described_class::Week
        expect(date.parent.name).to eq '2017M4'
        expect(date.name).to eq '2017M4W1'
      end

      it 'can parse a date' do
        date = described_class.parse('2017-04-08')
        expect(date).to be_a described_class::Day
        expect(date.start_date).to eq Date.parse('2017-04-08')
        expect(date.end_date).to eq Date.parse('2017-04-08')
      end

      it 'can parse an aesthetically displeasing date' do
        date = described_class.parse('20170408')
        expect(date).to be_a described_class::Day
        expect(date.start_date).to eq Date.parse('2017-04-08')
        expect(date.end_date).to eq Date.parse('2017-04-08')
      end

      it 'gives you nothing if you give it nothing' do
        expect(described_class.parse(nil)).to be nil
        expect(described_class.parse('')).to be nil
      end
    end
  end

  describe BroadcastCalendar::Day do
    let(:start_date) { Date.parse('2019-09-30') }
    let(:subject) { described_class.new(start_date) }

    it 'knows its stuff' do
      expect(subject.start_date).to eq start_date
      expect(subject.end_date).to eq start_date
    end

    it 'knows its name' do
      expect(subject.name).to eq start_date.to_s
    end

    it 'knows its title' do
      expect(subject.title).to eq 'September 30, 2019'
    end

    it 'can stringify itself' do
      expect(subject.to_s).to eq subject.name
    end

    describe '#current?' do
      it 'knows when it is' do
        allow(Date).to receive(:today).and_return start_date
        expect(subject).to be_current
      end

      it 'knows when it is not' do
        expect(subject).not_to be_current
      end
    end

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

  describe BroadcastCalendar::Week do
    let(:start_date) { Date.parse('2048-03-09') }
    let(:end_date) { Date.parse('2048-03-15') }
    let(:parent) { double(name: '2048M3') }
    let(:subject) { described_class.new(parent, 2, start_date, end_date) }

    it 'knows its stuff' do
      expect(subject.name).to eq '2048M3W2'
      expect(subject.start_date).to eq start_date
      expect(subject.end_date).to eq end_date
      expect(subject.range).to eq start_date..end_date
    end

    it 'can stringify itself' do
      expect(subject.to_s).to include(subject.name, start_date.to_s, end_date.to_s)
    end

    describe '#current?' do
      it 'knows when it is' do
        allow(Date).to receive(:today).and_return start_date
        expect(subject).to be_current
      end

      it 'knows when it is not' do
        expect(subject).not_to be_current
      end
    end

    context 'links' do
      context 'within year' do
        let(:parent) { TimeBoss::BroadcastCalendar.parse('2020') }
        let(:week) { parent.weeks.first }

        it 'knows itself first' do
          expect(week.parent.name).to eq '2020'
          expect(week.to_s).to include('2020W1', '2019-12-30', '2020-01-05')
        end

        it 'can get its next week' do
          subject = week.next
          expect(subject).to be_a described_class
          expect(subject.parent.name).to eq '2020'
          expect(subject.to_s).to include('2020W2', '2020-01-06', '2020-01-12')
        end

        it 'can get its previous week' do
          subject = week.previous
          expect(subject).to be_a described_class
          expect(subject.parent.name).to eq '2019'
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
        let(:parent) { TimeBoss::BroadcastCalendar.parse('2019Q3') }
        let(:week) { parent.weeks.last }

        it 'knows itself first' do
          expect(week.parent.name).to eq '2019Q3'
          expect(week.to_s).to include('2019Q3W13', '2019-09-23', '2019-09-29')
        end

        it 'can get its next week' do
          subject = week.next
          expect(subject).to be_a described_class
          expect(subject.parent.name).to eq '2019Q4'
          expect(subject.to_s).to include('2019Q4W1', '2019-09-30', '2019-10-06')
        end

        it 'can get its previous week' do
          subject = week.previous
          expect(subject).to be_a described_class
          expect(subject.parent.name).to eq '2019Q3'
          expect(subject.to_s).to include('2019Q3W12', '2019-09-16', '2019-09-22')
        end

        it 'can offset backwards' do
          expect(week.offset(-4).name).to eq '2019Q3W9'
          expect((week - 4).name).to eq '2019Q3W9'
        end

        it 'can offset forwards' do
          expect((week + 2).name).to eq '2019Q4W2'
        end
      end
    end
  end

  describe BroadcastCalendar::Quarter do
    let(:start_date) { Date.parse('2019-09-30') }
    let(:end_date) { Date.parse('2019-12-29') }
    let(:subject) { described_class.new(2019, 4, start_date, end_date) }

    it 'knows its stuff' do
      expect(subject.name).to eq '2019Q4'
      expect(subject.start_date).to eq start_date
      expect(subject.end_date).to eq end_date
      expect(subject.range).to eq start_date..end_date
    end

    it 'can stringify itself' do
      expect(subject.to_s).to include('2019Q4', start_date.to_s, end_date.to_s)
    end

    describe '#current?' do
      it 'knows when it is' do
        allow(Date).to receive(:today).and_return start_date
        expect(subject).to be_current
      end

      it 'knows when it is not' do
        expect(subject).not_to be_current
      end
    end

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
