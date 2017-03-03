json.partial! "exhibition_chests/exhibition_chest", exhibition_chest: @exhibition_chest
json.garments @garments, partial: 'garments/garment', as: :garment if @garments