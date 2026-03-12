sub navigateBack(focusComponent as Object)
    parent = m.top.getParent()
    parent.removeChild(m.top)
    focusComponent.setFocus(true)
end sub
