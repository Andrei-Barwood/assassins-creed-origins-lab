# frozen_string_literal: true

module OriginsLab
  class Scene
    attr_reader :id, :title, :location, :preconditions

    def initialize(id:, title:, location: "")
      @id = id.to_sym
      @title = title.to_s
      @location = location.to_s
      @preconditions = []
    end

    def add_precondition(description, &block)
      @preconditions << { description: description, check: block }
    end

    def check_preconditions!(state)
      @preconditions.each do |cond|
        satisfied = begin
          cond[:check].call(state)
        rescue StandardError => e
          raise OriginsLab::PreconditionError, "Fallo al evaluar precondición '#{cond[:description]}': #{e.message}"
        end

        unless satisfied
          raise OriginsLab::PreconditionError, "Precondición insatisfecha para escena '#{@id}': #{cond[:description]}"
        end
      end
      true
    end
  end
end
