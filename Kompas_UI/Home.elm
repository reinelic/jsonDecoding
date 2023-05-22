module Home exposing (main)

import Browser
import RemoteData exposing (RemoteData , WebData)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Document exposing (..)




type alias Model = {
                    data :  WebData Data
                    ,search : Query
                    
                    }


type Msg 
        = SearchData
          |DataReceived  (WebData Data)
          |UpdateQuery String



initialModel: Model
initialModel = {
                data = RemoteData.NotAsked
                ,search = {
                    query= ""
                }
                }


init : () -> (Model ,Cmd Msg)
init _ = 
        (initialModel,Cmd.none)


searchData : Query -> Cmd Msg
searchData query = 
    Http.post {
        url ="https://moisil.translatorswb.org/yasno/search/document_search"
        ,body = Http.jsonBody (queryEncoder query)
        ,expect = 
            dataDecoder
            |> Http.expectJson ( RemoteData.fromResult >> DataReceived)
    }        


update : Msg -> Model -> ( Model , Cmd Msg)
update msg model  = 
            case msg of 
                DataReceived  response ->
                    ( model , Cmd.none)
                                    

                SearchData ->
                    (model , searchData model.search)

                UpdateQuery query ->

                    let  
                        oldSearch = model.search
                        newSearch = { oldSearch | query = query}

        

                    in 
                    (
                        {model | search = newSearch} 
                    , Cmd.none)


view: Model -> Html Msg
view model =
        div[]
        [
          searchView model.search
          ,viewDataorError model


        ]

viewDataorError: Model -> Html Msg
viewDataorError model =
    case model.data of
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            h3 [] [ text "Hang on loading ..."]
        RemoteData.Success data ->
            viewData  data
        RemoteData.Failure httpError ->
            viewError (buildError httpError)


viewData: Data -> Html Msg
viewData data =
    div [] [
        text "Data has been successfully fetched"
    ]

viewError: String -> Html Msg
viewError errorMessage =
    let
        error = " Failed to fetch the data"
    in 
        div[]
        [
            h3 [] [text error]
            ,text ("Error: " ++ errorMessage)
        ]


buildError : Http.Error -> String
buildError httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


searchView : Query -> Html Msg
searchView  search =
        Html.form[]
        [
            div[]
            [
                text "Search By query"
                ,br [][]
                ,input
                 [
                    type_ " text"
                    ,value search.query
                    ,onInput UpdateQuery
                 ]
                 []

            ]
            ,br[][]
            ,div[]
             [
            button [type_ "button" , onClick SearchData] [ text " Search  Data"]
             ]
        ]


main: Program () Model Msg
main = Browser.element{
                    init = init
                    ,view = view
                    ,update = update
                    ,subscriptions = \_ ->Sub.none
            }