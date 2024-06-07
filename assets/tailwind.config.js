// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require('tailwindcss/plugin')
const fs = require('fs')
const path = require('path')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/live_view_studio_web.ex',
    '../lib/live_view_studio_web/**/*.*ex'
  ],
  theme: {
    extend: {
      colors: {
        brand: '#FD4F00',
        'cool-gray': {
          50: '#f8fafc',
          100: '#f1f5f9',
          200: '#e2e8f0',
          300: '#cfd8e3',
          400: '#97a6ba',
          500: '#64748b',
          600: '#475569',
          700: '#364152',
          800: '#27303f',
          900: '#1a202e'
        },
        'science-blue': {
          light: '#66b3ff',
          DEFAULT: '#06c',
          dark: '#004d99'
        },
        papayawhip: {
          light: '#fef4e4',
          DEFAULT: '#ffefd5',
          dark: '#fee5bc'
        }
      },
      transitionProperty: {
        width: 'width'
      },
      borderWidth: {
        10: '10px',
        12: '12px',
        14: '14px',
        16: '16px'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    // default: 'standard'
    require('tailwind-scrollbar')({
      nocompatible: true,
      preferredStrategy: 'pseudoelements'
    }),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant('phx-no-feedback', ['.phx-no-feedback&', '.phx-no-feedback &'])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-click-loading', [
        '.phx-click-loading&',
        '.phx-click-loading &'
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-submit-loading', [
        '.phx-submit-loading&',
        '.phx-submit-loading &'
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-change-loading', [
        '.phx-change-loading&',
        '.phx-change-loading &'
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant('phx-feedback', ['&:not(phx-no-feedback)'])
    ),
    plugin(({ addVariant }) => addVariant('selected', '&[selected]')),
    plugin(({ addVariant }) => addVariant('up', '&[up]')),
    plugin(({ addVariant }) => addVariant('down', '&[down]')),
    plugin(({ addVariant }) => addVariant('in', '&[in]')),
    plugin(({ addVariant }) => addVariant('out', '&[out]')),
    plugin(({ addVariant }) => addVariant('stale', '&[stale]')),
    plugin(({ addVariant }) => addVariant('fresh', '&[fresh]')),
    plugin(({ addVariant }) => addVariant('no-more', '&[no-more]')),
    // Generic conditional variants...
    plugin(({ addVariant }) => addVariant('c1', '&[c1]')),
    plugin(({ addVariant }) => addVariant('c2', '&[c2]')),
    plugin(({ addVariant }) => addVariant('c3', '&[c3]')),
    plugin(({ addVariant }) => addVariant('c4', '&[c4]')),
    plugin(({ addVariant }) => addVariant('c5', '&[c5]')),
    plugin(({ addVariant }) => addVariant('c6', '&[c6]')),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, '../deps/heroicons/optimized')
      let values = {}
      let icons = [
        ['', '/24/outline'],
        ['-solid', '/24/solid'],
        ['-mini', '/20/solid'],
        ['-micro', '/16/solid']
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, '.svg') + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, '')
            let size = theme('spacing.6')
            if (name.endsWith('-mini')) {
              size = theme('spacing.5')
            } else if (name.endsWith('-micro')) {
              size = theme('spacing.4')
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              '-webkit-mask': `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              'mask-repeat': 'no-repeat',
              'background-color': 'currentColor',
              'vertical-align': 'middle',
              display: 'inline-block',
              width: size,
              height: size
            }
          }
        },
        { values }
      )
    })
  ]
}
