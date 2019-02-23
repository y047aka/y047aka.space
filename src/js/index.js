// libraries
import axios from 'axios'

// Hyperapp
import { app } from 'hyperapp'
import { div, main } from '@hyperapp/html'

// views
import SiteHeader from './view/SiteHeader'
import SiteFooter from './view/SiteFooter'
import SideNav from './view/SideNav'
import Racing from './view/Racing'
import Profile from './view/Profile'
import Leaderboard from './view/Leaderboard'

const state = {
  race_id: '',
  vehicles: []
}

const actions = {
  setState: (newObj) => state => (newObj)
}

const view = (state, actions) => (
  div({
    oncreate: async () => {
      const standings = await axios.get('https://www.nascar.com/live/feeds/series_2/4812/live_feed.json').catch(e => { console.log(e) })
      actions.setState(standings.data)
    }
  }, [
    SiteHeader(),
    main([
      Leaderboard(),
      Racing(),
      Profile()
    ]),
    SideNav(),
    SiteFooter()
  ])
)

app(state, actions, view, document.body)