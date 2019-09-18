require 'MVVM.Sources.Infrastructure.ViewModelBase'
require 'MVVM.Sources.Infrastructure.BindableProperty'
ItemViewModel = class('ItemViewModel', ViewModelBase)

function ItemViewModel:ctor(_typeID,_num)
    self.itemType = ItemType.Material
    self.typeID = BindableProperty.new(_typeID)
    self.num = BindableProperty.new(_num or 0)
    self.Name = BindableProperty.new("nil")
    self.Desc = BindableProperty.new("nil")

    local data = MaterialsInfo.GetMaterialData(_typeID)
    if data ~= nil then
        self.Name.Value = data.name
        self.Desc.Value = data.desc
    end
    --暂时无背包，输出表明物品身份
    --print("NewItem : ".. tostring(self.Name.Value))
end

function ItemViewModel:Update(data,override)
    override = override or false
    if override then
        self.num.Value = data.num
    else
        self.num.Value = self.num.Value + data.num
    end
end
