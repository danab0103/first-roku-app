sub init()
    m.top.functionName = "run"
end sub

sub run()
    endpoint = "https://my-json-server.typicode.com/bogdanterzea/pokemon-server/photos"

    httpReq = CreateObject("roUrlTransfer")
    httpReq.SetUrl(endpoint)

    httpReq.SetCertificatesFile("common:/certs/ca-bundle.crt")
    httpReq.AddHeader("X-Roku-Reserved-Dev-Id", "")
    httpReq.InitClientCertificates()

    rsp = httpReq.GetToString()
    dataJson= ParseJson(rsp)

    root = CreateObject("roSGNode", "ContentNode")
    row  = CreateObject("roSGNode", "ContentNode")
    for each p in dataJson
        item = CreateObject("roSGNode", "PhotoNode")

        item.photoId = p.id
        item.title = p.title
        item.url = p.url
        item.image_1080_url = p.image_1080_url
        item.description = p.description

        row.appendChild(item)
    end for

    root.appendChild(row)
    m.top.photosContent = root
end sub
