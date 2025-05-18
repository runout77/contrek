RSpec.describe Contrek::Finder::List, type: :class do
  describe "List class" do
    it "grab" do
      lists = Contrek::Finder::Lists.new
      list_a = lists.add_list
      list_b = lists.add_list

      node_c = Contrek::Finder::ListEntry.new(lists, "C")
      expect(list_b.contains(node_c)).to be false
      list_b << node_c
      expect(list_b.contains(node_c)).to be true
      expect(node_c.data_pointer[list_b.idd].next).to be nil
      expect(node_c.data_pointer[list_b.idd].prev).to be nil
      expect(node_c.data_pointer[list_b.idd].inside).to be true
      expect(list_b.map { |a| a.name }.join).to eq("C")
      expect(list_b.size).to eq(1)
      expect(list_a.size).to eq(0)

      list_a.grab(list_b)
      expect(list_b.size).to eq(0)
      expect(list_a.size).to eq(1)
      expect(list_b.start).to be nil
      expect(list_b.end).to be nil
      expect(node_c.data_pointer[list_b.idd].next).to be nil
      expect(node_c.data_pointer[list_b.idd].prev).to be nil
      expect(node_c.data_pointer[list_b.idd].inside).to be false
      expect(node_c.data_pointer[list_a.idd].next).to be nil
      expect(node_c.data_pointer[list_a.idd].prev).to be nil
      expect(node_c.data_pointer[list_a.idd].inside).to be true
    end

    it "grab 2" do
      lists = Contrek::Finder::Lists.new
      list_a = lists.add_list
      list_b = lists.add_list

      node_c = Contrek::Finder::ListEntry.new(lists, "C")
      node_d = Contrek::Finder::ListEntry.new(lists, "D")
      node_e = Contrek::Finder::ListEntry.new(lists, "E")

      list_a << node_c
      list_b << node_d
      list_b << node_e

      expect(list_a.map { |a| a.name }.join).to eq("C")
      expect(list_b.map { |a| a.name }.join).to eq("DE")
      expect(node_e.data_pointer[list_b.idd].next).to be nil
      expect(node_e.data_pointer[list_b.idd].prev).to be node_d
      expect(node_d.data_pointer[list_b.idd].next).to be node_e
      expect(node_d.data_pointer[list_b.idd].prev).to be nil

      list_a.grab(list_b)

      expect(list_a.size).to eq(3)
      expect(list_b.size).to eq(0)
      expect(list_b.start).to be nil
      expect(list_b.end).to be nil
      expect(list_a.end).to be node_e
      expect(list_a.map { |a| a.name }.join).to eq("CDE")

      expect(node_c.data_pointer[list_a.idd].next).to be node_d
      expect(node_c.data_pointer[list_a.idd].prev).to be nil
      expect(node_d.data_pointer[list_a.idd].next).to be node_e
      expect(node_d.data_pointer[list_a.idd].prev).to be node_c
      expect(node_e.data_pointer[list_a.idd].next).to be nil
      expect(node_e.data_pointer[list_a.idd].prev).to be node_d
    end

    it "grab with dest empty" do
      lists = Contrek::Finder::Lists.new
      list_a = lists.add_list
      list_b = lists.add_list

      node_c = Contrek::Finder::ListEntry.new(lists, "C")
      node_d = Contrek::Finder::ListEntry.new(lists, "D")
      node_e = Contrek::Finder::ListEntry.new(lists, "E")

      list_b << node_c
      list_b << node_d
      list_b << node_e

      expect(list_a.map { |a| a.name }.join).to eq("")
      expect(list_b.map { |a| a.name }.join).to eq("CDE")

      list_a.grab(list_b)

      expect(list_a.size).to eq(3)
      expect(list_b.size).to eq(0)
      expect(list_b.start).to be nil
      expect(list_b.end).to be nil
      expect(list_a.end).to be node_e
      expect(list_a.start).to be node_c
      expect(list_a.map { |a| a.name }.join).to eq("CDE")

      expect(node_c.data_pointer[list_a.idd].next).to be node_d
      expect(node_c.data_pointer[list_a.idd].prev).to be nil
      expect(node_d.data_pointer[list_a.idd].next).to be node_e
      expect(node_d.data_pointer[list_a.idd].prev).to be node_c
      expect(node_e.data_pointer[list_a.idd].next).to be nil
      expect(node_e.data_pointer[list_a.idd].prev).to be node_d

      expect(node_c.data_pointer[list_b.idd].next).to be nil
      expect(node_c.data_pointer[list_b.idd].prev).to be nil
      expect(node_d.data_pointer[list_b.idd].next).to be nil
      expect(node_d.data_pointer[list_b.idd].prev).to be nil
      expect(node_e.data_pointer[list_b.idd].next).to be nil
      expect(node_e.data_pointer[list_b.idd].prev).to be nil
    end

    it "grab empty" do
      lists = Contrek::Finder::Lists.new
      list_a = lists.add_list
      list_b = lists.add_list

      node_c = Contrek::Finder::ListEntry.new(lists, "C")
      node_d = Contrek::Finder::ListEntry.new(lists, "D")
      node_e = Contrek::Finder::ListEntry.new(lists, "E")

      list_b << node_c
      list_b << node_d
      list_b << node_e

      expect(list_a.map { |a| a.name }.join).to eq("")
      expect(list_b.map { |a| a.name }.join).to eq("CDE")

      list_b.grab(list_a)

      expect(list_a.size).to eq(0)
      expect(list_b.size).to eq(3)
    end

    it "shifts" do
      lists = Contrek::Finder::Lists.new
      list_a = lists.add_list
      node_a = Contrek::Finder::ListEntry.new(lists, "A")
      node_b = Contrek::Finder::ListEntry.new(lists, "B")
      node_c = Contrek::Finder::ListEntry.new(lists, "C")
      node_d = Contrek::Finder::ListEntry.new(lists, "D")
      node_e = Contrek::Finder::ListEntry.new(lists, "E")

      expect(list_a.size).to eq(0)
      expect(list_a.first).to be nil
      list_a << node_a
      expect(list_a.size).to eq(1)
      expect(list_a.first).to be node_a
      list_a << node_c
      expect(list_a.size).to eq(2)
      list_a << node_b
      expect(list_a.size).to eq(3)
      list_a << node_d
      expect(list_a.size).to eq(4)
      list_a << node_e
      expect(list_a.size).to eq(5)
      expect(list_a.map { |a| a.name }.join).to eq("ACBDE")

      expect(list_a.find { |a| a.name == "B" }).to eq node_b
      expect(list_a.find { |a| a.name == "F" }).to be nil

      list_a.shift
      expect(list_a.size).to eq(4)
      list_a.delete(node_b)
      expect(list_a.size).to eq(3)
      expect(list_a.map { |a| a.name }.join).to eq("CDE")
      list_a.delete(node_a)

      list_a.shift
      expect(list_a.map { |a| a.name }.join).to eq("DE")
      expect(list_a.size).to eq(2)
      list_a.delete(node_d)
      expect(list_a.map { |a| a.name }.join).to eq("E")
      expect(list_a.size).to eq(1)
      list_a.delete(node_e)
      expect(list_a.size).to eq(0)
    end

    it "injects" do
      lists = Contrek::Finder::Lists.new

      list_a = lists.add_list
      expect(list_a.start).to be nil
      expect(list_a.end).to be nil
      expect(list_a.size).to be 0
      expect(list_a.idd).to be 0

      list_b = lists.add_list
      expect(list_b.start).to be nil
      expect(list_b.end).to be nil
      expect(list_b.size).to be 0
      expect(list_b.idd).to be 1

      node_a = Contrek::Finder::ListEntry.new(lists, "A")

      expect(node_a.data_pointer.class).to be Array
      expect(node_a.data_pointer.size).to eq(2)
      expect(node_a.data_pointer[0]).to eq(Contrek::Finder::Lists::Link.new(nil, nil, false))
      expect(node_a.data_pointer[1]).to eq(Contrek::Finder::Lists::Link.new(nil, nil, false))

      node_b = Contrek::Finder::ListEntry.new(lists, "B")
      expect(node_b.data_pointer.class).to be Array
      expect(node_b.data_pointer.size).to eq(2)
      expect(node_b.data_pointer[0]).to eq(Contrek::Finder::Lists::Link.new(nil, nil, false))
      expect(node_b.data_pointer[1]).to eq(Contrek::Finder::Lists::Link.new(nil, nil, false))

      node_c = Contrek::Finder::ListEntry.new(lists, "C")

      # add entry
      list_a << node_a
      expect(list_a.size).to be 1
      expect(list_a.end).to be node_a
      expect(list_a.start).to be node_a

      expect(node_a.data_pointer[list_a.idd].next).to be nil
      expect(node_a.data_pointer[list_a.idd].prev).to be nil

      list_a << node_b
      expect(list_a.size).to be 2
      expect(list_a.end).to be node_b
      expect(list_a.start).to be node_a

      expect(node_a.data_pointer[list_a.idd].prev).to be nil
      expect(node_a.data_pointer[list_a.idd].next).to be node_b
      expect(node_b.data_pointer[list_a.idd].prev).to be node_a
      expect(node_b.data_pointer[list_a.idd].next).to be nil
      expect(list_a.map { |a| a.name }.join).to eq("AB")

      # delete begins entry
      list_a.delete(node_a)
      expect(list_a.size).to be 1
      expect(list_a.end).to be node_b
      expect(list_a.start).to be node_b
      expect(node_a.data_pointer[list_a.idd].prev).to be nil
      expect(node_a.data_pointer[list_a.idd].next).to be nil

      expect(list_a.map { |a| a.name }.join).to eq("B")
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be nil

      # add again
      list_a << node_a
      expect(list_a.map { |a| a.name }.join).to eq("BA")
      expect(list_a.size).to be 2
      expect(list_a.end).to be node_a
      expect(list_a.start).to be node_b
      expect(node_a.data_pointer[list_a.idd].prev).to be node_b
      expect(node_a.data_pointer[list_a.idd].next).to be nil
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be node_a

      # delete ends entry
      list_a.delete(node_a)
      expect(list_a.size).to be 1
      expect(list_a.end).to be node_b
      expect(list_a.start).to be node_b
      expect(node_a.data_pointer[list_a.idd].prev).to be nil
      expect(node_a.data_pointer[list_a.idd].next).to be nil

      expect(list_a.map { |a| a.name }.join).to eq("B")
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be nil

      # add again
      list_a << node_a
      expect(list_a.map { |a| a.name }.join).to eq("BA")
      expect(node_a.data_pointer[list_a.idd].prev).to be node_b
      expect(node_a.data_pointer[list_a.idd].next).to be nil
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be node_a

      # try fail adding again node_b
      list_a << node_b
      expect(list_a.map { |a| a.name }.join).to eq("BA")
      expect(node_a.data_pointer[list_a.idd].prev).to be node_b
      expect(node_a.data_pointer[list_a.idd].next).to be nil
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be node_a

      list_a << node_c
      expect(list_a.map { |a| a.name }.join).to eq("BAC")
      expect(list_a.size).to be 3
      expect(list_a.end).to be node_c
      expect(list_a.start).to be node_b

      expect(node_a.data_pointer[list_a.idd].prev).to be node_b
      expect(node_a.data_pointer[list_a.idd].next).to be node_c
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be node_a
      expect(node_c.data_pointer[list_a.idd].prev).to be node_a
      expect(node_c.data_pointer[list_a.idd].next).to be nil

      # removes medium node
      list_a.delete(node_a)
      expect(list_a.size).to be 2
      expect(list_a.end).to be node_c
      expect(list_a.start).to be node_b
      expect(node_a.data_pointer[list_a.idd].prev).to be nil
      expect(node_a.data_pointer[list_a.idd].next).to be nil
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be node_c
      expect(node_c.data_pointer[list_a.idd].prev).to be node_b
      expect(node_c.data_pointer[list_a.idd].next).to be nil
      expect(list_a.map { |a| a.name }.join).to eq("BC")

      # shift list
      erased = list_a.shift
      expect(erased).to be node_b
      expect(list_a.size).to be 1
      expect(list_a.end).to be node_c
      expect(list_a.start).to be node_c
      expect(node_b.data_pointer[list_a.idd].prev).to be nil
      expect(node_b.data_pointer[list_a.idd].next).to be nil
      expect(node_c.data_pointer[list_a.idd].prev).to be nil
      expect(node_c.data_pointer[list_a.idd].next).to be nil
      expect(list_a.map { |a| a.name }.join).to eq("C")

      erased = list_a.shift
      expect(erased).to be node_c
      expect(list_a.size).to be 0
      expect(list_a.end).to be nil
      expect(list_a.start).to be nil
      expect(node_c.data_pointer[list_a.idd].prev).to be nil
      expect(node_c.data_pointer[list_a.idd].next).to be nil
      expect(list_a.map { |a| a.name }.join).to eq("")
    end
  end
end
