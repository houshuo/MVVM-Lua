require 'MVVM.Sources.Infrastructure.ViewModelBase'
require 'MVVM.Sources.Infrastructure.BindableProperty'
EquipViewModel = class('EquipViewModel',ItemViewModel)

function EquipViewModel:ctor(userEquipId,_typeID,star,enhanceProfessionId,num)
    ItemViewModel.ctor(self,_typeID,num)
    self.itemType = ItemType.Equip
    self.star = BindableProperty.new(star or 0)
    self.enhanceProfessionId = BindableProperty.new(enhanceProfessionId or 0)
    self.userEquipId = BindableProperty.new(userEquipId or 0)

    self.equippedNum = BindableProperty.new(0)
    self.quality =0
    self.maxStar =0
    self.equipPart =0
    self.name = BindableProperty.new( "")
    self.basePropertyType = BindableProperty.new( 0)
    self.basePropertyValue = BindableProperty.new( 0)
    self.extraPropertyType = BindableProperty.new( 0)
    self.extraPropertyValue = BindableProperty.new( 0)
    self.extraPropertyValueShowType = BindableProperty.new( 0)
    self.num = BindableProperty.new(num or 1)

    self.iconPath = BindableProperty.new("")
    self:UpdateCfgValue()
    self.BtnClickEvent = {
        OnClick = function()
            self:ShowEquipList()
        end
    }
end

function EquipViewModel:Update(data,override)

    override = override or false
    if override then
        self.typeID.Value = data.equipId
        self.userEquipId.Value = data.userEquipId
        self.enhanceProfessionId.Value = data.enhanceProfessionId
        self.star.Value = data.star
        self.num.Value = data.bagNum
        self.equippedNum.Value = data.equippedNum


    else
        self.num.Value = self.num.Value + data.bagNum
        self.equippedNum.Value = self.equippedNum.Value + data.equippedNum
    end

    if override then
       self:UpdateCfgValue()
    end
end
function EquipViewModel:UpdateCfgValue()

    if self.typeID.Value and self.typeID.Value > 0 then
      --  print("UpdateCfgValue",self.typeID.Value)
        local equipInfo = EquipInfo.GetEquipData(self.typeID.Value)
        self.quality =equipInfo.quality
        self.maxStar =equipInfo.maxStar
        self.equipPart =equipInfo.equipPart
        self.name.Value =equipInfo.name
        self.basePropertyType.Value =equipInfo.type
        self.basePropertyValue.Value =equipInfo.value
        self.extraPropertyType.Value = equipInfo.extraType
        self.extraPropertyValue.Value =  equipInfo.extraValue
        self.extraPropertyValueShowType.Value = equipInfo.extraPercent

        -- 临时图片
        --if self.iconPath.Value =='' then
        self.iconPath.Value =string.format("equip_%s.jpg",self.typeID.Value)
        --end

    else
        --error(self.typeID.Value .." non-existent equip")
    end
end

function EquipViewModel:GetFightValue()
    return self.basePropertyValue.Value
end

function EquipViewModel:ShowEquipList()
    print("todo equip list")
    --return self.basePropertyValue.Value
end
