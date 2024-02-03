-- Note That this script is not drag and drop you will have to put some stuff in here and there!

Citizen.CreateThread(function()
    local handlingData = "CHandlingData"
    
    local allVehicleModels = GetAllVehicleModels()
    
    for _, vehicleModel in ipairs(allVehicleModels) do
        local originalDurability = GetVehicleHandlingFloat(vehicleModel, handlingData)
        local newDurability = originalDurability * 0.5

        print(string.format("Handling has been loaded for %s with handlingData %s and new durability %f", GetDisplayNameFromVehicle(vehicleModel), handlingData, newDurability))

        -- You will have to add your own event here to check if the car is crashed or not!
        RegisterNetEvent("YOUR-EVENT")
        AddEventHandler("YOUR-EVENT", function(crashedVehicle)
            if crashedVehicle == vehicleModel then
                print(string.format("%s has crashed! Decreasing durability...", GetDisplayNameFromVehicle(vehicleModel)))
                newDurability = newDurability * 0.8 -- Adjust durability after a crash (you can customize this value)
                print(string.format("New durability for %s: %f", GetDisplayNameFromVehicle(vehicleModel), newDurability))
            end
        end)
    end
end)

--- This is check if vehicle is crashed or not
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if DoesEntityExist(vehicle) then
                local health = GetEntityHealth(vehicle)
                if health < 500 then
                    TriggerEvent("YOUR-EVENT", GetEntityModel(vehicle))
                    Citizen.Wait(5000) -- Wait for 5 seconds to prevent continuous triggering of the event
                end
            end
        end
    end
end)
