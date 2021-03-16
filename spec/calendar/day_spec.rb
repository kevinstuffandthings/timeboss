module TimeBoss
  class Calendar
    describe Day do
      let(:calendar) { instance_double(TimeBoss::Calendar) }
      let(:start_date) { Date.parse("2019-09-30") }
      let(:subject) { described_class.new(calendar, start_date) }

      it "knows its stuff" do
        expect(subject.start_date).to eq start_date
        expect(subject.end_date).to eq start_date
        expect(subject.to_range).to eq start_date..start_date
      end

      it "knows its name" do
        expect(subject.name).to eq start_date.to_s
      end

      it "knows its title" do
        expect(subject.title).to eq "September 30, 2019"
      end

      it "can stringify itself" do
        expect(subject.to_s).to eq subject.name
      end

      describe "#index" do
        before(:each) { allow(subject).to receive(:year).and_return double(start_date: start_date - 3) }

        it "gets its index within the year" do
          expect(subject.index).to eq 4
        end
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

      context "navigation" do
        it "can get the previous date" do
          result = subject.previous
          expect(result).to be_a described_class
          expect(result.start_date).to eq start_date - 1.day
        end

        it "can get the next date" do
          result = subject.next
          expect(result).to be_a described_class
          expect(result.start_date).to eq start_date + 1.day
        end
      end
    end
  end
end
