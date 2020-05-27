sub init()
    
    m.posterGrid = m.top.createChild("PosterGrid")
    m.posterGrid.setFields(getPosterGridConfig)
    m.posterGridContent = createObject("roSGNode", "ContentNode")
    m.top.setFocus(true)
    request(getOmdbURL(), "fillGridPanel")
end sub


sub fillGridPanel(params as object)
    m.assetList = parseJson(params.getData().bodystring).search
    for each asset in m.assetList
        gridPoster = createObject("roSGNode","ContentNode")
        gridPoster.hdgridposterurl = asset.poster
'        gridPoster.hdposterurl = asset.poster
        gridPoster.sdgridposterurl = asset.poster
'        gridPoster.sdposterurl = asset.poster
        gridPoster.shortdescriptionline1 = asset.title
        gridPoster.shortdescriptionline2 = asset.year
        gridPoster.x = 1
        gridPoster.y = 1
        m.posterGridContent.appendChild(gridPoster)
    end for
    m.posterGrid.content = m.posterGridContent
'    m.top.findNode("gridPanel").grid = m.posterGrid
'    m.top.findNode("gridPanel").grid.visible = true
'    m.top.findNode("gridPanel").grid.setFocus(true)
    m.top.grid = m.posterGrid
    m.top.setFocus(true)
    m.top.visible = true
'    m.posterGrid.visible = true
'    m.posterGrid.setFocus(true)
end sub


function getPosterGridConfig()
    return {
        basePosterSize: [200, 200]
        itemSpacing: [4,8]
        caption1NumLines: 1
        caption2NumLines: 1
        numColumns: 3
        fixedLayout: false
    }
end function