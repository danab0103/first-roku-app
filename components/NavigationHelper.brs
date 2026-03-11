sub navigateBack(focus)
    parent = m.top.getParent()
    parent.removeChild(m.top)
    focus.setFocus(true)
end sub
