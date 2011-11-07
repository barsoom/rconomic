require 'economic/entity'

module Economic
  class Invoice < Entity
    has_properties :number, :net_amount, :vat_amount, :due_date, :debtor_handle, :heading
    
    # Returns the current invoice lines of Invoice
    def lines
      @lines ||= InvoiceLineProxy.new(self)
    end
  end
end
