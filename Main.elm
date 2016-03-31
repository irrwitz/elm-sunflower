module Main (..) where

import Color exposing (orange)
import Graphics.Collage exposing (..)
import Html exposing (Html, Attribute, text, fromElement, div, input, label, span, h2)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import String exposing (toFloat)


mbox =
  Signal.mailbox "500"

main =
  Signal.map view mbox.signal

seed_radius = 2
scale_factor = 4
tau = pi * 2
max_d = 300
phi = (sqrt 5 + 1) / 2

drawAll seed =
  case seed of
    Ok seed -> List.map draw [1..seed]
    Err str -> List.map draw [1..500]

draw i =
  let
    theta = i * tau / phi
    r = sqrt i * scale_factor
    x = r * cos theta
    y = r * sin theta
  in
    drawSeed x y

drawSeed x y =
  circle seed_radius
  |> filled orange
  |> move ( x, y )

view seed =
  let
    canvas = fromElement (collage 300 300 (drawAll (String.toFloat seed)))
  in
    div [ style [ ("width", "300px"), ("margin", "0 auto") ] ]
      [ h2 [] [ Html.text "Dr. Fibonacci's Sunflower Spectacular"]
      , canvas
      , div [ style [ ("text-align", "center") ] ]
         [ label [] [ Html.text "1" ]
         , input
           [ style [ ("vertical-align", "middle") ]
           , type' "range"
           , Html.Attributes.min "1"
           , Html.Attributes.max "1000"
           , value seed
           , on "change" targetValue (Signal.message mbox.address)
           ]
            []
           , label [] [ Html.text " 1000" ]
         ]
      , div [ style [ ("text-align", "center"), ("padding-top", "8px"), ("display", "block") ] ]
          [ span [] [ Html.text seed ] ]
      ]