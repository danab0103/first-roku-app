sub init()
    appInfo = CreateObject("roAppInfo")

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.text = appInfo.GetTitle() + " v" + appInfo.GetVersion()

    m.playVideoButton = m.top.findNode("playVideoButton")
    m.searchButton = m.top.findNode("searchButton")
    m.list = m.top.findNode("imageList")

    m.list.observeField("rowItemFocused", "onItemFocused")
    m.list.observeField("rowItemSelected", "onItemSelected")
    m.playVideoButton.observeField("buttonSelected", "onButtonSelected")

    m.photosTask = CreateObject("roSGNode", "GetRequestPhotosTask")
    m.photosTask.observeField("photosContent", "onPhotosLoaded")
    m.photosTask.control = "RUN"

    m.playVideoButton.setFocus(true)
end sub

sub onPhotosLoaded()
    m.list.content = m.photosTask.photosContent
end sub

sub onItemSelected()
    selected = m.list.rowItemSelected
    item = m.list.content.getChild(selected[0]).getChild(selected[1])
    print "url="; item.image_1080_url
    navigateToNewScreen("DetailsScreen", item)
end sub

sub onItemFocused()
    focus = m.list.rowItemFocused
    item = m.list.content.getChild(focus[0]).getChild(focus[1])

    print "title="; item.title
end sub

sub onButtonSelected()
    print "Button pressed."
    loadVideoData()
end sub

sub loadVideoData()
    m.videoTask = CreateObject("roSGNode", "GetVideoDataTask")
    m.videoTask.observeField("videoData", "onVideoDataLoaded")
    m.videoTask.control = "RUN"
end sub

sub onVideoDataLoaded()
    videoItem = m.videoTask.videoData  
    navigateToNewScreen("VideoScreen", videoItem)
end sub

sub navigateToNewScreen(screenName as String, item as Object)
    screen = CreateObject("roSGNode", screenName)
    screen.itemContent = item
    m.top.appendChild(screen)
    screen.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press = true
        if key = "right" and m.playVideoButton.hasFocus()
            m.searchButton.setFocus(true)
            handled = true
        end if

        if key = "left" and m.searchButton.hasFocus()
            m.playVideoButton.setFocus(true)
            handled = true
        end if

        if key = "up"
            m.playVideoButton.setFocus(true)
            handled = true
        end if

        if key = "down"
            m.list.setFocus(true)
            handled = true
        end if
    end if

    return handled
end function
