sub init()
    m.keyboard = m.top.findNode("miniKeyboard")

    m.keyboard.observeField("text", "onKeyEnter")
    m.label = m.top.findNode("resultLabel")
    
    m.panelSet = m.top.findNode("panelSet")
    m.panelSet.observeField("focusedChild", "onFocusedChildChanged")
    m.keyboardPanel = m.top.findNode("keyboardPanel")
    m.keyboardPanel.hasNextPanel = true
    m.resultPanel = m.top.findNode("resultPanel")
    
    m.task = createObject("roSGNode", "HTTPTask")
    
    httpParams = {
        httpMethod: "GET"
        url: "http://192.168.43.102:8080/",
        body: invalid
        headers: invalid
    }
    m.task.setField("requestParams", httpParams)
    m.task.observeField("result","getAPIKey")
    m.task.control = "RUN"
    
    m.keyboard.setFocus(true)
end sub

sub onKeyEnter(key)
    m.label.text = key.getData().ToStr()
    
    httpParams = {
        httpMethod: "GET"
        url: ("http://192.168.43.102:8080/vod/search?s=" + m.keyboard.text),
        body: invalid
        headers: {"x-api-token":  m.apiKey}
    }
    
    m.task.setField("requestParams", httpParams)
    m.task.unobserveField("result")
    m.task.observeField("result","onSuccess")
    m.task.control = "RUN"

end sub

sub onSuccess(params as object)
    m.assets = parseJson(params.getData().bodyString)
    m.rowList = m.top.findNode("selectionRow")
    m.rowList.setFields(getResultRowListConfig())
    
    rowData = CreateObject("roSGNode", "ContentNode")
    row = rowData.CreateChild("ContentNode")
    row.title = "Result"
    for i = 0 to m.assets.Count()-1 step +1
        item = row.CreateChild("ResultRowListData")
        item.posterUrl = m.assets[i].poster
        item.title = m.assets[i].title
    end for
    
    m.rowList.content = rowData
    
    m.rowList.observeField("rowItemSelected", "onRowItemSelected")
'    m.rowList.setFocus(true)
end sub

sub getAPIKey(params as object)
    response = params.getData().bodyString

    m.apiKey = parseJson(response).apiToken
end sub

function getResultRowListConfig()
    return {
        itemComponentName: "ResultRowListItem"
        numRows: 3
        itemSize: [1920, 200]
        rowHeights: [200]
        rowItemSize: [[120,120]]
        itemSpacing: [ 0, 25]
        rowItemSpacing: [ [20 , 0], [20 , 0] ]
        rowLabelOffset: [ [0, 25 ], [0, 25 ] ]
        rowFocusAnimationStyle: "floatingFocus"
        showRowLabel: [true, true]
        rowLabelColor: "0xa0b033ff"
    }
end function
