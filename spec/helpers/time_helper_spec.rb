require 'rails_helper'

RSpec.describe TimeHelper, type: :helper do
  describe '#readable_time' do
    subject{ readable_time(90) }

    it 'should be converted to 1h30' do
      expect(subject).to eq "1h30"
    end

    it 'should be converted to 1h31' do
      expect( readable_time(91) ).to eq "1h31"
    end

    it 'should be converted to 1h40' do
      expect( readable_time(100) ).to eq "1h40"
    end

    it 'should be converted to 1h20' do
      expect( readable_time(80) ).to eq "1h20"
    end

    it 'should be converted to 2h00' do
      expect( readable_time(120) ).to eq "2h00"
    end
    it 'should be 0h05' do
      expect( readable_time(5) ).to eq "0h05"
    end
  end

  describe "#convert_in_minutes" do

    context 'when just a number' do
      subject{ convert_in_minutes('50')}
      it 'should be eq to 50 (minutes)' do
        expect( subject ).to eq 50
      end
      it 'should be eq to 1 (minute)' do
        expect( convert_in_minutes('1') ).to eq 1
      end
    end
    context 'when time contains h' do

      subject{ convert_in_minutes('1h00')}

      it 'should eq 60 (minutes)' do
        expect( subject ).to eq 60
      end
      it 'should eq 90 (minutes)' do
        expect( convert_in_minutes('1h30') ).to eq 90
      end
      it 'should be converted to 91' do
        expect( convert_in_minutes('1h31') ).to eq 91
      end
      it 'should eq 80 (minutes)' do
        expect( convert_in_minutes('1h20') ).to eq 80
      end
    end
    context 'when time contains a .' do

      subject{ convert_in_minutes('1.00')}

      it 'should eq 60 (minutes)' do
        expect( subject ).to eq 60
      end
      it 'should eq 90 (minutes)' do
        expect( convert_in_minutes('1.50') ).to eq 90
      end
      it 'should be converted to 91' do
        expect( convert_in_minutes('1.51') ).to eq 90
      end
      it 'should eq 80 (minutes)' do
        expect( convert_in_minutes('1.60') ).to eq 96
      end
    end

  end
end
