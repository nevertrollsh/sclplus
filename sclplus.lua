-----  Math --



-- Powering, Rooting.

function Math.Square(n)
    return Math.Pow(n, 2)
end

function Math.Sqrt(n)
    return Math.Pow(n, 0.5)
end


function Math.Pow(n, to)
    lol = n^to
    
    return Math.Floor( result )
end

Math.Power = Math.Pow

-- Rounding

function Math.Floor(x,y)
    y = y or 1
    return x - (x%y)
end

function Math.Ceil(x,y)
    y = y or 1
    if x%y==0 then
        return x
    else
        return (x+1)-(x%y)
    end
end




-----  Scene --



function Scene.IsWithin(v1, v2, radius)
    abs=Math.Abs
    return
    abs(v1:x() - v2:x()) < radius
    and
    abs(v1:y() - v2:y()) < radius
end
Scene.InRange = Scene.IsWithin

Scene.OverrideLights_old = Scene.OverrideLights
function Scene.OverrideLights(r, g, b, conv)
    if conv then
        local x = 1/255
        Scene.OverrideLights_old(r*x, g*x, b*x)
    else
        Scene.OverrideLights_old(r, g, b)
    end
end

Scene.CreateObject_old = Scene.CreateObject
function Scene.CreateObject(name, ident, parent, pos, alwaysActive, hide, scaling, disablePhysics, disableCollisions)
    local obj = Scene.CreateObject(name, ident, parent)
    if type(pos) == "userdata" then
        obj:setPosition(pos)
    elseif type(pos) == "table" then
        obj:setPosition(Vector3.New(pos[1] or 0, pos[2] or 0, pos[3] or 0))
    end
    
    if disablePhysics == true then
        PhysicsObject.SetEnabled(obj, false)
    end
    
    if disableCollisions == true then
        CollisionShape.DisableAll(obj)
    end
    
    if hide then
        obj:setHidden(true)
    end
    
    if type(scaling) == "number" then
        obj:setScaling(scaling)
    end
    
    return obj
end
Scene.Create = Scene.CreateObject

function Scene.EditObject(obj, key, value)
    
    function keyIn(a, arr)
        for i,v in pairs(arr) do
            if a == v then
                return true
            break
            end
        end
        
        return false
    end
    
    
    if keyIn(key, {"pos","position","vector","coordinate","coordinates"}) then
        if type(value) == "userdata" then
            obj:setPosition(value)
        elseif type(value) == "table" then
            obj:setPosition(value[1] or 0, value[2] or 0, value[3] or 0)
        end
    end
    
    
    if keyIn(key, {"nocollision","zerocollision","disablecollision","disablecollisions","removecollisions"} then
        if value == false then
            for i = 1, 200 do
                CollisionShape.SetEnabled(obj, i, true)
            end
        else
            CollisionShape.DisableAll(obj)
        end
    end
    
    if keyIn(key, {"nophysics","disablephysics","removephysics"}) then
        if value == false then
            PhysicsObject.SetEnabled(obj, true)
        else
            PhysicsObject.SetEnabled(obj, false)
        end
    end
    
    
    return obj
end
Scene.Edit = Scene.EditObject




----- Random --



Random = {}

function Random.Int(a, b)
    if not b then
        return Math.RandomInt(1, a)
    else
        return Math.RandomInt(a, b)
    end
end

Random.Num = Random.Int
Random.Number = Random.Int

function Random.Float(a, b)
    if not b then
        return Math.RandomFloat(1.0, a)
    else
        return Math.RandomFloat(a, b)
    end
end

function Random.Text(...)
    local arr = {...}
    if type(arr[1]) == "table" then
        newarr = arr[1]
        return newarr[Random.Int(1, #newarr)]
    else
        return arr[Random.Int(1, #newarr)]
    end
end

Random.Choice = Random.Text


function Random.Chance(percent)
    if percent < 0 or percent > 100 then
        Game.ShowNotification("err, percentage invalid!")
        return false
    else
        return math.random(1, 100) <= percent
    end
end
