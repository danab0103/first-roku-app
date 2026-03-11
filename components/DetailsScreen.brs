sub init()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.descriptionLabel = m.top.findNode("descriptionLabel")
    m.backgroundPoster.observeField("loadStatus", "onImageLoadStatus")
end sub

sub showDetails()
    item = m.top.itemContent
    m.backgroundPoster.uri = item.image_1080_url
    m.descriptionLabel.text = item.description
end sub

sub onImageLoadStatus()
    if m.backgroundPoster.loadStatus = "failed"
        m.backgroundPoster.uri = "pkg:/images/default.jpg"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press = false then return false

    if key = "left" or key = "back"
        m.top.back = true  
        return true
    end if

    return false
end function
