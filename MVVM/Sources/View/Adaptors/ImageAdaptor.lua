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
        self:ReleaseAsset()
        return
    end

    self.loadCo = coroutine.start(function()
        local path = nil
        if self.pathFunction then
            path = self.pathFunction(newValue)
        else
            path = newValue
        end
        local sprite = RESM.LoadAssetAsync(path, '', typeof(UnityEngine.Sprite))
        self:ReleaseAsset()
        self.loadedAsset = sprite

        if utils.IsAvailableGameObject(self.component) then
            self.component.sprite = self.loadedAsset
        end
        self.loadCo = nil
    end)
end

function ImageAdaptor:ReleaseAsset()
    RESM.ReleaseAsset(self.loadedAsset)
    self.loadedAsset = nil
end