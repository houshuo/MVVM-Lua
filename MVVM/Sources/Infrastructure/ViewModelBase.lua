ViewModelBase = class('ViewModelBase')

function ViewModelBase:ctor()
    self._isInitialized = false
    self.ParentViewModel = nil
    self.IsRevealed = false
end

function ViewModelBase:OnReveal()
end
function ViewModelBase:OnHide()
    self:ClearCoroutine()
end
function ViewModelBase:Destroy() 
    self:ClearCoroutine()
end


function ViewModelBase:StartCoroutine(func)
    if self.coroutines == nil then
        self.coroutines = {}
    end

    local co = coroutine.start(function()
        func()
        table.remove_value(self.coroutines, coroutine.running())
    end)
    table.insert(self.coroutines, co)

    return co
end
function ViewModelBase:ClearCoroutine()
    if self.coroutines then
        for _, co in pairs(self.coroutines) do
            coroutine.stop(co)
        end
    end

    self.coroutines = {}
end