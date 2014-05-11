
base = File.dirname __FILE__
$:.unshift File.join( base, 'lib' )

require 'lab42/nhash/version'

Gem::Specification.new do | spec |
  spec.name        = 'lab42_nhash'
  spec.version     = Lab42::NHash::VERSION
  spec.authors     = ['Robert Dober']
  spec.email       = %w{ robert.dober@gmail.com }
  spec.description = %{A Nested Hash with dotted access à la I18n in Rails}
  spec.summary     = %{A nested hash view with dotted deep access à la I18n.t of Rails and with optional string interpolation.
Typically YML loaded Hashes are used.}
  spec.homepage    = %{https://github.com/RobertDober/lab42_nested_hash}
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{\Atest|\Aspec|\Afeatures|\Ademo/})
  spec.require_paths = %w{lib}

  # spec.post_install_message = %q{ }


  spec.required_ruby_version = '>= 2.0.0'
  spec.required_rubygems_version = '>= 2.2.2'

  spec.add_dependency 'forwarder2', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'pry-debugger', '~> 0.2'
  spec.add_development_dependency 'ae', '~> 1.8'
  spec.add_development_dependency 'qed', '~> 2.9'
  
end
