# frozen_string_literal: true

module OriginsLab
  class WorldState
    attr_accessor :episode, :scene_id, :location, :time_period, :drachmas, :level,
                  :ability_points, :hidden_blade_level, :trinkets_count
    attr_reader :characters, :inventory, :craft_gear, :order_targets, :trophies_unlocked, :flags

    def initialize(
      episode:,
      scene_id: nil,
      location: "Siwa",
      time_period: "49 a.C.",
      drachmas: 250,
      level: 1,
      ability_points: 0,
      hidden_blade_level: 0,
      trinkets_count: 0,
      craft_gear: {},
      characters: {},
      inventory: [],
      order_targets: {},
      trophies_unlocked: [],
      flags: {}
    )
      @episode = episode.to_s.freeze
      @scene_id = scene_id&.to_s
      @location = location.to_s
      @time_period = time_period.to_s
      @drachmas = drachmas.to_i
      @level = level.to_i
      @ability_points = ability_points.to_i
      @hidden_blade_level = hidden_blade_level.to_i
      @trinkets_count = trinkets_count.to_i

      @craft_gear = {
        breastplate: 1,
        bracer: 1,
        quiver: 1,
        stabilizer: 1,
        tool_pouch: 1
      }.merge(craft_gear.transform_keys(&:to_sym))

      @characters = {}
      @inventory = inventory.map(&:to_sym)
      @order_targets = order_targets.transform_keys(&:to_sym)
      @trophies_unlocked = trophies_unlocked.map(&:to_sym)
      @flags = flags.transform_keys(&:to_sym)

      characters.each_value do |char|
        add_character(char)
      end
    end

    def add_character(char)
      raise ArgumentError, "Expected Character instance, got #{char.class}" unless char.is_a?(Character)
      @characters[char.id] = char
    end

    def character(id)
      @characters[id.to_sym]
    end

    def has_character?(id)
      @characters.key?(id.to_sym)
    end

    def add_item(item)
      sym = item.to_sym
      @inventory << sym unless @inventory.include?(sym)
      @inventory
    end

    def remove_item(item)
      @inventory.delete(item.to_sym)
    end

    def has_item?(item)
      @inventory.include?(item.to_sym)
    end

    def adjust_drachmas(delta)
      @drachmas += delta.to_i
      @drachmas
    end

    def level_up(amount = 1)
      @level += amount.to_i
      @ability_points += amount.to_i
      @level
    end

    def upgrade_hidden_blade!
      @hidden_blade_level += 1
      @hidden_blade_level
    end

    def upgrade_gear!(gear_key)
      k = gear_key.to_sym
      @craft_gear[k] = (@craft_gear[k] || 1) + 1
      @craft_gear[k]
    end

    def add_trinket(count = 1)
      @trinkets_count += count.to_i
      @trinkets_count
    end

    # Estrategia de prevención para el trofeo "Reduce, Reuse, Recycle"
    def sell_trinkets_all!
      count = @trinkets_count
      earnings = count * 20
      @drachmas += earnings
      @trinkets_count = 0
      if count >= 100
        unlock_trophy(:reduce_reuse_recycle)
      end
      { count_sold: count, drachmas_earned: earnings, trophy_unlocked: count >= 100 }
    end

    def eliminate_target(target_id)
      @order_targets[target_id.to_sym] = true
    end

    def target_eliminated?(target_id)
      !!@order_targets[target_id.to_sym]
    end

    def unlock_trophy(trophy_id)
      sym = trophy_id.to_sym
      @trophies_unlocked << sym unless @trophies_unlocked.include?(sym)
      @trophies_unlocked
    end

    def trophy_unlocked?(trophy_id)
      @trophies_unlocked.include?(trophy_id.to_sym)
    end

    def set_flag(key, value)
      @flags[key.to_sym] = value
    end

    def flag(key, default = nil)
      @flags.fetch(key.to_sym, default)
    end

    def flag?(key)
      !!@flags[key.to_sym]
    end

    def deep_clone
      cloned_chars = {}
      @characters.each do |k, v|
        cloned_chars[k] = v.deep_clone
      end

      WorldState.new(
        episode: @episode,
        scene_id: @scene_id,
        location: @location.dup,
        time_period: @time_period.dup,
        drachmas: @drachmas,
        level: @level,
        ability_points: @ability_points,
        hidden_blade_level: @hidden_blade_level,
        trinkets_count: @trinkets_count,
        craft_gear: @craft_gear.dup,
        characters: cloned_chars,
        inventory: @inventory.dup,
        order_targets: @order_targets.dup,
        trophies_unlocked: @trophies_unlocked.dup,
        flags: @flags.dup
      )
    end
  end
end
