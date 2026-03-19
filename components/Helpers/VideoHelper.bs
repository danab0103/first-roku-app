sub loadVideoData()
    m.videoTask = CreateObject("roSGNode", "GetVideoDataTask")
    m.videoTask.observeField("videoData", "onVideoDataLoaded")
    m.videoTask.control = "RUN"
end sub

sub onVideoDataLoaded()
    videoItem = m.videoTask.videoData
    navigateToNewScreen(m.top, "VideoScreen", videoItem)
end sub
