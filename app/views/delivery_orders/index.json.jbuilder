json.current_page @delivery_orders.current_page
json.total_pages @delivery_orders.total_pages
json.delivery_orders @delivery_orders, partial: 'delivery_orders/delivery_order', as: :delivery_order