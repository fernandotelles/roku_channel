sub init()
    m.gridPanel = m.top.findNode("gridPanel")
    m.posterGrid = m.top.createChild("PosterGrid")
    m.posterGrid.observeField("itemFocused", "onItemFocused")
    m.posterGrid.observeField("itemSelected", "onItemSelected")
    m.posterGrid.setFields(getPosterGridConfig())
    m.posterGridContent = createObject("roSGNode", "ContentNode")
    m.top.setFocus(true)
    m.task = createObject("roSGNode", "HTTPTask")
    
    httpParams = {
        httpMethod: "GET"
        url: "http://www.omdbapi.com/?apikey=69a8c95d&s=%22test%22/",
        body: invalid
        headers: invalid
    }
    m.task.setField("requestParams", httpParams)
    m.task.observeField("result","fillGridPanel")
    m.task.control = "RUN"
end sub


sub fillGridPanel(params as object)
    m.assetList = parseJson(params.getData().bodystring).search
    for each asset in m.assetList
        gridPoster = createObject("roSGNode","ContentNode")
        gridPoster.hdgridposterurl = asset.poster
        gridPoster.sdgridposterurl = asset.poster
        gridPoster.shortdescriptionline1 = asset.title
        gridPoster.shortdescriptionline2 = asset.year
        gridPoster.x = 1
        gridPoster.y = 1
        m.posterGridContent.appendChild(gridPoster)
    end for
    m.posterGrid.content = m.posterGridContent
    m.gridPanel.grid = m.posterGrid
    m.gridPanel.grid.visible = true
    m.gridPanel.grid.setFocus(true)
end sub

sub onItemFocused(params as object)
    ? params.getData()
end sub

sub onItemSelected(params as object)
    itemSelected = params.getData()
    itemSelectedContent = m.gridPanel.grid.content.getChild(itemSelected)
    m.detailPage = m.top.createChild("SimpleDetailPage")
    m.detailPage.callFunc("configure", m.assetList[itemSelected])
    m.detailPage.setFocus(true)
    m.gridPanel.grid.visible = false
end sub

function onKeyEvent(key, press)
    if press
        if key = "options"
            m.searchPage = m.top.createChild("SearchPage")
            m.searchPage.id = "searchPage"
            m.searchPage.visible = true
            m.searchPage.setFocus(true)
            m.gridPanel.grid.visible = false
        end if
    end if
end function

function getPosterGridConfig()
    return {
        basePosterSize: [230, 285]
        itemSpacing: [30,30]
        caption1NumLines: 1
        caption2NumLines: 1
        numColumns: 5
        numRows: 2
        fixedLayout: false
    }
end function