module Contrek
  module Finder
    class Lists
      Link = Struct.new(:next, :prev, :inside)
      def initialize
        @lists = []
      end

      def get_data_pointer
        data_pointer = Array.new(@lists.size) { [] }
        @lists.size.times do |n|
          data_pointer[n] = Link.new(nil, nil, false)
        end

        data_pointer
      end

      def add_list
        list = Contrek::Finder::List.new(@lists.size)
        @lists << list
        list
      end
    end
  end
end
