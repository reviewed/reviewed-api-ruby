module Reviewed
  class Collection
    include Enumerable
    extend Forwardable
    def_delegators :@items, :<<, :[], :[]=, :each, :first, :last, :concat, :map, :collect, :empty?

    attr_accessor :raw_response

    def initialize(klass, json, options={})
      json = JSON.parse(json).symbolize_keys!
      page_data = json[:pagination].symbolize_keys!

      @items = []
      items = json[:data]
      items.each do |item|
        @items << klass.new(item)
      end

      @page_attributes = page_data
      @raw_response = json
      @request_options = options.symbolize_keys!
      @klass = klass
    end

    def next_page
      return nil if @page_attributes[:last_page]
      fetch_page(@page_attributes[:next_page])
    end

    def previous_page
      return nil if @page_attributes[:first_page]
      fetch_page(@page_attributes[:previous_page])
    end

    def ==(other)
      @raw_response == other.raw_response
    end

    def method_missing(sym, *args, &block)
      if @page_attributes.has_key?(sym)
        @page_attributes[sym]
      else
        raise NoMethodError.new("undefined method '#{sym}' for #{to_s}")
      end
    end

    private

    def fetch_page(page=nil)
      @request_options[:page] = page
      @klass.where(@request_options)
    end
  end
end
