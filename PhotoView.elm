module PhotoView exposing (..)

import Maybe exposing (withDefault)
import List exposing (map)
import Types exposing (Msg, Photo, Comment, examplePhoto)
import Html exposing (beginnerProgram)
import Html exposing (Html, text, div, span, img)
import Html.Attributes exposing (class, src)


type alias Model =
    { photo : Maybe Photo }


model : Model
model =
    { photo = Just examplePhoto }


photoCommentView : Comment -> Html (Msg photo)
photoCommentView comment =
    div [ class "photo-comment" ]
        [ span [ class "comment-username" ]
            [ text comment.username ]
        , span [ class "comment-text" ]
            [ text comment.message ]
        ]


photoView : Photo -> Html (Msg photo)
photoView photo =
    let
        commentsList =
            map photoCommentView photo.comments
    in
        div [ class "photo" ]
            [ img [ src photo.url ] []
            , div [ class "photo-username" ]
                [ text photo.username ]
            , div [ class "photo-comments" ]
                commentsList
            ]


view : Model -> Html (Msg photo)
view model =
    case model.photo of
        Nothing ->
            div [ class "photo-view" ]
                [ text "No photo" ]

        Just photo ->
            div [ class "photo-view" ]
                [ photoView photo ]


update msg model =
    case msg of
        Types.LoadMoreComments ->
            model

        Types.OpenPhoto photo ->
            { model | photo = Just photo }

        Types.ClosePhoto ->
            { model | photo = Nothing }


main =
    beginnerProgram
        { model = model
        , view = view
        , update = update
        }
