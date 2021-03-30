local ParticlesPlus = {}

local Presets = {}

local Internal = {
    Smoke = {};
}

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local HTTPS = game:GetService("HttpService")

local function shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local CreateWithData = function(self, data)
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
            error("Attempted to edit properties of particle object.", 2)
        end;
    })
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
    
    CreateWithData = CreateWithData;
    
}

Presets.Smoke = {
    Position = Vector3.new();
    Color = Color3.new(0.156863, 0.156863, 0.156863);
    Transparency = 0;
    SmokeSize = 2;
    SmokeBaseRadius = 3;
    Speed = 5;
    Density = 4;
    Callback = function() end;
    SmokeID = HTTPS:GenerateGUID();
    
    Start = function(self)
        if not Internal.Smoke[self.SmokeID] then
            Internal.Smoke[self.SmokeID] = {
                connection = nil;
                isEnabled = false;
            }
        end
        
        local Smoke = Instance.new("Folder")
        Smoke.Parent = folder
        
        local function spawnSmoke()
            
            local function r()
                return (math.random()-0.5) * self.SmokeBaseRadius * 2
            end    
            
            local smoke = Instance.new("Part")
            smoke.Shape = Enum.PartType.Ball
            smoke.Color = self.Color
            smoke.Transparency = self.Transparency
            smoke.Position = self.Position + Vector3.new(r(), 0, r())
            smoke.Material = Enum.Material.Pebble
            smoke.CanCollide = false
            smoke.Anchored = true
            
            local distance = (smoke.Position - self.Position).Magnitude
            
            smoke.Size = Vector3.new(self.SmokeSize, self.SmokeSize, self.SmokeSize) * math.min((1 / math.log(3 / distance, 2)), 1)
            smoke.Parent = Smoke
            
            
            DebrisService:AddItem(smoke, math.log(3 / distance, 2) + 0.1)
        end
        
        Internal.Smoke[self.SmokeID].isEnabled = true
        
        spawn(function()
            while wait() do
                if Internal.Smoke[self.SmokeID].isEnabled then
                    for i = 1, self.Density do
                        spawnSmoke()
                    end
                else
                    break
                end
            end
        end)
        
        if Internal.Smoke[self.SmokeID].connection then
            Internal.Smoke[self.SmokeID].connection:Disconnect()
        end
        
        Internal.Smoke[self.SmokeID].connection = RunService.Heartbeat:Connect(function(dt)
            for i, v in ipairs(Smoke:GetChildren()) do
                v.Position = v.Position + Vector3.new(0, dt*self.Speed, 0)
            end
        end)
        
    end;
    
    Stop = function(self)
        Internal.Smoke[self.SmokeID].isEnabled = false
        self.Callback()
    end;
    
    CreateWithData = CreateWithData;
}

ParticlesPlus.NewParticle = function(name, data)
    
    assert(Presets[name], "Invalid particle. Non-existant.")
    
    return Presets[name]:CreateWithData(data)
end

return ParticlesPlus
