require 'spec_helper'

describe Reviewed::Article do
  describe 'find_page' do
    use_vcr_cassette 'article/find_page'

    it 'finds a page with a matching slug' do
      article = Reviewed::Article.find('minden-master-ii-grill-review')
      article.pages.length.should == 4
      article.find_page('performance').should == article.pages[1]
    end
  end

  describe 'products' do
    use_vcr_cassette 'article/products'

    before(:each) do
      @article = Reviewed::Article.find('big-green-egg-medium-charcoal-grill-review')
    end

    it 'returns products of the correct class' do
      @article.products.should_not be_empty
      @article.products.each do |product|
        product.class.should == Reviewed::Product
      end
    end
  end

  describe 'attachments' do
    use_vcr_cassette 'article/attachments'

    before(:each) do
      @article = Reviewed::Article.find('big-green-egg-medium-charcoal-grill-review')
    end

    it 'returns all attachments' do
      @article.attachments.length.should > 1
    end

    it 'finds attachments by tag' do
      attachments = @article.attachments('hero')
      attachments.length.should == 1
      attachments.each do |attachment|
        attachment.tags.join(',').should match(/hero/i)
      end
    end
  end
end
