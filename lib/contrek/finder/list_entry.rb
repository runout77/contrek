module Contrek
  module Finder
    class ListEntry
      attr_reader :data_pointer, :name
      def initialize(lists, name)
        @data_pointer = lists.get_data_pointer
        @name = name
      end
    end
  end
end
