sub init()
    m.gridPanel = m.top.findNode("gridPanel")
    m.posterGrid = m.top.createChild("PosterGrid")
    m.posterGrid.observeField("itemFocused", "onItemFocused")
    m.posterGrid.observeField("itemSelected", "onItemSelected")
    m.posterGrid.setFields(getPosterGridConfig())
    m.posterGridContent = createObject("roSGNode", "ContentNode")
    m.top.setFocus(true)
    request(getOmdbURL(), "fillGridPanel")
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
    ? params.getData()
end sub

function getPosterGridConfig()
    return {
        basePosterSize: [300, 200]
        itemSpacing: [30,30]
        caption1NumLines: 1
        caption2NumLines: 1
        numColumns: 3
        numRows: 3
        fixedLayout: false
    }
end function