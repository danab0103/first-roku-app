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
    if m.backgroundPoster.loadStatus = "failed" then m.backgroundPoster.uri = "pkg:/images/default.jpg"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press = true
        if key = "left" or key = "back"
            navigateBack(m.top.getParent().findNode("imageList"))
            handled = true
        end if
    end if

    return handled
end function
