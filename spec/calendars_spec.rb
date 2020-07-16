module TimeBoss
  describe Calendars do
    class MyTestCalendar < TimeBoss::Calendar
      def initialize
        super(basis: nil)
      end
    end

    describe '#all' do
      let(:all) { described_class.all }

      it 'can get a list of all the registered calendars' do
        expect(all).to be_a Array
        expect(all.length).to be > 1
        all.each { |e| expect(e).to be_a described_class::Entry }
      end

      context 'enumerability' do
        it 'can get a list of names' do
          expect(described_class.map(&:name)).to include(:broadcast, :my_test_calendar)
        end
      end
    end

    describe '#[]' do
      it 'can return a baked-in calendar' do
        c1 = described_class[:broadcast]
        c2 = described_class[:broadcast]
        expect(c1).to be_instance_of TimeBoss::Calendars::Broadcast
        expect(c1).to be c2
      end

      it 'can return a new calendar' do
        expect(described_class[:my_test_calendar]).to be_instance_of MyTestCalendar
      end

      it 'can graceully give you nothing' do
        expect(described_class[:missing]).to be nil
      end
    end
  end
end
