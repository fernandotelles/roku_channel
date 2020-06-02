sub init()
    m.keyboard = m.top.findNode("miniKeyboard")
    m.keyboard.observeField("text", "onKeyEnter")
    m.label = m.top.findNode("resultLabel")
    m.task = createObject("roSGNode", "HTTPTask")
    m.radioButtonList = m.top.findNode("radioButtonList")
    initRadioButtonList()
    
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
    for i = 0 to m.assets.Count()-1 step +1
        item = row.CreateChild("ResultRowListData")
        item.posterUrl = m.assets[i].poster
        item.title = m.assets[i].title
    end for
    
    m.rowList.content = rowData
    
    m.rowList.observeField("rowItemSelected", "onRowItemSelected")
end sub

sub getAPIKey(params as object)
    response = params.getData().bodyString

    m.apiKey = parseJson(response).apiToken
end sub

function onKeyEvent(key, press)

    if press
        if key = "right"
            if m.radioButtonList.hasFocus() and m.rowList <> invalid
                m.rowList.setFocus(true)
            else
                m.radioButtonList.setFocus(true)
            end if
        else if key = "left"
            m.keyboard.setFocus(true)
        end if
    end if
    
end function

function getResultRowListConfig()
    return {
        itemComponentName: "ResultRowListItem"
        numRows: 1
        itemSize: [700, 200]
        rowHeights: [200]
        rowItemSize: [[120,120]]
        itemSpacing: [ 0, 25]
        rowItemSpacing: [ [20 , 0], [20 , 0] ]
        rowFocusAnimationStyle: "floatingFocus"
    }
end function

sub initRadioButtonList()
    m.radioButtonList.content = createObject("roSGNode", "ContentNode")
    m.radioButtonList.observeField("itemSelected","onItemSelected")
    addRadioButtonList("All")
    addRadioButtonList("Movies")
    addRadioButtonList("Series")
    m.radioButtonList.checkedItem = 0
end sub

sub addRadioButtonList(title as string)
    if m.radioButtonList.content <> invalid
        item = createObject("roSGNode", "ContentNode")
        item.setField("title", title)
        m.radioButtonList.content.appendChild(item)
    end if
end sub
