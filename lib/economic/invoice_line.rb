require 'economic/entity'
require 'economic/invoice'

module Economic

  # Represents a invoice line.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IInvoiceLine.html
  class InvoiceLine < Entity
    has_properties :invoice_handle
  end

  def invoice=(invoice)
    self.invoice_handle = invoice.handle
    @invoice = invoice
  end
end
