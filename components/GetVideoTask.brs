sub init()
    m.top.functionName = "run"
end sub

sub run()
    endpoint = "https://my-json-server.typicode.com/bogdanterzea/pokemon-server/videos"

    httpReq = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")

    httpReq.SetUrl(endpoint)
    httpReq.SetPort(port)
    httpReq.SetCertificatesFile("common:/certs/ca-bundle.crt")
    httpReq.AddHeader("X-Roku-Reserved-Dev-Id", "")
    httpReq.InitClientCertificates()

    ok = httpReq.AsyncGetToString()

    if ok then
        event = wait(10000, port)
        if event = invalid then
            print "Request timeout or no response"
            return
        end if

        if type(event) = "roUrlEvent" then
            code = event.GetResponseCode()
            rsp  = event.GetString()

            if code <> 200 or rsp = invalid or rsp = "" then
                print "404 ERROR"
                return
            end if

            dataJson = ParseJson(rsp)
            populateContentVideo(dataJson[0])
        end if
    end if
end sub

sub populateContentVideo(dataJson as Object)
    item = CreateObject("roSGNode", "VideoNode")
    item.videoId = dataJson.id
    item.title = dataJson.title
    item.posterUrl = dataJson.poster
    item.streamUrl = dataJson.stream.url
    item.streamFormat = dataJson.stream.format
    item.description = dataJson.description
    m.top.videoContent = item
end sub
