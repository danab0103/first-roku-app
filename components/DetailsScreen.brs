sub init()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.descriptionLabel = m.top.findNode("descriptionLabel")
    m.playVideoButton = m.top.FindNode("playVideoButton")
    m.timer = m.top.findNode("timer")

    m.playVideoButton.text = "Unavailable..."
    m.timer.control = "start"

    m.backgroundPoster.observeField("loadStatus", "onImageLoadStatus")
    m.timer.observeField("fire", "changetext")
    m.playVideoButton.observeField("buttonSelected", "onTimerButtonSelected")
end sub

sub showDetails()
    item = m.top.itemContent
    m.backgroundPoster.uri = item.image_1080_url
    m.descriptionLabel.text = item.description
end sub

sub onImageLoadStatus()
    if m.backgroundPoster.loadStatus = "failed" then m.backgroundPoster.uri = "pkg:/images/default.jpg"
end sub

sub changetext()
    m.playVideoButton.text = "Available"
    m.playVideoButton.setFocus(true)
end sub

sub onTimerButtonSelected()
    loadVideoData()
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
        if key = "left" or key = "back"
            closeComponent(m.top, m.top.getParent().findNode("imageList"))
            handled = true
        end if
    end if

    return handled
end function
