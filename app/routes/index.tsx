import { css } from 'hono/css'
import type { Meta } from '../types'

export default function Top() {
  const posts = import.meta.glob<{ frontmatter: Meta }>('./posts/*.md', {
    eager: true,
  })
  return (
    <div>
      <h2>Posts</h2>
      <ul class='article-list'>
        {Object.entries(posts).map(([id, module]) => {
          if (module.frontmatter) {
            return (
              <li>
                <a href={`${id.replace(/\.md$/, '')}`}>{module.frontmatter.title}</a>
              </li>
            )
          }
        })}
      </ul>
    </div>
  )
}
