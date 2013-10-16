unless RUBY_PLATFORM =~ /java/
  puts "This library is only compatible with a java-based ruby environment like JRuby."
  exit 255
end

require_relative "jars/jrjackson-1.2.3.jar"

require 'com/jrjackson/jr_jackson'

module JrJackson
  module Json
    class << self
      TIME_REGEX = %r(\A(\d{4}-\d\d-\d\d|(\w{3}\s){2}\d\d)\s\d\d:\d\d:\d\d)

      def load(json_string, options = nil)
        if json_string.is_a?(String) && json_string =~ TIME_REGEX
          return JrJackson::Raw.parse_raw("\"#{json_string}\"")
        end

        if options && !options.empty?
          if options.size == 1 && !!options[:raw]
            return JrJackson::Raw.parse_raw(json_string)
          end
          if options.size == 1 && !!options[:symbolize_keys]
            return JrJackson::Raw.parse_sym(json_string)
          end
          JrJackson::Raw.parse(json_string, options)
        else
          JrJackson::Raw.parse_str(json_string)
        end
      end

      def dump(object)
        object = object.as_json if object.respond_to?(:as_json)
        JrJackson::Raw.generate(object)
      end

      alias :parse :load
      alias :generate :dump
    end
  end
end
