json.current_page @deposit_bills.current_page
json.total_pages @deposit_bills.total_pages
json.deposit_bills @deposit_bills, partial: 'bills/bill', as: :bill
