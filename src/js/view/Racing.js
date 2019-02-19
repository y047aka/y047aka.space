import { section, h1, a, ul, li } from '@hyperapp/html'

export default () => state =>
  section([
    h1('Racing!!'), 
    ul([
      li([
        a({ href: 'https://y047aka.github.io/MotorSportsCalendar/', target: '_blank' }, 'MotorSportsCalendar')
      ])
    ])
  ])