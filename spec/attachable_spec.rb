require 'spec_helper'

describe Reviewed::Article, vcr: true do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  before(:each) do
    @article = client.articles.find('50fb9a81bd0286d55504b952')
  end

  it 'does not request for an attachment if it can be found in attributes' do
    Reviewed::Request.should_not_receive(:new)
    @article.attachments('hero')
  end

  it 'fetches when an tag is not in pre-loaded set', focused: true do
    @article.should_receive(:fetch_attachments).with({tags: 'foobar'})
    @article.attachments('foobar')
  end

  it 'returns local attachments when available' do
    @article.attachments('hero').count.should eql(1)
  end
end
