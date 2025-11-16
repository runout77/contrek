class TestClass
  prepend Contrek::Concurrent::Poolable

  attr_reader :data
  def initialize
    @data = []
  end

  def do!
    enqueue!(name: "A") do |payload|
      operation(payload)
    end
    enqueue!(name: "B") do |payload|
      operation(payload)
      enqueue!(name: "C") do |payload|
        operation(payload)
      end
    end
    wait!
  end

  def operation(payload)
    @data << payload[:name]
  end
end

RSpec.describe Contrek::Concurrent::Poolable do
  describe "Pool class test" do
    it "is a poolable class" do
      t = TestClass.new(number_of_threads: 3)
      t.do!
      expect(t.data.sort).to eq ["A", "B", "C"]
    end

    it "should manage parameters" do
      t = TestClass.new
      expect(t.number_of_threads).to eq(0)
      t = TestClass.new(number_of_threads: nil) # platform dependent
      expect(t.number_of_threads).to be > 0
      t = TestClass.new(number_of_threads: 2)
      expect(t.number_of_threads).to eq 2
    end
  end
end
