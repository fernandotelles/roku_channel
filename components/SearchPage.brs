sub init()
    m.keyboard = m.top.findNode("miniKeyboard")
    m.keyboard.observeField("text", "onKeyEnter")
    m.label = m.top.findNode("resultLabel")
    m.notFoundLabel = m.top.findNode("notFound")
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
    m.searchTerm = m.keyboard.text
    
    httpParams = {
        httpMethod: "GET"
        url: ("http://192.168.43.102:8080/vod/search?s=" + m.searchTerm),
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
    m.notFoundLabel.visible = false
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
    if m.assets.count() = 0 
        m.notFoundLabel.visible = true
    end if
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
    addRadioButtonList("Movie")
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

sub onItemSelected(params as object)
    baseURL = ("http://192.168.43.102:8080/vod/search?s=" + m.searchTerm)
    itemSelected = m.radioButtonList.content.getChild(params.getData())
    if not itemSelected.title = "All"
        baseURL = (baseURL + "&filter=" + itemSelected.title)
    end if

    httpParams = {
        httpMethod: "GET"
        url: baseURL 
        body: invalid
        headers: {"x-api-token":  m.apiKey}
    }
    m.task.setField("requestParams", httpParams)
    m.task.unobserveField("result")
    m.task.observeField("result","onSuccess")
    m.task.control = "RUN"
end sub

sub onRowItemSelected(params as object)
    itemSelected = params.getData()[1]
    m.detailPage = m.top.createChild("SimpleDetailPage")
    params = {
        title: m.assets[itemSelected].title
        year: "2020"
        type: m.assets[itemSelected].type
        poster: "pkg:/images/bladerunner.jpg"
    }
    m.detailPage.callFunc("configure", params)
    m.detailPage.setFocus(true)
    setFieldsVisible(false)
end sub

sub setFieldsVisible(visible as boolean)
    m.top.getChild(0).visible = visible
end sub