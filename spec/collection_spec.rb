require 'spec_helper'

module Reviewed
  class Product < Base
  end
end

describe Reviewed::Collection do
  use_vcr_cassette 'collection/products'

  before(:each) do
    Reviewed.api_key = TEST_KEY
    @collection = Reviewed::Product.all # creates a collection
  end

  describe 'collection data' do
    it 'is enumerable' do
      @collection.each do |product|
        product.class.should == Reviewed::Product
        product.id.should_not be_blank
      end
    end

    it 'contains the raw response' do
      @collection.raw_response.should_not be_blank
    end

    it 'fetches the first page by default' do
      @collection.current_page.should == 1
    end
  end

  describe 'next page' do
    it 'fetches the next page of results' do
      page2 = @collection.next_page
      page2.current_page.should == 2
    end
  end

  describe 'previous page' do
    it 'fetches the previous page of results' do
      page2 = @collection.next_page
      page1 = page2.previous_page
      @collection.should == page1
      page1.current_page.should == 1
    end

    it 'returns nil if there is no previous page' do
      @collection.previous_page.should be_nil
    end
  end

  describe 'page attributes (pagination)' do
    it 'returns the total item count' do
      @collection.total.should == 1000
    end

    it 'returns the total number of pages' do
      @collection.total_pages.should == 50
    end

    it 'indicates whether this is the first or last page' do
      @collection.first_page.should be_true
      @collection.last_page.should be_false
    end

    it 'indicates if the page number is out of bounds' do
      @collection.out_of_bounds.should be_false
    end

    it 'returns the offset' do
      @collection.offset.should == 0
    end
  end
end
