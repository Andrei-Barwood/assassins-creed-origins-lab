# frozen_string_literal: true

require "sinatra/base"
require "erb"
require_relative "../origins_lab"

module OriginsLab
  class WebApp < Sinatra::Base
    set :root, File.expand_path("..", __dir__)
    set :views, File.expand_path("origins_lab/views", __dir__)
    set :public_folder, File.expand_path("../../public", __dir__)

    helpers do
      def h(text)
        Rack::Utils.escape_html(text)
      end
    end

    get "/" do
      @acts = (1..5).map do |act_num|
        {
          act_number: act_num,
          act_name: OriginsLab::Manifest.by_act(act_num).first&.act_name || "Acto #{act_num}",
          episodes: OriginsLab::Manifest.by_act(act_num)
        }
      end
      @total_episodes = OriginsLab::Manifest.all_episodes.size
      @total_side_quests = OriginsLab::Manifest.all_side_quests.size
      @total_trophies = OriginsLab::Manifest.all_trophies.size
      @total_easter_eggs = OriginsLab::Manifest.all_easter_eggs.size

      erb :index
    end

    get "/episodes/:id" do
      ep_info = OriginsLab::Manifest.find(params[:id])
      halt 404, "Episodio no encontrado" unless ep_info

      scenario_file = File.expand_path("origins_lab/scenarios/ep#{ep_info.id}.rb", __dir__)
      require scenario_file if File.exist?(scenario_file)

      scenario_class = Object.const_get(ep_info.class_name)
      scenario = scenario_class.new(seed: (params[:seed] || 42).to_i)
      @outcome = scenario.run
      @ep_info = ep_info

      erb :episode
    end

    get "/side-quests" do
      @region = params[:region]
      @side_quests = if @region && !@region.empty?
                       OriginsLab::Manifest.side_quests_by_region(@region)
                     else
                       OriginsLab::Manifest.all_side_quests
                     end
      @regions = OriginsLab::Manifest.all_side_quests.map(&:region).uniq.sort

      erb :side_quests
    end

    get "/trophies" do
      @risk = params[:risk]
      @trophies = if @risk && !@risk.empty?
                    OriginsLab::Manifest.trophies_by_risk(@risk)
                  else
                    OriginsLab::Manifest.all_trophies
                  end

      erb :trophies
    end

    get "/easter-eggs" do
      @easter_eggs = OriginsLab::Manifest.all_easter_eggs
      erb :easter_eggs
    end

    get "/mitigations" do
      @mitigations = OriginsLab::Manifest.all_mitigations
      erb :mitigations
    end
  end
end
