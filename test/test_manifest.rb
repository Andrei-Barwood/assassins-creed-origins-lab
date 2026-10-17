# frozen_string_literal: true

require_relative "test_helper"

class TestManifest < Minitest::Test
  def test_episodes_count_and_acts
    episodes = OriginsLab::Manifest.all_episodes
    assert_equal 21, episodes.size

    (1..5).each do |act|
      act_eps = OriginsLab::Manifest.by_act(act)
      refute_empty act_eps, "El Acto #{act} debe contener episodios"
    end
  end

  def test_find_and_normalize_id
    assert_equal "01", OriginsLab::Manifest.normalize_id(1)
    assert_equal "05", OriginsLab::Manifest.normalize_id("5")
    assert_equal "21", OriginsLab::Manifest.normalize_id("21")

    ep01 = OriginsLab::Manifest.find("01")
    assert_equal "01_el_oasis", ep01.slug
    assert_equal "Siwa", ep01.region

    ep21 = OriginsLab::Manifest.find("21_nacimiento_del_credo_roma")
    assert_equal "21", ep21.id
  end

  def test_side_quests
    all_sq = OriginsLab::Manifest.all_side_quests
    assert all_sq.size >= 25, "Debe haber al menos 25 misiones secundarias catalogadas"

    siwa_sq = OriginsLab::Manifest.side_quests_by_region("Siwa")
    refute_empty siwa_sq
    assert siwa_sq.any? { |q| q.title == "Gear Up" }
  end

  def test_trophies
    trophies = OriginsLab::Manifest.all_trophies
    assert_equal 14, trophies.size

    max_risk = OriginsLab::Manifest.trophies_by_risk("Máximo")
    assert max_risk.any? { |t| t.title == "Reduce, Reuse, Recycle" }

    crit_risk = OriginsLab::Manifest.trophies_by_risk("Crítico")
    assert crit_risk.any? { |t| t.title == "Old Habits" }
  end

  def test_easter_eggs
    ees = OriginsLab::Manifest.all_easter_eggs
    assert_equal 6, ees.size
    assert ees.any? { |e| e.id == "ee_ffxv" }
    assert ees.any? { |e| e.id == "ee_sphinx_crypt" }
  end

  def test_mitigations
    mits = OriginsLab::Manifest.all_mitigations
    assert_equal 5, mits.size
    assert mits.any? { |m| m.id == "mit_trinkets" }
    assert mits.any? { |m| m.id == "mit_old_habits" }
    assert mits.any? { |m| m.id == "mit_phylakes" }
  end
end
