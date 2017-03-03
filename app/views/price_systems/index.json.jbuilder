json.current_page @price_systems.current_page if @price_systems.try(:current_page)
json.total_pages @price_systems.total_pages if @price_systems.try(:total_pages)
json.price_systems @price_systems, partial: 'price_systems/price_system', as: :price_system