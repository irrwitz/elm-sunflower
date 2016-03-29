module Main (..) where

import Color exposing (orange)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Html exposing (Html, Attribute, text, toElement, div, input)
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
max_d = 600
phi = (sqrt 5 + 1) / 2

drawAll seed =
  case seed of
    Ok seed -> List.map draw [0..seed]
    Err str -> List.map draw [0..1000]

draw i =
  let
    theta = i * tau / phi
    r = sqrt i * scale_factor
    x = r * cos theta
    y = r * sin theta
  in
    drawSeed x y

drawSeed x y =
  circle seed_radius |> filled orange |> move ( x, y )

view i =
  let
    evth = on "change" targetValue (Signal.message mbox.address)
  in
    div []
      [  Html.fromElement (collage 600 600 (drawAll (String.toFloat i)))
        , Html.label [] [Html.text "0"]
        , input
          [ type' "range"
          , Html.Attributes.min "1"
          , Html.Attributes.max "1000"
          , value i
          , evth
          ]
          []
      , Html.label [] [Html.text "1000"]
      , input [ type' "text", value i, evth ]
          []
      ]