sub init()
    m.buttons = m.top.findNode("buttons")
    initButtons()
    m.title = m.top.findNode("title")
    m.year = m.top.findNode("year")
    m.description = m.top.findNode("description")
    m.poster = m.top.findNode("image")

end sub

sub configure(params as object)
    content = params
    setContent(content)
    setFieldsVisible(true)
    m.buttons.setFocus(true)
end sub

sub setContent(content as object)
    m.title.text = content.title
    m.year.text = content.year
    m.description.text = "The Video Description"
    m.poster.uri = content.poster
    
    if content.type = "movie"
        addButton("Play Video")
    end if
end sub

sub setFieldsVisible(visible as boolean)
    m.buttons.visible = visible
    m.title.visible = visible
    m.year.visible = visible
    m.description.visible = visible
    m.poster.visible = visible
end sub

sub initButtons()
    m.buttons.content = createObject("roSGNode", "ContentNode")
    m.buttons.observeField("itemSelected","onItemSelected")
    addButton("Back")
end sub

sub addButton(title as string)
    if m.buttons.content <> invalid
        item = createObject("roSGNode", "ContentNode")
        item.setField("title", title)
        m.buttons.content.appendChild(item)
    end if
end sub

sub onItemSelected(params as object)
     item = params.getData()
     itemContent = m.buttons.content.getChild(item)
     if itemContent.title = "Play Video" then
        ? "Play The Video"
     else
        ? "Back to grid menu"
     end if
end sub