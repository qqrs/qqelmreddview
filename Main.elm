module Main exposing (..)

import Debug exposing (log)
import List exposing (map, repeat, head, append)
import Maybe exposing (Maybe, withDefault)
import Html exposing (beginnerProgram)
import Html exposing (Html, node, text, div, span, img, button, input)
import Html.Attributes exposing (class, src, rel, href, placeholder, value)
import Html.Events exposing (onClick, onSubmit, onInput)
import DataModel exposing (Comment, Photo, addComment, examplePhotos, exampleComment)
import Json.Decode as Json


main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { photos : List Photo
    , openedPhoto : Maybe Photo
    , subredditInput : String
    }


model : Model
model =
    { photos = examplePhotos
    , openedPhoto = Nothing
    , subredditInput = "OldSchoolCool"
    }



-- UPDATE


type Msg
    = OpenPhoto Photo
    | ClosePhoto
    | LoadMoreComments
    | SubredditInputChange String
    | SubredditInputSubmit


update msg model =
    case msg of
        OpenPhoto photo ->
            { model | openedPhoto = Just photo }

        ClosePhoto ->
            { model | openedPhoto = Nothing }

        LoadMoreComments ->
            case model.openedPhoto of
                Nothing ->
                    model

                Just photo ->
                    { model | openedPhoto = Just (addComment exampleComment photo) }

        SubredditInputChange text ->
            { model | subredditInput = text }

        SubredditInputSubmit ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    let
        modalHtml =
            model.openedPhoto |> Maybe.map photoModal |> maybeHtml
    in
        div []
            [ searchHeader model.subredditInput
            , photoGrid model.photos
            , modalHtml
            , stylesheet "style.css"
            ]


searchHeader : String -> Html Msg
searchHeader subredditInput =
    div [ class "header" ]
        [ input
            [ placeholder "subreddit"
            , onInput SubredditInputChange
            , onSubmit SubredditInputSubmit
            , value subredditInput
            ]
            []
        ]


photoGrid : List Photo -> Html Msg
photoGrid photos =
    photos |> map photoItem |> div [ class "photo-grid" ]


photoItem : Photo -> Html Msg
photoItem photo =
    div [ class "photo" ]
        [ img [ src photo.url, onClick (OpenPhoto photo) ] []
        , div [ class "photo-user" ]
            [ text photo.user ]
        ]


photoModal : Photo -> Html Msg
photoModal photo =
    div []
        [ div [ class "modal" ]
            [ div [ class "closebutton", onClick ClosePhoto ]
                [ text "×" ]
            , img [ src photo.url ] []
            , div [ class "modal-stats" ]
                [ text (photo.user ++ " / " ++ photo.location) ]
            , div [ class "modal-comments-container" ]
                (photo.comments
                    |> map modalComment
                    |> append [ modalLoadMoreCommentsButton ]
                )
            ]
        , div [ class "shadowbox", onClick ClosePhoto ] []
        ]


modalComment : Comment -> Html Msg
modalComment comment =
    div [ class "modal-comment" ]
        [ span [ class "modal-comment-username" ] [ text comment.user ]
        , text comment.message
        ]


modalLoadMoreCommentsButton =
    button
        [ class "modal-comments-load-more"
        , onClick LoadMoreComments
        ]
        [ text "Load more..." ]



-- VIEW HELPERS


stylesheet url =
    Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href url ] []


maybeHtml html =
    withDefault (text "") html
