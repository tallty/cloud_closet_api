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
    @user_info = create(:user_info,
      user: @user, 
      balance: 10000
      )
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
    
    
    create(:garment, exhibition_chest: @alone_val1.exhibition_chests.first)

    @user.valuation_chests.collect(&:exhibition_chests).reduce(:+).map(&:release!)
  end

  describe '计算整月租金' do
    
    it '余额足够 测试删除空单礼服柜' do 
      
      assert_equal 5, @user.valuation_chests.count, '原有 5 计价柜'
      # do
      _rent, _detail = RentService.new(@user).deducte_monthly_rent
      p _rent
      assert_equal 4, @user.valuation_chests.count, '删除 无衣物的单礼服柜'
      assert_equal 'using', ValuationChest.find(@alone_val1.id).aasm_state, '不删除 有衣物的单礼服柜'
      assert_equal 'deleted', ValuationChest.unscope(:where).find(@alone_val2.id).aasm_state, '删除 无衣物的单礼服柜'
      
      _new_val_ary = [ @stocking_val, @group_val1, @group_val2, @alone_val1 ]
      _rent_should = _new_val_ary.collect(&:price).reduce(:+)
      assert_equal  _rent_should, _rent, '租金计算'
      
    end 

    describe '' do 
      before do 
        @user_info.update( balance: 100 )
      end
      # 用户收到微信推送
      it '本月余额不足' do
        _rent, _detail = RentService.new(@user).deducte_monthly_rent
      end
    end

    describe '' do 
      before do 
        @user_info.update( balance: 10 )
      end
      # 用户收到微信推送 ，管理员收到短信
      it '下个月本月余额不足' do
        _rent, _detail = RentService.new(@user).deducte_monthly_rent
      end
    end
  end
  

end