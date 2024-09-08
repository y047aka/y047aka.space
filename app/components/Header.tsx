import { css } from 'hono/css'
import type { FC } from 'hono/jsx'
import { siteName } from '../lib/constants'

const headerClass = css`
  h2 {
    max-width: 650px;
    margin-inline: auto;
    padding: 15px;
    font-family: "Saira", sans-serif;
    font-size: 18px;
    font-weight: normal;
  }
  a {
    text-decoration: none;
    color: inherit;
  }
  `

export const Header: FC = () => {
  return (
    <header class={headerClass}>
      <h2>
        <a href="/">{siteName}</a>
      </h2>
    </header>
  )
}
