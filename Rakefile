require "bundler/gem_tasks"

task default: :style

require "chefstyle"
require "rubocop/rake_task"
RuboCop::RakeTask.new(:style) do |task|
  task.options += ["--display-cop-names", "--no-color"]
end
