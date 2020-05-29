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
        m.videoPlayer = m.top.createChild("Player")
        videoData = {
            url: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
            title: (m.title.text +" - "+ m.year.text)
        }
        m.videoPlayer.callFunc("configure", videoData)
     else
        setFieldsVisible(false)
        m.buttons.setFocus(false)
        m.top.visible = false
        m.top.getParent().findNode("gridPanel").grid.visible = true
        m.top.getParent().findNode("gridPanel").grid.setFocus(true)
     end if
end sub

function onKeyEvent(key, press)
    if press then
        if key = "back" then
            if(m.videoPlayer <> invalid)
                m.videoPlayer.callFunc("stopVideo")
                m.videoPlayer.visible = false
                m.videoPlayer.setFocus(false)
                m.videoPlayer = invalid
                
                m.buttons.setFocus(true)
                return true
            end if
        end if
    end if
end function