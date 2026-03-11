sub init()
    m.top.functionName = "run"
end sub

sub run()
    endpoint = "https://my-json-server.typicode.com/bogdanterzea/pokemon-server/photos"

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
                populateContentLocalPhotos()
                return
            end if

            dataJson = ParseJson(rsp)
            populateContentEndpointPhotos(dataJson)
        end if
    end if
end sub

sub populateContentEndpointPhotos(dataJson as Object)
    root = CreateObject("roSGNode", "ContentNode")
    row  = CreateObject("roSGNode", "ContentNode")

    for each p in dataJson
        item = CreateObject("roSGNode", "PhotoNode")
        item.photoId        = p.id
        item.title          = p.title
        item.url            = p.url
        item.image_1080_url = p.image_1080_url
        item.description    = p.description
        row.AppendChild(item)
    end for

    root.AppendChild(row)
    m.top.photosContent = root
end sub

sub populateContentLocalPhotos()
    root = CreateObject("roSGNode", "ContentNode")
    row  = CreateObject("roSGNode", "ContentNode")

    for i = 0 to 4
        path = "pkg:/images/cat" + i.ToStr() + ".jpeg"
        item = CreateObject("roSGNode", "PhotoNode")
        item.photoId        = i
        item.title          = "Local photo " + i.ToStr()
        item.url            = path
        item.image_1080_url = path
        item.description    = "Loaded from local images folder"
        row.AppendChild(item)
    end for
    root.AppendChild(row)
    m.top.photosContent = root
end sub
