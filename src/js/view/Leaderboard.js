import { section, h1, table, tr, th, td } from '@hyperapp/html'

const array = [...Array(365).keys()].map(d => new Date(2019, 0, d + 1)).filter(d => d.getDay() === 0)

const check = (sunday, series) => {
  const a = series.races.filter(d => {
    const difference = sunday - new Date(d.date.replace(/-/g, '/'))
    return (difference >= 0 && difference < 7 * (1000 * 60 * 60 * 24))
  }).length
  return a
}

const TableHead = () => state =>
  tr([
		th('Pos'),
		th('#'),
		th('Name')
  ])

const Vehicle = (v, i) => state =>
  tr([
    td(i + 1),
    td(v.vehicle_number),
    td(v.driver.full_name)
  ])

export default () => state =>
  section([
		h1(state.run_name),
		state.laps_in_race,
    table({ class: 'live-timing' }, [
			TableHead(),
      state.vehicles.map((vehicle, i) =>
        Vehicle(vehicle, i)
      )
    ])
  ])