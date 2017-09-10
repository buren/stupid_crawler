require 'uri'
require 'set'
require 'spidr'

module StupidCrawler
  class Crawler
    NotAbsoluteURI = Class.new(ArgumentError)

    attr_reader :uri, :max_urls, :sleep_time, :robots, :ignore_links

    def initialize(site, max_urls:, sleep_time:, robots:, ignore_links:)
      @uri = build_uri!(site)
      @max_urls = max_urls
      @sleep_time = sleep_time
      @robots = robots
      @ignore_links = ignore_links.nil? ? [] : [Regexp.new(ignore_links)]
    end

    def call
      crawl
    end

    private

    def crawl
      found_urls = Set.new
      failed_urls = Set.new

      Spidr.site(uri.to_s, ignore_links: ignore_links, robots: robots) do |spider|
       spider.every_url do |url|
         puts url
         found_urls << url
         sleep sleep_time
         return found_urls.to_a if found_urls.length > max_urls
       end

       spider.every_failed_url do |url|
         puts "FAILED: #{url}"
         failed_urls << url
       end
      end
      {
        found: found_urls.to_a,
        failed: failed_urls.to_a
      }
    end

    def build_uri!(site)
      uri = URI.parse(site)

      unless uri.absolute
        raise(NotAbsoluteURI, 'must be an absolute url with http(s) protocol')
      end

      uri
    end
  end
end
