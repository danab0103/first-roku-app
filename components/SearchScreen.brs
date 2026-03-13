sub init()
    m.miniKeyboard = m.top.findNode("miniKeyboard")
    m.openKeyboardButton = m.top.findNode("openKeyboardButton")

    m.openKeyboardButton.observeField("buttonSelected", "onOpenKeyboardButtonSelected")
end sub

sub onOpenKeyboardButtonSelected()
    showKeyboardDialog()
end sub

sub showKeyboardDialog()
    createKeyboardDialog()
    m.keyboardDialog.setFocus(true)
    m.keyboardDialog.observeField("wasClosed", "onKeyboardDialogClosed")
end sub

sub onKeyboardDialogClosed()
    m.miniKeyboard.text = m.keyboardDialog.text
    m.top.removeChild(m.keyboardDialog)
    m.openKeyboardButton.setFocus(true)
end sub

sub createKeyboardDialog()
    m.keyboardDialog = CreateObject("roSGNode", "KeyboardDialog")
    m.keyboardDialog.title = "Search Pokemon"
    m.top.appendChild(m.keyboardDialog)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press = true
        if key = "back"
            navigateBack(m.top.getParent().findNode("searchButton"))
            handled = true
        end if

        if (key = "left" or key = "up") and m.openKeyboardButton.hasFocus()
            m.miniKeyboard.setFocus(true)
            handled = true
        end if

        if (key = "right" or key = "down") and not m.openKeyboardButton.hasFocus()
            m.openKeyboardButton.setFocus(true)
            handled = true
        end if
    end if
    return handled
end function
