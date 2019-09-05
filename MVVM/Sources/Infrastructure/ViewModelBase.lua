ViewModelBase = class('ViewModelBase')

function ViewModelBase:ctor()
    self._isInitialized = false
    self.ParentViewModel = nil
    self.IsRevealed = false
end

function ViewModelBase:OnReveal() end
function ViewModelBase:OnHide() end
function ViewModelBase:Destroy() end