require 'MVVM.Sources.Infrastructure.ViewModelBase'
require 'MVVM.Sources.Infrastructure.BindableProperty'

PackageMaterialViewModel = class('PackageMaterialViewModel', ViewModelBase)

function PackageMaterialViewModel:ctor(material)
    self.Content = BindableProperty.new(material)
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