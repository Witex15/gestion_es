const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  safelist: [
    // Backgrounds
    'bg-white',
    'bg-gray-50',
    'bg-gray-100',
    'bg-gray-200',
    'bg-gray-800',
    'bg-red-50',
    'bg-red-500',
    'bg-green-50',
    'bg-green-500',
    'bg-blue-50',
    'bg-blue-500',
    'bg-yellow-50',
    'bg-yellow-500',
    'bg-purple-50',
    'bg-purple-500',
    
    // Hover backgrounds
    'hover:bg-gray-50',
    'hover:bg-gray-100',
    'hover:bg-red-600',
    'hover:bg-green-600',
    'hover:bg-blue-600',
    'hover:bg-yellow-600',
    
    // Text colors
    'text-gray-500',
    'text-gray-600',
    'text-gray-700',
    'text-gray-900',
    'text-white',
    'text-red-500',
    'text-red-700',
    'text-green-500',
    'text-green-700',
    'text-blue-500',
    'text-blue-700',
    'text-yellow-500',
    'text-yellow-700',
    
    // Border colors
    'border-gray-200',
    'border-gray-300',
    'border-red-500',
    'border-green-500',
    'border-blue-500',
    'border-yellow-500'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')
  ]
} 