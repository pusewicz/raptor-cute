# frozen_string_literal: true

require 'rake/clean'

BUILD_DIR = 'build/debug'
ROOT_DIR = File.expand_path(__dir__)
CLOBBER.include(BUILD_DIR)

directory BUILD_DIR do
  sh "cmake -S #{ROOT_DIR} -G Ninja -B #{BUILD_DIR} -DCMAKE_BUILD_TYPE=Debug"
end

task compile: BUILD_DIR do
  sh "cmake --build #{BUILD_DIR} --config Debug"
end

task :run do
  sh "cd #{BUILD_DIR} && ./raptor"
end

task default: :run
