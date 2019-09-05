require 'MVVM.Sources.View.Adaptor'

ViewModelAdaptor = class('ViewModelAdaptor', Adaptor)

function ViewModelAdaptor:ctor(gameObject, propertyName, binder)
    self.component = gameObject
    self:BindProperty(propertyName, binder)
end

function ViewModelAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if oldValue == newValue then
        return
    end

    GetLuaObject(self.component):Set_BindingContext(newValue)

    if oldValue then
        oldValue:Destroy()
    end
end