require 'MVVM.Sources.View.GUIView'
require 'MVVM.Sources.View.Adaptors.ButtonAdaptor'
require 'MVVM.Sources.View.Adaptors.ViewModelAdaptor'
require 'MVVM.Sources.View.Adaptors.GameObjectActiveAdaptor'

PackageEquipView = class('PackageEquipView', GUIView)

function PackageEquipView:InitPanel()
    GUIView.InitPanel(self)

    ViewModelAdaptor.new(self.transform:Find('content'), 'Content', self.Binder)
    GameObjectActiveAdaptor.new(self.transform:Find('Image_Select'), 'IsSelect', self.Binder)
    ButtonAdaptor.new(self.transform:Find('content/Bg'), 'BtnClickEvent', self.Binder)
end