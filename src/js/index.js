import axios from "axios"
import frontMatter from "front-matter"

// Hyperapp
import { app } from "hyperapp"
import { div, header, nav } from "@hyperapp/html"
import { Link, Route, location } from "@hyperapp/router"

// view
import Home from "./view/Home"
import About from "./view/About"
import TopicsView from "./view/TopicsView"
import Article from "./view/Article"

const state = {
  location: location.state,
  currentArticle: {
    attributes: {},
    body: ""
  }
}

const actions = {
  location: location.actions,
  refreshCurrentArticle: article => state => ({ currentArticle: article }),
  refresh: (topicId) => async (state, actions) => {
    const path = `../md/${ topicId }.md`
    const response = await axios.get(path).catch((e) => { console.log(e) })

    const article = frontMatter(response.data)
    actions.refreshCurrentArticle(article)
  }
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
    Route({ path: "/topics", render: TopicsView }),
    Route({ path: "/:topicId", render: Article })
  ])
)

const main = app(state, actions, view, document.body)

const unsubscribe = location.subscribe(main.location)