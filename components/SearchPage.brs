sub init()
    m.keyboard = m.top.findNode("miniKeyboard")
    m.keyboard.setFocus(true)
    m.keyboard.observeField("text", "onKeyEnter")
    m.label = m.top.findNode("label")
end sub

sub onKeyEnter(key)
    m.label.text = key.getData().ToStr()
end sub