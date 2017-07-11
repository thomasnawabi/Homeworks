class Array
  # Write a new `Array#merge_sort` method; it should not modify the
  # array it is called on, but create a new sorted array.
  def merge_sort(&prc)
    prc  ||= Proc.new {|x, y| x <=> y }
    return self if self.count <= 1

    mid = count / 2
    left = take(mid).merge_sort(&prc)
    right = drop(mid).merge_sort(&prc)

    Array.merge(left, right, &prc)
  end

  private
  def self.merge(left, right, &prc)
    merged = []
    until left.empty? || right.empty?
      case prc.call(left.first, right.first)
      when -1
        merged << left.shift
      when 0
        merged << left.shift
      when 1
        merged << right.shift
      end
    end
    merged.concat(left)
    merged.concat(right)
    merged
  end

end

class Array
  # Write a new `Array#pair_sum(target)` method that finds all pairs of
  # positions where the elements at those positions sum to the target.

  # NB: ordering matters. I want each of the pairs to be sorted
  # smaller index before bigger index. I want the array of pairs to be
  # sorted "dictionary-wise":
  #   [0, 2] before [1, 2] (smaller first elements come first)
  #   [0, 1] before [0, 2] (then smaller second elements come first)

  def pair_sum(target)
    pairs = []
    self.each_with_index do |el, first_idx|
      ((first_idx + 1)...self.length).each do |second_idx|
        if el + self[second_idx] == target
          pairs << [first_idx, second_idx]
        end
      end
    end
    pairs
  end
end
p [5, 1, -7, -5].pair_sum(0)
# Write a method that recursively finds the first `n` factorial numbers
# and returns them. N! is the product of the numbers 1 to N.
# Be aware that the first factorial number is 0!, which is defined
# to equal 1. The 2nd factorial is 1!, the 3rd factorial is 2!, etc.
# The "calls itself recursively" spec may say that there is no method
# named "and_call_original" if you are using an older version of
# rspec. You may ignore this failure.
def factorials_rec(n)
  if n <= 1
    [1]
  #forgot else
  else
    # put an empty array for no reason facs = []
    facs = factorials_rec(n - 1)
    facs << facs.last * (n - 1)
    facs
end


# class String
#   # This method returns true if the string can be rearranged to form the
#   # sentence passed as an argument.
#
#   # Example:
#   # "cats are cool".shuffled_sentence_detector("dogs are cool") => false
#   # "cool cats are".shuffled_sentence_detector("cats are cool") => true
#
#   def shuffled_sentence_detector(sentence)
#     if self == self.shuffle.sort
#       true
#     end
#     self.split.each do |ch1|
#         return false
#       if sentence.include?(ch1)
#         return true
#       end
#     end
#   end
# end

#misunderstood question
class String
  def shuffled_sentence_detector(other)
    self.split.sort == other.split.sort
  end
end


def is_prime?(num)
  array_new = (2...num).select{ |el| num % el == 0 }
  if array_new.empty?
    true
  else
    false
  end
end


# Write a method that returns the nth prime number
def nth_prime(n)
  i = 2
  arr_n = []
  until arr_n.count == n
    arr_n << i if is_prime?(i)
    i += 1
  end
  arr_n.last
end

#called select which didnt satisfy the specs
class Array
  def my_each(&blk)
    i = 0
    while i < length
      blk.call(self[i])
      i += 1
    end
    self
  end
end

class Array
  # Write an array method that calls the given block on each element and
  # combines each result one-by-one with a given accumulator. If no accumulator is
  # given, the first element is used.
  def my_inject(accumulator = nil, &prc)
    i = 0
    if accumulator.nil?
      accumulator = self.first
      i += 1
    end

    while i < self.size
      accumulator = prc.call(accumulator, self[i])
      i +=1
    end
    accumulator
  end
end
