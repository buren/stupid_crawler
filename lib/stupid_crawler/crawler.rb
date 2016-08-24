require 'set'
require 'spidr'

module StupidCrawler
  class Crawler
    attr_reader :site, :max_urls, :sleep_time, :robots, :ignore_pattern

    def initialize(site, max_urls:, sleep_time:, robots:, ignore_pattern:)
      @site = site
      @max_urls = max_urls
      @sleep_time = sleep_time
      @robots = robots
      @ignore_pattern = ignore_pattern.nil? ? [Regexp.new(ignore_pattern)] : []
    end

    def perform
      dump_result(crawl)
    end

    private

    def crawl
      found_urls = Set.new
      failed_urls = Set.new

      Spidr.site(site, ignore_links: ignore_links, robots: robots) do |spider|
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

    def dump_result(result_hash)
      timestamp = Time.new.strftime("%Y-%m-%d-%H-%M-%S")
      formatted_site = site.delete('/').delete(':').delete('?') # Strip "illegal" chars from filename

      found = result_hash[:found]
      fails = result_hash[:failed]

      File.write("found-#{formatted_site}-#{timestamp}.csv", found.join("\n"))
      File.write("fails-#{formatted_site}-#{timestamp}.csv", fails.join("\n"))
    end
  end
end
