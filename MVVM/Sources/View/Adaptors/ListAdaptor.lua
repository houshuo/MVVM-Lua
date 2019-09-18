require 'MVVM.Sources.View.Adaptor'

ListAdaptor = class('ListAdaptor', Adaptor)

function ListAdaptor:ctor(gameObject, propertyName, prefab, binder)--这里不管理prefab释放，谁使用这个谁管理prefab的释放
    self.prefab = prefab
    self.component = gameObject:GetComponent('RectTransform')
    self:BindProperty(propertyName, binder)
    binder:AddEx(propertyName,
            function(viewModel) self:OnAdd(viewModel) end,
            function(index, viewModel) self:OnInsert(index, viewModel) end,
            function(viewModel) self:OnRemove(viewModel) end)
end

function ListAdaptor:GetPrefab(viewModel)
    if type(self.prefab) == 'function' then
        return self.prefab(viewModel)
    else
        return self.prefab
    end
end

function ListAdaptor:OnViewModelValueChanged(oldValue, newValue)
    if newValue == nil then
        return
    end

    local childCount = self.component.childCount
    local newCount = #newValue

    if type(self.prefab) == 'function' then--这种用函数生成的prefab内部完全没办法管理，只能全部删掉重新生成
        for i = childCount - 1, 0, -1 do
            local go = self.component:GetChild(i).gameObject
            go.transform.parent = nil
            GameObject.Destroy(go)
        end

        for i, viewModel in pairs(newValue) do
            local go = GameObject.Instantiate(self:GetPrefab(viewModel))
            go.transform:SetParent(self.component, false)
            go:SetActive(true)
        end
    else
        if childCount < newCount then
            for i = childCount + 1, newCount do
                local go = GameObject.Instantiate(self:GetPrefab(newValue[i]))
                go.transform:SetParent(self.component, false)
                go:SetActive(true)
            end
        elseif childCount > newCount then
            for i = childCount - 1, newCount, -1 do
                local go = self.component:GetChild(i).gameObject
                go.transform.parent = nil
                GameObject.Destroy(go)
            end
        end
    end

    for i, viewModel in pairs(newValue) do
        local go = self.component:GetChild(i - 1).gameObject
        local view = GetLuaObject(go)
        if view then
            view:Set_BindingContext(viewModel)
        end
        UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(go.transform)
        go:SetActive(true)
    end
    UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.component)
end

function ListAdaptor:OnAdd(viewModel)
    local go = GameObject.Instantiate(self:GetPrefab(viewModel))

    UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(go.transform)
    go.transform:SetParent(self.component, false)
    go.transform:SetAsLastSibling()

    local view = GetLuaObject(go)
    if view then
        view:Set_BindingContext(viewModel)
    end
    go:SetActive(true)
    UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.component)
end

function ListAdaptor:OnInsert(index, viewModel)
    local go = GameObject.Instantiate(self:GetPrefab(viewModel))

    UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(go.transform)
    local beforeHeight = self.component.rect.height
    go.transform:SetParent(self.component, false)
    go.transform:SetSiblingIndex(index - 1)
    local view = GetLuaObject(go)
    if view then
        view:Set_BindingContext(viewModel)
    end

    UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.component)
    local afterHeight = self.component.rect.height
    local displacement = afterHeight - beforeHeight


    local anchoredPosition = self.component.anchoredPosition
    anchoredPosition.y = anchoredPosition.y + displacement
    self.component.anchoredPosition = anchoredPosition
    go:SetActive(true)
end

function ListAdaptor:OnRemove(index)
    local trans = self.component.transform:GetChild(index - 1)
    GameObject.Destroy(trans.gameObject)
end