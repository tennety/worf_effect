# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'guard/guard'

module ::Guard
  class Talk < ::Guard::Guard
    def run_on_changes(paths)
      paths.each do |path|
        `slidedown #{path} > #{path.chomp(File.extname(path))}.html`
        ::Guard::Notifier.notify("Slides created.", title: path, image: :success)
      end
    end
  end
end

guard :talk do
  watch("talk/talk.md")
end
