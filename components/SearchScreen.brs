sub init()
    m.miniKeyboard = m.top.findNode("miniKeyboard")
    m.openKeyboardButton = m.top.findNode("openKeyboardButton")
    m.pokemonsGrid = m.top.findNode("pokemonsGrid")

    m.openKeyboardButton.observeField("buttonSelected", "onOpenKeyboardButtonSelected")
    m.miniKeyboard.observeField("text", "onSearchTextChanged") 
end sub

sub onOpenKeyboardButtonSelected()
    showKeyboardDialog()
end sub

sub onItemContentChanged()
    pokemonsContentList = m.top.itemContent
    pokemonsContentFirstRow = pokemonsContentList.getChild(0)
    m.pokemonsGrid.content = pokemonsContentFirstRow
    m.allPokemons = pokemonsContentFirstRow
end sub

sub showKeyboardDialog()
    createKeyboardDialog()
    m.top.appendChild(m.keyboardDialog)
    m.keyboardDialog.setFocus(true)
end sub

sub onKeyboardDialogClosed()
    m.miniKeyboard.text = m.keyboardDialog.text
    closeComponent(m.keyboardDialog, m.openKeyboardButton)
end sub

sub createKeyboardDialog()
    m.keyboardDialog = CreateObject("roSGNode", "StandardKeyboardDialog")
    m.keyboardDialog.title = "Search Pokemon"
    m.keyboardDialog.text = m.miniKeyboard.text
    m.keyboardDialog.observeField("wasClosed", "onKeyboardDialogClosed")
end sub

sub onSearchTextChanged()
    searchText = LCase(m.miniKeyboard.text)
    m.pokemonsGrid.content = filterPokemons(searchText)
end sub

function filterPokemons(searchText as String) as Object
    filteredPokemons = CreateObject("roSGNode", "ContentNode")  
    
    if searchText = "" then
        filteredPokemons = m.allPokemons
    else
        for childIndex = 0 to m.allPokemons.getChildCount() - 1
            pokemon = m.allPokemons.getChild(childIndex)     
            if Instr(LCase(pokemon.title), searchText) > 0
                clonedPokemon = clonePokemon(pokemon)
                filteredPokemons.appendChild(clonedPokemon)
            end if
        end for
    end if

    return filteredPokemons
end function

function clonePokemon(pokemon as Object) as Object
        clonedPokemon = CreateObject("roSGNode", "ContentNode")
        clonedPokemon.title = pokemon.title
        clonedPokemon.url = pokemon.url
        return clonedPokemon
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press = true
        if key = "back"
            navigateBack(m.top.getParent().findNode("searchButton"))
            handled = true
        end if

        if  key = "up"
            m.miniKeyboard.setFocus(true)
            handled = true
        end if

        if key = "down" 
            m.openKeyboardButton.setFocus(true)
            handled = true
        end if

        if key = "right" 
            m.pokemonsGrid.setFocus(true)
            handled = true
        end if

        if key = "left" and not m.openKeyboardButton.hasFocus()
            m.miniKeyboard.setFocus(true)
            handled = true
        end if
    end if
    return handled
end function
