# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stupid_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = 'stupid_crawler'
  spec.version       = StupidCrawler::VERSION
  spec.authors       = ['Jacob Burenstam']
  spec.email         = ['burenstam@gmail.com']

  spec.summary       = %q{Stupid crawler that looks for URLs on a given site.}
  spec.description   = %q{Stupid crawler that looks for URLs on a given site. Result is saved as two CSV files one with found URLs and another with failed URLs.}
  spec.homepage      = 'https://github/com/buren/stupid_crawler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'spidr', '~> 0.6'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
end
