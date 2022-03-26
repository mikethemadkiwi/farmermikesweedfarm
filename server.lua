Seeds = {}
Plants = {}
-----
function CreatePlant(pSrc, pCoords)
    local plant = {}
    local sex = math.random(0,1)
    if sex == 0 then
        plant.propHash = 452618762
        plant.gender = "xx"
    else
        plant.propHash = -305885281
        plant.gender = "xy"
    end
    plant.propPos = pCoords
    plant.genetics = {}
    plant.growPercent = 0
    plant.budPercent = 0
    plant.N = 0 -- 1 N (+1) > 0.01 Tox
    plant.P = 0
    plant.K = 0
    plant.DeTox = 0 --charcoal,  eggshell, calcium
    plant.Toxicity = 0
    return plant
end

Citizen.CreateThread(function() -- detect time loop.
    while true do 
        Citizen.Wait(0)

    end
end)


RegisterServerEvent('fmwf:plantlist')
AddEventHandler('fmwf:plantlist', function()
    TriggerClientEvent('fmwf:plist', -1, Plants)
    TriggerClientEvent('fmwf:slist', -1, Seeds)
end)
RegisterServerEvent('fmwf:canhazplant')
AddEventHandler('fmwf:canhazplant', function(pCoords)
    local plant = CreatePlant(source, pCoords)
    table.insert(Plants, plant)
    TriggerClientEvent('fmwf:plist', -1, Plants)
end)

----------------------------------------------------

-- light level daytime level
-- water level
-- nutrient level
-- toxicity level
-- Skunk vs S.Skunk
-- environment is it in or outside