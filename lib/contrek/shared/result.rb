module Contrek
  module Shared
    module Result
      def to_svg
        width = metadata[:width]
        height = metadata[:height]
        lines = []
        lines << %(<svg xmlns="http://www.w3.org/2000/svg" width="#{width}" height="#{height}">)
        points.each do |poly|
          pts = poly[:outer].map { |p| "#{p[:x]},#{p[:y]}" }.join(" ")
          lines << %(<polygon points="#{pts}" fill="none" stroke="red" stroke-width="1"/>)
          poly[:inner].each do |sequence|
            next if sequence.empty?
            pts = sequence.map { |p| "#{p[:x]},#{p[:y]}" }.join(" ")
            lines << %(<polygon points="#{pts}" fill="none" stroke="green" stroke-width="1"/>)
          end
        end
        lines << "</svg>"
        lines.join("\n")
      end
    end
  end
end
