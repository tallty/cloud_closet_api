json.current_page @payment_bills.current_page
json.total_pages @payment_bills.total_pages
json.payment_bills @payment_bills, partial: 'bills/bill', as: :bill