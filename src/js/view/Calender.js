import { section } from '@hyperapp/html'

export default () => state =>
  section([
    state.calender[0].series
  ])