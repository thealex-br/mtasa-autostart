function getResourceProperty(theResource, propertyName)
    local xml = xmlLoadFile(":"..getResourceName(theResource).."/meta.xml", true)
    if not xml then
        return false
    end

    local child = xmlFindChild(xml, propertyName, 0)
    local value = child and xmlNodeGetValue(child) or false

    xmlUnloadFile(xml)
    return value
end

function startResources()
    local resources, toStart = getResources(), {}

    for k, v in ipairs(resources) do
        local start = getResourceProperty(v, "autostart")
        local order = getResourceProperty(v, "download_priority_group") or "0"
        if start == "true" then
            table.insert(toStart, {p=tonumber(order), r=v})
        end
    end

    table.sort(toStart, function(a, b) return a.p > b.p end)

    for k, v in ipairs(toStart) do
        startResource(v.r, true)
    end
end
addEventHandler("onResourceStart", resourceRoot, startResources)
