# Pagy initializer file
# Customize only what you really need but notice that Pagy works also without any of the following lines.

# Extras
# See https://ddnexus.github.io/pagy/extras

# Backend Extras

# Array extra: Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
# See https://ddnexus.github.io/pagy/extras/array
# require 'pagy/extras/array'

# Countless extra: Paginate without any count, saving one query per rendering
# See https://ddnexus.github.io/pagy/extras/countless
# require 'pagy/extras/countless'
# Pagy::VARS[:cycle] = false    # default

# Elasticsearch Rails extra: Paginate `ElasticsearchRails::Results` objects efficiently, avoiding expensive object-wrapping and without overriding.
# See https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# require 'pagy/extras/elasticsearch_rails'

# Frontend Extras

# Bootstrap extra: Add nav, responsive and compact helpers and templates for Bootstrap pagination https://ddnexus.github.io/pagy/extras/bootstrap
require 'pagy/extras/bootstrap'

# Plain extra: Add responsive and compact nav plain helpers
# Notice: the other frontend extras add their own framework-styled versions,
# so require this extra only if you need the plain unstyled version
# See https://ddnexus.github.io/pagy/extras/plain
# require 'pagy/extras/plain'

# Breakpoints var used by the responsive nav helpers
# See https://ddnexus.github.io/pagy/extras/plain#breakpoints
# Pagy::VARS[:breakpoints] = { 0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3] }    # example of width/size pairs


# Feature Extras

# Support extra: Extra support for features like: incremental, infinite, auto-scroll pagination
# See https://ddnexus.github.io/pagy/extras/support
# require 'pagy/extras/support'

# Items extra: Allow the client to request a custom number of items per page with an optional selector UI
# See https://ddnexus.github.io/pagy/extras/items
# require 'pagy/extras/items'
# Pagy::VARS[:items_param] = :items    # default
# Pagy::VARS[:max_items]   = 100       # default

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/extras/overflow
# Pagy::VARS[:overflow] = :last_page    # default  (other options: :empty_page and :exception)

# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/extras/trim
# require 'pagy/extras/trim'


# Pagy Variables
# See https://ddnexus.github.io/pagy/api/pagy#variables
# All the Pagy::VARS are set for all the Pagy instances but can be overridden
# per instance by just passing them to Pagy.new or the #pagy controller method


# Instance variables
# See https://ddnexus.github.io/pagy/api/pagy#instance-variables
# Pagy::VARS[:items] = 20                                   # default


# Other Variables
# See https://ddnexus.github.io/pagy/api/pagy#other-variables
# Pagy::VARS[:size]       = [1,4,4,1]                       # default
# Pagy::VARS[:page_param] = :page                           # default
# Pagy::VARS[:params]     = {}                              # default
# Pagy::VARS[:anchor]     = '#anchor'                       # example
# Pagy::VARS[:link_extra] = 'data-remote="true"'            # example
# Pagy::VARS[:item_path]  = 'activerecord.models.product'   # example


# Rails

# Rails: extras assets path required by the compact and responsive navs, and the items extra
# See https://ddnexus.github.io/pagy/extras#javascript
Rails.application.config.assets.paths << Pagy.root.join('javascripts')


# I18n

# I18n faster internal pagy implementation (does not use the I18n gem)
# Use only for single language apps that don't need dynamic translation between multiple languages
# See https://ddnexus.github.io/pagy/api/frontend#i18n
# Notice: Do not use any of the following lines if you use the i18n extra below
# Pagy::Frontend::I18N.load(file: Pagy.root.join('locale', 'es.yml'), language:'es') # load 'es' pagy language file
# Pagy::Frontend::I18N.load(file:'path/to/dictionary.yml', language:'en')            # load a custom 'en' file
# Pagy::Frontend::I18N[:plural] = -> (count) {(['zero', 'one'][count] || 'other')}   # default

# I18n extra: Use the `I18n` gem instead of the pagy implementation
# (slower but allows dynamic translation between multiple languages)
# See https://ddnexus.github.io/pagy/extras/i18n
# require 'pagy/extras/i18n'