sub init()
    m.keyboard = m.top.findNode("miniKeyboard")
    m.keyboard.setFocus(true)
    m.keyboard.observeField("text", "onKeyEnter")
    m.label = m.top.findNode("resultLabel")
    
    m.panelSet = m.top.findNode("panelSet")
    m.panelSet.observeField("focusedChild", "showPanel")
    m.resultPanel = m.top.findNode("resultPanel")
    m.panelSet.observeField("focusedChild", "showPanel")
    request(index(), "getApiKey")
end sub

sub onKeyEnter(key)
    m.label.text = key.getData().ToStr()
    request(searchAssetByTitle(m.label.text), "printAssets", "GET", invalid, {"x-api-token":  m.apiKey})
end sub

sub printAssets(params as object)
    ? parseJson(params.getData().bodyString)
end sub

sub getAPIKey(params as object)
    response = params.getData().bodyString

    m.apiKey = parseJson(response).apiToken
end sub