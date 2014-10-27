# api key 5eEczAXe9b
require 'spec_helper'

include TowerdataEmail

describe "TowerdataEmail" do

  context "with valid API key" do

    before(:each)  do
      TowerdataEmail.configure do |c|
        c.token = ENV['API_KEY']
      end
    end

    context "email address" do


      context 'valid' do
        it 'returns a success code' do
          VCR.use_cassette('valid_email') do
            e = TowerdataEmail.validate_email('andrew.fallows@elocal.com')
            expect(e.ok).to be true
          end
        end
      end

      context 'invalid' do
        it "returns a failure code" do
          VCR.use_cassette('invalid_email') do
            e = TowerdataEmail.validate_email('emrslkvn.lfnvfl@dklsmns.com')
            expect(e.ok).to be false
          end
        end
      end

    end

  end
  context 'with invalid API token' do
    before(:each) do
      TowerdataEmail.configure do |c|
        c.token = 'bullocks'
      end
    end

    it 'raises exception' do
      expect{TowerdataEmail.validate_email('an.email@address.com')}.to raise_error(TowerdataEmail::TokenInvalidError)
    end

  end
end