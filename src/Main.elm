module HomePage exposing (main)

import Document exposing (..)
import Browser 
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder , int , list ,string)



type alias Data = {
    query: String
    ,documents : List Dct
    ,score: Int
}


type alias Dct = {
        content: String
        ,meta : Meta
    }


type alias Meta = {
            internal_id : List String
            ,question : List String
            ,resource_type : List String
            ,language :List String
            ,access_rights :List String
            ,equivalent_to :List String
            ,url : List String
            ,tags_coverage : List String
            ,last_accessed_date : List String
            ,publisher : List String
            ,published_date : List String
            ,tags_topics : List String
                }    

dataDecoder : Decoder Data
dataDecoder  = 
        Decode.Succeed Data
        |>  required "query" string
        |>  required "documents" dctsDecoder

dctDecoder: Decoder Dct
dctDecoder = 
        Decode.Succeed Dct
        |> required "content" string
        |> required  "meta" metaDecoder
    

metaDecoder: Decoder Meta
metaDecoder = 
        Decode.Succed Dct
            |> "internal_id" (list string)
            |> "question" (list string)
            |> "resource_type" (list string)
            |> "language" (list string)
            |> "access_rights" (list string)
            |> "equivalent_to" (list string)
            |> "url" (list string)
            |> "tags_coverage" (list string)
            |> "last_accessed_date" (list string)
            |> "publisher" (list string)
            |> "published_date" (list string)
            |> "tags_topics"  (list string )






