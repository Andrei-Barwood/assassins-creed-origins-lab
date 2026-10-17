# frozen_string_literal: true

module OriginsLab
  class Event
    attr_reader :sequence, :id, :episode, :scene, :actor, :target, :data, :timestamp

    def initialize(sequence:, id:, episode:, scene:, actor: nil, target: nil, data: {}, timestamp: Time.now)
      @sequence = sequence.to_i
      @id = id.to_s
      @episode = episode.to_s
      @scene = scene.to_s
      @actor = actor&.to_sym
      @target = target&.to_sym
      @data = data
      @timestamp = timestamp
    end

    def to_h
      {
        sequence: @sequence,
        id: @id,
        episode: @episode,
        scene: @scene,
        actor: @actor,
        target: @target,
        data: @data,
        timestamp: @timestamp.iso8601
      }
    end
  end

  class EventLog
    include Enumerable

    def initialize
      @events = []
    end

    def emit(id, episode:, scene:, actor: nil, target: nil, data: {})
      seq = @events.size + 1
      event = Event.new(
        sequence: seq,
        id: id,
        episode: episode,
        scene: scene,
        actor: actor,
        target: target,
        data: data
      )
      @events << event
      event
    end

    def each(&block)
      @events.each(&block)
    end

    def size
      @events.size
    end

    def empty?
      @events.empty?
    end

    def last
      @events.last
    end

    def [](index)
      @events[index]
    end

    def find_by_id(event_id)
      @events.select { |e| e.id == event_id.to_s }
    end

    def find_by_actor(actor)
      @events.select { |e| e.actor == actor.to_sym }
    end

    def to_a
      @events.dup
    end
  end
end
