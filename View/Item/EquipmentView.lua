require 'MVVM.Sources.View.GUIView'
require 'MVVM.Sources.View.Adaptors.ImageAdaptor'
require 'MVVM.Sources.View.Adaptors.ButtonAdaptor'
require 'MVVM.Sources.View.Adaptors.TextFieldAdaptor'
EquipmentView = class('EquipmentView',GUIView)

function EquipmentView:InitPanel( )
    GUIView.InitPanel(self);
    self.equipInfo =  self.transform:Find('EquipInfo')
    self.stars =  self.transform:Find('EquipInfo/BlueStar')
    self.Binder:Add('typeID',function(oldValue,newValue)

       if newValue == nil or newValue == 0  then
           self.equipInfo.gameObject:SetActive(false)
           return
       end
        self.equipInfo.gameObject:SetActive(true)
    end)

   self.Binder:Add('star',function(oldValue,newValue)
       if newValue == nil then
           return
       end

       for i = 1, 5 do
           if i<= newValue then
               self.stars.transform:Find(tostring(i)).gameObject:SetActive(true)
           else
               self.stars.transform:Find(tostring(i)).gameObject:SetActive(false)
           end
       end
   end)
    ImageAdaptor.new(self.transform:Find('EquipInfo/Equipment'),'iconPath', self.Binder, function(iconPath)
        if iconPath == "" then
            iconPath = 'equip_30001.jpg'
        end
        return 'Res/UI/Icon_Equip', iconPath
    end)

    TextFieldAdaptor.new(self.transform:Find('EquipInfo/Count'),'num',self.Binder)
 --  self.Binder:Add('Box',function(oldValue,newValue)
 --      if newValue == nil then
 --          return
 --      end
 --      oldValue = newValue
 --      self.transform:Find('Box'):GetComponent("Image").sprite = newValue
 --  end)
 --  self.Binder:Add('Equipment',function(oldValue,newValue)
 --      if newValue == nil then
 --          return
 --      end
 --      oldValue = newValue
 --      self.transform:Find('Equipment'):GetComponent("Image").sprite = newValue
 --  end)
 --  self.Binder:Add('TypeSprite',function(oldValue,newValue)
 --      if newValue == nil then
 --          return
 --      end
 --      oldValue = newValue
 --      self.transform:Find('Type'):GetComponent("Image").sprite = newValue
 --  end)
end
