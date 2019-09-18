require 'MVVM.Sources.View.GUIView'
require 'MVVM.Sources.View.Adaptors.ImageAdaptor'
require 'MVVM.Sources.View.Adaptors.TextFieldAdaptor'

ItemView = class('ItemView',GUIView)

function ItemView:InitPanel()
    GUIView.InitPanel(self)

    ImageAdaptor.new(self.transform:Find('Item'),'typeID',self.Binder,function(value)
        if value == 1 or value == 10 or value == 2 or value == 101 or value == 11 then
            return "Res/UI/Materials",string.format( "%d.png", value )
        else
            return "Res/UI/Materials","0.png"
        end
    end)

    TextFieldAdaptor.new(self.transform:Find('Count'),'num',self.Binder)
end