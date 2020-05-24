sub init()
    m.top.functionName = "getContent"
End sub

sub getContent()
    requestParams = m.top.requestParams
    resultObject = doRequest(requestParams.httpMethod, requestParams.url, requestParams.body, requestParams.headers)
    
    m.top.result = resultObject
end sub

function doRequest(httpMethod as String, url as String, body as Dynamic, headers as Dynamic) as Object
    deviceInfo = CreateObject("roDeviceInfo")
    if (deviceInfo.GetLinkStatus() = false)
        print("deviceInfo.GetLinkStatus(): " + deviceInfo.getLinkStatus())
    end if
    
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.setMessagePort(CreateObject("roMessagePort"))
    urlTransfer.setUrl(url)                                    
    urlTransfer.enableEncodings(true)                                
    urlTransfer.retainBodyOnError(true)                              
    urlTransfer.setCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.initClientCertificates()

    urlTransfer.enableCookies()
    
    if (headers <> invalid)
        urlTransfer.setHeaders(headers)
    end if

    urlTransfer.asyncGetToString()

    resultObject = CreateObject("roAssociativeArray")

    while true
        message = wait(0, urlTransfer.getMessagePort())

        if (type(message) = "roUrlEvent")
            resultObject.responseCode = message.getResponseCode()
            resultObject.failureReason = message.getFailureReason()
            resultObject.bodyString = message.getString()

            if (message.getResponseCode() >= 200 and message.getResponseCode() < 300)
                resultObject.responseHeaders = message.getResponseHeaders()
            end if
            
            exit while
        end if
    end while

    return resultObject
end function
