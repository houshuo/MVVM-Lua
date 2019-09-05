require 'MVVM.Sources.View.Adaptor'

ToggleAdaptor = class('ToggleAdaptor', Adaptor)

function ToggleAdaptor:ctor(gameObject, propertyName, binder)

    self.component = gameObject:GetComponent('Toggle')
    binder:RegisterEvent(function(viewModel)
     --   print(viewModel.CurSelect.Value,gameObject.name)
        if viewModel.CurSelect.Value == gameObject.name then
            self.component.isOn = true
        end

        self.component.onValueChanged:AddListener(function(isOn)
            local property = viewModel[propertyName]
            if property == nil then
                return
            end

            local onValueChanged = property['onValueChanged']
            if onValueChanged == nil then
                return
            end

            onValueChanged(isOn)
        end)
    end, function()
        self.component.onValueChanged:RemoveAllListeners()
    end)
end