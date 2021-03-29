# ParticlesPlus

ParticlesPlus V1

ParticlesPlus offers a (soon) variety of particles to easily create from presets. For example, creating an explosion is as easy as:

```lua
local myExplosion = PP.NewParticle("Explosion", {
    Position = Vector3.new(0, 0, 0);
    
    MinRadius = 5;
    
    MaxRadius = 20;
    
    Time = 5;
})

myExplosion:Fire()
```

The current presets available are:  

`Explosion`  

The API:  

Explosion
```
  Position [Vector3]; Position
  Color [Color3]; Color
  Transprency [num]; Transprency
  MinRadius [num]; Start Radius
  MaxRadius [num]; End Radius
  Time [num]; Explosion Expansion Time
  Ring [bool]; Creates a ring affect for things like an atomic bomb.
  Callback [function]; Callback when function is finished.
```
