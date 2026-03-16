sub closeComponent(component as Object, focusComponent as Object)
    parent = component.getParent()
    parent.removeChild(component)
    focusComponent.setFocus(true)
end sub
