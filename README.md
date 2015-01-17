# EmberDataActiveModelParser

This is a middleware for [Her](http://her-rb.org/) which makes it possible to consume API endpoints used by ember-data's [ActiveModelAdapter](http://emberjs.com/api/data/classes/DS.ActiveModelAdapter.html). You can read more about the data format in the ember-data's [docs](http://emberjs.com/api/data/classes/DS.ActiveModelAdapter.html)

## Installation

Add this line to your application's Gemfile:

    gem 'ember_data_active_model_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ember_data_active_model_parser

## Usage

The parser expects that all your serializers are embedding the ids of the associations like this:

```ruby
class ProjectSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :name

  has_many :tasks
end

class TaskSerializer < ActiveModel::Serializer
  embed :ids, embed_in_root: true

  attributes :id, :name, :completed, :project_id
end
```

also you need to specify that active_model_serializers format in the Her models:

```ruby
class Project
  include Her::Model

  parse_root_in_json true, format: :active_model_serializers

  has_many :tasks
end

class Task
  include Her::Model

  parse_root_in_json true, format: :active_model_serializers

  belongs_to :project
end
```

In order to tell Her to use the serializer you need to replace the default JSON parser with it in an initializer (ex. config/initializers/her.rb):

```ruby
Her::API.setup url: "http://localhost:3000" do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  c.use EmberDataActiveModelParser::Middleware

  # Adapter
  c.use Faraday::Adapter::NetHttp
end
```

## Contributing

1. Fork it ( https://github.com/valo/ember_data_active_model_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
