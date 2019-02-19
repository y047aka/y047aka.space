import { footer, p } from '@hyperapp/html'

export default () => state =>
  footer({ class: 'site-footer' }, [
    p({ class: 'copyright', innerHTML: `&copy; 2018-${ new Date().getFullYear() } y047aka` })
  ])
