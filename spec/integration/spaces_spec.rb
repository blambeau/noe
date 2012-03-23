require 'spec_helper'
describe 'line endings and trailing spaces' do
  it 'all files should end with a single \n and have no trailing spaces' do
    begin
      dir = Path.relative '../fixtures'
      project_dir = dir / 'test'
      dir.chdir do
        Noe::Main.run(%w{prepare --silent test})
      end
      project_dir.chdir do
        (dir/'test.noespec').cp(project_dir)
        Noe::Main.run(['go'])
        Path.glob("**/*") { |file|
          if file.file? and !file.empty?
            contents = file.read
            tail = contents[-3..-1]
            contents.each_line.with_index { |line, i|
              line.should match(/(?:^|\S)$/),
                "#{file} line #{i+1} has trailing spaces:\n#{line.inspect}"
            }
            tail.should match(/[^\n]\n\z/),
              "#{file} does not end with a single LF (#{tail.inspect})"
          end
        }
      end
    ensure
      project_dir.rm_r if project_dir.exist?
    end
  end
end
