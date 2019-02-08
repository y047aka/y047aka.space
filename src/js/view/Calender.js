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

export default () => state =>
  section([
    state.calender.map(d => [
      h1(`${ d.seriesName } ${ d.season }`),
      table({ class: 'heatmap' }, [
        tr([
          array.map(d => 
            th([
              span(d.getDate() <= 7 ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.getMonth()] : '')
            ])
          )
        ]),
        tr([
          array.map(d =>
            td({ 'data-tooltip': `${ d.toLocaleDateString() }` === '2019/6/16' ? '24 Hours of Le Mans' : '' }, '')
          )
        ])
      ])
    ])
  ])