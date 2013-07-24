require 'spec_helper'

module Reviewed
  class Product < Base
  end
end

describe Reviewed::Collection, vcr: true do

  let(:client) do
    Reviewed::Client.new(api_key: TEST_KEY, base_uri: TEST_URL)
  end

  before(:each) do
    Faraday::Cache.store.clear
    @collection = client.products.with_no_cache.all # creates a collection
  end

  describe 'collection data' do

    it 'is enumerable' do
      @collection.each do |product|
        product.class.should == Reviewed::Product
        product.id.should_not be_blank
      end
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
      @collection.current_page == page1.current_page
    end

    it 'returns nil if there is no previous page' do
      @collection.previous_page.should be_nil
    end
  end

  describe 'page attributes (pagination)' do

    it 'returns the total item count' do
      @collection.total.should > 1
    end

    it 'returns the total number of pages' do
      @collection.total_pages.should > 1
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

    it 'returns the limit value (max per page)' do
      @collection.per_page.should == 20
    end

    it 'returns the number of entries on the current page' do
      @collection.entries_on_page.should == 20
    end
  end
end
