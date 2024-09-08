import { css } from 'hono/css'
import { LinkTile } from '../components/LinkTile'
import { TopSection } from '../components/TopSection'
import type { Meta } from '../types'

export default function Top() {
  const posts = import.meta.glob<{ frontmatter: Meta }>('./posts/*.md', {
    eager: true
  })
  return (
    <TopSection title="Blog Posts">
      <div class={css`display: flex; flex-direction: column; row-gap: 5px;`}>
        {Object.entries(posts).map(([id, module]) => {
          if (module.frontmatter) {
            return (
              <LinkTile
                title={module.frontmatter.title}
                subTitle={module.frontmatter.pubDate}
                url={`${id.replace(/\.md$/, '')}`}
              />
            )
          }
        })}
      </div>
    </TopSection>
  )
}
