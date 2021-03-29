local ParticlesPlus = {}

local Presets = {}

local TweenService = game:GetService("TweenService")

local function shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local folder = Instance.new("Folder")
folder.Name = "Particles"
folder.Parent = workspace

Presets.Explosion = {
    Position = Vector3.new();
    Color = Color3.new(0.815686, 0.760784, 0.121569);
    Transparency = 0.5;
    MinRadius = 2;
    MaxRadius = 10;
    Time = 1;
    Ring = false;
    Callback = function() end;
    
    Fire = function(self)
        local Explosion = Instance.new("Part")
        Explosion.Shape = Enum.PartType.Ball
        Explosion.Color = self.Color
        Explosion.Size = Vector3.new(self.MinRadius, self.MinRadius, self.MinRadius)
        Explosion.Position = self.Position
        Explosion.Anchored = true
        Explosion.CanCollide = false
        Explosion.Transparency = self.Transparency
        Explosion.Material = Enum.Material.SmoothPlastic
        Explosion.Parent = folder
        
        local action = TweenService:Create(Explosion, TweenInfo.new(self.Time), {Size = Vector3.new(self.MaxRadius, self.MaxRadius, self.MaxRadius)})
        
        action:Play()
        
        action.Completed:Connect(function()
            local action2 = TweenService:Create(Explosion, TweenInfo.new(0.5), {Transparency = 1})
            
            action2:Play()
            
            action2.Completed:Connect(function()
                Explosion:Destroy()
                
                self.Callback()
            end)
        end)
        
    end;
    
    CreateWithData = function(self, data)
        local particle = shallowCopy(self)
        
        particle.CreateWithData = nil
        
        for k, v in ipairs(data) do
            particle[k] = v
        end
        
        local returnParticle = newproxy(true)
        
        return setmetatable(getmetatable(returnParticle), {
            __metatable = {};
            
            __index = particle;
            
            __newindex = function()
                error("Attempted to edit properties of particle object.")
            end;
        })
    end;
    
}

ParticlesPlus.NewParticle = function(name, data)
    
    assert(Presets[name], "Invalid particle. Non-existant.")
    
    return Presets[name]:CreateWithData(data)
end

return ParticlesPlus
