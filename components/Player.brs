sub init()
    m.videoPlayer = m.top.findNode("videoPlayer")
end sub

sub configure(params as object)
    videoContent = createObject("roSGNode", "ContentNode")
    videoContent.url = params.url
    videoContent.title = params.title
    videoContent.streamformat = "hls"
    m.videoPlayer.content = videoContent
    playVideo()
end sub

sub playVideo()
    m.videoPlayer.control = "play"
end sub

sub stopVideo(params = invalid as dynamic)
    m.videoPlayer.control = "stop"
end sub