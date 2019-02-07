<<<<<<< HEAD
import { h2 } from '@hyperapp/html'

export default () => state => (
  h2({}, 'About')
=======
import { section, h2, p } from "@hyperapp/html"

export default ({ match }) => state => (
  section({}, [
    h2({}, "About"),
    p({}, "y047aka")
  ])
>>>>>>> 6021fe8c943707f5db03d7c519d2b663ab8f168b
)