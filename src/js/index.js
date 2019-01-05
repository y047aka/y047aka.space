import { h, app } from "hyperapp"
import { div, h1, button } from "@hyperapp/html"
import { Link, Route, location } from "@hyperapp/router"

const Home = () => h("h2", {}, "Home")
const About = () => h("h2", {}, "About")
const Topic = ({ match }) => h("h3", {}, match.params.topicId)
const TopicsView = ({ match }) => (
  h("div", { key: "topics" }, [
    h("h2", {}, "Topics"),
    h("ul", {}, [
      h("li", {}, [
        h(Link, { to: `${match.url}/components` }, "Components")
      ]),
      h("li", {}, [
        h(Link, { to: `${match.url}/single-state-tree` }, "Single State Tree")
      ]),
      h("li", {}, [
        h(Link, { to: `${match.url}/routing` }, "Routing")
      ])
    ]),
    h(Route, { path: `${match.path}/:topicId`, render: Topic })
  ])
)

const state = {
  location: location.state
}

const actions = {
  location: location.actions
}

const view = state => (
  h("div", {}, [
    h("ul", {}, [
      h("li", {}, [
        h(Link, { to: "/" }, "Home")
      ]),
      h("li", {}, [
        h(Link, { to: "/about" }, "About")
      ]),
      h("li", {}, [
        h(Link, { to: "/topics" }, "Topics")
      ])
    ]),
    h("hr", {}),
    h(Route, { path: "/", render: Home }),
    h(Route, { path: "/about", render: About }),
    h(Route, { path: "/topics", render: TopicsView })
  ])
)

const main = app(state, actions, view, document.body)

const unsubscribe = location.subscribe(main.location)