# frozen_string_literal: true

require_relative "test_helper"
require_relative "../lib/origins_lab/web_app"

class TestWebApp < Minitest::Test
  def setup
    @app = OriginsLab::WebApp.new
    @request = Rack::MockRequest.new(@app)
  end

  def test_index_route
    res = @request.get("/")
    assert_equal 200, res.status
    assert_includes res.body, "Assassin's Creed Origins"
    assert_includes res.body, "01. El Oasis"
    assert_includes res.body, "21. Nacimiento del Credo"
  end

  def test_episode_routes
    res = @request.get("/episodes/01")
    assert_equal 200, res.status
    assert_includes res.body, "The Oasis"
    assert_includes res.body, "Rudjek"

    res21 = @request.get("/episodes/21")
    assert_equal 200, res21.status
    assert_includes res21.body, "Amunet"
    assert_includes res21.body, "Layla Hassan"
  end

  def test_side_quests_route
    res = @request.get("/side-quests")
    assert_equal 200, res.status
    assert_includes res.body, "Gear Up"

    res_siwa = @request.get("/side-quests?region=Siwa")
    assert_equal 200, res_siwa.status
    assert_includes res_siwa.body, "Siwa"
  end

  def test_trophies_route
    res = @request.get("/trophies")
    assert_equal 200, res.status
    assert_includes res.body, "Old Habits"
    assert_includes res.body, "Reduce, Reuse, Recycle"

    res_crit = @request.get("/trophies?risk=critico")
    assert_equal 200, res_crit.status
    assert_includes res_crit.body, "Old Habits"
  end

  def test_easter_eggs_route
    res = @request.get("/easter-eggs")
    assert_equal 200, res.status
    assert_includes res.body, "Final Fantasy XV"
    assert_includes res.body, "Gran Esfinge"
  end

  def test_mitigations_route
    res = @request.get("/mitigations")
    assert_equal 200, res.status
    assert_includes res.body, "Phylakes"
    assert_includes res.body, "Elefantes de Guerra"
  end

  def test_not_found_episode
    res = @request.get("/episodes/99")
    assert_equal 404, res.status
  end
end
