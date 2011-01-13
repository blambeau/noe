class Hash
  
  # Methodize this hash
  def methodize!(recursive = true)
    self.extend(Methodize)
    if recursive
      self.values.each do |val|
        case val
        when Hash
          val.methodize!(recursive)
        when Array
          val.methodize_hashes!(recursive)
        end
      end
    end
  end
  
  module Methodize
  
    # Allows using hash.key as a synonym for hash[:key] and
    # hash['key']
    def method_missing(name, *args, &block)
      if args.empty? and block.nil?
        self[name] || self[name.to_s]
      else
        super(name, *args, &block)
      end
    end

  end
end