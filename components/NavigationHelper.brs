sub closeComponent(component as object, focusComponent as object)
    parent = component.getParent()
    parent.removeChild(component)
    focusComponent.setFocus(true)
end sub

sub navigateToNewScreen(screenParent as Object, screenName as string, item as object)
    screen = CreateObject("roSGNode", screenName)
    screen.itemContent = item
    screenParent.appendChild(screen)
    screen.setFocus(true)
end sub
