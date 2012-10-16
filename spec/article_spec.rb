require 'spec_helper'

describe Reviewed::Article do
  describe 'find_page' do
    use_vcr_cassette 'article/find_page'

    it 'finds a page with a matching slug' do
      article = Reviewed::Article.find('minden-master-ii-grill-review')
      article.pages.length.should == 10
      page = article.find_page('performance')
      page.should == article.pages[2]
      page.name.should == 'Performance'
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

  describe 'primary_product' do
    use_vcr_cassette 'article/products'

    before(:each) do
      @article = Reviewed::Article.find('big-green-egg-medium-charcoal-grill-review')
      @product = @article.primary_product
    end

    it "returns the primary product" do
      @product.id.should eql('506b06970494340f51809caf')
    end

    it "returns a product of the correct class" do
      @product.class.should == Reviewed::Product
    end
  end

  describe 'attachments' do
    use_vcr_cassette 'article/attachments'

    before(:each) do
      @article = Reviewed::Article.find('big-green-egg-medium-charcoal-grill-review')
    end

    it 'returns all attachments' do
      @article.attachments.length.should >= 1
    end

    it 'finds attachments by tag' do
      attachments = @article.attachments('hero')
      attachments.length.should == 1
      attachments.each do |attachment|
        attachment.tags.join(',').should match(/hero/i)
      end
    end

    it 'does not have any matching attachments' do
      attachments = @article.attachments('doesnotcompute')
      attachments.length.should == 0
    end 
  end
end
