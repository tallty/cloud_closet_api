json.current_page @delivery_orders.current_page
json.total_pages @delivery_orders.total_pages
@need_garment_info ?
  ( json.delivery_orders @delivery_orders, partial: 'delivery_orders/delivery_order_with_garments', as: :delivery_order ) :
  ( json.delivery_orders @delivery_orders, partial: 'delivery_orders/delivery_order', as: :delivery_order )