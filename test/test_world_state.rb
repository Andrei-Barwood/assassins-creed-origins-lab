# frozen_string_literal: true

require_relative "test_helper"

class TestWorldState < Minitest::Test
  def setup
    @bayek = OriginsLab::Character.new(
      id: :bayek,
      name: "Bayek",
      attributes: { hp: 100, level: 5 }
    )
    @state = OriginsLab::WorldState.new(
      episode: "01_el_oasis",
      scene_id: "siwa_temple",
      location: "Siwa",
      drachmas: 500,
      level: 5,
      trinkets_count: 50,
      characters: { bayek: @bayek }
    )
  end

  def test_initial_state
    assert_equal "01_el_oasis", @state.episode
    assert_equal "Siwa", @state.location
    assert_equal 500, @state.drachmas
    assert_equal 5, @state.level
    assert_equal 50, @state.trinkets_count
    assert @state.has_character?(:bayek)
  end

  def test_level_and_gear_upgrades
    @state.level_up(2)
    assert_equal 7, @state.level
    assert_equal 2, @state.ability_points

    @state.upgrade_hidden_blade!
    assert_equal 1, @state.hidden_blade_level

    @state.upgrade_gear!(:quiver)
    assert_equal 2, @state.craft_gear[:quiver]
  end

  def test_trinket_mitigation_sell_all_under_100
    res = @state.sell_trinkets_all!
    assert_equal 50, res[:count_sold]
    assert_equal 1000, res[:drachmas_earned]
    assert_equal 1500, @state.drachmas
    assert_equal 0, @state.trinkets_count
    refute res[:trophy_unlocked]
    refute @state.trophy_unlocked?(:reduce_reuse_recycle)
  end

  def test_trinket_mitigation_sell_all_over_100_unlocks_trophy
    @state.add_trinket(55) # 50 + 55 = 105
    res = @state.sell_trinkets_all!
    assert_equal 105, res[:count_sold]
    assert res[:trophy_unlocked]
    assert @state.trophy_unlocked?(:reduce_reuse_recycle)
  end

  def test_target_elimination
    @state.eliminate_target(:the_ibis)
    assert @state.target_eliminated?(:the_ibis)
    refute @state.target_eliminated?(:the_lion)
  end

  def test_deep_clone
    clone = @state.deep_clone
    refute_same @state, clone
    clone.adjust_drachmas(1000)
    assert_equal 500, @state.drachmas
    assert_equal 1500, clone.drachmas
  end
end
