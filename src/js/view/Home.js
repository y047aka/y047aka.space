<<<<<<< HEAD
import { h2 } from '@hyperapp/html'

export default () => state => (
  h2({}, 'Home')
=======
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
>>>>>>> 6021fe8c943707f5db03d7c519d2b663ab8f168b
)