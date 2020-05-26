sub init()
  m.poster = m.top.findNode("poster") 
  m.config = getResultRowListItemConfig()
  m.poster.setFields(m.config.poster)
  m.title = m.top.findNode("title")
end sub
  
function onContentChanged() as void
    itemData = m.top.itemContent
    if itemData.posterUrl <> "" then m.poster.uri = itemData.posterUrl else m.poster.uri = m.config.fallBackPoster
    m.title.text = itemData.title
end function

function getResultRowListItemConfig()
    return {
        poster: {
            translation: [0, 0]
            width: 120
            height: 120
        }
        fallBackPoster: "pkg:/images/splash_hd.jpg"
    }
end function