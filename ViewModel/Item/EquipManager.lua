require 'ViewModel.Item.ItemViewModel'
require 'ViewModel.Item.EquipViewModel'
module('EquipManager', package.seeall)

EquipPart = {}
EquipPart.Weapon = 1
EquipPart.Armor = 2
EquipPart.Helmet  = 3

function Update(_item,override)
    ItemManager.Update(_item,ItemType.Equip,override)
end

function UpdateEquip(_items,override)
    ItemManager.UpdateItems(_items,ItemType.Equip,override)
end

--以实例id索引
function Get(_instanceId)
    return  ItemManager.Get(_instanceId,ItemType.Equip)
end

function CheckInBag(equip)
    return equip.num.Value >0
end

function GetEquipsByType(_typeId)
    local equips = {}
    local allEquips = ItemManager.GetAllEquip()
    for _,v in pairs(allEquips) do
        if v.typeID.Value == _typeId and CheckInBag(v) then
            table.insert(equips,v)
        end
    end
    return equips
end



function EquipBagCompare(a,b)
    if number_val(a.quality.Value) == number_val(b.quality.Value) then          --品质-星级-装备id-装备是否有种族加成排序
        if number_val(a.star.Value) == number_val(b.star.Value) then
            if number_val(a.typeID.Value) == number_val(b.typeID.Value) then
                return number_val(a.enhanceProfessionId) > number_val(b.enhanceProfessionId)
            else
                return number_val(a.typeID.Value) > number_val(b.typeID.Value)
            end
        else
            return number_val(a.star.Value) > number_val(b.star.Value)
        end
    else
        return number_val(a.quality.Value) > number_val(b.quality.Value)
    end
end

function GetHighFightByType(...)
    local equips = ItemManager.GetAllEquip()
    local args = {...}
    local res = {}

    if equips and #args >0 then
        for _,v in pairs(equips) do
            for j = 1, #args do
                if v.equipPart == args[j] and CheckInBag(v) then
                    if res[j] == nil or res[j]:GetFightValue() <v:GetFightValue() then
                        res[j] = v
                    end
                end
            end
        end
    end
    return res
end

function Init()
    print("EquipManager Init")
-- coroutine.start(function()
--     print("req test")
--     local reqMsg = TestMessage.TestGainUserEquipReq()
--     reqMsg.equipId =57201
--     local response, exceptionCode = RpcUtils.callRpcMethodAsync(MsgType.TEST_GAIN_USER_EQUIP_REQ,reqMsg:SerializeToString())
--     print("rsp test")
--     if exceptionCode ~= ResponseCode.SUCCESS then
--         return
--     end
-- end)

    coroutine.start(function()
        local reqMsg = EquipMessage.UserBagEquipListReq()
        local response, exceptionCode = RpcUtils.callRpcMethodAsync(MsgType.USER_BAG_EQUIP_LIST_REQ,reqMsg:SerializeToString())
        if exceptionCode ~= ResponseCode.SUCCESS then
            return
        end

        local data = EquipMessage.UserBagEquipListResp()
        data:ParseFromString(response)
        UpdateEquip(data.equip,true)
    end)
end

Init()


