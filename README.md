# dnb-api

This Gem provides a wrapper to the D*B Direct Plus API.

https://directplus.documentation.dnb.com

## Quick Start

Connect using your API Credentials
```ruby
require 'dnb-api'
client = Dnb::Api::Client.new(api_key: <api_key> , secret: <secret> )
client.connect
```
Search for records matching critera

https://directplus.documentation.dnb.com/openAPI.html?apiID=searchCriteria
```ruby
client.criteria_search(countryISOAlpha2Code: 'GB', searchTerm: 'Market Dojo')
```

Find the best matches for search criteria

https://directplus.documentation.dnb.com/openAPI.html?apiID=IDRCleanseMatch
```ruby
client.cleanse_match(countryISOAlpha2Code: 'GB', name: 'Market Dojo')
```
Retrieve a record based on DUNS

```ruby
result = client.company_profile(<duns>, Dnb::Api::Report.new)
```

## Dummy API

Because obtaining credetials can be time consuming and accessing the API may be costly, there is a dummy mode.
In dummy mode, calls to the API will return data in the correct format, from a local cache. This is only suitable for development. They api_key and secret variables are validated

```ruby
require 'dnb-api'
client = Dnb::Api::Client.new(api_key: 'key' , secret: 'secret' )
client.connect
result = client.criteria_search(countryISOAlpha2Code: 'GB', searchTerm: 'Dojo')

```

## Authentication

You will need a valid set of API credentials from D&B in order to access the API.

Learn more: [API authentication on the D&B Website](https://directplus.documentation.dnb.com/openAPI.html?apiID=authentication).


## Identify

This GEM implements the [Criteria Search](https://directplus.documentation.dnb.com/openAPI.html?apiID=searchCriteria) and [Cleanse Match](https://directplus.documentation.dnb.com/openAPI.html?apiID=IDRCleanseMatch) endpoints from the D&B API.

Parameters which can be passed to these methods are listed on the D&B API website.

## Enrich

D&B provide a number of different options for retrieving data about an entity. In all cases, the basic API endpoint remains the same, but the parameters vary. These different options are modelled as 'Report Types' in the GEM.

At its simplest, you can simply pass a duns and a new report type to the method.

```ruby
result = client.company_profile(<duns>, Dnb::Api::ReportType.new)
```

### Report Types

Report types allow you to define the results which will be returned from D&B.

```ruby
rt = Dnb::Api::ReportType.new
product = :'Data Blocks'
product_components = ['Business Activity Insights', 'Derived Trade Insights']
rt.product = product
rt.product_components = product_components
rt.order_reason = :'Credit Decision'
rt.customer_reference = '12345'

result = client.company_profile(<duns>, rt)

```

#### Using a string
If you prefer you can just pass a string to the company_profile method instead of a report type:

`productId=cmptcs&customerReference=123456789&orderReason=1234&reportFormat=html&tradeUp=hq&versionId=v1`

This is also the string returned by a new `ReportType`.

Calling to_s on a Report Type object will display the query string.

#### Data Blocks
The D&B Data Blocks API allows you to return one or more blocks of information

#### Data Product: Analytics

#### Data Product: Company Profile

#### Data Product: Corporate Linkage, Family Tree

#### Data Product: Resolved Network Insights

#### Company Report

#### Other
The following report types are not yet implemented as report types.
- News and Media, Standard
- Industry Profile
- Restricted Party Screening
- Consolidated Assessment Report (CAR) Investigation
-
You can access them by using the appropriate query string instead of a Report Type object.
```ruby
result = client.company_profile(<duns>, <query_string_for_required_report>)
```
If you are doing this, then please consider submitting a PR.

### Monitor
D&B offer the ability to monitor a set of companies for changes
The monitored companies are grouped under a 'Registration'.
For small lists of companies, the results can be polled regularly.

Get a list of registration lists
```ruby
result = client.monitoring_registrations_list
```
Get details of a registration
```ruby
result = client.monitoring_registration_details(<monitoring registration reference>)
```
## Related Efforts

- [dnb-direct-ruby](https://github.com/jihaia/dnb-direct-ruby) - Another ruby API wrapper for D&B Direct.

## Maintainers

[@nicliketo](https://github.com/niciliketo)

## Contributing

Feel free to dive in! [Open an issue](https://github.com/niciliketo/dnb-api/issues/new) or submit PRs.

Standard Readme follows the [Contributor Covenant](http://contributor-covenant.org/version/1/3/0/) Code of Conduct.

### Contributors

This project exists thanks to all the people who contribute.

[![](https://github.com/niciliketo.png?size=50)](https://github.com/niciliketo)


## License

[MIT](LICENSE) © Nicholas Martin