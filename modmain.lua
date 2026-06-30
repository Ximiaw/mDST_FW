AddPrefabPostInit("tentaclespike", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    if inst.components.finiteuses then
        inst:RemoveComponent("finiteuses")
    end
end)
