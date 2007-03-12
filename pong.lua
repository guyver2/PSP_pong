-- Jeu de pong (multijoueur pour le moment)

-- chargement des images
ImaFond = Image.load ("fond.png")
ImaBalle = Image.load("balle.png")
ImaRaquette = Image.load("raquette.png")


-- initialisation des constantes
HAUTEUR = 46
ACCEL = 1.1
LARGEUR = 8
BORD = 4
DIAMETRE = 7
RED = Color.new(255,0,0)
VITESSE = 4
MAX = 10.5

-- initialisation des variable
score = {j1=0, j2=0}
balle = {x=240, y=136, vitesse=3.7, angle=45}
j1 = {x=10, y=136, sens=0}
j2 = {x=230, y=136, sens=0}



-- fonction qui gere l'initialisation des variables
function initialisation()
 -- ajouter un rand
 local angle = math.pi/2
 while (angle < (math.pi/2 + math.pi/16) and angle > (math.pi/2 - math.pi/16))
    or (angle < (3*math.pi/4 + math.pi/16) and angle > (3*math.pi/4 - math.pi/16))
    or (angle < (math.pi + math.pi/16) and angle > (math.pi - math.pi/16))
    or (angle < (5*math.pi/4 + math.pi/16) and angle > (5*math.pi/4 - math.pi/16)) do
  math.randomseed(os.time())
  local dec =  math.random() * 360
  angle = 2*math.pi*dec/360
 end
 --score = {j1=0, j2=0}
 balle = {x=240, y=136, vitesse=3.5, angle=angle}
 j1 = {x=10, y=136, sens=0}
 j2 = {x=470, y=136, sens=0}
end

-- fonction qui gere l'affichage
function affichage()
 screen:clear()
 screen:blit(0,0,ImaFond)
 screen:blit(j1.x-(LARGEUR/2), j1.y-(HAUTEUR/2), ImaRaquette)
 screen:blit(j2.x-(LARGEUR/2), j2.y-(HAUTEUR/2), ImaRaquette)
 screen:blit(balle.x-(DIAMETRE/2), balle.y-(DIAMETRE/2), ImaBalle)
 -- partie pour le score
 screen:print(200, 10, "score : "..score.j1.." | "..score.j2, RED)
 screen:print(10,10, "v="..balle.vitesse.." a="..math.floor(100*balle.angle)/100, RED)
 screen.flip()
 screen.waitVblankStart()
end

-- pour savoir si on continue ou pas
function continuer()
 local pad = Controls.read()
 if pad:start() then
  return false
 else
  return true
 end
end



-- fait bouger la balle
function mvtBalle()
 -- deplacement
 balle.x = balle.x + math.cos((balle.angle))*balle.vitesse
 balle.y = balle.y + math.sin((balle.angle))*balle.vitesse
 -- colision avec les bord
 if (balle.y > (272 - BORD)) or (balle.y < BORD) then
  balle.angle = 2*math.pi - balle.angle
  balle.vitesse = balle.vitesse*ACCEL
  
 end
 -- colision avec les joueurs
  -- j1
 if (balle.x - DIAMETRE/2) < (j1.x + LARGEUR) and balle.x > j1.x then
  if balle.y < (j1.y + HAUTEUR/2) and balle.y > (j1.y - HAUTEUR/2) then
   balle.x = j1.x + LARGEUR + DIAMETRE/2
   balle.angle = math.pi - balle.angle
   balle.vitesse = balle.vitesse*ACCEL
  end
 end
   -- j2
 if (balle.x + DIAMETRE/2) > (j2.x - LARGEUR) and balle.x < j2.x then
  if balle.y < (j2.y + HAUTEUR/2) and balle.y > (j2.y - HAUTEUR/2) then
   balle.x = j2.x - LARGEUR - DIAMETRE/2
   balle.angle = math.pi - balle.angle
   balle.vitesse = balle.vitesse*ACCEL
  end
 end

 -- recadrage de l'angle
 if balle.angle > 2*math.pi then
  balle.angle = balle.angle - 2*math.pi
 elseif balle.angle < 0 then
  balle.angle = balle.angle + 2*math.pi
 end
 
 balle.vitesse = math.floor(100*balle.vitesse) / 100
 -- bornage de la vitesse
 if balle.vitesse > MAX then
  balle.vitesse = MAX
 end

 -- debordement
 if balle.x < 0 then
  score.j2 = score.j2 + 1
  initialisation()
 end
 if balle.x > 480 then
  score.j1 = score.j1 + 1
  initialisation()
 end


end


-- fait bouger les joueurs
function mouvement()
 local pad = Controls.read()
 -- joueur1
 if pad:up() then
  j1.y = j1.y - VITESSE
 end
 if pad:down() then
  j1.y = j1.y + VITESSE
 end
-- recadrage
 if (j1.y + BORD + HAUTEUR/2) > 272 then
  j1.y = 272 - (BORD + HAUTEUR/2)
 end
 if (j1.y - HAUTEUR/2) < BORD then
  j1.y = BORD + HAUTEUR/2
 end

 -- joueur2
 if pad:triangle() then
  j2.y = j2.y - VITESSE
 end
 if pad:cross() then
  j2.y = j2.y + VITESSE
 end
 -- recadrage
 if (j2.y + BORD + HAUTEUR/2) > 272 then
  j2.y = 272 - (BORD + HAUTEUR/2)
 end
 if (j2.y - HAUTEUR/2) < BORD then
  j2.y = BORD + HAUTEUR/2
 end

 --
   -- mvt de la balle
 --
 mvtBalle()
end


-- programme principal

initialisation()
while continuer() do
 affichage()
 mouvement()
end
