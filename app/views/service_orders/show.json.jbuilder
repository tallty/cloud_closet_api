json.partial! "service_orders/service_order", service_order: @service_order
json.user @service_order.user, partial: 'admin/users/admin_user', as: :admin_user