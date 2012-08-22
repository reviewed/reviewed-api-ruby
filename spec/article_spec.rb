require 'spec_helper'

describe Reviewed::Article do
  describe 'find_page' do
    use_vcr_cassette 'article/find_page'

    it 'finds a page with a matching slug' do
      article = Reviewed::Article.find('minden-master-ii-grill-review')
      article.pages.length.should == 7
      article.find_page('performance').should == article.pages[2]
    end
  end
end
