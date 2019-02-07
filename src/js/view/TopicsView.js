import axios from 'axios'
import { div, h2, h3, ul, li } from '@hyperapp/html'
import { Link, Route, location } from '@hyperapp/router'


let doc
axios.get('../md/topics.md')
  .then(function (response) {
    doc = response.data
    console.log(doc)
  })
  .catch(function (error) {
    console.log(error)
  })


const Topic = ({ match }) => h3({}, 'match.params.topicId')

export default ({ match }) => (
  div({ key: 'topics' }, [
    h2({}, 'Topics'),
    ul({}, [
      li({}, [
        Link({ to: `${match.url}/components` }, 'Components')
      ]),
      li({}, [
        Link({ to: `${match.url}/single-state-tree` }, 'Single State Tree')
      ]),
      li({}, [
        Link({ to: `${match.url}/routing` }, 'Routing')
      ])
    ]),
    Route({ path: `${match.path}/:topicId`, render: Topic })
  ])
)