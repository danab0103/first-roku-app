sub init()
    m.top.setFocus(true)

    appInfo = CreateObject("roAppInfo")

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.text = appInfo.GetTitle() + " v" + appInfo.GetVersion()

    m.button = m.top.findNode("leftButton")
    m.list = m.top.findNode("imageList")

    m.list.observeField("rowItemFocused", "onItemFocused")
    m.list.observeField("rowItemSelected", "onItemSelected")
    m.button.observeField("buttonSelected", "onButtonSelected")

    m.photosTask = CreateObject("roSGNode", "GetRequestPhotosTask")
    m.photosTask.observeField("photosContent", "onPhotosLoaded")
    m.photosTask.control = "RUN"

    m.button.setFocus(true)
end sub

sub onPhotosLoaded()
    m.list.content = m.photosTask.photosContent
end sub

sub onItemSelected()
    selected = m.list.rowItemSelected
    item = m.list.content.getChild(selected[0]).getChild(selected[1])
    print "url="; item.image_1080_url
    navigateToNewScreen(item)
end sub

sub navigateToNewScreen(item)
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.itemContent = item

    m.top.appendChild(detailsScreen)
    detailsScreen.setFocus(true)

    detailsScreen.observeField("back", "onDetailsBack")
    m.detailsScreen = detailsScreen
end sub

sub onDetailsBack()
    m.top.removeChild(m.detailsScreen)
    m.list.setFocus(true) 
end sub

sub onItemFocused()
    focus = m.list.rowItemFocused
    item = m.list.content.getChild(focus[0]).getChild(focus[1])

    print "title="; item.title
end sub

sub onButtonSelected()
    print "Button pressed."
    m.videoTask = CreateObject("roSGNode", "GetVideoTask")
    m.videoTask.observeField("videoContent", "onVideoLoaded")
    m.videoTask.control = "RUN"
end sub

sub onVideoLoaded()
    item = m.videoTask.videoContent  
    navigateToVideoScreen(item)     
end sub

sub navigateToVideoScreen(item)
    videoScreen = CreateObject("roSGNode", "VideoScreen")
    videoScreen.itemContent = item

    m.top.appendChild(videoScreen)
    videoScreen.setFocus(true)

    videoScreen.observeField("back", "onVideoBack")
    m.videoScreen = videoScreen
end sub

sub onVideoBack()
    m.top.removeChild(m.videoScreen) 
    m.button.setFocus(true)
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
