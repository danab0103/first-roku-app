sub init()
    initComponents()
    attachFieldsObservers()
    m.countdownInSeconds = 5
    m.playVideoButton.text = getCountdownText()
end sub

sub initComponents()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.descriptionLabel = m.top.findNode("descriptionLabel")
    m.playVideoButton = m.top.FindNode("playVideoButton")
    m.timer = m.top.findNode("timer")
end sub

sub attachFieldsObservers()
    m.backgroundPoster.observeField("loadStatus", "onImageLoadStatus")
    m.timer.observeField("fire", "changetext")
    m.playVideoButton.observeField("buttonSelected", "onPlayVideoButtonSelected")
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
    m.countdownInSeconds--

    if m.countdownInSeconds > 0
        m.playVideoButton.text = getCountdownText()
    else
        m.timer.control = "stop"
        m.playVideoButton.text = "Play Video"
        m.playVideoButton.setFocus(true)
    end if
end sub

function getCountdownText() as string
    return "Available in " + strI(m.countdownInSeconds) + " seconds ..."
end function

sub onPlayVideoButtonSelected()
    loadVideoData()
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if press = true
        if key = "back"
            closeComponent(m.top, m.top.getParent().findNode("imageList"))
            handled = true
        end if

        if key = "left" or key = "up" or key = "down" or key = "right"
            if m.countdownInSeconds = 0
                m.playVideoButton.setFocus(true)
            else
                m.top.setFocus(true)
            end if
            handled = true
        end if
    end if

    return handled
end function
