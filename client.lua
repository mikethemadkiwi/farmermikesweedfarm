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
MyPlants = {
    {
        propHash = 452618762, 
        propPos = vector3(-595.756,-187.858, 35.806),
        growPercent = 0
    },    
    {
        propHash = -305885281, 
        propPos = vector3(-598.756,-189.858, 35.806),
        growPercent = 0
    }
}
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
            for j=1, #MyPlants do
                if MyPlants[j].Obj == nil then
                    MyPlants[j].Obj = CreateObject(MyPlants[j].propHash, MyPlants[j].propPos.x, MyPlants[j].propPos.y, MyPlants[j].propPos.z, false, false, false)
                    SetEntityHeading(MyPlants[j].Obj, 0) -- perhaps rando the heading between 0-359
                    FreezeEntityPosition(MyPlants[j].Obj, true)
                end
            end
        break
        end
    end
end)
---------------------------------
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for j=1, #MyPlants do
            DeleteObject(MyPlants[j].Obj)        
        end
    end
end)
---------------------------------
-- Plant Growth
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            for j=1, #MyPlants do
                if MyPlants[j].Obj ~= nil then
                    if MyPlants[j].growPercent <= 0.9999 then
                        local newhieght = MyPlants[j].propPos.z + 0.0001
                        MyPlants[j].growPercent = MyPlants[j].growPercent + 0.0001
                        MyPlants[j].propPos = vector3(MyPlants[j].propPos.x, MyPlants[j].propPos.y, newhieght)
                    end
                    SetEntityCoords(MyPlants[j].Obj, MyPlants[j].propPos.x, MyPlants[j].propPos.y, MyPlants[j].propPos.z, false, false, false, true)
                    SetEntityHeading(MyPlants[j].Obj, 0) -- perhaps rando the heading between 0-359
                    FreezeEntityPosition(MyPlants[j].Obj, true)

                    ---
                    local perc = Math.floor(MyPlants[j].growPercent * 100)
                    drawOnScreen3D(MyPlants[j].propPos, 'Growth: '..perc..'% Type: ['..MyPlants[j].propHash..']', 0.5)
                end
            end	
        end
    end
end)
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