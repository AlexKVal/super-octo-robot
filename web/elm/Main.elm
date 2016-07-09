module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class)
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
            ( { model | currentView = page }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "elm-app" ] [ pageView model ]


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


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
