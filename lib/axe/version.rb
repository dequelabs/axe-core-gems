module Axe
  module VERSION
    MAJOR=1
    MINOR=2
    PATCH=1
    PRE=nil
    BUILD=nil

    class << self
      def to_s
        [MAJOR, MINOR, PATCH].join(".") + pre + build
      end

      private

      def pre
        empty?(PRE) ? "" : "-#{PRE}"
      end

      def build
        empty?(BUILD) ? "" : "+#{BUILD}"
      end

      def empty?(v)
        v.nil? || v.empty?
      end
    end
  end
end
