require 'MVVM.Sources.Infrastructure.ViewModelBase'
require 'MVVM.Sources.Infrastructure.BindableProperty'

PackageEquipViewModel = class('PackageEquipViewModel', ViewModelBase)

function PackageEquipViewModel:ctor(equip)
    self.Content = BindableProperty.new(equip)
    self.IsSelect = BindableProperty.new(false)

    self.onClick = nil
    self.BtnClickEvent = {
        OnClick = function()
            if self.onClick then
                self.onClick()
            end
        end
    }
end