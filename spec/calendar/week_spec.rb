module TimeBoss
  class Calendar
    describe Week do
      let(:calendar) { instance_double(TimeBoss::Calendar) }
      let(:start_date) { Date.parse('2048-04-06') }
      let(:end_date) { Date.parse('2048-04-12') }
      let(:subject) { described_class.new(calendar, start_date, end_date) }

      it 'knows its stuff' do
        expect(subject.start_date).to eq start_date
        expect(subject.end_date).to eq end_date
        expect(subject.to_range).to eq start_date..end_date
      end

      it 'knows its title' do
        expect(subject.title).to eq "Week of April 6, 2048"
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

      context 'navigation' do
        let(:calendar) { TimeBoss::Calendars::Broadcast.new }

        describe '#previous' do
          it 'can back up simply' do
            result = subject.previous
            expect(result).to be_a described_class
            expect(result.to_s).to eq "2048W14: 2048-03-30 thru 2048-04-05"
          end

          it 'can wrap to the previous 52-week year' do
            result = described_class.new(calendar, Date.parse('2021-12-27'), Date.parse('2022-01-02')).previous
            expect(result).to be_a described_class
            expect(result.to_s).to eq "2021W52: 2021-12-20 thru 2021-12-26"
          end

          it 'can wrap to the previous 53-week year' do
            result = described_class.new(calendar, Date.parse('2024-01-01'), Date.parse('2024-01-07')).previous
            expect(result).to be_a described_class
            expect(result.to_s).to eq "2023W53: 2023-12-25 thru 2023-12-31"
          end
        end

        describe '#next' do
          it 'can move forward simply' do
            result = subject.next
            expect(result).to be_a described_class
            expect(result.to_s).to eq "2048W16: 2048-04-13 thru 2048-04-19"
          end

          it 'can wrap from week 52 to the next year' do
            result = described_class.new(calendar, Date.parse('2021-12-20'), Date.parse('2021-12-26')).next
            expect(result).to be_a described_class
            expect(result.to_s).to eq "2022W1: 2021-12-27 thru 2022-01-02"
          end

          it 'can wrap from week 53 to the next year' do
            result = described_class.new(calendar, Date.parse('2023-12-25'), Date.parse('2023-12-31')).next
            expect(result).to be_a described_class
            expect(result.to_s).to eq "2024W1: 2024-01-01 thru 2024-01-07"
          end
        end
      end
    end
  end
end
