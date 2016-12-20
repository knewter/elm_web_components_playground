module View.Home exposing (view)

import Html exposing (Html, text, div, node, h2, p, a)
import Html.Attributes exposing (attribute, style, class, href)
import Html.Events exposing (onClick)
import Msg exposing (Msg(NewUrl))
import Model exposing (Model)
import Polymer.Paper as Paper
import Markdown
import Routes exposing (Route(Login))


view : Model -> Html Msg
view model =
    Paper.card
        [ class "view-home"
        , attribute "heading" "Home"
        , attribute "elevation" "2"
        ]
        [ Markdown.toHtml
            [ class "card-content" ]
            bodyMarkdown
        , div
            [ class "card-actions" ]
            [ Paper.button
                [ onClick <| NewUrl Login ]
                [ text "Next" ]
            ]
        ]


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

### About DailyDrip

[![DailyDrip](static/dailydrip.png)](http://www.dailydrip.com)

This code is part of [Elm Drips](https://www.dailydrip.com/topics/elm/), a
daily continous learning website where you can just spend 5 minutes a day to
learn more about Elm (or other things!)
    """
