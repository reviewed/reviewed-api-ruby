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
    @article.attachments('hero').first.tags.should eql(['hero'])
  end

  it 'fetches when an tag is not in pre-loaded set' do
    @article.should_receive(:fetch_attachments).with({tags: 'foobar'})
    @article.attachments('foobar').should eql([])
  end

  it 'sets DEFAULT_ATTACHMENTS' do
    class Foo
      include Reviewed::Attachable
    end
    Foo::DEFAULT_ATTACHMENTS.should eql([])
  end
end
