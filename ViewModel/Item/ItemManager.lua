require 'ViewModel.Item.ItemViewModel'
require 'ViewModel.Item.EquipViewModel'
ItemType = {}
ItemType.Material = 1
ItemType.Equip = 2

MaterialType = {}

module('ItemManager', package.seeall)
Items = {}

function Update(_item,_itemType,override)
    print("update item ",_itemType, tostring(_item))
    _item  = UtilTable.protoMsgToTable(_item)
    local type = _item.type or _item.userEquipId
    local item =Get(type,_itemType)
    item:Update(_item,override)


    if not override and item.num.Value <= 0 then
        if _itemType == ItemType.Material then
            Items[_itemType].Value[type] = nil
        elseif _itemType == ItemType.Equip then
            if item.equippedNum.Value <= 0 then
                Items[_itemType].Value[type] = nil
            end
        end

    end
end

function UpdateItems(_items,_itemType,override)
    override = override or false
    _itemType = _itemType or ItemType.Material

    for i = 1, #_items do
        Update(_items[i],_itemType,override)
    end
end

function CreateViewModelByType(_typeId,_itemType)
    if _itemType == ItemType.Material then
        return ItemViewModel.new(_typeId,0)
    elseif  _itemType == ItemType.Equip then
        return EquipViewModel.new(_typeId)
    end
end

--装备以实例id索引，其他物品以type_id
function Get(_typeId,_itemType)
    local item
    _itemType = _itemType or ItemType.Material

    item= Items[_itemType].Value[_typeId]

    if item == nil then
        item = CreateViewModelByType(_typeId,_itemType)
        local itemList = Items[_itemType].Value
        itemList[_typeId] = item
        Items[_itemType].Value = itemList
    end

    return item
end


function GetAllEquip()
    return  Items[ItemType.Equip].Value
end

function Init()
    print("ItemManager Init")
    Items[ItemType.Equip] = BindableProperty.new({})
    Items[ItemType.Material] = BindableProperty.new({})

    for _, data in pairs(CfgMaterialVO.table) do
        MaterialType[data.name] = data.id
    end

    coroutine.start(function()
        local reqMsg = UserMessage.SelfUserInfoReq()
        local response, exceptionCode = RpcUtils.callRpcMethodAsync(MsgType.SELF_USER_INFO_REQ,reqMsg:SerializeToString())
        if exceptionCode ~= ResponseCode.SUCCESS then
            return
        end

        local data = UserMessage.SelfUserInfoResp()
        data:ParseFromString(response)
        UpdateItems(data.material,ItemType.Material,true)
    end)
end

Init()


