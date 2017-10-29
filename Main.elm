module Main exposing (..)

import List exposing (map, filterMap, append)
import String exposing (endsWith)
import Maybe exposing (Maybe, withDefault)
import Html exposing (Html, node, text, div, span, img, form, button, input)
import Html.Attributes exposing (class, src, rel, href, placeholder, value)
import Html.Events exposing (onClick, onSubmit, onInput)
import Http
import Json.Decode as Decode
import DataModel exposing (Comment, Photo, addComment, examplePhoto, examplePhotos, exampleComment)


main =
    Html.program
        { init = init ""
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { photos : List Photo
    , openedPhoto : Maybe Photo
    , subredditInput : String
    }


init : String -> ( Model, Cmd Msg )
init subreddit =
    ( Model examplePhotos Nothing subreddit
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = OpenPhoto Photo
    | ClosePhoto
    | LoadMoreComments
    | SubredditInputChange String
    | SubredditInputSubmit
    | GiphyResponse (Result Http.Error String)
    | RedditResponse (Result Http.Error (List String))


update msg model =
    case msg of
        OpenPhoto photo ->
            ( { model | openedPhoto = Just photo }
            , Cmd.none
            )

        ClosePhoto ->
            ( { model | openedPhoto = Nothing }
            , Cmd.none
            )

        LoadMoreComments ->
            case model.openedPhoto of
                Nothing ->
                    ( model, Cmd.none )

                Just photo ->
                    ( { model | openedPhoto = Just (addComment exampleComment photo) }
                    , Cmd.none
                    )

        SubredditInputChange text ->
            ( { model | subredditInput = text }, Cmd.none )

        SubredditInputSubmit ->
            ( model, getRedditPosts model.subredditInput )

        GiphyResponse _ ->
            ( model, Cmd.none )

        RedditResponse (Err err) ->
            ( model, Cmd.none )

        RedditResponse (Ok urls) ->
            let
                photos =
                    getPhotosFromRedditResponse urls
            in
                ( { model | photos = photos }, Cmd.none )



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
        [ form [ onSubmit SubredditInputSubmit ]
            [ input
                [ placeholder "subreddit"
                , onInput SubredditInputChange
                , value subredditInput
                ]
                []
            ]
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



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Http.send GiphyResponse (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string


getRedditPosts : String -> Cmd Msg
getRedditPosts subreddit =
    let
        url =
            "https://www.reddit.com/r/" ++ subreddit ++ ".json"
    in
        Http.send RedditResponse (Http.get url decodeRedditResponse)


decodeRedditResponse : Decode.Decoder (List String)
decodeRedditResponse =
    Decode.at [ "data", "children" ] (Decode.list (Decode.at [ "data", "url" ] Decode.string))



-- HTTP RESPONSE HANDLERS


getPhotosFromRedditResponse : List String -> List Photo
getPhotosFromRedditResponse urls =
    filterMap getPhotoFromRedditUrl urls


getPhotoFromRedditUrl url =
    if endsWith ".jpg" url then
        Just { examplePhoto | url = url }
    else
        Nothing
