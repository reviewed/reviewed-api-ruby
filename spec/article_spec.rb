require 'spec_helper'

describe Reviewed::Article do
  use_vcr_cassette 'article/grill'

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  before(:each) do
    @article = client.articles.find('big-green-egg-medium-charcoal-grill-review')
  end

  describe 'associations' do

    describe 'pages' do
      use_vcr_cassette 'article/pages'

      it 'has_many :pages' do
        Reviewed::Article._embedded_many.should include({"pages"=>Reviewed::Page})
      end
    end

    describe 'products' do
      use_vcr_cassette 'article/products'

      it 'has_many :products' do
        Reviewed::Article._embedded_many.should include({"products"=>Reviewed::Product})
      end

      it 'returns products of the correct class' do
        @article.products.each do |product|
          product.should be_an_instance_of(Reviewed::Product)
        end
      end
    end

    describe 'attachments' do
      use_vcr_cassette 'article/attachments'

      it 'has_many :attachments' do
        Reviewed::Article._embedded_many.should include({"attachments"=>Reviewed::Attachment})
      end

      it 'returns all attachments' do
        @article.attachments.length.should >= 1
      end

      it 'returns attachments of the correct class' do
        @article.attachments.each do |attachment|
          attachment.should be_an_instance_of(Reviewed::Attachment)
        end
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

  describe 'find_page' do
    use_vcr_cassette 'article/find_page'

    it 'finds a page with a matching slug' do
      article = client.articles.find('minden-master-ii-grill-review')
      article.pages.length.should == 9
      page = article.find_page('performance')
      page.should == article.pages[2]
      page.name.should == 'Performance'
    end
  end


  describe 'primary_product' do
    use_vcr_cassette 'article/products'

    before(:each) do
      @article = client.articles.find('big-green-egg-medium-charcoal-grill-review')
      @product = @article.primary_product
    end

    it "returns the primary product" do
      @product.name.should eql('Big Green Egg Medium')
    end

    it "returns a product of the correct class" do
      @product.class.should == Reviewed::Product
    end
  end
end
