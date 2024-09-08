import { css } from 'hono/css'
import type { FC } from 'hono/jsx'
import { owner } from '../lib/constants'

const footerClass = css`
div {
  max-width: 650px;
  margin-inline: auto;
  padding: 15px;
  text-align: right;
  font-family: "Saira", sans-serif;
  font-size: 14px;
}
`

export const Footer: FC = () => {
  return (
    <footer class={footerClass}>
      <div>© 2024 {owner}</div>
    </footer>
  )
}
