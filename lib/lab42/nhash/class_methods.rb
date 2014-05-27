require_relative 'enum'

require 'yaml'

module Lab42
  class NHash
    module ClassMethods

      def from_sources *sources
        __from_sources__(sources)
      end
      
      def from_sources_with_indifferent_access *sources
        __from_sources__(sources, indifferent_access: true )
      end

      def from_value value, options={}
        case value
        when Hash
          new( value ).import_options options
        when Enumerable
          Lab42::NHash::Enum.new value, options
        else
          value
        end
      end

      private
      def __from_sources__ sources, indifferent_access: false
        sources = sources.map{ |source|
          make_nhash_from source, indifferent_access: indifferent_access
        }
        result = sources.shift
        sources.inject result do | r, s |
          r.add_hierarchy s
          s
        end
        result
      end

      def make_nhash_from source, indifferent_access: false
        case source
        when Hash
          new source, indifferent_access: indifferent_access
        when self
          indifferent_access ? source.dup.with_indifferent_access : source.dup
        when String
          raise ArgumentError, "#{source.inspect} needs to designate a readable yaml file" unless File.readable? source
          new YAML.load( File.read source ), indifferent_access: indifferent_access
        else
          raise ArgumentError, "type of value #{source.inspect} is not implemented (yet)"
        end
      end
    end # module ClassMethods
    extend ClassMethods
  end # class NHash
end # module Lab42
