module TimeBoss
  class Calendar
    module Support
      describe MonthBased do
        class ChunkMonthBased < described_class
          NUM_MONTHS = 2

          def name
            "#{year_index}C#{index}"
          end
        end
        let(:described_class) { ChunkMonthBased }
        let(:calendar) { double }
        let(:start_date) { Date.parse('2018-06-25') }
        let(:end_date) { Date.parse('2018-08-26') }
        let(:subject) { described_class.new(calendar, 2018, 4, start_date, end_date) }

        it 'knows its stuff' do
          expect(subject.start_date).to eq start_date
          expect(subject.end_date).to eq end_date
          expect(subject.to_range).to eq start_date..end_date
        end

        it 'can stringify itself' do
          expect(subject.to_s).to eq "2018C4: 2018-06-25 thru 2018-08-26"
        end

        describe '#weeks' do
          let(:base) { double(start_date: Date.parse('2018-01-01'), end_date: Date.parse('2018-12-30')) }
          before(:each) { allow(calendar).to receive(:year).with(2018).and_return base }

          it 'can get the relevant weeks for the period' do
            result = subject.weeks
            result.each { |w| expect(w).to be_instance_of TimeBoss::Calendar::Week }
            expect(result.map(&:name)).to eq %w[2018W26 2018W27 2018W28 2018W29 2018W30 2018W31 2018W32 2018W33 2018W34]
          end
        end

        context 'navigation' do
          let(:result) { double }

          describe '#previous' do
            it 'moves easily within itself' do
              expect(calendar).to receive(:chunk_month_based).with(48, 3).and_return result
              expect(described_class.new(calendar, 48, 4, nil, nil).previous).to eq result
            end

            it 'flips to the previous container' do
              expect(calendar).to receive(:chunk_month_based).with(47, 6).and_return result
              expect(described_class.new(calendar, 48, 1, nil, nil).previous).to eq result
            end
          end

          describe '#next' do
            it 'moves easily within itself' do
              expect(calendar).to receive(:chunk_month_based).with(48, 3).and_return result
              expect(described_class.new(calendar, 48, 2, nil, nil).next).to eq result
            end

            it 'flips to the previous container' do
              expect(calendar).to receive(:chunk_month_based).with(48, 1).and_return result
              expect(described_class.new(calendar, 47, 6, nil, nil).next).to eq result
            end
          end
        end
      end
    end
  end
end