# frozen_string_literal: true

require_relative "test_helper"

class TestMitigations < Minitest::Test
  def test_precondition_violation_triggers_error
    scene = OriginsLab::Scene.new(id: :restricted_area, title: "Zona Restringida")
    scene.add_precondition("Debe poseer la hoja oculta") do |ws|
      ws.has_item?(:hidden_blade)
    end

    state_without_blade = OriginsLab::WorldState.new(
      episode: "test",
      inventory: [:bronze_sword]
    )

    assert_raises(OriginsLab::PreconditionError) do
      scene.check_preconditions!(state_without_blade)
    end

    state_with_blade = OriginsLab::WorldState.new(
      episode: "test",
      inventory: [:hidden_blade]
    )

    assert scene.check_preconditions!(state_with_blade)
  end

  def test_trinket_mitigation_workflow
    state = OriginsLab::WorldState.new(episode: "mit_test", trinkets_count: 99)
    result = state.sell_trinkets_all!
    refute result[:trophy_unlocked]

    state.add_trinket(100)
    result2 = state.sell_trinkets_all!
    assert result2[:trophy_unlocked]
    assert state.trophy_unlocked?(:reduce_reuse_recycle)
  end
end
