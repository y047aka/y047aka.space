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
    th('Driver'),
    th(''),
    th('Laps'),
    th('Delta'),
    th('Last Lap'),
    th('mph'),
    th('Pit Stops'),
    th('Last Pit')
  ])

const Vehicle = v => state =>
  tr([
    td(v.running_position),
    td(v.vehicle_number),
    td(v.driver.full_name),
    td({ Chv: 'Chevrolet', Frd: 'Ford', Tyt: 'Toyota' }[v.vehicle_manufacturer]),
    td(v.laps_completed),
    td(v.delta > 0 ? v.delta.toFixed(3) : v.delta),
    td(v.last_lap_time.toFixed(3)),
    td(v.last_lap_speed.toFixed(1)),
    td(v.pit_stops.length),
    td(v.pit_stops.length > 0 ? v.pit_stops.reverse()[0].pit_in_lap_count : '')
  ])

export default () => state =>
  section([
		h1(state.run_name),
    table({ class: 'leaderboard' }, [
			TableHead(),
      state.vehicles.map(vehicle =>
        Vehicle(vehicle)
      )
    ])
  ])