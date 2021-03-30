# ParticlesPlus

ParticlesPlus V1

ParticlesPlus offers a (soon) variety of low poly particles to easily create from presets. For example, creating an explosion is as easy as:

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
`Smoke`  

The API:  

Explosion
```
  Position [Vector3]; Position
  Color [Color3]; Color
  Transparency [num]; Transparency
  MinRadius [num]; Start Radius
  MaxRadius [num]; End Radius
  Time [num]; Explosion Expansion Time
  Ring [bool]; Creates a ring affect for things like an atomic bomb.
  Callback [function]; Callback when explosion is finished.
  
  Fire() - Starts explosion.
```

Smoke
```
    Position [Vector3]; Position
    Color [Color3]; Color
    Transarency [num]; Transparency
    SmokeSize [num]; Size of each particle.
    SmokeBaseRadius [num]; Size of smoke width - affects height.
    Speed [num]; Speed of smoke.
    Density [int]; Density of smoke.
    Callback [function]; Callback when smoke is stopped.
    SmokeID [internal]; Internal Property for identification.
    
    Start - Starts Smoke.
    Stop - Stops Smoke.
```
