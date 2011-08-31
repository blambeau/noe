require File.expand_path('../spec_helper', __FILE__)
describe 'line endings and trailing spaces' do
  it 'all files should end with a single \n and have no trailing spaces' do
    begin
      dir = File.expand_path('../../fixtures', __FILE__)
      project_dir = dir + '/test'
      Dir.chdir(dir) do
        Noe::Main.run(%w{prepare --silent test})
      end
      Dir.chdir(project_dir) do
        FileUtils.cp dir+'/test.noespec', project_dir
        Noe::Main.run(['go'])
        Dir["**/*"].each { |file|
          if File.file?(file) and File.size(file) > 0
            contents = File.read(file)
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
      FileUtils.rm_r(project_dir) if File.exist? project_dir
    end
  end
end
