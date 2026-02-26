sub init()
    m.top.setFocus(true)

    appInfo = CreateObject("roAppInfo")

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.text = appInfo.GetTitle() + " v" + appInfo.GetVersion()

    m.button = m.top.findNode("leftButton")
    m.list = m.top.findNode("imageList")

    m.list.observeField("rowItemFocused", "onItemFocused")
    m.button.observeField("buttonSelected", "onButtonSelected")

    m.photosTask = CreateObject("roSGNode", "GetRequestPhotosTask")
    m.photosTask.observeField("photosContent", "onPhotosLoaded")
    m.photosTask.control = "RUN"

    m.button.setFocus(true)
end sub

sub onPhotosLoaded()
    m.list.content = m.photosTask.photosContent
end sub

sub onItemFocused()
    focus = m.list.rowItemFocused
    item = m.list.content.getChild(focus[0]).getChild(focus[1])

    print "title="; item.title
end sub

sub onButtonSelected()
    print "Button pressed."
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press = false then return false

    if key = "right" and m.button.hasFocus()
        m.list.setFocus(true)
        return true
    end if

    if key = "up" and m.list.hasFocus()
        m.button.setFocus(true)
        return true
    end if

    if key = "down" and m.button.hasFocus()
        m.list.setFocus(true)
        return true
    end if

    return false
end function
