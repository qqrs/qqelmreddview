module Main exposing (..)

import List exposing (map, repeat)
import Html exposing (beginnerProgram)
import Html exposing (Html, node, text, div, img)
import Html.Attributes exposing (class, src, rel, href)
import DataModel exposing (Comment, Photo, examplePhotos)


type Msg
    = ZZZ


type alias Model =
    { photos : List Photo
    , openedPhoto : Maybe Photo
    }


model : Model
model =
    { photos = examplePhotos
    , openedPhoto = Nothing
    }


view : Model -> Html Msg
view model =
    div []
        [ photoGrid model.photos
        , stylesheet "style.css"
        ]


photoGrid : List Photo -> Html Msg
photoGrid photos =
    photos |> map photoItem |> div [ class "photo-grid" ]


photoItem : Photo -> Html Msg
photoItem photo =
    div [ class "photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-user" ]
            [ text photo.user ]
        ]


update msg model =
    model


stylesheet url =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href url ] []


main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }
