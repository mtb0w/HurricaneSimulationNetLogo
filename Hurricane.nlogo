;Final Project
;Matt Bowman and John Paul Dyar
;Hurricane Survival Simulation

extensions [sound]

;1 patch is 1 mile
;1 tick is 1 minute

globals[flooder numba]

breed[human people]
breed[hurricane storm]

human-own [speed move-truth?]
hurricane-own [speed2]

to setup
  clear-all
  reset-ticks
  create-human hum-num-start [set color red]
  ask human [
    setxy (random 20 + random -40) random-ycor
    ifelse random 6 < 1
    [set move-truth? false]
    [ set move-truth? true]
  ]
  if category = 1 [
  create-hurricane 1000 [set color yellow]
  ask hurricane [
    setxy (20 + random 20) random-ycor
  ]
  ]
  if category = 2 [
  create-hurricane 1500 [set color yellow]
  ask hurricane [
    setxy (20 + random 20) random-ycor
  ]
  ]
  if category = 3 [
  create-hurricane 2000 [set color yellow]
  ask hurricane [
    setxy (20 + random 20) random-ycor
  ]
  ]
  if category = 4 [
  create-hurricane 2500 [set color yellow]
  ask hurricane [
    setxy (20 + random 20) random-ycor
  ]
  ]
  if category = 5 [
  create-hurricane 3000 [set color yellow]
  ask hurricane [
    setxy (20 + random 20) random-ycor
  ]
  ]
  setup-patches
end

to setup-patches
  ask patches [
    ifelse pxcor < 20
    [set pcolor green]
    [set pcolor blue]
  ]
  ask patches [
    if (pycor = 10 and pxcor <= 10 and pxcor >= -30 ) or (pycor = 30 and pxcor <= 10 and pxcor >= -30 ) or (pycor = -25 and pxcor <= 10 and pxcor >= -30 )[set pcolor black + 1]
    if pxcor = 10 or pxcor = -10 or pxcor = -30 [set pcolor black]

  ]
  ask patches [
    if pxcor < 20 and pycor < -5 and pycor > -7
    [set pcolor gray]]

end

to go
  ask patches [collision]
  ask human [move-human]
  ask human [move-human2]
  ask hurricane [move-hurricane]
  ask patches [flood]

  tick
  if count hurricane = 0 [stop]
  if survive = hum-num-start [stop]

end

;Move Humans to Road
to move-human
  if move-truth? [
  if pcolor = green [
    face min-one-of patches with [ pcolor = black + 1 ] [distance myself]
    forward speed]
  if pcolor = black + 1 [
    face min-one-of patches with [ pcolor = black] [distance myself]
    forward speed]
  if pcolor = black[
    face min-one-of patches with [ pcolor = gray] [distance myself]
    forward speed]]
  if pcolor = blue [die]

end

;Move humans on road
to move-human2
    if pcolor = gray [
    facexy -40 -6
    forward speed]
    ;if xcor <= -39 [die]
end

;Moves Hurricanes
to move-hurricane
  if ticks > Warning_Time * 60 [
  facexy -40 ycor
  if category = 1 [
    set speed2 1.4
    set flooder 1
    forward speed2]
  if category = 2 [
    set speed2 1.717
    set flooder 4
    forward speed2]
  if category = 3 [
    set speed2 2
    set flooder 7.
    forward speed2]
  if category = 4 [
    set speed2 2.383
    set flooder 12
    forward speed2]
  if category = 5 [
    set speed2 2.9
    set flooder 20
    forward speed2]
  ]
  if xcor <= -39 [die]
end

;slows down humans, simulates traffic
to collision
    ifelse count human-here > 1 [
    ask human-here
    [set speed 0.167]]
    ;.028 is 10 MPH
    [ask human-here [set speed 1]
      ;.167 is 60 MPH
    ]
end

to flood
  if count hurricane-here > 0 and pcolor = green[
    if random 100 < flooder [set pcolor blue]
  ]
  if count hurricane-here > 0 and pcolor = black[
    if random 100 < flooder [set pcolor blue]
  ]
  if count hurricane-here > 0 and pcolor = black + 1[
    if random 100 < flooder [set pcolor blue]
  ]
end


;report survivors who make it off of coast
to-report survive
  let number 0
  ask human [
    if xcor < -39
    [set number number + 1]]
  report number
end

to-report patch-color-blue
  let number 0
  ask patches [if pcolor = blue [ set number number + 1]]
  set number number - 1701
  set number number / 4860
  report number

end

to-report death
  let number hum-num-start - survive
  report number


end

to-report stay-behind
  let number 0
  if stay-behind = 0 [set number number + 1]
  report number
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
706
527
40
40
6.0
1
10
1
1
1
0
0
0
1
-40
40
-40
40
0
0
1
ticks
30.0

BUTTON
135
17
198
50
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
351
126
384
hum-num-start
hum-num-start
25
4550
2275
1
1
NIL
HORIZONTAL

BUTTON
137
65
200
98
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
5
308
126
341
category
category
1
5
5
1
1
NIL
HORIZONTAL

MONITOR
3
10
60
55
Escape
survive
17
1
11

SLIDER
3
267
136
300
Warning_Time
Warning_Time
0
36
33
1
1
NIL
HORIZONTAL

MONITOR
3
115
106
160
% Flooded
patch-color-blue
2
1
11

MONITOR
3
60
68
105
Impacted
death
0
1
11

@#$#@#$#@
## Hurricane ODD

Matt Bowman & John Paul Dyar
1/21/17
Toth
CSC 261

Purpose

This model is designed to explore the effects of hurricanes on a coastal region that is being evacuated. It examines the 5 hurricane categories and various warning times in advance to the hurricane reaching land. The simulation aims to examine what is a sufficient amount of warning time in advance to a hurricane making landfall to produce minimal direct hurricane impact on human life.

Entities, States, Variables

The model has 3 entities; humans, hurricane turtles, and patches. Since our grid is 81 x 81, we used a starting population of 2275 humans in each trial. This number was scaled according to the population of pre-katrina New Orleans. The human's own a variable called “move-truth?”, which will dictate whether or not they will flee the storm when an evacuation is issued or if they will ride out the storm. There is a 1 in 6 chance that any given individual will choose to ride out the storm, based off the data we found on Katrina. A slider-adjusted variable called “category” will allow the user to dictate the category of the storm, 1-5. Based on this, the program will determine how many hurricane turtles to create (which will produce more or less flooding) and the speed of the hurricane will be set, which is a variable owned by the hurricane. Finally, patches simply have a color. The land patches are green, grey, or black to signify neighborhoods and roads. They may become blue when the hurricane floods the patches.

Process Overview and Scheduling

The following actions are executed once per step:

Patches are checked for collision. If there are 2 or more humans on the same patch, the speed of the humans is reduced to the equivalent of 10mph. This is to replicate traffic. The default speed of a single human with no collision is 60mph, an open road.
The humans are asked to move. Move-human moves humans from their homes, to the street roads, where they will eventually contact the highway.
The humans are asked to move again, if they are on the highway. This procedure is simply for controlling interstate movement of the humans.
The hurricane is moved. If the tick count exceeds the warning time * 60 (each tick is a minute), then the hurricane begins to move at its assigned speed based on the category of the storm.
The flood procedure is called. When the hurricane comes in contact with a green, grey, or black patch, it has a random chance of flooding that patch. The global variable “flooder” is assigned when the category of the storm is selected in the setup procedure, and then used for random flooding. Since Katrina was a category 5 storm and approximately 70% of the land in New Orleans flooded, we calibrated our model accordingly.
The model stops execution when the hurricane is off the view or when everyone has successfully escaped (this only occurs if no one stays behind).

Design Concepts

The basic principle of this model is the indirect interaction between the human agents and hurricane agents via flooding. The leading cause of death in Katrina was flooding, and although we cannot measure precisely who does and doesn't dia because of flooding, we can measure who is directly affected by flooding. Adaptive Behavior occurs in our Agent Based Model when the human agents group up, as this reduces their speed, simulating traffic. Stochasticity is used to represent variability in both flooding and people who choose/forced to wait out the storm. To allow for observation, we have replicated a coast via patches and a grid system of roads.

Initilization

Our landscape is initialized with a hurricane cluster of hurricane agents and the 2275 human agents. The initial location of the humans is random within the coastal region, and the hurricane is concentrated on the sea.The category of storm is set upon initialization, which will determine the size and speed of the hurricane. However, the hurricane will not begin moving until the initial warning time, adjusted via slider, has expired.

Input data

Human population is assumed to be constant, but may be adjusted via slider. Hurricane inputs include the warning time before the hurricane moves and the category of the storm.

Submodels

Our submodel procedures are defined within the “Processes Overview and Scheduling” section of this ODD.

## CREDITS AND REFERENCES

matthew.bowman@centre.edu
john.dyar@centre.edu
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>count hurricane = 0</exitCondition>
    <metric>ticks</metric>
    <metric>survive</metric>
    <metric>death</metric>
    <steppedValueSet variable="hum-num-start" first="50" step="500" last="4550"/>
    <steppedValueSet variable="category" first="1" step="1" last="5"/>
    <steppedValueSet variable="wt" first="0" step="1" last="36"/>
  </experiment>
  <experiment name="Main" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>hurricane = 0</exitCondition>
    <metric>survive</metric>
    <metric>death</metric>
    <steppedValueSet variable="category" first="1" step="1" last="5"/>
    <steppedValueSet variable="Warning_Time" first="21" step="1" last="36"/>
    <enumeratedValueSet variable="hum-num-start">
      <value value="2275"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
