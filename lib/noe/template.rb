module Noe
  class Template
    include Enumerable
    
    # Main folder of the template
    attr_reader :folder
    
    # Loaded specification
    attr_reader :spec
    
    # Creates a template instance
    def initialize(folder)
      @folder = folder
      __load
    end
  
    # Loads the template from its folder
    def __load
      if File.file?(spec_file) and File.readable?(spec_file)
        @spec = YAML::load(File.read(spec_file))
      else
        raise Noe::Error, "Unable to find template: #{spec_file}"
      end
    end
    
    def spec_layout_file(layout = 'noespec')
      file = File.join(folder, "#{layout}.yaml")
      if File.exists?(file)
        file
      else
        raise Noe::Error, "Unknown specification layout: #{layout}, try 'noe list'"
      end
    end
    alias :spec_file :spec_layout_file
    
    # Merges another spec file inside this template
    def merge_spec_file(file)
      merge_spec YAML::load(File.read(spec_file))
    end
    
    # Merges template spec with another spec given from a Hash
    def merge_spec(hash)
      @spec = @spec.noe_merge(hash)
    end
    
    # Returns template name  
    def name
      File.basename(folder)
    end
    
    # Returns template summary
    def summary
      spec['template-info']['summary'] || description
    end
    
    # Returns template description
    def description
      spec['template-info']['description']
    end
    
    # Returns template version
    def version
      spec['template-info']['version']
    end
    
    # Returns the template variables entry
    def variables
      spec['variables']
    end
    
    def main_wlang_dialect
      spec['template-info']['main-wlang-dialect']
    end
    
    # Returns path to the sources folder
    def src_folder
      File.join(folder, "src")
    end
    
    # Ignore some file?
    def ignore?(file)
      ['.', '..'].include? File.basename(file)
    end
    
    # Returns an entry for a given relative path
    def entry(*paths)
      Entry.new(self, paths.join(File::PATH_SEPARATOR))
    end
    
    # Returns manifest Hash for a given entry
    def manifest_for(entry)
      manifest = spec['template-info']['manifest'] || {}
      manifest[entry.path] || {
        'description'   => "No description for #{entry.path}",
        'safe-override' => false,
        'wlang-dialect' => "wlang/active-text"
      } 
    end
    
    # Visit the template
    def visit(entry = src_folder, &block)
      if entry.is_a?(Entry)
        block.call(entry) 
      else
        entry = Entry.new(self, nil)
      end  
      if entry.directory?
        Dir.foreach(entry.realpath) do |child|
          childentry = entry.child_entry(child)
          unless ignore?(childentry.realpath)
            visit(childentry, &block)
          end
        end
      end
    end
    alias :each :visit
    
    # Delegated to spec
    def to_yaml(*args)
      spec.to_yaml(*args)
    end
  
    private :__load
    
    # Entry inside a template structure
    class Entry
      
      # Template where this entry is located
      attr_reader :template
      
      # Relative path of the entry inside the template
      attr_reader :path
      
      # Creates an entry instance
      def initialize(template, path)
        @template = template
        @path = path
      end
      
      # Returns real absolute path of the entry
      def realpath
        path.nil? ? template.src_folder : File.join(template.src_folder, path)
      end
      
      # Returns entry name
      def name
        File.basename(realpath)
      end
      
      # Relocate the path according to variables
      def relocate(variables)
        path.split(File::PATH_SEPARATOR).
             collect{|v| rename_one(variables, v)}.
             join(File::PATH_SEPARATOR)
      end
      
      # Returns the target name, according to some variables
      def rename_one(variables, name = self.name)
        if name =~ /__([a-z]+)__/
          if x = variables[$1]
            name.gsub(/__([a-z]+)__/, x)
          else
            raise Noe::Error, "Missing variable #{$1}"
          end
        else
          name
        end
      end
      
      # Is the entry a file?
      def file?
        File.file?(realpath)
      end
      
      # Is the entry a directory?
      def directory?
        File.directory?(realpath)
      end
      
      # Builds an child entry for a given name
      def child_entry(name)
        template.entry(path.nil? ? name : File.join(path, name))
      end
      
      # Returns the hash with the manifest for this entry
      def manifest
        template.manifest_for(self)
      end
      
      # Returns wlang dialect to use
      def wlang_dialect
        manifest['wlang-dialect'] || template.main_wlang_dialect || 'wlang/active-text'
      end
      
      # Is this entry safe to override
      def safe_override?
        manifest['safe-override']
      end

    end # class Entry
    
  end # class Template
end # module Noe