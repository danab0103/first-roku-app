sub closeComponent(component as object, focusComponent as object)
    parent = component.getParent()
    parent.removeChild(component)
    focusComponent.setFocus(true)
end sub

sub navigateToNewScreen(screenParent as object, screenName as string, itemContent as object)
    screen = CreateObject("roSGNode", screenName)
    screen.itemContent = itemContent
    screenParent.appendChild(screen)
    screen.setFocus(true)
end sub
