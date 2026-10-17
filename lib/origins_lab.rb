# frozen_string_literal: true

module OriginsLab
  class Error < StandardError; end
  class PreconditionError < Error; end
  class ExecutionError < Error; end
  class StateError < Error; end
end

require_relative "origins_lab/character"
require_relative "origins_lab/event_log"
require_relative "origins_lab/world_state"
require_relative "origins_lab/scene"
require_relative "origins_lab/base_scenario"
require_relative "origins_lab/manifest"
