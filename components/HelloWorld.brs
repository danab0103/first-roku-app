function init()
    m.top.setFocus(true)

    appInfo = CreateObject("roAppInfo")
        
    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.text = appInfo.GetTitle() + " v" + appInfo.GetVersion()
end function