import { app } from "hyperapp"
import { div, header, nav, h1, h2, ul, li } from "@hyperapp/html"
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
    header({ class: "site-header" }, [
      nav({}, [
        Link({ to: "/" }, "Home"),
        Link({ to: "/about" }, "About"),
        Link({ to: "/topics" }, "Topics")
      ])
    ]),
    Route({ path: "/", render: Home }),
    Route({ path: "/about", render: About }),
    Route({ path: "/topics", render: TopicsView })
  ])
)

const main = app(state, actions, view, document.body)

const unsubscribe = location.subscribe(main.location)