json.current_page @garments.current_page if @garments.try(:current_page)
json.total_pages @garments.total_pages if @garments.try(:total_pages)

json.garments_count @garments.first ? @garments.first.garment_count : 0
json.storing_garments_count @garments.first ? @garments.first.storing_garment_count : 0

json.garments @garments, partial: 'garments/garment', as: :garment