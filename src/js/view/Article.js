import { article, section, h2 } from "@hyperapp/html"

export default ({ match }) => (state, actions) => (
  article({ oncreate: () => actions.refresh(match.params.topicId) }, [
    h2({}, state.currentArticle.attributes.title),
    section({}, state.currentArticle.body)
  ])
)