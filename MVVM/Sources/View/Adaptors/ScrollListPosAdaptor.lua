require 'MVVM.Sources.View.Adaptor'

VerticalScrollListPosAdaptor = class('VerticalScrollListPosAdaptor', Adaptor)

function VerticalScrollListPosAdaptor:ctor(gameObject, scrollPositionName, binder)
    self.component = gameObject:GetComponent('ScrollRect')
    binder:RegisterEvent(function(viewModel)
        local property = viewModel[scrollPositionName]
        if property == nil then
            return
        end

        self.component.onValueChanged:AddListener(function(pos)
            local normalizedPosition = self.component.verticalNormalizedPosition
            rawset(property, '_value', normalizedPosition)
        end)
    end, function()
        self.component.onValueChanged:RemoveAllListeners()
    end)
    self:BindProperty(scrollPositionName, binder)
end

function VerticalScrollListPosAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if oldValue ~= newValue then
        self.component.verticalNormalizedPosition = newValue
    end
end

HorizontalScrollListPosAdaptor = class('HorizontalScrollListPosAdaptor', Adaptor)

function HorizontalScrollListPosAdaptor:ctor(gameObject, scrollPositionName, binder)
    self.component = gameObject:GetComponent('ScrollRect')
    binder:RegisterEvent(function(viewModel)
        local property = viewModel[scrollPositionName]
        if property == nil then
            return
        end

        self.component.onValueChanged:AddListener(function(pos)
            local normalizedPosition = self.component.horizontalNormalizedPosition
            rawset(property, '_value', normalizedPosition)
        end)
    end, function()
        self.component.onValueChanged = nil
    end)
    self:BindProperty(scrollPositionName, binder)
end

function HorizontalScrollListPosAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if oldValue ~= newValue then
        self.component.horizontalNormalizedPosition = newValue
    end
end