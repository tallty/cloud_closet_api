json.current_page @bills.current_page
json.total_pages @bills.total_pages
json.bills @bills, partial: 'bills/bill', as: :bill
