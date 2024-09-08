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
