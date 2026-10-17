# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "origins_lab"
require "origins_lab/web_app"

run OriginsLab::WebApp
