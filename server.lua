Seeds = {}
Plants = {}
plantid = 0
-----
function CreatePlant(pSrc, pCoords)
    local plant = {}
    local sex = math.random(0,1)
    if sex == 1 then
        plant.propHash = 452618762
        plant.gender = "female"
    else
        plant.propHash = -305885281
        plant.gender = "male"
    end
    plant.pSrc = pSrc
    plant.plantid = plantid
    plantid = plantid + 1 -- increase unique identifier for plants.
    plant.propPos = pCoords
    plant.genetics = {}
    plant.growthStage = 0
    plant.growPercent = 0
    plant.budPercent = 0
    -----
    plant.Nitrogen = 0 -- 1 N (+1) > 0.01 Tox
    plant.Phosphorus = 0
    plant.Potassium = 0
    plant.Calcium = 0
    plant.Oxidane = 0
    plant.Toxicity = 0
    --
    table.insert(Plants, plant)
    TriggerClientEvent('fmwf:newplant', -1, plant) 
end

Citizen.CreateThread(function() -- detect time loop.
    while true do 
        Citizen.Wait(0)
        for j=1, #Plants do
                ---                    
                if Plants[j].growPercent <= 1.0 then
                    local newhieght = Plants[j].propPos.z + growthRate
                    Plants[j].growPercent = Plants[j].growPercent + growthRate
                    Plants[j].propPos = vector3(Plants[j].propPos.x, Plants[j].propPos.y, newhieght)
                end
                ---
        end
    end
end)


RegisterServerEvent('fmwf:plantlist')
AddEventHandler('fmwf:plantlist', function()
    TriggerClientEvent('fmwf:plist', -1, Plants)
    TriggerClientEvent('fmwf:slist', -1, Seeds)
end)
RegisterServerEvent('fmwf:canhazplant')
AddEventHandler('fmwf:canhazplant', function(pCoords)
    CreatePlant(source, pCoords)
end)

----------------------------------------------------

-- light level daytime level
-- water level
-- nutrient level
-- toxicity level
-- Skunk vs S.Skunk
-- environment is it in or outside