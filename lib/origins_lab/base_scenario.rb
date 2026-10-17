# frozen_string_literal: true

module OriginsLab
  class BaseScenario
    attr_reader :state, :events, :seed

    def initialize(initial_state = nil, seed: 42)
      @seed = seed
      @random = Random.new(seed)
      @events = EventLog.new
      @state = initial_state ? initial_state.deep_clone : default_initial_state
    end

    def run
      emit("story.scenario_started", actor: main_actor, data: { episode: episode_id })
      execute_scenario
      emit("story.scenario_completed", actor: main_actor, data: { episode: episode_id, final_location: @state.location })
      outcome
    end

    def outcome
      {
        success: true,
        episode_id: episode_id,
        state: @state,
        events: @events,
        summary: generate_summary,
        spoilers: spoilers,
        easter_eggs: easter_eggs,
        mitigations: mitigations,
        side_quests: side_quests,
        trophies: trophies
      }
    end

    def spoilers
      []
    end

    def easter_eggs
      []
    end

    def mitigations
      []
    end

    def side_quests
      []
    end

    def trophies
      []
    end

    protected

    def episode_id
      raise NotImplementedError, "Subclasses must implement #episode_id"
    end

    def main_actor
      :bayek
    end

    def default_initial_state
      raise NotImplementedError, "Subclasses must implement #default_initial_state"
    end

    def execute_scenario
      raise NotImplementedError, "Subclasses must implement #execute_scenario"
    end

    def generate_summary
      "Episodio #{episode_id} completado con #{@events.size} eventos registrados."
    end

    def emit(id, actor: nil, target: nil, data: {})
      @events.emit(
        id,
        episode: episode_id,
        scene: @state.scene_id || "unspecified",
        actor: actor || main_actor,
        target: target,
        data: data
      )
    end

    def transition_to(scene, new_location: nil, new_time: nil)
      scene.check_preconditions!(@state)
      @state.scene_id = scene.id.to_s
      @state.location = new_location if new_location
      @state.time_period = new_time if new_time
      emit("story.scene_transition", data: { to_scene: scene.id.to_s, location: @state.location })
    end
  end
end
