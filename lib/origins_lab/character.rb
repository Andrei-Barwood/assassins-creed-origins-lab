# frozen_string_literal: true

module OriginsLab
  class Character
    attr_reader :id, :name, :attributes, :relationships, :belongings

    def initialize(id:, name:, attributes: {}, relationships: {}, belongings: [])
      @id = id.to_sym
      @name = name.to_s
      @attributes = attributes.transform_keys(&:to_sym)
      @relationships = relationships.transform_keys(&:to_sym)
      @belongings = belongings.map(&:to_sym)
    end

    def set_attribute(key, value)
      @attributes[key.to_sym] = value
    end

    def attribute(key, default = nil)
      @attributes.fetch(key.to_sym, default)
    end

    def has_attribute?(key)
      @attributes.key?(key.to_sym)
    end

    def set_relationship(target_id, relation)
      @relationships[target_id.to_sym] = relation.to_sym
    end

    def relationship(target_id)
      @relationships[target_id.to_sym]
    end

    def add_belonging(item)
      sym = item.to_sym
      @belongings << sym unless @belongings.include?(sym)
      @belongings
    end

    def remove_belonging(item)
      @belongings.delete(item.to_sym)
    end

    def has_belonging?(item)
      @belongings.include?(item.to_sym)
    end

    def alive?
      attribute(:status, :alive) != :deceased && attribute(:hp, 100) > 0
    end

    def kill!
      set_attribute(:hp, 0)
      set_attribute(:status, :deceased)
    end

    def deep_clone
      Character.new(
        id: @id,
        name: @name.dup,
        attributes: @attributes.dup,
        relationships: @relationships.dup,
        belongings: @belongings.dup
      )
    end
  end
end
