require 'ViewModel.Item.ItemManager'
require 'ViewModel.Item.EquipManager'

module('ResourceTransfer', package.seeall)

function UpdateWithMsg(msg)
   -- print("ResourceTransfer",msg.data:HasField("update"))
    if msg.data:HasField("update") then
        ItemManager.UpdateItems(msg.data.update.material,ItemType.Material)
        EquipManager.UpdateEquip(msg.data.update.equip)
    end
end

function Init()
    EVTM.add(EVENT.RESOURCE_UPDATE, UpdateWithMsg)
end
Init()