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
    {propHash = 452618762, propPos = vector3(-595.756,-187.858, 36.806)},
    {propHash = -305885281, propPos = vector3(-598.756,-189.858, 36.806)}
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
-- Citizen.CreateThread(function()
--     while true do 
--         Citizen.Wait(0)
--         if NetworkIsPlayerActive(PlayerId()) then

	
--         end
--     end
-- end)
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