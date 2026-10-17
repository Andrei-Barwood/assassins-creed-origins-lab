# frozen_string_literal: true

require_relative "test_helper"

class TestCharacter < Minitest::Test
  def setup
    @bayek = OriginsLab::Character.new(
      id: :bayek,
      name: "Bayek de Siwa",
      attributes: { hp: 100, level: 1, role: :medjay, status: :alive },
      relationships: { khemu: :son, aya: :beloved_wife },
      belongings: [:medjay_badge, :bronze_sword]
    )
  end

  def test_initialization
    assert_equal :bayek, @bayek.id
    assert_equal "Bayek de Siwa", @bayek.name
    assert_equal 100, @bayek.attribute(:hp)
    assert_equal :son, @bayek.relationship(:khemu)
    assert @bayek.has_belonging?(:medjay_badge)
    assert @bayek.alive?
  end

  def test_belongings_manipulation
    @bayek.add_belonging(:hidden_blade)
    assert @bayek.has_belonging?(:hidden_blade)
    @bayek.remove_belonging(:bronze_sword)
    refute @bayek.has_belonging?(:bronze_sword)
  end

  def test_kill_and_attributes
    @bayek.kill!
    refute @bayek.alive?
    assert_equal :deceased, @bayek.attribute(:status)
    assert_equal 0, @bayek.attribute(:hp)
  end

  def test_deep_clone
    clone = @bayek.deep_clone
    refute_same @bayek, clone
    assert_equal @bayek.name, clone.name
    clone.set_attribute(:level, 10)
    assert_equal 1, @bayek.attribute(:level)
    assert_equal 10, clone.attribute(:level)
  end
end
