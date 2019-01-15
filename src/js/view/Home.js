import { section, h2, ul, li } from "@hyperapp/html"
import { Link, Route, location } from "@hyperapp/router"

const array = [
  {
    title: "article_01",
    slug: "article-1"
  },
  {
    title: "article_02",
    slug: "article-2"
  }
]

export default () => state => (
  section({}, [
    h2({}, "Home"),
    ul({}, [
      array.map(d => li({}, [
        Link({ to: d.slug }, d.title),
      ]))
    ])
  ])
)