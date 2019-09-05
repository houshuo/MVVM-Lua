require 'MVVM.Sources.View.Adaptor'

GameObjectActiveAdaptor = class('GameObjectActiveAdaptor', Adaptor)

function GameObjectActiveAdaptor:ctor(gameObject, propertyName, binder,func)
    self.component = gameObject.gameObject
    self:BindProperty(propertyName, binder)
    self.func = func
end


function GameObjectActiveAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if self.func then
        self.component:SetActive(self.func(newValue))
    else
        self.component:SetActive(newValue)
    end
end