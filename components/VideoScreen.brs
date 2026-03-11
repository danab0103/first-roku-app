sub init()
    m.video = m.top.findNode("video")
end sub

sub showVideo()
    item = m.top.itemContent

    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = item.streamUrl
    videoContent.streamFormat = item.streamFormat

    m.video.content = videoContent
    m.video.control = "play"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press = true
        if key = "back"
            m.video.control = "stop"
            m.top.back = true   
            return true
        end if
    end if

    return handled
end function
