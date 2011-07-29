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
  
  # Makes a fully recursive merge
  def noe_merge(right, stack = "")
    self.merge(right) do |key,oldval,newval|
      if oldval.nil? or newval.nil?
        newval
      elsif [true, false].include?(oldval) &&
            [true, false].include?(newval)
        newval
      elsif oldval.class != newval.class
        raise Noe::Error, "Conflict on #{stack} has to be resolved manually, sorry.\n"\
                          "#{oldval} (#{oldval.class}) vs. #{newval} (#{newval.class})"
      elsif oldval.respond_to?(:noe_merge)
        oldval.noe_merge(newval, "#{stack}/#{key}")
      else
        newval
      end
    end
  end
  
  module Methodize

    def gem(*args, &block)
      if args.empty? && block.nil? && (self[:gem] || self["gem"])
        self[:gem] || self["gem"]
      else
        super
      end
    end
  
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
