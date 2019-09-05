require 'MVVM.Sources.View.Adaptor'

ButtonAdaptor = class('ButtonAdaptor', Adaptor)

function ButtonAdaptor:ctor(gameObject, propertyName, binder)
    self.component = gameObject:GetComponent('Button')
    binder:RegisterEvent(function(viewModel)
        self.component.onClick:AddListener(function()
            local property = viewModel[propertyName]
            if property == nil then
                return
            end

            local onClick = property['OnClick']
            if onClick == nil then
                return
            end

            onClick()
        end)
    end, function()
        self.component.onClick:RemoveAllListeners()
    end)
end