module Components.ArticleShow exposing (..)

import Components.Article as Article
import Html exposing (..)
import Html.Attributes exposing (href)


type Msg
    = NoOp


view : Article.Model -> Html Msg
view article =
    div []
        [ h3 [] [ text article.title ]
        , a [ href article.url ] [ text ("URL: " ++ article.url) ]
        , br [] []
        , span []
            [ text
                ("Posted by: "
                    ++ article.postedBy
                    ++ " On: "
                    ++ article.postedOn
                )
            ]
        ]
