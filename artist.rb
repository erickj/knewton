class Artist
  class << self
    attr_accessor :instances
    def build(name)
      self.instances ||= {}
      unless self.instances[name.to_sym]
        tmp = self.new
        tmp.name = name.to_s
        self.instances[name.to_sym] = tmp
      end
      self.instances[name.to_sym]
    end
  end

  attr_accessor :lists,:name

  def initialize
    # cached will most likely be a BigNum
    @cached = nil
    @name = nil
    @lists = []
  end

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

  ##
  # if Artist Bjork is lists 0,2,8 list_bit_flags = 261
  def list_bit_flags
    if (!@cached)
      @cached = lists.uniq.inject(0) { |memo,cur| memo |= (1 << cur) }
    end
    @cached
  end

  ###
  # if Bjork is has list_bit_flags = 261 (@see +list_bit_flags+)
  # and Beck has list_bit_flags = 7
  #
  # bjork:  100000101
  # beck:   000000111
  # & --------------
  # masked: 000000101
  #
  # just count the 1's
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
