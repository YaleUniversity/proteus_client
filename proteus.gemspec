# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proteus/version'

Gem::Specification.new do |spec|
  spec.name          = 'proteus'
  spec.version       = Proteus::VERSION
  spec.authors       = ['Tenyo Grozev', 'E. Camden Fisher']
  spec.email         = ['tenyo.grozev@yale.edu, camden.fisher@yale.edu']
  spec.summary       = %q{Bluecat Proteus Client}
  spec.description   = %q{A ruby client for talking to bluecat proteus.}
  spec.homepage      = 'https://github.com/YaleUniversity/proteus_client'

  spec.license       = 'Apache-2.0'
  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib lib/proteus lib/actions)

  spec.add_dependency 'awesome_print', '~> 0'
  spec.add_dependency 'cri', '~> 2.7.1'
  spec.add_dependency 'mini_portile2', '~> 2.0'
  spec.add_dependency 'netaddr', '~> 1.5', '>= 1.5.1'
  spec.add_dependency 'savon', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 11'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0'
  spec.add_development_dependency 'yard', '~> 0'
  spec.add_development_dependency 'webmock', '~> 2'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'

  spec.post_install_message = 'Thanks for installing the proteus client!'
end
