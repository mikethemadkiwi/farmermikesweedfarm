--player should be able to plant a plant by going to a location and selecting grow from seed.
--plant registers to server as item, gives genetics. updates to all other players.
--player should be able to leave server and return to plant.
--plant should be grown in timed stages.
--all players should be able to see plant blips once the plant has been seen, until it is gone.
---------------------------------
PlayerDb = {}
---------------------------------
weedObjs = {}
weedObjs.stage1 = {propHash = 452618762, propName = prop_weed_01}
weedObjs.stage2 = {propHash = -305885281, propName = prop_weed_02}
weedObjs.brick = {propHash = -1688127, propName = prop_weed_block_01}
weedObjs.pallet = {propHash = 243282660, propName = prop_weed_pallet}
weedObjs.bottle = {propHash = 671777952, propName = prop_weed_bottle}
--
MyPlants = {}
--
PlantList = {}
PlantObj = {}
MyPlantBlips = {}
PlantStrain = {}
FreeRangePlants = {}
---------------------------------
function CreateProp(model, pos)
    local plant = CreateObject(model.propHash, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(plant, 0) -- perhaps rando the heading between 0-359
    FreezeEntityPosition(plant, true)
end
--
drawOnScreen3D = function(coords, text, size)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords      = GetGameplayCamCoords()
    local aboveZ = coords.z + 1
    local dist           = GetDistanceBetweenCoords(camCoords.x, camCoords.y, camCoords.z, coords.x, coords.y, aboveZ, 1)
    local size           = size  
    if size == nil then
      size = 1
    end  
    local scale = (size / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov  
    if onScreen then  
      SetTextScale(0.0 * scale, 0.55 * scale)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry('STRING')
      SetTextCentre(1)  
      AddTextComponentString(text)  
      DrawText(x, y)
    end  
  end
---------------------------------
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('fmwf:plantlist')
            -- for j=1, #MyPlants do
            --     if MyPlants[j].Obj == nil then
            --         MyPlants[j].Obj = CreateObject(MyPlants[j].propHash, MyPlants[j].propPos.x, MyPlants[j].propPos.y, MyPlants[j].propPos.z, false, false, false)
            --         SetEntityHeading(MyPlants[j].Obj, 0) -- perhaps rando the heading between 0-359
            --         FreezeEntityPosition(MyPlants[j].Obj, true)
            --     end
            -- end
        break
        end
    end
end)
---------------------------------
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for j=1, #PlantList do
            DeleteObject(PlantObj[PlantList[j].plantid])        
        end
    end
end)
---------------------------------
-- Plant Growth
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            for j=1, #PlantList do
                if PlantObj[PlantList[j].plantid] ~= nil then
                    ---
                    local plantDistance = #(GetEntityCoords(PlayerPedId()) - PlantList[j].propPos)
                    if plantDistance < 2.5 then
                        -- local perc = 
                        local textpos = vector3(PlantList[j].propPos.x, PlantList[j].propPos.y, PlantList[j].propPos.z+1.25)
                        drawOnScreen3D(textpos, 'Cannabis ['..PlantList[j].pSrc..'-'..PlantList[j].plantid..'] '..PlantList[j].gender..' Growth: '..math.floor(PlantList[j].growPercent * 100)..'% Type: ['..PlantList[j].propHash..']', 0.5)
                    end
                    ---                    
                    if PlantList[j].growPercent <= 1.0 then
                        local newhieght = PlantList[j].propPos.z + 0.0001
                        PlantList[j].growPercent = PlantList[j].growPercent + 0.0001
                        PlantList[j].propPos = vector3(PlantList[j].propPos.x, PlantList[j].propPos.y, newhieght)
                    else

                    end
                    SetEntityCoords(PlantObj[PlantList[j].plantid], PlantList[j].propPos.x, PlantList[j].propPos.y, PlantList[j].propPos.z, false, false, false, true)
                    SetEntityHeading(PlantObj[PlantList[j].plantid], 0) -- perhaps rando the heading between 0-359
                    FreezeEntityPosition(PlantObj[PlantList[j].plantid], true)
                    ---
                end
            end	
        end
    end
end)

RegisterNetEvent('fmwf:plist')
AddEventHandler('fmwf:plist', function(plist)
    PlantList = plist
    for j=1, #plist do
        if PlantObj[plist[j].plantid] == nil then
            PlantObj[plist[j].plantid] = CreateObject(plist[j].propHash, plist[j].propPos.x, plist[j].propPos.y, plist[j].propPos.z, false, false, false)
            SetEntityHeading(PlantObj[plist[j].plantid], 0) -- perhaps rando the heading between 0-359
            FreezeEntityPosition(PlantObj[plist[j].plantid], true)
        end
    end
end)

RegisterNetEvent('fmwf:newplant')
AddEventHandler('fmwf:newplant', function(plant)
    table.insert(PlantList, plant)
    if PlantObj[plant.plantid] == nil then
        PlantObj[plant.plantid] = CreateObject(plant.propHash, plant.propPos.x, plant.propPos.y, plant.propPos.z, false, false, false)
        SetEntityHeading(PlantObj[plant.plantid], 0) -- perhaps rando the heading between 0-359
        FreezeEntityPosition(PlantObj[plant.plantid], true)
    end
end)


RegisterCommand('plantme', function(source, args) 
    local pCoords = GetEntityCoords(PlayerPedId())
    local didWork, groundZ  = GetGroundZFor_3dCoord(pCoords[1],pCoords[2],pCoords[3],0)
    local ugroundZ = groundZ - 1.0
    local posonground = vector3(pCoords[1],pCoords[2], ugroundZ)
   TriggerServerEvent('fmwf:canhazplant', posonground)
end,false)

-- Plant Blips
        -- playerBikeBlip = AddBlipForEntity(playerBike[1])
        -- SetBlipAsFriendly(playerBikeBlip, true)
        -- SetBlipSprite(playerBikeBlip, 226)
        -- SetBlipDisplay(playerBikeBlip, 4)
        -- SetBlipScale(playerBikeBlip, 0.8)
        -- SetBlipColour(playerBikeBlip, 4)
        -- SetBlipAsShortRange(playerBikeBlip, true)
        -- BeginTextCommandSetBlipName("STRING")
        -- AddTextComponentString("My Bike")
        -- EndTextCommandSetBlipName(playerBikeBlip)