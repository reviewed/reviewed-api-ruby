require 'spec_helper'

describe Reviewed::Article, vcr: true do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  before(:each) do
    @article = client.articles.find('50fb9a81bd0286d55504b952')
  end

  it 'returns local attachments when available' do
    Reviewed::Request.should_not_receive(:new)
    @article.attachments(tags: 'hero').first.tags.should eql(['hero'])
  end

  it 'fetches when a tag is not in pre-loaded set' do
    @article.should_receive(:fetch_attachments).with({tags: ['foobar']})
    @article.attachments(tags: 'foobar').should eql([])
  end

  it 'merges local and fetched tags', focused: true do
    @article.stub(:fetch_attachments).
      and_return(Reviewed::Article.new(tags: ['fetched']))
    @article.should_receive(:fetch_attachments).with({tags: ['foobar']})
    attachments = @article.attachments(tags: ['hero', 'foobar'])
    attachments.count.should eql(2)
    attachments.map(&:tags).flatten.should eql(['hero', 'fetched'])
  end

  it 'passes options to fetch_attachments when no tags present' do
    @article.should_receive(:fetch_attachments).with({test: 'test'})
    @article.attachments(test: 'test')
  end

  it 'uses the client to fetch scoped attachments' do
    @article.attachments.count.should eql(1)
  end
end
