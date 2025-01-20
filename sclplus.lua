-----  Math --



-- Powering, Rooting.

function Math.Square(n)
    return Math.Pow(n, 2)
end

function Math.Sqrt(n)
    return Math.Pow(n, 0.5)
end


function Math.Pow(n, to)
    return Math.Floor(n^to)
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
        local x = 1/256
        Scene.OverrideLights_old(r*x, g*x, b*x)
    else
        Scene.OverrideLights_old(r, g, b)
    end
end

Scene.CreateObject_old = Scene.CreateObject
function Scene.CreateObject(name, ident, parent, pos, alwaysActive, hide, scaling, disablePhysics, disableCollisions)

    local parent = parent or nil
    local pos = pos or {0,0,0}
    local alwaysActive = alwaysActive or false
    local hide = hide or false
    local scaling = scaling or 1
    local disablePhysics = disablePhysics or false
    local disableCollisions = disableCollisions or false

    local obj
    if parent == nil then
        obj = Scene.CreateObject_old(name, ident)
    else
        obj = Scene.CreateObject_old(name, ident, parent)
    end

    if type(pos) == "userdata" then
        obj:setPosition(pos)
    elseif type(pos) == "table" then
        obj:setPosition(Vector3.New(pos[1] or 0, pos[2] or 0, pos[3] or 0))
    end
    
    if disablePhysics then
        PhysicsObject.SetEnabled(obj, false)
    end
    
    if disableCollisions then
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

function Scene.EditObject(obj_handle, key, value)

    local obj
    if type(obj_handle) == "string" then
        obj = Scene.Find(obj_handle)
    elseif type(obj_handle) == "userdata" then
        obj = obj_handle
    end

    function keyIn(a, arr)
        for i,v in pairs(arr) do
            if a == v then
                return true
            end
        end
        return false
    end
    
    
    if keyIn(key, {"pos","position","vector","coordinate","coordinates"}) then
        if type(value) == "userdata" then
            obj:setPosition(value)
        elseif type(value) == "table" then
            obj:setPosition(Vector3.New(value[1] or 0, value[2] or 0, value[3] or 0))
        end
    end
    
    
    if keyIn(key, {"nocollision","zerocollision","disablecollision","disablecollisions","removecollisions"}) then
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
    b = b or nil
    if b == nil then
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
        return Math.RandomInt(1, 100) <= percent
    end
end




----- Threads --




Thread = {}

function Thread.Exists(name)
    n = "thr_"..tostring(name)
    return Scene.Find(n) ~= nil
end

function Thread.New(name, func, args)
    local name = tostring(name)
    local ident = name

    local n = 0
    while Thread.Exists("thr_"..ident) do
        n = n +1
        ident = name..tostring(n)
    end
    
    local thr = Scene.CreateObject("threadObj", "thr_"..ident)
    thr.args = args
    thr.func = func
    
    thr:setAlwaysActive(true)
end

function Thread.Terminate(name)
    local name = tostring(name)
    if Scene.Find("thr_"..name) then
        local thr = Scene.Find("thr_"..name)
        thr:setHidden(true)
        thr:destroy()
        return true -- Successful termination
    else
        return false -- Unsuccessful termination
    end
end


Thread.Create = Thread.New
Async = Thread.New
Thread.Kill = Thread.Terminate





----- Buttons --


Button = {}


function Button.New(name, text, func, args, pos, radius)

    local function button_func(args)

        local name, text, func, call_args, pos, radius =
            args[1], args[2], args[3], args[4],
            args[5] or Scene.Find("hero"):position()+Vector3.New(0,40),
            args[6] or 60

        local bubble = ShowTextBubble("_bb_"..name, pos, text)
        TextBubble.SetTouchHandlingEnabled(bubble, true)
        Touchable.SetTouchRadius(bubble, radius)

        while not TextBubble.IsTextFinished(bubble) do Program.Wait(0.05) end

        if call_args ~= nil then
            func(call_args)
        else
            func()
        end

        bubble:destroy()
    end

    Thread.New("_bb_thr", button_func, {name, text, func, args, pos, radius})

end

function Button.Menu(buttons, pos, radius)

    local function button_func(args)

        local name,    text,    func,    call_args, pos,     radius  =
              args[1], args[2], args[3], args[4],   args[5], args[6]

        local bubble = ShowTextBubble("_bb_"..name, pos, text)

        if func == nil then
            return
        end

        TextBubble.SetTouchHandlingEnabled(bubble, true)
        Touchable.SetTouchRadius(bubble, radius)

        while not TextBubble.IsTextFinished(bubble) do Program.Wait(0.05) end

        _bubble_refresh = true
        while _bubble_refresh do Program.Wait(0.05) end

        if call_args ~= nil then
            func(call_args)
        else
            func()
        end

    end



    _bubble_refresh = false
    _bubble_list = {}

    for name, details in pairs(buttons) do
        local text = details[1]
        if #text == 0 or text == nil then text = " " end
        Thread.New("_bb_thr"..name, button_func, {name, text, details[2], details[3], details[4]+pos, radius or 30})
        _bubble_list [#_bubble_list +1] = name
    end

    while not _bubble_refresh do Program.Wait(0.05) end
    _bubble_refresh = false

    
    for _, n in pairs(_bubble_list) do
        if Scene.Find("_bb_"..n.."_bubble") ~= nil then
            HideTextBubble("_bb_"..n)
        end
    end

end
