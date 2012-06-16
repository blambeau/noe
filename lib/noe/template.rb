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
      if spec_file.file? and spec_file.readable?
        @spec = YAML::load(spec_file.read)
      else
        raise Noe::Error, "Unable to find template: #{spec_file}"
      end
    end
    
    def spec_layout_file(layout = 'noespec')
      file = folder/"#{layout}.yaml"
      if file.exists?
        file
      else
        $stderr.puts "Config file: #{file}"
        raise Noe::Error, "No such file or directory: #{file}, try 'noe list'"
      end
    end
    alias :spec_file :spec_layout_file
    
    # Returns an array with available layout names
    def layouts
      folder.glob('*.yaml').map { |file| file.base.to_s }
    end
    
    # Merges another spec file inside this template
    def merge_spec_file(file)
      merge_spec YAML::load(spec_file.read)
    end
    
    # Merges template spec with another spec given from a Hash
    def merge_spec(hash)
      @spec = @spec.noe_merge(hash)
    end
    
    # Returns template name  
    def name
      folder.basename
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
      folder/"src"
    end
    
    # Returns an entry for a given relative path
    def entry(*paths)
      Entry.new(self, paths.join(File::SEPARATOR))
    end
    
    # Returns manifest Hash for a given entry
    def manifest_for(entry)
      path = entry.path.to_s
      manifest = spec['template-info']['manifest']
      manifest = manifest[path]
      if manifest.nil? and Path(path).file?
        raise "Missing manifest for #{entry.path}"
      end
      {
        'description'   => "No description for #{entry.path}",
        'safe-override' => false
      }.merge(manifest || {})
    end
    
    # Visit the template
    def visit(entry = src_folder, &block)
      if entry.is_a?(Entry)
        block.call(entry) 
      else
        entry = Entry.new(self, nil)
      end  
      if entry.directory?
        entry.realpath.each_child(false) do |child|
          childentry = entry.child_entry(child)
          visit(childentry, &block)
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
        @path = Path(path)
      end
      
      # Returns real absolute path of the entry
      def realpath
        template.src_folder/path
      end
      
      # Returns entry name
      def name
        realpath.basename
      end
      
      # Relocate the path according to variables
      def relocate(variables = template.variables)
        # path must be relative (or the initial / might be lost)
        Path(*path.each_filename.map { |v| rename_one(variables, v) })
      end
      
      # Returns the target name, according to some variables
      def rename_one(variables, name = self.name)
        if name.to_s =~ /__([a-z]+)__/
          if x = variables[$1]
            Path(name.to_s.gsub(/__([a-z]+)__/, x))
          else
            raise Noe::Error, "Missing variable #{$1}"
          end
        else
          name
        end
      end
      
      # Is the entry a file?
      def file?
        realpath.file?
      end
      
      # Is the entry a directory?
      def directory?
        realpath.directory?
      end
      
      # Builds an child entry for a given name
      def child_entry(name)
        template.entry(path/name)
      end
      
      # Returns the hash with the manifest for this entry
      def manifest
        template.manifest_for(self)
      end
      
      # Returns wlang dialect to use
      def wlang_dialect
        told = manifest['wlang-dialect']
        if told.nil? && manifest.has_key?('wlang-dialect')
          nil
        else
          told || self.class.infer_wlang_dialect(relocate, template.main_wlang_dialect)
        end
      end
      
      # Infers the wlang dialect to use for the entry
      def self.infer_wlang_dialect(uri, default = nil)
        res = case d = WLang::infer_dialect(uri.to_s)
          when nil
            nil
          when /^wlang/
            d
          else
            WLang::dialect("wlang/#{d}").qualified_name
        end
        res ? res : (default || 'wlang/active-text')
      end
      
      # Returns wlang braces
      def wlang_braces
        @wlang_braces ||= (manifest['wlang-braces'] || "braces").to_sym
      end
      
      # Is this entry safe to override?
      def safe_override?
        manifest['safe-override']
      end
      
      # Is this entry marked as to be ignored?
      def ignore?
        manifest['ignore']
      end

    end # class Entry
    
  end # class Template
end # module Noe
