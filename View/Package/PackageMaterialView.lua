require 'MVVM.Sources.View.GUIView'
require 'MVVM.Sources.View.Adaptors.ButtonAdaptor'
require 'MVVM.Sources.View.Adaptors.ViewModelAdaptor'
require 'MVVM.Sources.View.Adaptors.GameObjectActiveAdaptor'

PackageMaterialView = class('PackageMaterialView', GUIView)

function PackageMaterialView:InitPanel()
    GUIView.InitPanel(self)

    ViewModelAdaptor.new(self.transform:Find('content'), 'Content', self.Binder)
    GameObjectActiveAdaptor.new(self.transform:Find('Image_Select'), 'IsSelect', self.Binder)
    ButtonAdaptor.new(self.transform:Find('content'), 'BtnClickEvent', self.Binder)
end