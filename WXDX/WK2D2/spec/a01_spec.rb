require 'rspec'
require 'spec_helper'
require 'a01'

describe "#merge_sort" do
  # write a new `Array#merge_sort` method; it should not modify the
  # array it is called on, but create a new sorted array.
  let(:array) { [1, 2, 3, 4, 5].shuffle }

  it "works with an empty array" do
    expect([].merge_sort).to eq([])
  end

  it "works with an array of one item" do
    expect([1].merge_sort).to eq([1])
  end

  it "sorts numbers" do
    expect(array.merge_sort).to eq(array.sort)
  end

  it "sorts arrays with duplicates" do
    expect([5, 4, 3, 3, 2, 1].merge_sort).to eq([1, 2, 3, 3, 4, 5])
  end

  it "will use block if given" do
    reversed = array.merge_sort do |num1, num2|
      # reverse order
      num2 <=> num1
    end
    expect(reversed).to eq([5, 4, 3, 2, 1])
  end

  it "does not modify original" do
    duped_array = array.dup
    duped_array.merge_sort
    expect(duped_array).to eq(array)
  end

  it "calls the merge helper method" do
    expect(Array).to receive(:merge).at_least(:once).and_call_original
    array.merge_sort
  end
end

describe "#pair_sum" do
  # Write a new `Array#pair_sum(target)` method that finds all pairs of
  # positions where the elements at those positions sum to the target.

  # NB: ordering matters. I want each of the pairs to be sorted
  # smaller index before bigger index. I want the array of pairs to be
  # sorted "dictionary-wise":
  #   [0, 2] before [1, 2] (smaller first elements come first)
  #   [0, 1] before [0, 2] (then smaller second elements come first)

  it "returns positions of pairs of numbers that add to zero" do
    expect([5, 1, -7, -5].pair_sum(0)).to eq([[0, 3]])
  end

  it "returns positions of pairs that add to other targets" do
    expect([2, 1, 4, -2].pair_sum(5)).to eq([[1, 2]])
  end

  it "finds multiple pairs" do
    expect([5, -1, -5, 1].pair_sum(0)).to eq([[0, 2], [1, 3]])
  end

  it "finds pairs with same element" do
    expect([5, -5, -5].pair_sum(0)).to eq([[0, 1], [0, 2]])
  end

  it "returns [] when no pair is found" do
    expect([5, 5, 3, 1].pair_sum(7)).to eq([])
  end

  it "won't find spurious target pairs" do
    expect([0, 1, 2, 3].pair_sum(0)).to eq([])
  end
end

describe "#factorials_rec" do
  # Write a **recursive** implementation of a method that returns the
  # first `n` factorial numbers.
  # Be aware that the first factorial number is 0!, which is defined to
  # equal 1. So the 2nd factorial is 1!, the 3rd factorial is 2!, etc.

  it "returns first factorial number" do
    expect(factorials_rec(1)).to eq([1])
  end

  it "returns first two factorial numbers" do
    expect(factorials_rec(2)).to eq([1, 1]) # = [0!, 1!]
  end

  it "returns many factorials numbers" do
    expect(factorials_rec(6)).to eq([1, 1, 2, 6, 24, 120])
    # == [0!, 1!, 2!, 3!, 4!, 5!]
  end

  it "calls itself recursively" do
    # this should enforce you calling your method recursively.

    expect(self).to receive(:factorials_rec).at_least(:twice).and_call_original
    factorials_rec(6)
  end
end

# This method returns true if the sentence passed as an argument
# can be created by rearranging the receiver.
describe "shuffled_sentence_detector" do
  it "can detect a shuffled sentence" do
    sentence1 = "the cat ate the rat"
    sentence2 = "the rat ate the cat"
    expect(sentence1.shuffled_sentence_detector(sentence2)).to eq(true)
  end

  it "doesn't return false positives" do
    sentence1 = "the cat ate the rat"
    sentence2 = "the rat ate a cat"
    expect(sentence1.shuffled_sentence_detector(sentence2)).to eq(false)
  end

  it "anagrams don't cause a false positive" do
    sentence1 = "the cat ate the rat"
    sentence2 = "tcatr hatha eteet"
    expect(sentence1.shuffled_sentence_detector(sentence2)).to eq(false)
  end

  it "partial matches don't cause a false positive" do
    sentence1 = "the cat ate the rat"
    sentence2 = "the rat ate cat"
    expect(sentence1.shuffled_sentence_detector(sentence2)).to eq(false)
  end
end

describe "#nth_prime" do
  # `nth_prime(n)` returns the nth prime number
  it "returns the first prime number" do
    expect(nth_prime(1)).to eq(2)
  end

  it "returns the fifth prime number" do
    expect(nth_prime(5)).to eq(11)
  end

  it "returns nil when asked for the zeroth prime" do
    expect(nth_prime(0)).to be_nil
  end
end

describe 'Array#my_each' do
  it 'calls the block passed to it' do
    expect do |block|
      ["test array"].my_each(&block)
    end.to yield_control.once
  end

  it 'yields each element to the block' do
    expect do |block|
      ["el1", "el2"].my_each(&block)
    end.to yield_successive_args("el1", "el2")
  end

  it 'does NOT call the Array#each or Array#map! method' do
    original_array = ["original array"]
    expect(original_array).not_to receive(:each)
    expect(original_array).not_to receive(:map!)
    original_array.my_each {}
  end

  it 'is chainable and returns the original array' do
    original_array = ["original array"]
    expect(original_array.my_each {}).to be(original_array)
  end
end

describe 'Array#my_inject' do
  it 'calls the block passed to it' do
    expect do |block|
      ["test array"].my_inject(:dummy, &block)
    end.to yield_control.once
  end

  it 'makes the first element the accumulator if no default is given' do
    expect do |block|
      ["el1", "el2", "el3"].my_inject(&block)
    end.to yield_successive_args(["el1", "el2"], [nil, "el3"])
  end

  it 'yields the accumulator and each element to the block' do
    expect do |block|
      [1, 2, 3].my_inject(100, &block)
    end.to yield_successive_args([100, 1], [nil, 2], [nil, 3])
  end

  it 'does NOT call the built in Array#inject method' do
    original_array = ["original array"]
    expect(original_array).not_to receive(:inject)
    original_array.my_inject {}
  end

  it 'is chainable and returns a new array' do
    original_array = ["original array"]
    expect(original_array.my_inject {}).not_to eq(original_array)
  end
end

