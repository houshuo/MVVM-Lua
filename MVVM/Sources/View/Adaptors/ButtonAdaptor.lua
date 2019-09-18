require 'MVVM.Sources.View.Adaptor'

ButtonAdaptor = class('ButtonAdaptor', Adaptor)

function ButtonAdaptor:ctor(gameObject, propertyName, binder)
    self.component = gameObject:GetComponent('Button')
    binder:RegisterEvent(function(viewModel, property)
        self.component.onClick:AddListener(function()
            local onClick = property['OnClick']
            if onClick == nil then
                return
            end

            onClick()
        end)
    end, function()
        self.component.onClick:RemoveAllListeners()
    end, propertyName)
end