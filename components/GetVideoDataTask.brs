sub init()
    m.top.functionName = "runTask"
end sub

sub runTask()
    endpoint = "https://my-json-server.typicode.com/bogdanterzea/pokemon-server/videos"
    requestResponse = fetchVideoData(endpoint)
    videoDataJson = ParseJson(requestResponse)
    populateVideoData(videoDataJson[0])
end sub

function fetchVideoData(endpoint as String) as Dynamic
    httpRequest = createHttpRequest(endpoint)
    return executeHttpRequest(httpRequest)
end function

function executeHttpRequest(httpRequest as Object) as Dynamic
    requestResult = invalid

    requestInitiated = httpRequest.AsyncGetToString()
    if requestInitiated 
        event = wait(10000, httpRequest.getPort())

        if event = invalid
            print "Request timeout or no response"
        else if type(event) = "roUrlEvent" 
            code = event.GetResponseCode()
            responseBody = event.GetString()

            if code <> 200 or responseBody = invalid or responseBody = ""
                print "404 ERROR"
            else 
                requestResult = responseBody
            end if
        end if
    end if

    return requestResult
end function

function createHttpRequest(endpoint as String) as Object
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
