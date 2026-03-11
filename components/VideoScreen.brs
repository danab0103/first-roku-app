sub init()
    m.video = m.top.findNode("videoId")
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
        if key = "left" or key = "back"
            m.top.back = true  
            handled = true
        end if
    end if

    return handled
end function
