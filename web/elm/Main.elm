module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Components.ArticleList as ArticleList


type Msg
    = ArticleListMsg ArticleList.Msg
    | UpdateView Page


type Page
    = RootView
    | ArticleListView


type alias Model =
    { articleListModel : ArticleList.Model
    , currentView : Page
    }


initialModel : Model
initialModel =
    { articleListModel = ArticleList.initialModel
    , currentView = RootView
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ArticleListMsg articleMsg ->
            let
                ( updatedModel, cmd ) =
                    ArticleList.update articleMsg model.articleListModel
            in
                ( { model | articleListModel = updatedModel }, Cmd.map ArticleListMsg cmd )

        UpdateView page ->
            let
                updatedPageModel =
                    { model | currentView = page }
            in
                case page of
                    ArticleListView ->
                        ( updatedPageModel, Cmd.map ArticleListMsg ArticleList.fetchArticles )

                    _ ->
                        ( updatedPageModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "elm-app" ] [ header, pageView model ]


pageView : Model -> Html Msg
pageView model =
    case model.currentView of
        RootView ->
            welcomeView

        ArticleListView ->
            articleListView model


welcomeView : Html Msg
welcomeView =
    h2 [] [ text "Welcome to Elm Articles!" ]


articleListView : Model -> Html Msg
articleListView model =
    App.map ArticleListMsg (ArticleList.view model.articleListModel)


header : Html Msg
header =
    div []
        [ h1 [] [ text "Elm Articles" ]
        , ul []
            [ li []
                [ a [ href "#", UpdateView RootView |> onClick ]
                    [ text "Home" ]
                ]
            , li []
                [ a [ href "#articles", UpdateView ArticleListView |> onClick ]
                    [ text "Articles" ]
                ]
            ]
        ]


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
