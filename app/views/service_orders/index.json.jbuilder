json.service_orders @service_orders, partial: 'service_orders/service_order', as: :service_order
json.user @service_order.user, partial: 'admin/user', as: :admin_user