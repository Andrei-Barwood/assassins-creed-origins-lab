# frozen_string_literal: true

require_relative "test_helper"

class TestScenarios < Minitest::Test
  def test_all_21_scenarios_execute_successfully
    OriginsLab::Manifest.all_episodes.each do |ep_info|
      file_path = File.expand_path("../lib/origins_lab/scenarios/ep#{ep_info.id}.rb", __dir__)
      assert File.exist?(file_path), "El archivo de escenario #{file_path} debe existir"

      require file_path
      scenario_class = Object.const_get(ep_info.class_name)
      scenario = scenario_class.new(seed: 42)
      outcome = scenario.run

      assert outcome[:success], "El escenario #{ep_info.id} debe ejecutarse con éxito"
      refute_empty outcome[:events], "El escenario #{ep_info.id} debe registrar eventos"
      refute_empty outcome[:spoilers], "El escenario #{ep_info.id} debe incluir spoilers"
      refute_empty outcome[:mitigations], "El escenario #{ep_info.id} debe incluir mitigaciones"
      refute_nil outcome[:state].location
    end
  end

  def test_specific_plot_points
    # Ep06: Pérdida del dedo anular
    require_relative "../lib/origins_lab/scenarios/ep06"
    ep06 = OriginsLab::Scenarios::Ep06EndOfTheSnake.new.run
    assert ep06[:state].flag?(:ring_finger_lost)
    assert ep06[:state].target_eliminated?(:the_snake)

    # Ep09: Escape de la arena y muerte de Taharqa
    require_relative "../lib/origins_lab/scenarios/ep09"
    ep09 = OriginsLab::Scenarios::Ep09TheScarabsLies.new.run
    assert ep09[:state].target_eliminated?(:the_scarab)
    assert ep09[:state].trophy_unlocked?(:overheating)

    # Ep18: Derrota de Flavius y paz para Khemu
    require_relative "../lib/origins_lab/scenarios/ep18"
    ep18 = OriginsLab::Scenarios::Ep18TheFinalWeighing.new.run
    assert ep18[:state].target_eliminated?(:the_lion)
    assert ep18[:state].flag?(:khemu_avenged)

    # Ep21: Muerte de César y Amunet
    require_relative "../lib/origins_lab/scenarios/ep21"
    ep21 = OriginsLab::Scenarios::Ep21BirthOfTheCreedRome.new.run
    assert ep21[:state].target_eliminated?(:the_father_of_understanding)
    assert ep21[:state].flag?(:amunet_identity_assumed)
    assert ep21[:state].flag?(:layla_recruited_by_assassins)
    assert ep21[:state].trophy_unlocked?(:earn_them_all)
  end
end
