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
      const dir = 'https://y047aka.github.io/MotorSportsCalendars'
      const response_F1_2019 = await axios.get(`${ dir }/F1_2019.json`).catch(e => { console.log(e) })
      const response_IndyCar_2019 = await axios.get(`${ dir }/IndyCar_2019.json`).catch(e => { console.log(e) })
      const response_FormulaE_2018 = await axios.get(`${ dir }/FormulaE_2018-19.json`).catch(e => { console.log(e) })
      const response_SuperFormula_2019 = await axios.get(`${ dir }/SuperFormula_2019.json`).catch(e => { console.log(e) })
      const response_WEC_2018 = await axios.get(`${ dir }/WEC_2018-19.json`).catch(e => { console.log(e) })
      const response_WEC_2019 = await axios.get(`${ dir }/WEC_2019-20.json`).catch(e => { console.log(e) })
      const response_IMSA_2019 = await axios.get(`${ dir }/IMSA_2019.json`).catch(e => { console.log(e) })
      const response_SuperGT_2019 = await axios.get(`${ dir }/SuperGT_2019.json`).catch(e => { console.log(e) })
      const response_DTM_2019 = await axios.get(`${ dir }/DTM_2019.json`).catch(e => { console.log(e) })
      const response_BlancpainGT_2019 = await axios.get(`${ dir }/BlancpainGT_2019.json`).catch(e => { console.log(e) })
      const response_WTCR_2019 = await axios.get(`${ dir }/WTCR_2019.json`).catch(e => { console.log(e) })
      const response_NASCAR_2019 = await axios.get(`${ dir }/NASCAR_2019.json`).catch(e => { console.log(e) })
      const response_WRC_2019 = await axios.get(`${ dir }/AirRace_2019.json`).catch(e => { console.log(e) })
      const response_AirRace_2019 = await axios.get(`${ dir }/WRC_2019.json`).catch(e => { console.log(e) })
      actions.setCalender([
        response_F1_2019.data,
        response_IndyCar_2019.data,
        response_FormulaE_2018.data,
        response_SuperFormula_2019.data,
        response_WEC_2018.data,
        response_WEC_2019.data,
        response_IMSA_2019.data,
        response_SuperGT_2019.data,
        response_DTM_2019.data,
        response_BlancpainGT_2019.data,
        response_WTCR_2019.data,
        response_NASCAR_2019.data,
        response_AirRace_2019.data,
        response_WRC_2019.data
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