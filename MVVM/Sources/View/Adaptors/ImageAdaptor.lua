require 'MVVM.Sources.View.Adaptor'

ImageAdaptor = class('ImageAdaptor', Adaptor)

function ImageAdaptor:ctor(gameObject, propertyName, binder, pathFunction)

    self.component = gameObject:GetComponent('Image')
    self.pathFunction = pathFunction
    self:BindProperty(propertyName, binder)
    self.loadCo = nil
    self.loadedAsset = nil
end

function ImageAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if oldValue == newValue then
        return
    end

    if self.loadCo then
        coroutine.stop(self.loadCo)
    end

    if newValue == nil then
        return
    end

    self.loadCo = coroutine.start(function()
        local path = nil
        local name = nil
        if self.pathFunction then
            path, name = self.pathFunction(newValue)
        else
            path = newValue
        end
            local asset = RESM.LoadAssetAsync(path, name, typeof(UnityEngine.Sprite))
            asset:Require(self.component.gameObject)
            self.component.sprite = asset.resource
        self.loadCo = nil
    end)
end