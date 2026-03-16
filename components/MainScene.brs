sub init()
    appInfo = CreateObject("roAppInfo")

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.text = appInfo.GetTitle() + " v" + appInfo.GetVersion()

    m.playVideoButton = m.top.findNode("playVideoButton")
    m.searchButton = m.top.findNode("searchButton")
    m.list = m.top.findNode("imageList")

    m.list.observeField("rowItemFocused", "onItemFocused")
    m.list.observeField("rowItemSelected", "onItemSelected")
    m.playVideoButton.observeField("buttonSelected", "onPlayVideoButtonSelected")
    m.searchButton.observeField("buttonSelected", "onSearchButtonSelected")

    m.photosTask = CreateObject("roSGNode", "GetRequestPhotosTask")
    m.photosTask.observeField("photosContent", "onPhotosLoaded")
    m.photosTask.control = "RUN"

    m.playVideoButton.setFocus(true)
end sub

sub onPhotosLoaded()
    m.list.content = m.photosTask.photosContent
    m.searchButton.visible = true
end sub

sub onItemSelected()
    selected = m.list.rowItemSelected
    item = m.list.content.getChild(selected[0]).getChild(selected[1])
    print "url="; item.image_1080_url
    navigateToNewScreen(m.top, "DetailsScreen", item)
end sub

sub onItemFocused()
    focus = m.list.rowItemFocused
    item = m.list.content.getChild(focus[0]).getChild(focus[1])

    print "title="; item.title
end sub

sub onPlayVideoButtonSelected()
    print "Play video button pressed."
    loadVideoData()
end sub

sub onSearchButtonSelected()
    print "Search button pressed."
    navigateToNewScreen(m.top, "SearchScreen", m.list.content)
end sub

sub loadVideoData()
    m.videoTask = CreateObject("roSGNode", "GetVideoDataTask")
    m.videoTask.observeField("videoData", "onVideoDataLoaded")
    m.videoTask.control = "RUN"
end sub

sub onVideoDataLoaded()
    videoItem = m.videoTask.videoData
    navigateToNewScreen(m.top, "VideoScreen", videoItem)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
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
