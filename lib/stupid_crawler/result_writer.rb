require 'fileutils'

module StupidCrawler
  class ResultWriter
    def self.call(result_hash, dir_path: nil)
      dir_path = dir_path.to_s
      dir_path = "#{dir_path}/" if !dir_path.empty? && !dir_path.end_with?('/')
      FileUtils::mkdir_p(dir_path) unless dir_path.empty?

      timestamp = Time.new.strftime("%Y-%m-%d-%H-%M-%S")

      found = result_hash[:found]
      fails = result_hash[:failed]

      File.write("#{dir_path}#{timestamp}-found.csv", found.join("\n"))
      File.write("#{dir_path}#{timestamp}-fails.csv", fails.join("\n"))
    end
  end
end
