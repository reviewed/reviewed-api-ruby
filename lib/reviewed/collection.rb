module Reviewed
  class Collection
    include Enumerable
    extend Forwardable
    def_delegators :@items, :<<, :[], :[]=, :each, :first, :last, :length, :concat, :map, :collect, :empty?

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

    def limit_value
      per_page
    end

    def num_pages
      total_pages
    end

    def total_count
      total
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
      clean_sym = sym.to_s.gsub(/\?/, '').to_sym
      if @page_attributes.has_key?(clean_sym)
        @page_attributes[clean_sym]
      else
        super
      end
    end

    private

    def fetch_page(page=nil)
      @request_options[:page] = page
      @klass.where(@request_options)
    end
  end
end
