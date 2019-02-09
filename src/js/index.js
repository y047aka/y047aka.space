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
      const response_F1_2019 = await axios.get('../data/F1_2019.json').catch(e => { console.log(e) })
      const response_WEC_2018 = await axios.get('../data/WEC_2018-19.json').catch(e => { console.log(e) })
      const response_WEC_2019 = await axios.get('../data/WEC_2019-20.json').catch(e => { console.log(e) })
      const response_IMSA_2019 = await axios.get('../data/IMSA_2019.json').catch(e => { console.log(e) })
      const response_SuperGT_2019 = await axios.get('../data/SuperGT_2019.json').catch(e => { console.log(e) })
      const response_DTM_2019 = await axios.get('../data/DTM_2019.json').catch(e => { console.log(e) })
      const response_AirRace_2019 = await axios.get('../data/AirRace_2019.json').catch(e => { console.log(e) })
      actions.setCalender([
        response_F1_2019.data,
        response_WEC_2018.data,
        response_IMSA_2019.data,
        response_SuperGT_2019.data,
        response_DTM_2019.data,
        response_AirRace_2019.data,
        response_WEC_2019.data
      ])
    }
  }, [
    SiteHeader(),
    main([
      Calender(),
      Profile()
    ]),
    SiteFooter()
  ])
)

app(state, actions, view, document.body)