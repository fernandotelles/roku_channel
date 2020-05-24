function index()
    return "http://192.168.43.102:8080/"
end function

function getAllAssets()
    return "http://192.168.43.102:8080/vod"
end function

function searchAssetByTitle(title as string)
    return ("http://192.168.43.102:8080/vod/search?s=" + title)
end function

sub request(url as string, observerMethod as string, method = "GET" as string, body = invalid as object, headers = invalid as object)
    body = FormatJson({})
    
    requestParams = {
        httpMethod: method
        url: url
        body: body
        headers: headers
    }
    
    ? "Performing call: "; url
    executeTask(requestParams, observerMethod)
end sub

sub executeTask(requestParams as Object, observerMethod as String)
        task = createObject("roSGNode", "HTTPTask")
        task.setField("requestParams", requestParams)
        task.observeField("result", observerMethod)
        setTask(task)
end sub

Sub setTask(task as Object)
    if(m.tasks <> invalid)
        nrTasks = m.tasks.Count()
        task.id = nrTasks
        task.control = "RUN"
        m.tasks[nrTasks] = task
    else
        task.id = 0
        task.control = "RUN"
        m.tasks = []
        m.tasks[0] = task
    end if
End Sub