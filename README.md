# SCL+
SCL+ or sclplus is a library for Swordigo which makes modding Swordigo easier!

## Math
The Math library in SP is an interesting libary which adds several functions i.e:
1. Math.Pow(n, to)
2. Math.Sqrt(n)
3. Math.Floor(x,y)
4. Math.Ceil(x,y)
5. Math.Square(n)
   
These functions are pretty self explanatory.

## Scene
1. Scene.OverrideLights(r, g, b, conv)
conv is an optional field that converts normal RGB values to Swordigo values. For example, it will convert 255, 0, 0 to 1, 0, 0.
```js
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

1. Thread.New(name, thread)
In this, `name` must be a string, and `thread` must be a function.
This function also returns back the new thread name it converted to.
Examples:
```js
function myFunc()
    Game.ShowNotification("Hello, World!")
end

local thread = Thread.New("hello", myFunc)

```
> WARNING: If your thread name is similar to another thread name then the function will add a "1" to your thread name i.e. if a thread's name is "hello" then it'll get turned into "thr_hello1". Thread name can be optional in some cases. 
> Well, it doesn't really matter much because thread names are pretty much useless.

### Thread Parameters
Threads can pass data, and parameters of your choice. For example:
```lua
local self = ...;

function myFunc(threadname, data)
    -- data is "self" here.
    Program.Wait(5)
    data:destroy()
end


Thread.New("destroyer", myFunc)
Game.ShowNotification("Destroying self in 5 seconds!")
```

## Random
The Random library is a library focused around randomness.
1. Random.Int(a, b)

Aliases: Random.Num, Random.Number

3. Random.Float(a, b)

**These are pretty self explanatory.**

5. Random.Text

Aliases: Random.Choice
Examples:
```lua
Game.ShowNotification(Random.Choice({"Hello","Hi"}))
-- This will print either Hello, or Hi.
```
