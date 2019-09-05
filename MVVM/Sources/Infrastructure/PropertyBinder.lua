PropertyBinder = class('PropertyBinder')

local function getProperty(viewModel, path)
    local property = viewModel
    local propertyPath = {}
    for _, name in ipairs(path) do
        local bindableProperty = property[name]
        if bindableProperty == nil then
            return nil
        end

        if type(bindableProperty) ~= 'table' then
            return nil
        end

        if bindableProperty.OnValueChanged == nil then
            return nil
        end

        table.insert(propertyPath, bindableProperty)
        property = bindableProperty.Value
    end

    return propertyPath
end

function PropertyBinder:ctor(view)
    self.view = view
    self._binders = {} --function(viewModel)
    self._unbinders = {} --function(viewModel)
end

function PropertyBinder:Add(name, valueChangedHandler)
    local bind = nil
    local unbind = nil
    local RebindGen = function(currentPath)
        local currentPathArray = string.split(currentPath, '.')
        return function(oldValue, newValue)
            if oldValue ~= nil then
                unbind(oldValue, currentPathArray)
            end
            bind(newValue, currentPathArray)
        end
    end

    local path = string.split(name, '.')
    local rebinders = {}
    for i = 1, #path - 1 do
        table.insert(rebinders, RebindGen(table.concat(path, '.', i + 1)))
    end

    bind = function(viewModel, currentPath)
        currentPath = currentPath or path
        local bindableProperties = getProperty(viewModel, currentPath)
        if bindableProperties==nil then
            error(string.format("bindableProperty empty! name=%s",name))
        end

        for i, bindableProperty in ipairs(bindableProperties) do
            if i < #bindableProperties then
                table.insert(bindableProperty.OnValueChanged, rebinders[i])
            else
                table.insert(bindableProperty.OnValueChanged, valueChangedHandler)
            end
        end

        local property = bindableProperties[#bindableProperties]
        valueChangedHandler(nil, property.Value) --初始化数据
    end

    unbind = function(viewModel, currentPath)
        currentPath = currentPath or path
        local bindableProperties = getProperty(viewModel, currentPath)
        for i, bindableProperty in ipairs(bindableProperties) do
            if i < #bindableProperties then
                table.remove_value(bindableProperty.OnValueChanged, rebinders[i])
            else
                table.remove_value(bindableProperty.OnValueChanged, valueChangedHandler)
            end
        end
    end

    table.insert(self._binders, bind)
    table.insert(self._unbinders, unbind)
end

function PropertyBinder:AddEx(name, onAdd, onInsert, onRemove)--给list用绑定
    local bind = nil
    local unbind = nil
    local RebindGen = function(currentPath)
        local currentPathArray = string.split(currentPath, '.')
        return function(oldValue, newValue)
            if oldValue ~= nil then
                unbind(oldValue, currentPathArray)
            end
            bind(newValue, currentPathArray)
        end
    end

    local path = string.split(name, '.')
    local rebinders = {}
    for i = 1, #path - 1 do
        table.insert(rebinders, RebindGen(table.concat(path, '.', i + 1)))
    end

    bind = function(viewModel, currentPath)
        currentPath = currentPath or path
        local bindableProperties = getProperty(viewModel, currentPath)
        if bindableProperties==nil then
            error(string.format("bindableProperty empty! name=%s",name))
        end

        for i, bindableProperty in ipairs(bindableProperties) do
            if i < #bindableProperties then
                table.insert(bindableProperty.OnValueChanged, rebinders[i])
            else
                local bindableProperty = bindableProperties[#bindableProperties]
                table.insert(bindableProperty.AddHandlers, onAdd)
                table.insert(bindableProperty.InsertHandlers, onInsert)
                table.insert(bindableProperty.RemoveHandlers, onRemove)
            end
        end
    end

    unbind = function(viewModel, currentPath)
        currentPath = currentPath or path
        local bindableProperties = getProperty(viewModel, currentPath)
        for i, bindableProperty in ipairs(bindableProperties) do
            if i < #bindableProperties then
                table.remove_value(bindableProperty.OnValueChanged, rebinders[i])
            else
                local bindableProperty = bindableProperties[#bindableProperties]
                table.remove_value(bindableProperty.AddHandlers, onAdd)
                table.remove_value(bindableProperty.InsertHandlers, onInsert)
                table.remove_value(bindableProperty.RemoveHandlers, onRemove)
            end
        end
    end

    table.insert(self._binders, bind)
    table.insert(self._unbinders, unbind)
end

function PropertyBinder:RegisterEvent(eventRegisterHandler, eventUnregisterHandler)
    local bind = function(viewModel)
        eventRegisterHandler(viewModel)
    end

    local unbind = function(viewModel)
        eventUnregisterHandler(viewModel)
    end

    table.insert(self._binders, bind)
    table.insert(self._unbinders, unbind)
end

function PropertyBinder:Bind(viewModel)
    if viewModel then
        for _, binder in pairs(self._binders) do
            binder(viewModel)
        end
    end
end

function PropertyBinder:Unbind(viewModel)
    if viewModel then
        for _, unbinder in pairs(self._unbinders) do
            unbinder(viewModel)
        end
    end
end