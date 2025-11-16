class TestNode
  include Contrek::Concurrent::Listable

  attr_reader :name
  def initialize(name)
    @name = name
  end

  def payload
    @name
  end
end

class TestList
  prepend Contrek::Concurrent::Queueable
end

RSpec.describe Contrek::Concurrent::Listable, type: :class do
  describe "Listable class test" do
    it "removes ancients" do
      e = TestNode.new("e")
      a = TestNode.new("a")
      b = TestNode.new("b")
      b1 = TestNode.new("b")
      a1 = TestNode.new("a")
      f = TestNode.new("f")
      g = TestNode.new("g")
      list = TestList.new
      [e, a, b, b1, a1, f, g].each { |entry| list.add(entry) }
      expect(list.to_a).to eq ["e", "a", "b", "b", "a", "f", "g"]
      expect(a.next).to be b
      expect(list.remove_adjacent_pairs).to eq ["e", "f", "g"]
      list.remove_adjacent_pairs!
      expect(list.to_a).to eq ["e", "f", "g"]
    end

    it "removes ancients 2" do
      a = TestNode.new("a")
      b = TestNode.new("b")
      b1 = TestNode.new("b")
      list = TestList.new
      [a, b, b1].each { |entry| list.add(entry) }
      expect(list.to_a).to eq ["a", "b", "b"]
      list.remove_adjacent_pairs!
      expect(list.to_a).to eq ["a"]
    end

    it "no removes ancients" do
      a = TestNode.new("a")
      b = TestNode.new("b")
      c = TestNode.new("c")
      list = TestList.new
      [a, b, c].each { |entry| list.add(entry) }
      expect(list.to_a).to eq ["a", "b", "c"]
      list.remove_adjacent_pairs!
      expect(list.to_a).to eq ["a", "b", "c"]
    end

    it "removes ancients 3" do
      a = TestNode.new("a")
      b = TestNode.new("b")
      b1 = TestNode.new("b")
      list = TestList.new
      [b, b1, a].each { |entry| list.add(entry) }
      expect(list.to_a).to eq ["b", "b", "a"]
      list.remove_adjacent_pairs!
      expect(list.to_a).to eq ["a"]
    end

    it "multiple append" do
      a1 = TestNode.new("a1")
      a2 = TestNode.new("a2")
      list_a = TestList.new
      list_a.add(a1)
      list_a.add(a2)
      expect(list_a.to_a).to eq ["a1", "a2"]

      b1 = TestNode.new("b1")
      b2 = TestNode.new("b2")
      list_b = TestList.new
      list_b.add(b1)
      list_b.add(b2)
      expect(list_b.to_a).to eq ["b1", "b2"]

      list_c = TestList.new
      list_c.append(list_a)
      list_c.append(list_b)

      expect(list_c.to_a).to eq ["a1", "a2", "b1", "b2"]
      expect(list_c.head).to eq a1
      expect(list_c.tail).to eq b2
      expect(list_c.size).to eq 4
      expect(list_a.to_a).to eq []
      expect(list_b.to_a).to eq []
      expect(list_a.head).to be nil
      expect(list_a.tail).to be nil
      expect(list_b.head).to be nil
      expect(list_b.tail).to be nil
      expect(list_b.size).to eq 0
      expect(list_a.size).to eq 0
    end

    it "iterate and remove" do
      a = TestNode.new("a")
      b = TestNode.new("b")
      c = TestNode.new("c")
      list = TestList.new
      list2 = TestList.new
      list.add(a)
      list.add(b)
      list.add(c)
      list2.move_from(list) { |node| node.name == "b" }
      expect(list2.to_a).to eq ["b"]
      expect(list.to_a).to eq ["a", "c"]
    end

    it "intersection" do
      a = TestNode.new("a")
      b = TestNode.new("b")
      c = TestNode.new("c")
      c1 = TestNode.new("c")
      d = TestNode.new("d")
      list = TestList.new
      list.add(a)
      list.add(b)
      list.add(c)
      list2 = TestList.new

      expect(list.intersection_with(list2)).to eq([])
      expect(list.intersect_with?(list2)).to be false

      list2.add(c1)
      list2.add(d)

      expect(list.intersection_with(list2)).to eq(["c"])
      expect(list.intersect_with?(list2)).to be true
    end

    it "iterate and remove 2" do
      a = TestNode.new("a")
      b = TestNode.new("b")
      c = TestNode.new("c")

      list = TestList.new
      list2 = TestList.new

      list.add(a)
      list.add(b)
      list.add(c)

      expect(list.iterator).to eq a
      list.forward!
      list2.add(a)
      expect(list.iterator).to eq b
      list.forward!
      list2.add(b)
      expect(list.iterator).to eq c
      expect(list2.to_a).to eq ["a", "b"]
      expect(list.to_a).to eq ["c"]
      list.forward!
      list2.add(c)
      expect(list.iterator).to eq nil
      expect(list2.to_a).to eq ["a", "b", "c"]
      expect(list.to_a).to eq []

      expect(list.iterator).to be nil
    end

    it "moves nodes by two lists" do
      a = TestNode.new("a")
      b = TestNode.new("b")

      list = TestList.new

      list.add(a)
      expect(list.to_a).to eq ["a"]
      expect(list.head).to eq a
      expect(list.tail).to eq a
      expect(a.owner).to eq list
      expect(a.next).to be nil
      expect(a.prev).to be nil
      expect(list.size).to eq(1)

      list.add(b)
      expect(list.to_a).to eq ["a", "b"]
      expect(list.head).to eq a
      expect(list.tail).to eq b
      expect(b.owner).to eq list
      expect(a.next).to be b
      expect(a.prev).to be nil
      expect(b.next).to be nil
      expect(b.prev).to be a
      expect(list.size).to eq(2)

      list.rem(a)
      expect(list.to_a).to eq ["b"]
      expect(list.head).to eq b
      expect(list.tail).to eq b
      expect(b.next).to be nil
      expect(b.prev).to be nil
      expect(a.next).to be nil
      expect(a.prev).to be nil
      expect(a.owner).to be nil
      expect(list.size).to eq(1)

      list2 = TestList.new
      expect(list2.size).to eq(0)
      list2.add(a)
      expect(list2.to_a).to eq ["a"]
      expect(list2.head).to eq a
      expect(list2.tail).to eq a
      expect(a.owner).to eq list2
      expect(a.next).to be nil
      expect(a.prev).to be nil
      expect(list2.size).to eq(1)

      list2.rem(a)
      expect(list2.to_a).to eq []
      expect(list2.head).to be nil
      expect(list2.tail).to be nil
      expect(a.next).to be nil
      expect(a.prev).to be nil
      expect(a.owner).to be nil
      expect(list2.size).to eq(0)

      list2 = TestList.new
      list2.add(a)
      expect(list2.to_a).to eq ["a"]
      expect(list2.head).to eq a
      expect(list2.tail).to eq a
      expect(a.owner).to eq list2
      expect(a.next).to be nil
      expect(a.prev).to be nil

      list.append(list2)
      expect(list2.to_a).to eq []
      expect(list2.head).to be nil
      expect(list2.tail).to be nil
      expect(list.to_a).to eq ["b", "a"]
      expect(list.head).to eq b
      expect(list.tail).to eq a
      expect(b.owner).to eq list
      expect(a.owner).to eq list
      expect(a.next).to be nil
      expect(a.prev).to be b
      expect(b.next).to be a
      expect(b.prev).to be nil
      expect(list.size).to eq(2)

      # iterator
      expect(list.iterator).to eq b
      list.forward!
      expect(list.iterator).to eq a
      list.forward!
      expect(list.iterator).to eq nil
      list.rewind!
      expect(list.iterator).to eq b
      list.forward!
      expect(list.iterator).to eq a
      list.forward!
      expect(list.iterator).to eq nil

      list.rewind!
      expect(list.iterator).to eq b
      expect(list.iterator).to eq b
      list.forward!
      expect(list.iterator).to eq a
      expect(list.iterator).to eq a
      list.forward!
      expect(list.iterator).to eq nil

      list.next_of!(b)
      expect(list.iterator).to eq a
      list.next_of!(a)
      expect(list.iterator).to eq nil
    end
  end
end
