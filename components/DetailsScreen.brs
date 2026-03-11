sub init()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
end sub

sub showDetails()
    item = m.top.itemContent
    m.backgroundPoster.uri = item.image_1080_url
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press = false then return false

    if key = "left" or key = "back"
        m.top.back = true  
        return true
    end if

    return false
end function
