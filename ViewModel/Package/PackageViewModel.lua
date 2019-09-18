require 'MVVM.Sources.Infrastructure.ViewModelBase'
require 'MVVM.Sources.Infrastructure.BindableProperty'
require 'MVVM.Sources.Infrastructure.CompoundBindableProperty'
require 'ViewModel.Package.PackageEquipViewModel'
require 'ViewModel.Package.PackageMaterialViewModel'

PackageViewModel = class("PackageViewModel",ViewModelBase)
function PackageViewModel:ctor()
    self.CloseEvent = {
        OnClick = function()
            VIEWM.hideView(VIEW.PACKAGE)
        end
    }

    self.CurSelectTab = BindableProperty.new(1)
    --全部列表
    self.AllListProperty = CompoundBindableProperty.new({ItemManager.Items[ItemType.Equip], ItemManager.Items[ItemType.Material]}, function(equips, items)
        local showList = {}
        for i, material in ipairs(items) do
            local item = PackageMaterialViewModel.new(material)
            table.insert(showList, item)
        end

        for _, equip in pairs(equips) do
            local item = PackageEquipViewModel.new(equip)
            table.insert(showList, item)
        end

        self.AllList.Value = showList

        for i, item in ipairs(showList) do
            item.onClick = function()
                self.AllListCurrentSelect.Value = item.Content.Value
            end
        end
    end)
    self.AllList = BindableProperty.new({})
    self.AllListCurrentSelect = BindableProperty.new(nil)
    self.AllListCurrentSelectIndex = -1
    self.AllListCurrentSelectProperty = CompoundBindableProperty.new({self.AllListCurrentSelect}, function(curSelect)
        self.MaterialListCurrentSelectIndex = -1
        for i, item in ipairs(self.AllList.Value) do
            item.IsSelect.Value = (item.Content.Value == curSelect)
            if item.IsSelect.Value then
                self.AllListCurrentSelectIndex = i
            end
        end
        return self.AllListCurrentSelectIndex
    end)
    self.AllListSelectItemProperty = CompoundBindableProperty.new({self.AllList}, function(allList)
        local lastSelectIndex = self.AllListCurrentSelectIndex
        local curSelect = self.AllListCurrentSelectProperty.Value
        if curSelect < 0 then
            local item = allList[math.min(#allList, lastSelectIndex)]
            if item then
                self.AllListCurrentSelect.Value = item.Content.Value
            else
                self.AllListCurrentSelect.Value = nil
            end
        end
    end)
    local _ = self.AllListProperty.Value
    --物品列表
    self.MaterialListProperty = CompoundBindableProperty.new({ItemManager.Items[ItemType.Material]}, function(items)
        local materialList = {}
        for i, item in ipairs(items) do
            local material = PackageMaterialViewModel.new(item)
            table.insert(materialList, material)
        end
        self.MaterialList.Value = materialList

        for i, item in ipairs(materialList) do
            item.onClick = function()
                self.MaterialListCurrentSelect.Value = item.Content.Value
            end
        end
    end)
    self.MaterialList = BindableProperty.new({})
    self.MaterialListCurrentSelect = BindableProperty.new(nil)
    self.MaterialListCurrentSelectIndex = -1
    self.MaterialListCurrentSelectProperty = CompoundBindableProperty.new({self.MaterialListCurrentSelect}, function (curSelect)
        self.MaterialListCurrentSelectIndex = -1
        for i, item in ipairs(self.MaterialList.Value) do
            item.IsSelect.Value = (item.Content.Value == curSelect)
            if item.IsSelect.Value then
                self.MaterialListCurrentSelectIndex = i
            end
        end
        return self.MaterialListCurrentSelectIndex
    end)
    self.MaterialListSelectItemProperty = CompoundBindableProperty.new({self.MaterialList}, function(materialList)
        local lastSelectIndex = self.MaterialListCurrentSelectIndex
        local curSelect = self.MaterialListCurrentSelectProperty.Value
        if curSelect < 0 then
            local item = materialList[math.min(#materialList, lastSelectIndex)]
            if item then
                self.MaterialListCurrentSelect.Value = item.Content.Value
            else
                self.MaterialListCurrentSelect.Value = nil
            end
        end
    end)
    local _ = self.MaterialListProperty.Value
    --装备列表
    self.EquipListProperty = CompoundBindableProperty.new({ItemManager.Items[ItemType.Equip]}, function(equips)
        local equipList = {}
        for i, equip in pairs(equips) do
            local item = PackageEquipViewModel.new(equip)
            table.insert(equipList, item)
        end
        self.EquipList.Value = equipList

        for i, item in ipairs(equipList) do
            item.onClick = function()
                self.EquipListCurrentSelect.Value = item.Content.Value
            end
        end
    end)
    self.EquipList = BindableProperty.new({})
    self.EquipListCurrentSelect = BindableProperty.new(nil)
    self.EquipListCurrentSelectIndex = -1
    self.EquipListCurrentSelectProperty = CompoundBindableProperty.new({self.EquipListCurrentSelect}, function (curSelect)
        self.EquipListCurrentSelectIndex = -1
        for i, item in ipairs(self.EquipList.Value) do
            item.IsSelect.Value = (item.Content.Value == curSelect)
            if item.IsSelect.Value then
                self.EquipListCurrentSelectIndex = i
            end
        end
        return self.EquipListCurrentSelectIndex
    end)
    self.EquipListSelectItemProperty = CompoundBindableProperty.new({self.EquipList}, function(equipList)
        local lastSelectIndex = self.EquipListCurrentSelectIndex
        local curSelect = self.EquipListCurrentSelectProperty.Value
        if curSelect < 0 then
            local item = equipList[math.min(#equipList, lastSelectIndex)]
            if item then
                self.EquipListCurrentSelect.Value = item.Content.Value
            else
                self.EquipListCurrentSelect.Value = nil
            end
        end
    end)
    local _ = self.EquipListProperty.Value
    --宝物列表
    self.TreasureList = BindableProperty.new({})
    --切换tab的时候切换显示列表
    self.CurShowList = CompoundBindableProperty.new({self.CurSelectTab, self.AllList, self.MaterialList, self.EquipList, self.TreasureList}, function(index, allList,  materialList, equipList, treasureList)
        if index == 1 then
            return allList
        elseif index == 2 then
            return materialList
        elseif index == 3 then
            return equipList
        else
            return treasureList
        end
    end)
    --切换tab的时候把默认选中的变成第一个,切换CurrentSelectItem
    self.CurrentSelectItem = CompoundBindableProperty.new({self.CurSelectTab}, function(index)
        if index == 1 then
            if #self.AllList.Value > 0 then
                self.AllListCurrentSelect.Value = self.AllList.Value[1].Content.Value
            end
            return self.AllListCurrentSelect
        elseif index == 2 then
            if #self.MaterialList.Value > 0 then
                self.MaterialListCurrentSelect.Value = self.MaterialList.Value[1].Content.Value
            end
            return self.MaterialListCurrentSelect
        elseif index == 3 then
            if #self.EquipList.Value > 0 then
                self.EquipListCurrentSelect.Value = self.EquipList.Value[1].Content.Value
            end
            return self.EquipListCurrentSelect
        elseif index == 4 then
            return nil
        end
    end)
end

PackageViewModelInstance = PackageViewModel.new()