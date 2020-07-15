module TimeBoss
  class Calendar
    describe Week do
      let(:calendar) { instance_double(TimeBoss::Calendar) }
      let(:start_date) { Date.parse('2048-03-09') }
      let(:end_date) { Date.parse('2048-03-15') }
      let(:subject) { described_class.new(calendar, 2048, 15, start_date, end_date) }

      it 'knows its stuff' do
        expect(subject.name).to eq '2048W15'
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
    end
  end
end
