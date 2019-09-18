require 'MVVM.Sources.View.Adaptor'

SliderAdaptor = class('SliderAdaptor', Adaptor)
function SliderAdaptor:ctor(gameObject, sliderValueProperty, onSliderChangedProperty, binder)
    self.component = gameObject:GetComponent('Slider')
    binder:RegisterEvent(function(viewModel, property)
        self.component.onValueChanged:AddListener(function()
            local value = self.component.value
            rawset(property, '_value', value)

            local onValueChangedProperty = viewModel[onSliderChangedProperty]
            if onValueChangedProperty == nil then
                return
            end

            onValueChangedProperty(value)
        end)
    end, function()
        self.component.onValueChanged:RemoveAllListeners()
    end, sliderValueProperty)
    self:BindProperty(sliderValueProperty, binder)
end

function SliderAdaptor:OnViewModelValueChanged(oldValue, newValue)
    self.component.value = newValue
end

SliderMaxValueAdaptor = class('SliderMaxValueAdaptor', Adaptor)
function SliderMaxValueAdaptor:ctor(gameObject, sliderMaxValueProperty, binder)
    self.component = gameObject:GetComponent('Slider')
    self:BindProperty(sliderMaxValueProperty, binder)
end

function SliderMaxValueAdaptor:OnViewModelValueChanged(oldValue, newValue)
    self.component.maxValue = newValue
end