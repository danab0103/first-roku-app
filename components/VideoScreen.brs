sub init()
    m.video = m.top.findNode("video")
end sub

sub showVideo()
    videoItem = m.top.itemContent
    m.video.content = createVideoContent(videoItem)
    m.video.control = "play"
end sub

function createVideoContent(videoItem as object) as object
    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = videoItem.streamUrl
    videoContent.streamFormat = videoItem.streamFormat
    return videoContent
end function

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if press = true
        if key = "back"
            m.video.control = "stop"
            closeComponent(m.top, m.top.getParent().findNode("playVideoButton"))
            handled = true
        end if
    end if

    return handled
end function
