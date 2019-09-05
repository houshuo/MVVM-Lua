Adaptor = class('Adaptor')
function Adaptor:BindProperty(propertyName, binder)
    self.view = binder.view
    binder:Add(propertyName, function(oldValue, newValue) self:OnViewModelValueChanged(oldValue, newValue) end)
end

function Adaptor:OnViewModelValueChanged(oldValue, newValue) end
function Adaptor:OnAdd(viewModel) end
function Adaptor:OnInsert(index, viewModel) end
function Adaptor:OnRemove(index) end