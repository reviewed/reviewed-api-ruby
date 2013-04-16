module Reviewed
  class Collection
    include Enumerable

    extend Forwardable

    def_delegators :@items, :<<, :[], :[]=, :each, :first, :last, :length, :concat, :map, :collect, :empty?

    attr_accessor :raw_response, :page_attributes, :klass, :items, :params, :client

    def initialize(client, klass, response, params={})
      body = response.body
      data = body.data

      @client = client
      @klass = klass
      @params = params
      @items = []
      @page_attributes = body.pagination || {}

      data.each do |obj|
        self.items << klass.new(obj)
      end
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
      self.params[:page] = page
      client.send(klass.association_name).where(self.params)
    end
  end
end
