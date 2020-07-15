module TimeBoss
  class Calendar
    describe Day do
      let(:calendar) { instance_double(TimeBoss::Calendar) }
      let(:start_date) { Date.parse('2019-09-30') }
      let(:subject) { described_class.new(calendar, start_date) }

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
    end
  end
end
