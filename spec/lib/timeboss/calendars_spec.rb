module TimeBoss
  class TestMyCal < TimeBoss::Calendar
    def initialize
      super(basis: nil)
    end
  end

  describe Calendars do
    TimeBoss::Calendars.register(:my_amazing_calendar, TestMyCal)

    describe "#all" do
      let(:all) { described_class.all }

      it "can get a list of all the registered calendars" do
        expect(all).to be_a Array
        expect(all.length).to be > 1
        all.each { |e| expect(e).to be_a described_class::Entry }
      end

      context "enumerability" do
        it "can get a list of names" do
          expect(described_class.map(&:name)).to include(:broadcast, :my_amazing_calendar)
        end
      end
    end

    describe "#[]" do
      it "can return a baked-in calendar" do
        c1 = described_class[:broadcast]
        c2 = described_class[:broadcast]
        expect(c1).to be_instance_of TimeBoss::Calendars::Broadcast
        expect(c1).to be c2

        expect(c1.name).to eq "broadcast"
        expect(c1.title).to eq "Broadcast"
      end

      it "can return a new calendar" do
        c1 = described_class[:my_amazing_calendar]
        expect(c1).to be_instance_of TestMyCal
        expect(c1.name).to eq "test_my_cal"
        expect(c1.title).to eq "Test My Cal"
      end

      it "can graceully give you nothing" do
        expect(described_class[:missing]).to be nil
      end
    end
  end
end
