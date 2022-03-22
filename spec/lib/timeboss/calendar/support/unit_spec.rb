module TimeBoss
  class Calendar
    module Support
      class TestChunkUnit < Unit
      end

      describe Unit do
        let(:described_class) { TestChunkUnit }
        let(:calendar) { double }
        let(:start_date) { Date.parse("2018-06-25") }
        let(:end_date) { Date.parse("2018-08-26") }
        let(:subject) { described_class.new(calendar, start_date, end_date) }

        it "knows its stuff" do
          expect(subject.start_date).to eq start_date
          expect(subject.end_date).to eq end_date
          expect(subject.to_range).to eq start_date..end_date
        end

        describe "#current?" do
          it "is not current right now" do
            expect(subject).not_to be_current
          end

          it "is current when today falls in the middle" do
            allow(Date).to receive(:today).and_return start_date + 3.days
            expect(subject).to be_current
          end
        end

        describe "#clamp" do
          let(:clamp_start_date) { Date.parse("2018-06-21") }
          let(:clamp_end_date) { Date.parse("2018-08-30") }
          let(:result) { subject.clamp(described_class.new(calendar, clamp_start_date, clamp_end_date)) }
          let(:period) { double }

          context "open" do
            it "does not restrict the returned period" do
              expect(calendar).to receive(:parse).with("#{start_date}..#{end_date}").and_return period
              expect(result).to eq period
            end
          end

          context "left clamped" do
            let(:clamp_start_date) { Date.parse("2018-06-30") }

            it "brings the beginning date inward" do
              expect(calendar).to receive(:parse).with("#{clamp_start_date}..#{end_date}").and_return period
              expect(result).to eq period
            end
          end

          context "right clamped" do
            let(:clamp_end_date) { Date.parse("2018-07-30") }

            it "brings the beginning date inward" do
              expect(calendar).to receive(:parse).with("#{start_date}..#{clamp_end_date}").and_return period
              expect(result).to eq period
            end
          end

          context "fully clamped" do
            let(:clamp_start_date) { Date.parse("2018-06-30") }
            let(:clamp_end_date) { Date.parse("2018-07-30") }

            it "brings the beginning date inward" do
              expect(calendar).to receive(:parse).with("#{clamp_start_date}..#{clamp_end_date}").and_return period
              expect(result).to eq period
            end
          end

          context "obliterated" do
            let(:clamp_start_date) { Date.parse("2018-09-01") }
            let(:clamp_end_date) { Date.parse("2018-09-06") }

            it "returns nil" do
              expect(result).to be_nil
            end
          end
        end

        context "periods" do
          before(:each) do
            allow(calendar).to receive(:days_for).with(subject).and_return %w[D1 D2 D3 D4 D5 D6 D7 D8]
            allow(calendar).to receive(:weeks_for).with(subject).and_return %w[W1 W2 W3 W4]
            allow(calendar).to receive(:months_for).with(subject).and_return %w[M1 M2 M3]
            allow(calendar).to receive(:quarters_for).with(subject).and_return %w[Q1 Q2]
            allow(calendar).to receive(:halves_for).with(subject).and_return %w[H1]
            allow(calendar).to receive(:years_for).with(subject).and_return %w[Y1]
          end

          it "knows about its days" do
            expect(subject.days).to eq %w[D1 D2 D3 D4 D5 D6 D7 D8]
            expect(subject.day).to be nil
          end

          it "knows about its weeks" do
            expect(subject.weeks).to eq %w[W1 W2 W3 W4]
            expect(subject.week).to be nil
          end

          it "knows about its months" do
            expect(subject.months).to eq %w[M1 M2 M3]
            expect(subject.month).to be nil
          end

          it "knows about its quarters" do
            expect(subject.quarters).to eq %w[Q1 Q2]
            expect(subject.quarter).to be nil
          end

          it "knows about its halves" do
            expect(subject.halves).to eq %w[H1]
            expect(subject.half).to eq "H1"
          end

          it "knows about its years" do
            expect(subject.years).to eq %w[Y1]
            expect(subject.year).to eq "Y1"
          end
        end

        context "navigation" do
          let(:result) { double }

          describe "#offset" do
          end

          it "can increment" do
            expect(subject).to receive(:offset).with(7).and_return result
            expect(subject + 7).to eq result
          end

          it "can decrement" do
            expect(subject).to receive(:offset).with(-23).and_return result
            expect(subject - 23).to eq result
          end
        end
      end
    end
  end
end
