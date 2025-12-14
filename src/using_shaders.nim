import kirpi
import math 

# shader declarations
var windShader:Shader
var waterShader:Shader
var waveShader:Shader
var parallaxShader:Shader

# texture declarations
var tree:Texture
var platform:Texture
var sky:Texture
var water:Texture
var fish:Texture
var moss:Texture

# variable for fish vertical position
var fishPosY:float=0

proc load() =
    # load textures
    tree=newTexture("src/resources/tree.png")
    platform=newTexture("src/resources/platform.png")
    water=newTexture("src/resources/water.png")
    moss=newTexture("src/resources/moss.png")
    fish=newTexture("src/resources/fish.png")
    sky=newTexture("src/resources/sky.png")

    # load shaders
    windShader=newShader("src/resources/shaders/wind_effect.vs.glsl","src/resources/shaders/wind_effect.fs.glsl")
    windShader.setValue("amount",50.0) # set wind strength
    
    waterShader=newShader("src/resources/shaders/water_effect.vs.glsl","src/resources/shaders/water_effect.fs.glsl")
    
    # load wave shader (fs only, using default vs)
    waveShader=newShader("","src/resources/shaders/wave_effect.fs.glsl")
    waveShader.setValue("amplitude",0.1) # set swing amount
    waveShader.setValue("frequency",20.0) # set wave density
    waveShader.setValue("speed",3.0) # set animation speed
    
    # load parallax shader (fs only)
    parallaxShader=newShader("","src/resources/shaders/parallax_effect.fs.glsl")
   

proc update( dt:float) =
    # update shader time uniforms
    # pass current time for animation
    windShader.setValue("time",getTime())
    waterShader.setValue("time",getTime())
    waveShader.setValue("time",getTime())
    parallaxShader.setValue("time",getTime())

    # calculate fish vertical sine wave movement
    fishPosY=sin( getTime()*0.4 )*16
    

proc draw() =
    clear( "#c7e1c0" ) # clear with background color
    setColor(White)

    # draw parallax sky
    setShader(parallaxShader) # use parallax shader
    draw(sky,0,60)
    setShader() # reset shader
    
    # draw wave effects (moss and fish)
    setShader(waveShader) # use wave shader
    draw(moss,400,500)
    draw(moss,600,550)
    # draw fish with vertical offset
    push()
    translate(0,fishPosY)
    draw(fish,500,500)
    pop()
    setShader() # reset shader
    
    # draw water surface
    setShader(waterShader)
    draw(water,250,440)
    setShader()

    # draw wind effect (tree)
    setShader(windShader)
    draw(tree,80,115) # tree sways
    setShader() 

    # draw static foreground
    draw(platform,-20,375)
    draw(platform,700,400)

#Run the game
run("Using Shaders",load,update,draw) # start the game