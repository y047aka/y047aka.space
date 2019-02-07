import { app } from 'hyperapp'
import { div, span, header, footer, main, nav, h1, h2, p, a, ul, li, img } from '@hyperapp/html'

/*
import Home from './view/Home'
import About from './view/About'
import TopicsView from './view/TopicsView'
*/

const state = {}

const actions = {}

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
  ])
)

app(state, actions, view, document.body)