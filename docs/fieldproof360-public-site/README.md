# FieldProof 360 Pro public pages

This is a framework-free static site package. Its directory layout maps directly to the intended public paths:

- `/fieldproof360/privacy`
- `/fieldproof360/terms`
- `/fieldproof360/support`

## Deploy to benattech.me

1. Copy the `fieldproof360` directory to the document root of the existing `benattech.me` site, preserving the directory name.
2. Configure the web server or static host to serve `index.html` for directory paths. This is the default for Apache, Nginx, Cloudflare Pages, Netlify, Vercel, and most static hosts.
3. Confirm HTTPS is enabled for `benattech.me` and that the three URLs above return HTTP 200 without authentication.
4. Open each URL on a phone and desktop browser. Confirm the support email opens a mail client through its `mailto:` link.

No build step, server runtime, login, form handler, or environment variables are required.
