<<<<<<< HEAD
import { app } from 'hyperapp'
import { div, span, header, footer, main, nav, h1, h2, p, a, ul, li, img } from '@hyperapp/html'

/*
import Home from './view/Home'
import About from './view/About'
import TopicsView from './view/TopicsView'
*/

const state = {}

const actions = {}
=======
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
>>>>>>> 6021fe8c943707f5db03d7c519d2b663ab8f168b

const view = state => (
  div([
    header({ class: 'site-header' }, [
      div({ class: 'icon' }),
      h1([
        '戸塚 孝高',
        span('Yoshitaka Totsuka / y047aka')        
      ]),
      p([
        img({ src: '/images/location.svg' }),
        'Tokyo, Japan'
      ])
    ]),
<<<<<<< HEAD
    main([
      h1('I\'m belong to...'), 
      ul([
        li([
          a({ href: 'http://spacemgz-telstar.com/', target: '_blank' }, '宇宙広報団体 TELSTAR')
        ]),
        li([
          a({ href: 'https://sorabatake.jp/', target: '_blank' }, '宙畑')
        ])
      ]),
      h1('Motor Sports Fun!!'), 
      ul([
        li('Aston Martin Racing (WEC)'),
        li('Corvette Racing (IMSA)')
      ])
    ]),
    footer({ class: 'site-footer' }, [
      p({ class: 'copyright', innerHTML: `&copy; 2018-${ new Date().getFullYear() } y047aka` })
    ])
=======
    Route({ path: "/", render: Home }),
    Route({ path: "/about", render: About }),
    Route({ path: "/topics", render: TopicsView }),
    Route({ path: "/:topicId", render: Article })
>>>>>>> 6021fe8c943707f5db03d7c519d2b663ab8f168b
  ])
)

app(state, actions, view, document.body)