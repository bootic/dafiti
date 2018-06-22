module Dafiti
  module Actions
    class Action
      def self.escapes
        @escaped ||= []
      end

      def self.escape(key)
        escapes << key
      end

      def initialize(payload = {})
        @query = payload.each_with_object({}) do |(k, v), o|
          o[k.to_s] = v
        end
      end

      def params
        query.merge(
          'Action' => action_name
        )
      end

      def body
        nil
      end

      def inspect
        %(<#{self.class}:#{object_id} [#{verb}] params=#{params.inspect}>)
      end

      private
      attr_reader :query

      def action_name
        @action_name ||= self.class.name.split('::').last
      end
    end

    class Get < Action
      def verb
        :get
      end
    end

    require 'builder'

    class Post < Action
      def initialize(payload = {})
        @payload = [payload].flatten
      end

      def verb
        :post
      end

      def body
        @body ||= (
          xml = Builder::XmlMarkup.new(indent: 2)
          xml.instruct!(:xml, encoding: "UTF-8")
          build(xml, :Request, payload)
          xml.target!
        )
      end

      private
      attr_reader :payload

      def query
        {}
      end

      # turn a Ruby Hash into a Builder::XmlMarkup object, recursively
      def build(xml, key, value)
        case value
        when Hash
          xml.tag!(key.to_s){|t|
            value.each { |k, v|
              build(t, k, v)
            }
          }
        when Array
          value.each {|v|
            build(xml, key, v)
          }
        else
          xml_leaf(xml, key, value)
        end
      end

      def xml_leaf(xml, key, value)
        if e = self.class.escapes.include?(key)
          xml.tag!(key.to_s){|t| t.cdata!(value.to_s) }
        else
          xml.tag!(key.to_s, value.to_s)
        end
      end
    end
  end
end
