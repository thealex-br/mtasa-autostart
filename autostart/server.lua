function getResourcePriority(theResource)
    local meta = xmlLoadFile(":"..getResourceName(theResource).."/meta.xml", true)
    if not meta then
        return false
    end

    local child = xmlFindChild(meta, 'download_priority_group', 0)
    local value = child and xmlNodeGetValue(child) or "0"

    xmlUnloadFile(meta)
    return tonumber(value)
end

function init()
    local resources, toStart = getResources(), {}

    for i=1, #resources do
        local resource = resources[i]
        local priority = getResourcePriority(resource)
        if priority and getResourceInfo(resource, "start") == "true" then
            table.insert(toStart, {priority=priority, resource=resource})
        end
    end

    table.sort(toStart, function(a, b) return a.priority > b.priority end)

    for i=1, #toStart do
        startResource(toStart[1].resource, true)
    end
end
init()