# apparently ruby-1.8.7 doesn't insclude Math.log2
unless Math.methods.include?('log2')
  class << Math
    def log2(n)
      Math.log(n) / Math.log(2)
    end
  end
end
