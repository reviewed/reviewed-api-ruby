require 'spec_helper'

describe Reviewed::Article, vcr: true do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  before(:each) do
    Reviewed::Cache.store.clear
    @article = client.articles.find('big-green-egg-medium-charcoal-grill-review', { with_attachments: true })
  end

  describe 'associations', vcr: true do

    describe 'pages' do

      it 'has_many :pages' do
        Reviewed::Article._embedded_many.should include({"pages"=>Reviewed::Page})
      end
    end

    describe 'deals' do

      it 'has_many :deals' do
        Reviewed::Article._embedded_many.should include({"deals"=>Reviewed::Deal})
      end
    end

    describe 'related_articles' do
      it 'has_many :related_articles' do
        Reviewed::Article._embedded_many.should include({"related_articles"=>Reviewed::Article})
      end
    end

    describe 'products' do

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

      it 'does not has_many :attachments' do
        Reviewed::Article._embedded_many.should_not include({"attachments"=>Reviewed::Attachment})
      end

      it 'gets gallery attachments' do
        attachments = @article.gallery('all', 7)
        attachments.length.should == 7
      end

      it 'assigns attachments to the correct class' do
        @article.attachments(:gallery).each do |attachment|
          attachment.should be_an_instance_of(Reviewed::Attachment)
        end
      end

      it 'finds attachments by tag' do
        attachments = @article.attachments('hero')
        attachments.map(&:tags).flatten.should == ['hero']
      end

      it 'does not have any matching attachments' do
        attachments = @article.attachments('doesnotcompute')
        attachments.length.should == 0
      end

    end
  end

  describe 'find_page', vcr: true do

    it 'finds a page with a matching slug' do
      article = client.articles.find('minden-master-ii-grill-review')
      article.pages.length.should == 4
      page = article.find_page('performance')
      page.should == article.pages[2]
      page.name.should == 'Performance'
    end
  end


  describe 'primary_product', vcr: true do

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

    it 'returns nil if does not respond to products' do
      @article.attributes.delete(:products)
      @article.primary_product.should be_nil
    end
  end
end
