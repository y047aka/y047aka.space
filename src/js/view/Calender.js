import { span, section, h1, ul, li, table, tr, th, td } from '@hyperapp/html'

const array = (() => {
  const array = []
  for (var i = 0; i < 365; i++) {
    const d = new Date(2019, 0, i + 1)
    if (d.getDay() === 0) {
      array.push(d)
    }
  }
  return array
})()

const check = (sunday, series) => {
  const a = series.races.filter(d => {
    const difference = sunday - new Date(d.date.replace(/-/g, '/'))
    return (difference >= 0 && difference < 7*1000*60*60*24)
  }).length
  return a
}

export default () => state =>
  section([
    state.calender.map(series => [
      h1(`${ series.seriesName } ${ series.season }`),
      table({ class: 'heatmap' }, [
        tr([
          array.map(d => 
            th([
              span(d.getDate() <= 7 ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.getMonth()] : '')
            ])
          )
        ]),
        tr([
          array.map(d => ([
            td({ 'data-tooltip': check(d, series) ? '24 Hours of Le Mans' : '' }, '')
          ]))
        ])
      ])
    ])
  ])