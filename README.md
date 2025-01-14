# SCL+
SCL+ or sclplus is a library for Swordigo which makes modding Swordigo easier!

## Usage

There are two ways to use sclplus.

1. Load it as an scl file. You can do this by just adding `sclplus.scl` and `hiro.scl` to your apk. You can also add only `sclplus.scl` and reference it in another scl file (`?dependancy : 'sclplus'`).
2. Copy and paste the contents of `sclplus.lua` into your lua chunk. Note that you won't be able to use threads this way.

## Math
The Math library in SP is an interesting library which adds several functions i.e:
1. Math.Pow(n, to)
2. Math.Sqrt(n)
3. Math.Floor(x,y)
4. Math.Ceil(x,y)
5. Math.Square(n)
   
These functions are pretty self explanatory.

## Scene
1. Scene.OverrideLights(r, g, b, conv)
conv is an optional field that converts normal RGB values to Swordigo values. For example, it will convert 255, 0, 0 to 1, 0, 0.
```lua
Scene.OverrideLights(255, 0, 0, true)
Scene.OverrideLights(1, 0, 0, false)
Scene.OverrideLights(1, 0, 0)
```

2. Scene.CreateObject
This function now accepts these fields: `name, ident, parent, pos, alwaysActive, hide, scaling, disablePhysics, disableCollisions`

3. Scene.EditObject
No documentation for this yet. The function is WIP.

## Thread
Thread is a **new** library added by SCL+, it allows for multithreading easily!

1. Thread.New(name, thread, argument)
Alias: Thread.Create
In this, `name` must be a string, `thread` must be a function and `argument` can be anything.
This function also returns back the new thread name it converted to.
Examples:
```lua
function myFunc()
    Game.ShowNotification("Hello, World!")
end

local thread = Thread.New("hello", myFunc)

```
> WARNING: If your thread name is similar to another thread name then the function will add a "1" to your thread name i.e. if a thread's name is "hello" then it'll get turned into "thr_hello1". Thread name can be optional in some cases. 

### Thread Parameters
Threads can pass data, and parameters of your choice. For example:
```lua
local self = ...

function myFunc(data)
    -- data is "self" here.
    Program.Wait(5)
    data:destroy()
end


Thread.New("destroyer", myFunc, self)
Game.ShowNotification("Destroying self in 5 seconds!")
```

2. Thread.Exists
Pass the name of a thread, and it will return true or false, depending if the thread object exists. Note that it will not tell you whether the code is actually running.

3. Thread.Terminate
Alias: Thread.Kill
Pass the name of a thread, and it will delete the thread object. Important to note: it will not stop the code from running.

## Random
The Random library is a library focused around randomness.
1. Random.Int(a, b)
Aliases: Random.Num, Random.Number

This function is pretty self explanatory.

2. Random.Float(a, b)
This function is pretty self explanatory.

3. Random.Text

Aliases: Random.Choice
Examples:
```lua
Game.ShowNotification(Random.Choice({"Hello","Hi"}))
-- This will print either Hello or Hi.
```

## Button
The Button library allows you to make clickable buttons using TextBubbles.
1. Button.New(name, text, func, args, pos, radius)
Arguments: name, text, func, args, pos, radius.
Example:
```lua
Button.New("cool_button", "Click Me!", function() --[[code to run]] end, nil, hero:position(), 50)
-- let's go through those one at a time

Button.New(
-- name: this isn't important, you just have to give each one a different name
"cool_button",

-- text: the button will show this text
"Click Me!",

-- func: the function that will run when the button is clicked
--       you can declare this in the function call, or beforehand
function() --[[code to run]] end,

-- args: the arguments that will be passed to the function
--       if you need to pass multiple args, use a table
--       if you don't need any args, pass nil
nil

-- pos: the position where the button will appear
--      if you don't pass a position it will default to Scene.Find("hero"):position()+Vector3.New(0,40)
hero:position(),

-- radius: the size of the touchable area of the button
--         the larger the radius, the easier it is to click
--         if you don't pass a radius it will default to 30
50

)

```
2. Button.Menu(buttons, pos, radius)
This function takes a list of buttons as one of the arguments. The buttons look like: [name] = {text, func, args, pos}.
Example:
```lua
local function create(type)   -- declaring my function ahead of the button list
    local obj = Scene.CreateObject(type, "")
    obj:setPosition(Scene.Find("hero"):position())
end

cool_menu = {   -- both these buttons call the same function, but with different arguments
    ["health"] = {"Spawn Health Orb", create, "nugget_health", Vector3.New(-50)},
    ["mana"]   = {"Spawn Mana Orb",   create, "nugget_mana",   Vector3.New(50)},
}


-- now we pass the button list to the function

Button.Menu(
    cool_menu,   -- the menu from before
    Scene.Find("hero"):position(),  -- the central position of the menu
                                    -- all the buttons will be positioned relative to this
    40   -- the radius for all the buttons
)
```
