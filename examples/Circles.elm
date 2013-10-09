module Circles where

import open D3
import D3.Color 
import Mouse

size   = 375
margin = { top = 25, left = 25, right = 25, bottom = 25 }
dims   = { height = size - margin.top - margin.bottom
         , width  = size - margin.left - margin.right }

type Dimensions = { height : number, width : number }
type Margins = { top : number, left : number, right : number, bottom : number }

svg : Dimensions -> Margins -> Selection a
svg ds ms =
  append "svg"
  |. num attr "height" (ds.height + ms.top + ms.bottom)
  |. num attr "width"  (ds.width  + ms.left + ms.right)
  |. append "g"
     |. str attr "transform" (translate margin.left margin.top)

-- Move the mouse to the left to right to remove or add circles. Move the mouse
-- up and down to change the brightness of the circles.
circles : Selection (number, number)
circles =
  selectAll "circle"
  |. bind (\(x, y) -> repeat (x `div` 50) y)
     --enter
     (append "circle"
     |. attr     "fill" color
     |. num attr "r"    0
     |. num attr "cy"   150
     |. attr     "cx"   (\_ i -> show (25 + 50 * i))
     |. transition
        |. num attr "r" 25)
     -- update
     (attr "fill" color)
     -- exit
     remove

color : number -> number -> String
color y i =
  let steelBlue = D3.Color.fromString "steelblue"
      magnitude = (2 * toFloat y / toFloat dims.height) ^ (toFloat i / 2)
    in D3.Color.toString (D3.Color.darker magnitude steelBlue)

translate : number -> number -> String
translate x y = "translate(" ++ (show x) ++ "," ++ (show y) ++ ")"

main : Signal Element
main = render dims.width dims.height (svg dims margin) circles <~ Mouse.position