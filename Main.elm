module Main exposing (..)

import Types exposing (Msg, Photo, Comment, examplePhoto)
import PhotoView exposing (photoView)
import List exposing (map, repeat)
import Html exposing (beginnerProgram)
import Html exposing (Html, node, text, div, img)
import Html.Attributes exposing (class, src, rel, href)


type alias Model =
    { photos : List Photo }


model : Model
model =
    { photos = repeat 3 examplePhoto }


photoGridView : List Photo -> Html (Msg photo)
photoGridView photos =
    div [ class "photo-grid" ]
        (map photoView photos)


view : Model -> Html (Msg photo)
view model =
    div []
        [ photoGridView model.photos
        , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
        ]


update msg model =
    case msg of
        Types.LoadMoreComments ->
            model

        Types.OpenPhoto photo ->
            --{ model | photoOpened = photo }
            model

        Types.ClosePhoto ->
            --{ model | photoOpened = Nothing }
            model


main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }
