require 'active_support/concern'

module Ahub
  module Collection
    extend ActiveSupport::Concern
    include Ahub::APIResource

    attr_reader :page, :pageSize, :pageCount, :listCount, :totalCount, :list

    def initialize(type:, url:, headers:)
      @type = type
      @url = url
      @headers = headers
    end

    def get_resources
      response = JSON.parse(RestClient.get(url, @headers), symbolize_names:true)
      @page = response[:page]
      @pageSize = response[:pageSize]
      @pageCount = response[:pageCount]
      @listCount = response[:listCount]
      @totalCount = response[:totalCount]
      @list = response[:list].map{ |node| resource.new(node) }
    end

    def get_next_page
    end

    def get_all_pages
    end
  end
end