sub closeComponent(component as object, focusComponent as object)
    parent = component.getParent()
    parent.removeChild(component)
    focusComponent.setFocus(true)
end sub
