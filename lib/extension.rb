class Hash
  def map_values &block
    ret = {}
    each{|k,v| ret[k] = block.call(v) }
    ret
  end
  def map_keys &block
    ret = {}
    each{|k,v| ret[block.call(k)] = v}
    ret
  end
end
