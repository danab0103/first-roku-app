sub init()
    m.video = m.top.findNode("video")
end sub

sub showVideo()
    videoItem = m.top.itemContent
    m.video.content = createVideoContent(videoItem)
    m.video.control = "play"
end sub

function createVideoContent(videoItem as Object) as Object
    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = videoItem.streamUrl
    videoContent.streamFormat = videoItem.streamFormat
    return videoContent
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press = true
        if key = "back"
            m.video.control = "stop"
            navigateBack(m.top.getParent().findNode("leftButton"))
            return true
        end if
    end if

    return handled
end function
