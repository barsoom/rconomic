require './spec/spec_helper'

describe Economic::Invoice do
  let(:session) { make_session }
  subject { (i = Economic::Invoice.new( :number => 512 )).tap { i.session = session } }

  describe "new" do
    it "initializes lines as an empty proxy" do
      subject.lines.should be_instance_of(Economic::InvoiceLineProxy)
      subject.lines.should be_empty
    end
  end
end
