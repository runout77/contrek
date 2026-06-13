# frozen_string_literal: true

module Contrek
  module Cpp
    class CPPTempfile < CPPOfstream
      def self.new(name)
        require "tempfile"
        tempfile = Tempfile.new(name)
        instance = super(tempfile.path)
        instance.instance_variable_set(:@tempfile, tempfile)
        instance
      end

      def path
        @tempfile.path
      end

      def close
        super
        @tempfile.close
      end

      def unlink
        @tempfile.unlink
      end
    end
  end
end
