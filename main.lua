-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end




function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2+w2 and
  x2 < x1+w1 and
  y1 < y2+h2 and
  y2 < y1+h1
end

local levels = {
  "The beginning",
  "Learn me to jump",
  "Make this a little more difficult"
}

local level = {}
level.pandouxStart = {}
level.guyStart = {}
level.buttonPos = {}
level.haveDoors = false
level.number = 1
level.background = 1

local currentLevel = 1

local imgTiles = {}
local background = {}

local map = {}

local lstSprites = {}

local mapHeight = 0
local mapWidth = 0

local tileWidth = 32;

local Pandoux = {}

local Guy = {}

local Button = {}

local Caisse1 = {}
local Caisse2 = {}
local Caisse3 = {}
--local Portes = {}

local MenuStart = {};
MenuStart.y = 0
MenuStart.x = 0
local MenuOptions = {};
MenuOptions.y = 0
MenuOptions.x = 0 
local Selecteur = {}
Selecteur.x = 0
Selecteur.y = 0
Selecteur.Options = 1

local Options = {}
toucheDroite = {}
toucheDroite.y = 0
toucheDroite.binding = "right"
toucheDroite.texte = "Aller à droite : "
toucheDroite.onEdit = false
toucheGauche = {}
toucheGauche.y = 0
toucheGauche.binding = "left"
toucheGauche.texte = "Aller à gauche : "
toucheGauche.onEdit = false
toucheSaut = {}
toucheSaut.y = 0
toucheSaut.binding = "space"
toucheSaut.texte = "Sauter : "
toucheSaut.onEdit = false
retour = {}
retour.y = 0
retour.texte = "Retour"

PositionOptions = {}



Button.pushed = false

function getTileAt(pX,pY)
  local col = math.floor(pX / tileWidth) + 1
  local lig = math.floor(pY / tileWidth) + 1
  if col > 0 and col <= mapWidth and lig > 0 and lig <= mapHeight then
    local id = string.sub(map[lig],col,col)
    return id
  end
  return 0
end

function ResetLevel()
  level = {}
  level.pandouxStart = {}
  level.guyStart = {}
  level.buttonPos = {}
  level.haveDoors = false
  
  lstSprites = {}
  
  Pandoux = {}
  Guy = {}
  Button = {}
  
  --Portes = {}
end

function ChargerImage()
  background[1] = love.graphics.newImage("images/BG/BG.png")
  background[2] = love.graphics.newImage("images/BG/BG.png")
  
  imgTiles["1"] = love.graphics.newImage("images/Tiles/1.png")
  imgTiles["2"] = love.graphics.newImage("images/Tiles/2.png")
  imgTiles["3"] = love.graphics.newImage("images/Tiles/3.png")
  imgTiles["a"] = love.graphics.newImage("images/Tiles/a.png")
  imgTiles["v"] = love.graphics.newImage("images/Tiles/v.png")
  imgTiles["m"] = love.graphics.newImage("images/Tiles/m.png")
  imgTiles[">"] = love.graphics.newImage("images/Object/tile-arrow-right.png")
    imgTiles["<"] = love.graphics.newImage("images/Object/tile-arrow-left.png")
  
  --imgTiles["B"] = love.graphics.newImage("images/Object/buttonRed.png")
  --imgTiles["E"] = love.graphics.newImage("images/Object/buttonRed_pressed.png")
end

function CreatrPnj(pCol,pLig)
  local myPnj = CreateSprite("Pnj", pCol,pLig)
  myPnj.AddAnimation("images/Personnages","walk",{"walk0","walk1","walk2","walk3","walk4","walk5"})
  myPnj.PlayAnimation("walk")
  myPnj.direction = "right"
end

function ChargerNiveau(pNum)
  ResetLevel()
  level.number = pNum
  map = {}
  local filename = "lvl/level_"..tostring(pNum)..".txt"
  for line in love.filesystem.lines(filename) do
    map[#map+1] = line
  end
  mapHeight = #map
  mapWidth = #map[1]
  level.background = 2
  local l = 1
  local c = 1
  for l=1, mapHeight do
    for c=1, mapWidth do
      local char = string.sub(map[l],c,c)
      if char == "P" then
        level.pandouxStart.x = (c -1)* tileWidth
        level.pandouxStart.y = (l -1) * tileWidth
      elseif char == "G" then
        level.guyStart.x = (c - 1) * tileWidth
        level.guyStart.y = (l - 1) * tileWidth
      elseif char == "B" then
          level.buttonPos.x = (c - 1) * tileWidth
          level.buttonPos.y = (l - 1) * tileWidth
      elseif char == "C" then
          level.haveDoors = true
          if level.Caisse1 == nil then
            level.Caisse1 = {}
            level.Caisse1.x = (c - 1) * tileWidth
            level.Caisse1.y = (l - 1) * tileWidth
            
          elseif level.Caisse2 == nil then
            level.Caisse2 = {}
            level.Caisse2.x = (c - 1) * tileWidth
            level.Caisse2.y = (l - 1) * tileWidth
          
        elseif level.Caisse3 == nil then
          level.Caisse3 = {}
          level.Caisse3.x = (c - 1) * tileWidth
          level.Caisse3.y = (l - 1) * tileWidth
        end
      elseif char == "@" then
        local enemies =  CreatrPnj((c-1) * tileWidth, (l-1) * tileWidth)
      end
    end
  end
  
  
    if level.haveDoors == true then
      --table.insert(Portes,CreateSprite("Caisse",level.Caisse1.x,level.Caisse1.y))
      --table.insert(Portes,CreateSprite("Caisse",level.Caisse2.x,level.Caisse2.y))
      --table.insert(Portes,CreateSprite("Caisse",level.Caisse3.x,level.Caisse3.y))
      Caisse1 = CreateSprite("Caisse",level.Caisse1.x,level.Caisse1.y,"caisse1")
      Caisse2 = CreateSprite("Caisse",level.Caisse2.x,level.Caisse2.y, "caisse2")
      Caisse3 = CreateSprite("Caisse",level.Caisse3.x,level.Caisse3.y, "caisse3")
      
    end
  
  Pandoux = CreateSprite("Pandoux",level.pandouxStart.x,level.pandouxStart.y,"Pandoux")
  Guy = CreateSprite("Guy",level.guyStart.x,level.guyStart.y,"Guy")
  Button = CreateSprite("buttonRed",level.buttonPos.x,level.buttonPos.y,"Button")
  
  
  Pandoux.AddAnimation("images/player","idle", {"idle1","idle2","idle3","idle4"})
  Pandoux.AddAnimation("images/player", "run",{"run1","run2","run3","run4","run5","run6","run7","run8","run9","run10"})
  Pandoux.PlayAnimation("idle")
  
  Guy.AddAnimation("images/Personnages","idle",{"Guy"})
  Guy.PlayAnimation("idle")
  Button.AddAnimation("images/Object","idle",{"buttonRed"})
  Button.AddAnimation("images/Object","pushed",{"buttonRed_pressed"})
  Button.PlayAnimation("idle")
  
  Pandoux.currentAnimation = "idle"
  Guy.currentAnimation = "idle"
  Button.currentAnimation = "idle"
  
end


function CreateSprite(pType, pX,pY,pName)
  local mySprite =  {}
  mySprite.x = pX
  mySprite.y = pY
  mySprite.vx = 0
  mySprite.vy = 0
  mySprite.type = pType
  mySprite.frame = 0
  mySprite.type = pType
  mySprite.flip = false
  mySprite.name = pName
  mySprite.currentAnimation = ""
  mySprite.animationSpeed = 1/8
  mySprite.animationTimer = mySprite.animationSpeed
  mySprite.animations = {}
  mySprite.images = {}
  mySprite.AddImages = function(psDir,plstImages)
    for k,v in pairs(plstImages) do
      local filename = psDir.."/"..v..".png"
      mySprite.images[v] = love.graphics.newImage(filename)
    end
  end
  
  mySprite.AddAnimation = function(psDir,psName,plstImages)
    mySprite.AddImages(psDir,plstImages)
    mySprite.animations[psName] = plstImages
  end
  
  mySprite.PlayAnimation = function(psName)
    if mySprite.currentAnimation ~= psName then
      mySprite.currentAnimation = psName
      mySprite.frame = 1
    end
  end
  
  if pType == "Pandoux" then
    mySprite.bJumpReady = true
    mySprite.jumpVelocity = -300
    mySprite.gravity = 500
    mySprite.accel = 500
    mySprite.standing = true
    mySprite.maxSpeed = 150
    mySprite.friction = 150
    mySprite.pushed = ""
    mySprite.estSurSprite = false
  elseif pType == "ennemie" then
    mySprite.direction = "right"
    mySprite.gravity = 500
  end
  
  mySprite.img = {}
  if pType == "Pandoux" or pType == "Guy" then
    mySprite.img[1] = love.graphics.newImage("images/Personnages/"..pType..".png")
  elseif pType == "buttonRed" then
    mySprite.img[1] = love.graphics.newImage("images/Object/"..pType..".png")
    mySprite.img[2] = love.graphics.newImage("images/Object/"..pType.."_pressed.png")
  elseif pType == "Caisse" then
    mySprite.img[1] = love.graphics.newImage("images/Object/"..pType..".png")
  end
  
  table.insert(lstSprites,mySprite)
  
  return mySprite
end

function InitGame(lvl)
  ChargerImage()
  if lvl == "Menu" then
    level.number = "Menu"
  elseif lvl == "Options" then
    level.number = "Options"
    Selecteur.Options = 1
    Selecteur.y = Options[1].y
  else
    ChargerNiveau(lvl)
    
    
  end
end

function IsInvisible(pId)
  if pId == ">" or pId == "<" then
    return true
  end
  return false
end

function isSolid(pID)
  if pID == "0" then return false end
  if pID == "1" then 
    return true 
  end

  if pID == "2" then 
    return true 
  end
  return false
end

function isJumpThrough(pId)
  if pId == "a" then
    return true
  end
end

function CollideBelow(pSprite)
  local id1 = getTileAt(pSprite.x - 1, pSprite.y + tileWidth)
  local id2 = getTileAt(pSprite.x + tileWidth -2,pSprite.y + tileWidth)
  if id1 == "a" or id2 == "a" then
    local o = "o"
  end
  if isSolid(id1) or isSolid(id2) then
    return true
  end
  if isJumpThrough(id1) or isJumpThrough(id2) then
    return true
  end
  
  return false
end

function CollideRight(pSprite)
  local id1 = getTileAt(pSprite.x + tileWidth, pSprite.y + 3)
  local id2 = getTileAt(pSprite.x + tileWidth, pSprite.y + 30)

  return isSolid(id1) or isSolid(id2)
end

function CollideLeft(pSprite)
  local id1 = getTileAt(pSprite.x -1, pSprite.y + 3)
  local id2 = getTileAt(pSprite.x - 1, pSprite.y + 30)
  return isSolid(id1) or isSolid(id2)
end

function CollideAbove(pSprite)
  local id1 = getTileAt(pSprite.x + 1, pSprite.y - 1 )
  local id2 = getTileAt(pSprite.x + 30, pSprite.y - 1)
  
  if isSolid(id1) or isSolid(id2) then
    return true
  end
end

function love.load()
  
  love.window.setMode(1024,768)
  
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  MenuStart.x = screen_width/3.5
  MenuStart.y = screen_height/2
  MenuOptions.x = screen_width/ 3.5
  MenuOptions.y = screen_height/1.5
  Selecteur.x = MenuStart.x - 20
  Selecteur.y = MenuStart.y
  
  
  toucheDroite.y = screen_height/5
  toucheGauche.y = screen_height/4
  toucheSaut.y = screen_height/3.5
  retour.y = screen_height/3
  
  PositionOptions[1] = toucheDroite.y
  PositionOptions[2] = toucheGauche.y
  PositionOptions[3] = toucheSaut.y
  PositionOptions[4] = retour.y
  
  
  Options[1] = toucheDroite
  Options[2] = toucheGauche
  Options[3] = toucheSaut
  Options[4] = retour
  
  level.background = 1
  
  InitGame("Menu")
  --CreerPandoux()
  --CreerGuy()
  
end

function UpdatePnj(pSprite,dt)
  --Tile behind the sprite
  local idOverlap = getTileAt(pSprite.x + tileWidth/2,pSprite.y + tileWidth-1)
  if idOverlap == ">" then
    pSprite.direction = "right"
    pSprite.flip = false
  elseif idOverlap == "<" then
    pSprite.direction = "left"
    pSprite.flip = true
  end
  
  if pSprite.direction == "right" then
    pSprite.vx = 25
  elseif pSprite.direction == "left" then
    pSprite.vx = -25
  end
  
end

function UpdatePlayer(pPlayer, dt)
  --Friction
  if pPlayer.vx > 0 then
    pPlayer.vx = pPlayer.vx - pPlayer.friction * dt
    if pPlayer.vx < 0 then
      pPlayer.vx = 0
    end
  end
  if pPlayer.vx < 0 then
    pPlayer.vx = pPlayer.vx + pPlayer.friction * dt
    if pPlayer.vx > 0 then
      pPlayer.vx = 0
    end
  end
  
  local newAnimation = "idle"
  
  --Keyboard
  --if love.keyboard.isDown("right") and pPlayer.pushed ~= "left" then
  if love.keyboard.isDown("right") then
    if pPlayer.pushed == "right" then
      pPlayer.vx = 100
    end
    if pPlayer.pushed == "left" and pPlayer.estSurSprite then
      pPlayer.vx = 100
    end

    pPlayer.vx = pPlayer.vx + pPlayer.accel * dt
    if pPlayer.vx > pPlayer.maxSpeed then
      pPlayer.vx =  pPlayer.maxSpeed
    end
    pPlayer.flip = false
    newAnimation = "run"
  end
  
  --if love.keyboard.isDown("left") and pPlayer.pushed ~= "right" then
  if love.keyboard.isDown("left") then
    if pPlayer.pushed == "left" then
      pPlayer.vx = -100
    end
    if pPlayer.pushed == "right" and pPlayer.estSurSprite then
      pPlayer.vx = -100
    end
    pPlayer.vx = pPlayer.vx - pPlayer.accel * dt
    if pPlayer.vx < -pPlayer.maxSpeed then
      pPlayer.vx = -pPlayer.maxSpeed
    end
    pPlayer.flip = true
    newAnimation = "run"
  end
  
  if love.keyboard.isDown("space") then
    if pPlayer.bJumpReady == true and pPlayer.standing == true then
      pPlayer.vy = pPlayer.jumpVelocity
      pPlayer.bJumpReady = false
      pPlayer.standing = false
      pPlayer.estSurSprite = false
    end
  end
  
  pPlayer.PlayAnimation(newAnimation)

  
end


function UpdateSprite(pSprite, dt)
  local oldX = pSprite.x
  local oldY = pSprite.y
  
  if pSprite.currentAnimation ~= "" then
    pSprite.animationTimer = pSprite.animationTimer - dt
    if pSprite.animationTimer <= 0 then
      pSprite.frame = pSprite.frame + 1
      pSprite.animationTimer = pSprite.animationSpeed
      local toast = #pSprite.animations[pSprite.currentAnimation]
      if pSprite.frame > #pSprite.animations[pSprite.currentAnimation] then
        pSprite.frame = 1
        end
    end
  end
  
  if pSprite.type == "Pandoux" then
    UpdatePlayer(pSprite, dt)
  elseif pSprite.type == "Pnj" then
    UpdatePnj(pSprite,dt)
  end
  
    --Move
  pSprite.x = pSprite.x + pSprite.vx * dt
  pSprite.y = pSprite.y + pSprite.vy * dt
  
  
  if pSprite.type == "Pandoux" then
    if pSprite.y > screen_height then
      pSprite.x = level.pandouxStart.x
      pSprite.y = level.pandouxStart.y
    end
  end
  
  
  --Collision detection
  local collide = false
  local collideBellow = false
    --En dessous
  if pSprite.standing or pSprite.vy > 0 then
    collideBellow = CollideBelow(pSprite)
    if collideBellow then
      pSprite.vy = 0
      local lig = math.floor((pSprite.y + 16) / 32) + 1
      pSprite.y = (lig-1)*32
      pSprite.standing = true
      pSprite.bJumpReady = true
    else
      if pSprite.gravity ~= 0 then
        pSprite.standing = false
      end
    end
  end
  
  --A droite
  if pSprite.vx > 0 then
    collide = CollideRight(pSprite)
  end
  --A gauche
  if pSprite.vx < 0 then
    collide = CollideLeft(pSprite)
  end
  
  if pSprite.x < 0 or pSprite.x + tileWidth > screen_width then
    collide = true
  end
  --Stop
  if collide then
    pSprite.vx = 0
    local col = math.floor((pSprite.x + 16) / 32) + 1
    pSprite.x = (col - 1)*32
  end
  --Au dessus
  if pSprite.vy < 0 then
    collide = CollideAbove(pSprite)
    if collide then
      if isJumpThrough then
        pSprite.vy = 0
        local lig = math.floor((pSprite.y + 16) / 32) + 1
        pSprite.y = (lig-1)*32
      end
    end
  end
  
  if pSprite.standing == false then
    pSprite.vy = pSprite.vy + pSprite.gravity * dt
    pSprite.estSurSprite = false
  end

  

if pSprite.type == "Caisse" then
  if Button.pushed then
    local i = 1
    for k, v in pairs(lstSprites) do
      if v == pSprite then
        break
      end
      i = i + 1
    end
    local toast = lstSprites[i].name
    lstSprites[i] = nil
    table.remove(lstSprites,i)
    print(#lstSprites)
    
  end
end

end

function AfficherEcranNiveau()
  level.background = 1
end

function TransitionNextLevel()
  level.number = "Tnext"
end

function NextLevel()
  currentLevel = currentLevel + 1
  if currentLevel > #levels then
    currentLevel = 1
  end
  ChargerNiveau(currentLevel)
end

function TombeSurEnnemi(ennemi)
  Pandoux.vy = 0
  Pandoux.y = ennemi.y - tileWidth
  Pandoux.standing = true
  Pandoux.bJumpReady = true
  Pandoux.estSurSprite = true
  if ennemi.direction == "right" then
    Pandoux.vx = 25
    Pandoux.pushed = "right"
  elseif ennemi.direction == "left" then
    Pandoux.vx = -25
    Pandoux.pushed = "left"
  end
end

function love.update(dt)
  
  if level.number == "Menu" then
    
    if love.keyboard.isDown("down") then
      Selecteur.y = MenuOptions.y
    end
    
    if love.keyboard.isDown("up") then
      Selecteur.y = MenuStart.y
    end
    
    if love.keyboard.isDown("return") and Selecteur.y == MenuStart.y then
      InitGame(1)
    end
    if love.keyboard.isDown("return") and Selecteur.y == MenuOptions.y then
      InitGame("Options")
    end
  elseif level.number == "Options" then
    if love.keyboard.isDown("down") then
      if Selecteur.Options == 4 then
        Selecteur.Options = 1
      else
        Selecteur.Options = Selecteur.Options + 1
      end
      local pos = Options[Selecteur.Options]
      Selecteur.y = pos.y
    end
    
    if love.keyboard.isDown("up") then
      if Selecteur.Options == 1 then
        Selecteur.Options = 4
      else
        Selecteur.Options = Selecteur.Options - 1
      end
      local pos = Options[Selecteur.Options]
      Selecteur.y = pos.y
    end
  
    if love.keyboard.isDown("return") then
      if Selecteur.Options == 4 then
        InitGame("Menu")
      elseif Selecteur.Options == 3 then
        toucheDroite.onEdit = true
        toucheDroite.binding = ""
      elseif Selecteur.Options == 2 then
        toucheGauche.onEdit = true
        tocuheGauche.binding = ""
      else 
        toucheSaut.onEdit = true
        toucheSaut.binding = ""
    end
  
  
    if toucheDroite.onEdit then
      toucheDroite.binding = love.keyreleased
      toucheDroite.onEdit = false
    elseif toucheGauche.onEdit then
      toucheGauche.binding = love.keyreleased
      toucheGauche.onEdit = false
    elseif toucheSaut.onEdit then
      toucheSaut.binding = love.keyreleased
      toucheSaut.onEdit = false
    end
  
  elseif level.number == "Tnext" then
    love.timer.sleep(3)
    NextLevel()
  else
    if #lstSprites > 0 then
      for k, mySprite in pairs(lstSprites) do
        UpdateSprite(mySprite,dt)
      end
      
      --Check collision with the player
      for nSprite=#lstSprites,1,-1 do
        local sprite = lstSprites[nSprite]
        if level.number == 2 then
          local b = sprite
        end
        if sprite ~= nil then
          if sprite.type ~= "Pandoux" then
            if CheckCollision(Pandoux.x,Pandoux.y,tileWidth,tileWidth,sprite.x,sprite.y,tileWidth,tileWidth) then
              if sprite.type == "Caisse" then
                Pandoux.vx = 0
                local col = math.floor((Pandoux.x + 16) / 32) + 1
                Pandoux.x = (col - 1)*32
              elseif sprite.type == "Guy" then
                TransitionNextLevel()
              elseif sprite.type == "buttonRed" then
                Button.pushed = true
                Button.currentAnimation = "pushed"
              elseif sprite.type == "Pnj" then
                --todo
                if Pandoux.y + tileWidth >= sprite.y and Pandoux.standing == false then
                  TombeSurEnnemi(sprite)
                else
                  if sprite.direction == "right" then
                    Pandoux.vx = 25
                    Pandoux.pushed = "right"
                  elseif sprite.direction == "left" then
                    Pandoux.vx = -25
                    Pandoux.pushed = "left"
                  end
                end
              end
            else
              Pandoux.pushed = ""
            end
          end
        end
      end
    end
  end
end


function OldDrawSprite(pSprite)
    if pSprite.type == "Pandoux" then
    love.graphics.draw(pSprite.img[1],pSprite.x,pSprite.y)
  elseif pSprite.type == "Guy" then
        love.graphics.draw(pSprite.img[1],pSprite.x,pSprite.y)
  elseif pSprite.type == "buttonRed" then
      local i = 1
      if Button.pushed then
        i = 2
      end
      love.graphics.draw(pSprite.img[i],pSprite.x,pSprite.y)
  
  elseif pSprite.type == "Caisse" then
    love.graphics.draw(pSprite.img[1],pSprite.x,pSprite.y)
  end
end

function DrawSprite(pSprite)
  local toast = pSprite.type
  if toast == "Caisse" then
    love.graphics.draw(pSprite.img[1],pSprite.x,pSprite.y)
  else
    local imgName = pSprite.animations[pSprite.currentAnimation][pSprite.frame]
    local img = pSprite.images[imgName]
    local halfw = img:getWidth() / 2
    local halfh = img:getHeight() / 2
    local flipCoef = 1
    if pSprite.flip then
      flipCoef = -1
    end
    love.graphics.draw(
      img, --image
      pSprite.x + halfw, --position horizontale
      pSprite.y + halfh, --position verticale
      0, --rotation
      1 * flipCoef, --horizontal scale
      1, --vertical scale (normal size = 1)
      halfw,halfh -- horizontale et verticale offset
      )
  end
end

function DrawTransition()
    love.graphics.clear()
    love.graphics.draw(background[level.background],0,0)
    local t = #levels
    love.graphics.print(levels[currentLevel + 1],screen_width/3.5,screen_height/2,0,2,2,0,0)
end

function love.draw()
  
  if level.number == "Menu" then
    love.graphics.draw(background[level.background],0,0)
    
    love.graphics.print("Commencer !",MenuStart.x,MenuStart.y,0,2,2,0,0)
    love.graphics.print("Options",MenuOptions.x,MenuOptions.y,0,2,2,0,0)
    
    love.graphics.print(">",Selecteur.x,Selecteur.y,0,2,2,0,0)
  
  elseif level.number == "Options" then
  
     --love.graphics.draw(background[level.background],0,0)
     
    love.graphics.print(toucheDroite.texte,screen_width/3.5,toucheDroite.y,0,2,2,0,0)
    love.graphics.print(toucheGauche.texte,screen_width/3.5,toucheGauche.y,0,2,2,0,0)
    love.graphics.print(toucheSaut.texte,screen_width/3.5,toucheSaut.y,0,2,2,0,0)
    love.graphics.print(retour.texte,screen_width/3.5,retour.y,0,2,2,0,0)
  
    love.graphics.print(toucheDroite.binding,screen_width/2 + 20,toucheDroite.y,0,2,2,0,0)
    love.graphics.print(toucheGauche.binding,screen_width/2 + 20,toucheGauche.y,0,2,2,0,0)
    love.graphics.print(toucheSaut.binding,screen_width/2 + 20,toucheSaut.y,0,2,2,0,0)
  
    love.graphics.print(">",Selecteur.x,Selecteur.y,0,2,2,0,0)
  elseif level.number == "Tnext" then
    DrawTransition()
  else
    
  --Affichage background
 love.graphics.draw(background[level.background],0,0)
  
  --Affichage de la map
  for ligne=1, mapHeight do
    for colonne = 1, mapWidth do
      local char = string.sub(map[ligne],colonne,colonne)
      if char ~= "0" and char ~= "P" and char ~= "G" and char ~= "B" and char ~= "C" and char ~= "@" and IsInvisible(char) == false then
        love.graphics.draw(imgTiles[char],(colonne - 1)*tileWidth,(ligne-1)*tileWidth)
      end
    end
  end
  
  for nSprite=#lstSprites,1, -1 do
    local sprite = lstSprites[nSprite]
    if sprite ~= nil then
      DrawSprite(sprite)
    end
  end
  
  --Afficher Pandoux
  --love.graphics.draw(Pandoux.img[1],Pandoux.x,Pandoux.y)
  
  --Afficher Guy
  --love.graphics.draw(Guy.img[1],Guy.x,Guy.y)

  love.graphics.print("x : "..love.mouse.getX().." y : "..love.mouse.getY(),0,0)
  --local toastX = love.mouse.getX()
  --local toastY = love.mouse.getY()

  --love.graphics.setColor(1,0,0)
  --local id = getTileAt(toastX,toastY)
  --local col = math.floor(toastX / tileWidth) + 1
  --local lig = math.floor(toastY / tileWidth) + 1
  --love.graphics.print("col : "..col.." lig : "..lig,0,0)
  --love.graphics.setColor(0,0,0)
  end
end

end


function love.keypressed(key)
  
  
end
  