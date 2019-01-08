import { app } from "hyperapp"
import { div, h1, h2, hr, ul, li } from "@hyperapp/html"
import { Link, Route, location } from "@hyperapp/router"

import Home from "./view/Home"
import About from "./view/About"
import TopicsView from "./view/TopicsView"

const state = {
  location: location.state
}

const actions = {
  location: location.actions
}

const view = state => (
  div({}, [
    ul({}, [
      li({}, [
        Link({ to: "/" }, "Home")
      ]),
      li({}, [
        Link({ to: "/about" }, "About")
      ]),
      li({}, [
        Link({ to: "/topics" }, "Topics")
      ])
    ]),
    hr({}),
    Route({ path: "/", render: Home }),
    Route({ path: "/about", render: About }),
    Route({ path: "/topics", render: TopicsView })
  ])
)

const main = app(state, actions, view, document.body)

const unsubscribe = location.subscribe(main.location)