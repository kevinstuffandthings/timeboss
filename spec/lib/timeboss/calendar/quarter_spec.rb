module TimeBoss
  class Calendar
    describe Quarter do
      let(:calendar) { instance_double(TimeBoss::Calendar) }
      let(:start_date) { Date.parse("2019-09-30") }
      let(:end_date) { Date.parse("2019-12-29") }
      let(:subject) { described_class.new(calendar, 2019, 4, start_date, end_date) }

      it "knows its stuff" do
        expect(subject.name).to eq "2019Q4"
        expect(subject.start_date).to eq start_date
        expect(subject.end_date).to eq end_date
        expect(subject.to_range).to eq start_date..end_date
      end

      it "can stringify itself" do
        expect(subject.to_s).to include("2019Q4", start_date.to_s, end_date.to_s)
      end

      describe "#current?" do
        it "knows when it is" do
          allow(Date).to receive(:today).and_return start_date
          expect(subject).to be_current
        end

        it "knows when it is not" do
          expect(subject).not_to be_current
        end
      end
    end
  end
end
