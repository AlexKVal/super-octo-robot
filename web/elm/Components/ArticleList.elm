module Components.ArticleList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List
import Components.Article as Article
import Http
import Task
import Json.Decode as Json exposing ((:=))
import Debug


type Msg
    = NoOp
    | Fetch
    | FetchSucceed (List Article.Model)
    | FetchFail Http.Error
    | RouteToNewPage SubPage


type SubPage
    = ListView
    | ShowView Article.Model


type alias Model =
    { articles : List Article.Model
    }


initialModel : Model
initialModel =
    { articles = [] }


articles : List Article.Model
articles =
    [ { title = "Article 1", url = "http://google.com", postedBy = "Author 1", postedOn = "07/07/16" }
    , { title = "Article 2", url = "http://google.com", postedBy = "Author 2", postedOn = "07/07/16" }
    , { title = "Article 3", url = "http://google.com", postedBy = "Author 3", postedOn = "07/07/16" }
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Fetch ->
            ( model, fetchArticles )

        FetchSucceed articleList ->
            ( Model articleList, Cmd.none )

        FetchFail error ->
            case error of
                Http.UnexpectedPayload errorMsg ->
                    Debug.log errorMsg
                        ( model, Cmd.none )

                _ ->
                    Debug.log "some other error"
                        ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


fetchArticles : Cmd Msg
fetchArticles =
    let
        url =
            "/api/articles"
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeArticleFetch url)


decodeArticleFetch : Json.Decoder (List Article.Model)
decodeArticleFetch =
    Json.at [ "data" ] decodeArticleList


decodeArticleList : Json.Decoder (List Article.Model)
decodeArticleList =
    Json.list decodeArticleData


decodeArticleData : Json.Decoder Article.Model
decodeArticleData =
    Json.object4 Article.Model
        ("title" := Json.string)
        ("url" := Json.string)
        ("posted_by" := Json.string)
        ("posted_on" := Json.string)


renderArticle : Article.Model -> Html Msg
renderArticle article =
    li []
        [ div [] [ Article.view article, articleLink article ] ]


articleLink : Article.Model -> Html Msg
articleLink article =
    a
        [ href ("#article/" ++ article.title ++ "/show")
        , ShowView article |> RouteToNewPage |> onClick
        ]
        [ text " (Show) " ]


renderArticles : Model -> List (Html Msg)
renderArticles model =
    List.map renderArticle model.articles


view : Model -> Html Msg
view model =
    div [ class "article-list" ]
        [ h2 [] [ text "Article List" ]
        , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Articles" ]
        , ul [] (renderArticles model)
        ]
