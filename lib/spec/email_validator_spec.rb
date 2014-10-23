# api key 5eEczAXe9b
require 'spec_helper'

include EmailValidator

describe "EmailValidator" do
  context "email address" do
    before(:each)  do
      EmailValidator.configure do |c|
        c.token = '5eEczAXe9b'
      end
    end

    context 'valid' do
      it 'returns a success code' do
        VCR.use_cassette('valid_email') do
          e = EmailValidator.validate_email('andrew.fallows@elocal.com')
          expect(e.ok).to be true
        end
      end
    end

    context 'invalid' do
      it "returns a failure code" do
        VCR.use_cassette('invalid_email') do
          e = EmailValidator.validate_email('emrslkvn.lfnvfl@dklsmns.com')
          expect(e.ok).to be false
        end
      end
    end

  end

end