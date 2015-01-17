require "active_support/inflector"

module EmberDataActiveModelParser
  class EmbedAssociations
    def initialize(root_json)
      @root_json = root_json
    end

    def call
      root_json.each do |key, value|
        walk(value)
      end
    end

    private

    attr_reader :root_json

    def walk(object)
      case object
        when Array
          object.each { |element| walk(element) }
        when Hash
          walk_hash(object)
      end
    end

    def walk_hash(hash)
      hash.keys.each do |key|
        if association_ids_key(key, hash[key])
          handle_association_ids(hash, hash.delete(key), association_name(key))
        else
          walk(hash[key])
        end
      end
    end

    def handle_association_ids(hash, association_ids, association_name)
      case association_ids
        when Array
          hash[association_name.pluralize.to_sym] = {
            association_name.pluralize.to_sym => association_ids.map { |association_id|
              association_array(association_name).find { |association_item| association_item[:id] == association_id }
            }
          }
        when Fixnum
          hash[association_name.to_sym] = {
            association_name.to_sym => association_array(association_name).find { |association_item| association_item[:id] == association_ids }
          }
      end
    end

    def association_ids_key(key, value)
      key.to_s =~ /(.+)_id(s?)$/ && association_array(association_name(key)) && (value.is_a?(Array) || value.is_a?(Fixnum))
    end

    def association_name(key)
      key[/^(.+)_id(s?)$/, 1]
    end

    def association_array(association_name)
      root_json[association_name.pluralize.to_sym]
    end
  end
end
