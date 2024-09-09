import { css } from 'hono/css'
import { createRoute } from 'honox/factory'
import { LinkTile } from '../components/LinkTile'
import { TopSection } from '../components/TopSection'
import type { MDX } from '../lib/post'

export default createRoute((c) => {
  const posts = import.meta.glob<MDX>('../posts/*.md', {
    eager: true
  })

  return c.render(
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
})
