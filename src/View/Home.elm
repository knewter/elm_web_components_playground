module View.Home exposing (view)

import Html exposing (Html, text, div, node, h2, p, a)
import Html.Attributes exposing (attribute, style, class, href)
import Html.Events exposing (onClick)
import Msg exposing (Msg)
import Model exposing (Model)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label)
import Markdown


view : Model -> Html Msg
view model =
    Paper.card
        [ style
            [ ( "padding", "1em" )
            , ( "width", "80%" )
            , ( "margin", "0 auto" )
            ]
        , attribute "heading" "Home"
        , attribute "elevation" "2"
        ]
        [ Markdown.toHtml [] bodyMarkdown ]


bodyMarkdown : String
bodyMarkdown =
    """
This is an example application from [DailyDrip](https://www.dailydrip.com)
showing off a more full-featured application combining [Elm](http://www.elm-lang.org)
and [Polymer](https://www.polymer-project.org/1.0/).

Explore the links on the left to see various examples.  I'd like this to
become a Kitchen-Sink style repo.  If you want to send a pull request
showing off some more Web Components, bring it on!

You can find [the source code here](http://github.com/knewter/elm_web_components_playground).

If you want to get started learning how to work with Elm and Polymer,
[I've written it up and recorded a screencast](https://www.dailydrip.com/topics/elm/drips/web-components-introduction).
    """
