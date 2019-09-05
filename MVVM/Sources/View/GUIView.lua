require 'View.Base.BaseView'
require 'MVVM.Sources.Infrastructure.PropertyBinder'
require 'MVVM.Sources.Infrastructure.BindableProperty'
GUIView = class('GUIView', BaseView)

function GUIView:InitPanel()
    self._isInitialized = false
    self.destroyOnHide = false
    self.Binder = PropertyBinder.new()
    self.viewModelProperty = BindableProperty.new()
end

function GUIView:Set_BindingContext(viewModel)
    if self._isInitialized == false then
        self:OnInitialize()
        self._isInitialized = true
    end
    self.viewModelProperty.Value = viewModel
end

function GUIView:Get_BindingContext()
    return self.viewModelProperty.Value
end

function GUIView:OnInitialize()
    table.insert(self.viewModelProperty.OnValueChanged, handlerEx(self.OnBindingContextChanged, self))
end

function GUIView:OnDestroy()
    self:Set_BindingContext(nil)
    self.Binder = nil
    table.remove_value(self.viewModelProperty.OnValueChanged, handlerEx(self.OnBindingContextChanged, self))
    BaseView.OnDestroy(self)
end

function GUIView:OnBindingContextChanged(oldValue, newValue)
    self.Binder:Unbind(oldValue)
    self.Binder:Bind(newValue)
end

