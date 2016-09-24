json.current_page @garments.current_page
json.total_pages @garments.total_pages

json.garments @garments, partial: 'garments/garment', as: :garment