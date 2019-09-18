require 'MVVM.Sources.View.GUIView'
require 'MVVM.Sources.View.Adaptors.ButtonAdaptor'
require 'MVVM.Sources.View.Adaptors.ToggleGroupAdaptor'
require 'MVVM.Sources.View.Adaptors.ListAdaptor'

PackageView = class("ChatView",GUIView)
function PackageView:InitPanel()
    GUIView.InitPanel(self)

    ButtonAdaptor.new(self.transform:Find('Top/Contain/BackBtn'), 'CloseEvent', self.Binder)

    local toggles = {self.transform:Find('Left/LeftTab/BtnGroup/All'),
                        self.transform:Find('Left/LeftTab/BtnGroup/Items'),
                        self.transform:Find('Left/LeftTab/BtnGroup/Equipment'),
                        self.transform:Find('Left/LeftTab/BtnGroup/Hero_Chips')
    }

    ToggleGroupAdaptor.new(toggles, 'CurSelectTab', function (hideIndex,showIndex)
        if hideIndex ~= nil then
            local oldText = toggles[hideIndex]:Find("Text"):GetComponent("Text")
            ChangeColor(oldText,'AssistBlue')
        end

        if showIndex ~= nil then
            local newText = toggles[showIndex]:Find("Text"):GetComponent("Text")
            ChangeColor(newText,'White')
        end
    end , self.Binder)

    ListAdaptor.new(self.transform:Find('Right/Package/ViewPoint/Contain'), 'CurShowList', function(viewModel)
        if viewModel.__cname == 'PackageEquipViewModel' then
            return self.EquipmentPrefab
        elseif viewModel.__cname == 'PackageMaterialViewModel' then
            return self.MaterialPrefab
        end
    end, self.Binder)
end

function PackageView:OnStart()
    self:Set_BindingContext(PackageViewModelInstance)
end