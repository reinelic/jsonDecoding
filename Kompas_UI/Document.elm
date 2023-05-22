module Document exposing (..)

import Json.Decode as Decode exposing (Decoder , int , list ,string)
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (optional, optionalAt , required , requiredAt)


-- Encoding search query
type alias Query = {
                    query: String
                    }

queryEncoder: Query -> Encode.Value
queryEncoder query = 
    Encode.object
    [
        ("query" , Encode.string query.query)
    ]


-- Decoding JSON  Data

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
        Decode.succeed Data
        |>  required "query" string
        |>  required "documents" (list dctDecoder)
        |>  required "score" int

dctDecoder: Decoder Dct
dctDecoder = 
        Decode.succeed Dct
        |> required "content" string
        |> required  "meta" metaDecoder
    

metaDecoder: Decoder Meta
metaDecoder = 
        Decode.succeed Meta
            |> required "internal_id" (list string)
            |> required "question" (list string)
            |> required "resource_type" (list string)
            |> required "language" (list string)
            |> required "access_rights" (list string)
            |> required "equivalent_to" (list string)
            |> required "url" (list string)
            |> required "tags_coverage" (list string)
            |> required "last_accessed_date" (list string)
            |> required "publisher" (list string)
            |> required "published_date" (list string)
            |> required "tags_topics"  (list string )



