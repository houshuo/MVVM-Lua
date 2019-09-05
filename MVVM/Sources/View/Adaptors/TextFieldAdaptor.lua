require 'MVVM.Sources.View.Adaptor'

TextFieldAdaptor = class('TextFieldAdaptor', Adaptor)

function TextFieldAdaptor:ctor(gameObject, propertyName, binder, func)
    self.component = gameObject:GetComponent('Text')
    self.func = func
    self:BindProperty(propertyName, binder)
end


function TextFieldAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if self.func == nil then
        self.component.text = tostring(newValue)
    else
        self.component.text = self.func(newValue)
    end
end