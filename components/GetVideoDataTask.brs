sub init()
    m.top.functionName = "run"
end sub

sub run()
    endpoint = "https://my-json-server.typicode.com/bogdanterzea/pokemon-server/videos"
    requestResponse = fetchVideoData(endpoint)
    videoDataJson = ParseJson(requestResponse)
    populateVideoData(videoDataJson[0])
end sub

function fetchVideoData(endpoint as String)
    httpRequest = createHttpRequest(endpoint)
    return executeHttpRequest(httpRequest)
end function

function executeHttpRequest(httpRequest)
    ok = httpRequest.AsyncGetToString()
    if not ok then return invalid

    event = wait(10000, httpRequest.getPort())
    if event = invalid
        print "Request timeout or no response"
        return invalid
    end if

    if type(event) <> "roUrlEvent" then return invalid

    code = event.GetResponseCode()
    responseBody = event.GetString()

    if code <> 200 or responseBody = invalid or responseBody = ""
        print "404 ERROR"
        return invalid
    end if

    return responseBody
end function

function createHttpRequest(endpoint as String)
    httpRequest = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    httpRequest.SetUrl(endpoint)
    httpRequest.SetPort(port)
    httpRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
    httpRequest.AddHeader("X-Roku-Reserved-Dev-Id", "")
    httpRequest.InitClientCertificates()
    return httpRequest
end function

sub populateVideoData(videoDataJson as Object)
    videoNode = CreateObject("roSGNode", "VideoNode")
    videoNode.videoId = videoDataJson.id
    videoNode.title = videoDataJson.title
    videoNode.posterUrl = videoDataJson.poster
    videoNode.streamUrl = videoDataJson.stream.url
    videoNode.streamFormat = videoDataJson.stream.format
    videoNode.description = videoDataJson.description
    m.top.videoData = videoNode
end sub
