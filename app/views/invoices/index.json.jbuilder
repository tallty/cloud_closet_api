json.current_page @invoices.current_page if @invoices.try(:current_page) 
json.total_pages @invoices.total_pages if @invoices.try(:total_pages) 

json.invoices @invoices, partial: 'invoices/invoice', as: :invoice