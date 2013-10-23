require 'spec_helper'

describe Reviewed::Award do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  describe 'associations' do

    describe 'articles', vcr: true do

      before(:each) do
        @award = client.awards.find('best-of-year')
      end

      it 'has_many :articles' do
        Reviewed::Award._embedded_many.should include({"articles"=>"Reviewed::Article"})
      end

      it 'returns attachments of the correct class' do
        @award.articles.each do |article|
          article.should be_an_instance_of(Reviewed::Article)
        end
      end
    end
  end
end
