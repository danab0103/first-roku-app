sub init()
    m.miniKeyboard = m.top.findNode("miniKeyboard")
    m.openKeyboardButton = m.top.findNode("openKeyboardButton")
    m.pokemonsGrid = m.top.findNode("pokemonsGrid")

    m.openKeyboardButton.observeField("buttonSelected", "onOpenKeyboardButtonSelected")
end sub

sub onOpenKeyboardButtonSelected()
    showKeyboardDialog()
end sub

sub onItemContentChanged()
    pokemonsContentList = m.top.itemContent
    gridContent = CreateObject("roSGNode", "ContentNode")
    pokemonsContentFirstRow = pokemonsContentList.getChild(0)
    m.pokemonsGrid.content = pokemonsContentFirstRow
end sub

sub showKeyboardDialog()
    createKeyboardDialog()
    m.top.appendChild(m.keyboardDialog)
    m.keyboardDialog.setFocus(true)
end sub

sub onKeyboardDialogClosed()
    m.miniKeyboard.text = m.keyboardDialog.text
    m.top.removeChild(m.keyboardDialog)
    m.openKeyboardButton.setFocus(true)
end sub

sub createKeyboardDialog()
    m.keyboardDialog = CreateObject("roSGNode", "KeyboardDialog")
    m.keyboardDialog.title = "Search Pokemon"
    m.keyboardDialog.observeField("wasClosed", "onKeyboardDialogClosed")
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press = true
        if key = "back"
            navigateBack(m.top.getParent().findNode("searchButton"))
            handled = true
        end if

        if  key = "up" and m.openKeyboardButton.hasFocus()
            m.miniKeyboard.setFocus(true)
            handled = true
        end if

        if key = "down" and not m.openKeyboardButton.hasFocus()
            m.openKeyboardButton.setFocus(true)
            handled = true
        end if

        if key = "right" and not m.openKeyboardButton.hasFocus()
            m.pokemonsGrid.setFocus(true)
            handled = true
        end if

        if key = "right" and m.openKeyboardButton.hasFocus()
            m.pokemonsGrid.setFocus(true)
            handled = true
        end if

        if key = "right" and not m.openKeyboardButton.hasFocus()
            m.pokemonsGrid.setFocus(true)
            handled = true
        end if

        if key = "left" and m.pokemonsGrid.hasFocus()
            m.miniKeyboard.setFocus(true)
            handled = true
        end if
    end if
    return handled
end function
