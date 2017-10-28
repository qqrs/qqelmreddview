module Types exposing (..)

import List exposing (repeat)


type alias Photo =
    { url : String
    , username : String
    , location : String
    , likeCount : Int
    , commentCount : Int
    , comments : List Comment
    }


type alias Comment =
    { username : String
    , message : String
    }


examplePhoto : Photo
examplePhoto =
    { username = "qqrs"
    , location = "BK"
    , likeCount = 3
    , commentCount = 2
    , comments = repeat 2 exampleComment
    , url = "b.gif"
    }


exampleComment : Comment
exampleComment =
    { username = "ZZZ"
    , message = "Wat"
    }


type Msg photo
    = OpenPhoto photo
    | ClosePhoto
    | LoadMoreComments
