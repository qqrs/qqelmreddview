module Main exposing (..)

import List exposing (map, repeat, head)
import Maybe exposing (Maybe, withDefault)
import Html exposing (beginnerProgram)
import Html exposing (Html, node, text, div, span, img)
import Html.Attributes exposing (class, src, rel, href)
import Html.Events exposing (onClick)
import DataModel exposing (Comment, Photo, examplePhotos)


type Msg
    = CloseModal


type alias Model =
    { photos : List Photo
    , openedPhoto : Maybe Photo
    }


model : Model
model =
    { photos = examplePhotos

    --, openedPhoto = Nothing
    , openedPhoto = head examplePhotos
    }


view : Model -> Html Msg
view model =
    let
        modalHtml =
            model.openedPhoto |> Maybe.map photoModal |> maybeHtml
    in
        div []
            [ photoGrid model.photos
            , modalHtml
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


photoModal : Photo -> Html Msg
photoModal photo =
    div []
        [ div [ class "modal" ]
            [ div [ class "closebutton", onClick CloseModal ]
                [ text "×" ]
            , img [ src photo.url ] []
            , div [ class "modal-stats" ]
                [ text (photo.user ++ " / " ++ photo.location) ]
            , div [ class "modal-comments-container" ]
                (map modalComment photo.comments)
            ]
        , div [ class "shadowbox", onClick CloseModal ] []
        ]


modalComment : Comment -> Html Msg
modalComment comment =
    div [ class "modal-comment" ]
        [ span [ class "modal-comment-username" ] [ text comment.user ]
        , text comment.message
        ]


update msg model =
    case msg of
        CloseModal ->
            { model | openedPhoto = Nothing }


stylesheet url =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href url ] []


maybeHtml html =
    withDefault (text "") html


main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }
