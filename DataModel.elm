module DataModel exposing (..)

import List exposing (repeat)


type alias Comment =
    { user : String
    , message : String
    }


type alias Photo =
    { user : String
    , location : String
    , likesCount : Int
    , commentsCount : Int
    , comments : List Comment
    , url : String
    }


examplePhoto : Photo
examplePhoto =
    { user = "qqrs"
    , location = "BK"
    , likesCount = 3
    , commentsCount = 2
    , comments = repeat 2 exampleComment
    , url = "b.gif"
    }


exampleComment : Comment
exampleComment =
    { user = "ZZZ"
    , message = "Wat"
    }


examplePhotos : List Photo
examplePhotos =
    [ examplePhoto
    , { examplePhoto | url = "pic1.jpg" }
    , { examplePhoto | url = "pic2.jpg" }
    , { examplePhoto | url = "pic3.jpg" }
    , { examplePhoto | url = "pic4.jpg" }
    , { examplePhoto | url = "pic5.jpg" }
    , { examplePhoto | url = "pic6.jpg" }
    ]
