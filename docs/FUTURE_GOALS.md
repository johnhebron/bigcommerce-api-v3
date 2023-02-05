# Future Goals
I would love to make the process of building an HTTP request more "natural" by introducing chainability to the Resources/Objects in some way, along with awareness of the available filters for each endpoint.

Ideally, a request might look like:
```ruby
@client.pages.where(channel_id: 1, name_like: 'history').page(1).limit(10).list
# => https://api.bigcommerce.com/stores/store_hash/v3/content/pages?channel_id=1&name:like=history&page=1&limit=10
```
Or even
```ruby
@client.pages.channel_id(1).name_like('history').page(1).limit(1).list
# => https://api.bigcommerce.com/stores/store_hash/v3/content/pages?channel_id=1&name:like=history&page=1&limit=10
```
