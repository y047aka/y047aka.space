// Libraries
import axios from "axios"

// Hyperapp
import { app } from 'hyperapp'
import { div, span, header, footer, section, main, nav, h1, h2, p, a, ul, li, img } from '@hyperapp/html'

/*
import Home from './view/Home'
import About from './view/About'
import TopicsView from './view/TopicsView'
*/

const state = {
  calender: [{}]
}

const actions = {
  setCalender: (newObj) => state => ({
    calender: [newObj]
  })
}

const view = (state, actions) => (
  div({
    oncreate: async () => {
      const path = '../data/WEC_2018-19.json'
      const response = await axios.get(path).catch(e => { console.log(e) })
      actions.setCalender(response.data)
    }
  }, [
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
      section([
        h1('I\'m belong to...'), 
        ul([
          li([
            a({ href: 'http://spacemgz-telstar.com/', target: '_blank' }, '宇宙広報団体 TELSTAR')
          ]),
          li([
            a({ href: 'https://sorabatake.jp/', target: '_blank' }, '宙畑')
          ])
        ]),
        h1('Motor Sports Fun :)'), 
        ul([
          li('Aston Martin Racing (WEC)'),
          li('Corvette Racing (IMSA)')
        ]),
        h1('Links'), 
        ul([
          li([
            a({ href: 'https://twitter.com/y047aka', target: '_blank' }, 'Twitter')
          ]),
          li([
            a({ href: 'https://github.com/y047aka', target: '_blank' }, 'GitHub')
          ])
        ])
      ]),
      section([
        state.calender[0].series
      ])
    ]),
    footer({ class: 'site-footer' }, [
      p({ class: 'copyright', innerHTML: `&copy; 2018-${ new Date().getFullYear() } y047aka` })
    ])
  ])
)

app(state, actions, view, document.body)