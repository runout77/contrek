RSpec.describe Contrek::Finder::Node, type: :class do
  describe "Node class" do
    it "verify constants" do
      expect(Contrek::Finder::Node::T_UP).to eq(-1)
      expect(Contrek::Finder::Node::T_DOWN).to eq(1)
      expect(Contrek::Finder::Node::T_UP).not_to eq(Contrek::Finder::Node::T_DOWN)
      expect(Contrek::Finder::Node::OMAX).to eq(1)  # questi devono essere così altrimenti saltano molte logiche di ottimizzazione
      expect(Contrek::Finder::Node::OMIN).to eq(2)
      expect(Contrek::Finder::Node::IMAX).to eq(4)
      expect(Contrek::Finder::Node::IMIN).to eq(8)
    end
  end
end
