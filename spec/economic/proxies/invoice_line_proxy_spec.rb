require './spec/spec_helper'

describe Economic::InvoiceLineProxy do
  let(:session) { make_session }
  let(:invoice) { make_invoice(:session => session) }
  subject { Economic::InvoiceLineProxy.new(invoice) }

  describe ".build" do
    it "instantiates a new InvoiceLine" do
      subject.build.should be_instance_of(Economic::InvoiceLine)
    end

    it "assigns the session to the InvoiceLine" do
      subject.build.session.should == session
    end

    it "should not build a partial InvoiceLine" do
      subject.build.should_not be_partial
    end

    it "adds the built line to proxy items" do
      line = subject.build
      subject.items.should == [line]
    end

    context "when owner is a Invoice" do
      subject { invoice.lines }

      it "should use the Debtors session" do
        subject.build.session.should == invoice.session
      end

      it "should initialize with values from Invoice" do
        invoice_line = subject.build
        invoice_line.invoice_handle.should == invoice.handle
      end
    end
  end
end
