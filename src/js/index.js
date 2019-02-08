// libraries
import axios from "axios"

// Hyperapp
import { app } from 'hyperapp'
import { div, main } from '@hyperapp/html'

// views
import SiteHeader from './view/SiteHeader'
import SiteFooter from "./view/SiteFooter";
import Profile from './view/Profile'
import Calender from './view/Calender'

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
    SiteHeader(),
    main([
      Profile(),
      Calender()
    ]),
    SiteFooter()
  ])
)

app(state, actions, view, document.body)