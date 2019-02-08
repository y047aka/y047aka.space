// libraries
import axios from 'axios'

// Hyperapp
import { app } from 'hyperapp'
import { div, main } from '@hyperapp/html'

// views
import SiteHeader from './view/SiteHeader'
import SiteFooter from './view/SiteFooter';
import Profile from './view/Profile'
import Calender from './view/Calender'

const state = {
  calender: [
    { races: [] }
  ]
}

const actions = {
  setCalender: (newObj) => state => ({
    calender: newObj
  })
}

const view = (state, actions) => (
  div({
    oncreate: async () => {
      const response_WEC = await axios.get('../data/WEC_2018-19.json').catch(e => { console.log(e) })
      const response_IMSA = await axios.get('../data/IMSA_2019.json').catch(e => { console.log(e) })
      actions.setCalender([
        response_WEC.data,
        response_IMSA.data
      ])
    }
  }, [
    SiteHeader(),
    main([
      Profile(),
      Calender()
    ]),
    SiteFooter()
  ])
)

app(state, actions, view, document.body)