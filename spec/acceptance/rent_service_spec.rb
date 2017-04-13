require 'acceptance_helper'

resource '租金计算 相关' do
  header 'Accept', 'application/json'

  before do
    create_list(:vip_level, 4)
    @store_methods = create_list(:store_method, 3)
    @stocking_chest = create(:stocking_chest) 
    @group_chest1 = create(:group_chest1)
    @alone_full_dress_chest = create(:alone_full_dress_chest)

    @user = create(:user)
    @stocking_val = create(:valuation_chest, 
      user: @user,
      price_system: @stocking_chest
      )
    @group_val1 = create(:valuation_chest,
      user: @user,
      price_system: @group_chest1
      )
    @group_val2 = create(:valuation_chest,
      user: @user,
      price_system: @group_chest1
      )
    @alone_val1 = create(:valuation_chest,
      user: @user,
      price_system: @alone_full_dress_chest
      )
    @alone_val2 = create(:valuation_chest,
      user: @user,
      price_system: @alone_full_dress_chest
      )
    @new_val_ary = [ @stocking_val, @group_val1, @group_val2, @alone_val1, @alone_val2 ]
    
    create(:garment, exhibition_chest: @alone_val1.exhibition_chests.first)

    @user.valuation_chests.collect(&:exhibition_chests).reduce(:+).map(&:release!)
  end

  describe '计算整月租金' do
    
    it ' ' do 
      assert_equal 5, @user.valuation_chests.count, '原有 5 计价柜'
      
      _rent, _detail = RentService.new(@user).deducte_monthly_rent
      p @new_val_ary
      assert_equal 4, @user.valuation_chests.count, '删除 无衣物的单礼服柜'
      assert_equal 'using', ValuationChest.find(@alone_val1.id).aasm_state, '不删除 有衣物的单礼服柜'
      assert_equal 'deleted', ValuationChest.unscope(:where).find(@alone_val2.id).aasm_state, '删除 无衣物的单礼服柜'
      _rent_should = @new_val_ary.collect(&:price).reduce(:+)
      assert_equal  _rent_should, _rent, '租金计算'
      
      describe '删除衣服' do
        ValuationChest.find(@alone_val1.id).exhibition_chests.collect(&:garments).reduce(:+).map(:delete)
        assert_nil RentService.new(@user).deducte_monthly_rent
        assert 3, @user.valuation_chests.count
      end
      
    end  

  end
  

end