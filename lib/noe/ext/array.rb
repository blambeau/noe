class Array
  
  def methodize_hashes!(recursive = true)
    self.each do |val|
      case val
      when Hash
        val.methodize!(recursive)
      when Array
        val.methodize_hashes!(recursive)
      end
    end
  end
  
  def noe_merge(right)
    (self + right).uniq
  end
  
end # class Array