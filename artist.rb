class Artist
  class << self
    attr_accessor :instances
    def build(name)
      self.instances ||= {}
      unless self.instances[name.to_sym]
        tmp = self.new
        tmp.name = name.to_s
        tmp.lists = []
        self.instances[name.to_sym] = tmp
      end
      self.instances[name.to_sym]
    end
  end

  attr_accessor :lists,:name

  def append_list(i)
    @cached = nil
    lists << i
  end

  def num_lists
    lists.uniq.length
  end

  def in_n_lists?(n)
    num_lists >= n
  end

  def list_bit_flags
    if (!@cached)
      @cached = lists.uniq.inject(0) { |memo,cur| memo |= (1 << cur) }
    end
    @cached
  end

  def shared_list_count(artist)
    my_bit_mask = list_bit_flags
    your_bits = artist.list_bit_flags
    masked = my_bit_mask & your_bits
    masked.to_s(2).count("1")
  end

  def shares_n_lists(artist,n)
    shared_list_count(artist) >= n
  end
end
