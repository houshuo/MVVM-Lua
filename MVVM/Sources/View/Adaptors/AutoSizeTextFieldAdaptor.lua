require 'MVVM.Sources.View.Adaptor'

AutoSizeTextFieldAdaptor = class('AutoSizeTextFieldAdaptor', Adaptor)

function AutoSizeTextFieldAdaptor:ctor(gameObject, maxOneLineSize, propertyName, binder)
    self.component = gameObject:GetComponent('Text')
    self.maxOneLineSize = maxOneLineSize
    self.rectTransform = gameObject:GetComponent('RectTransform')
    self:BindProperty(propertyName, binder)
end

function AutoSizeTextFieldAdaptor:OnViewModelValueChanged(oldValue, newValue)
    self.component.text = tostring(newValue)
    if self.component.preferredWidth > self.maxOneLineSize then
        self.rectTransform.sizeDelta = Vector2(
                self.maxOneLineSize,self.rectTransform.sizeDelta.y)
        self.component.horizontalOverflow = UnityEngine.HorizontalWrapMode.Wrap
    end
end