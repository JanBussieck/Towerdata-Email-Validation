# TowerData Email

The `towerdata-email` gem provides a Ruby wrapper to the [TowerData REST API](http://www.towerdata.com/api). In addition to a module, methods, and classes for explicit calls to the API, the gem provides an email validator for ActiveModel classes.

## Installation

Add this line to your application's Gemfile:

    gem 'towerdata-email'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install towerdata-email

## Configuration

TowerData requires an API token for all requests. ([Get one here](http://info.towerdata.com/real-time-free-trial).) To configure your app with your token, add this code in an initializer or somewhere similar.

    TowerData.configure do |c|
      c.token = 'MY_TOKEN'
    end

### Optional Config Settings

**These settings are used by the Email Validator**
* **c.show_corrections**:
  * function: if a record is invalid, the error report will include suggested corrections
  * default: true

## Usage

### Email Validation

    email = TowerdataEmail.validate_email('address@domain.com')

After this call, `email` will be an instance of [`TowerdataEmail::Email`] This wrapper class exposes all the values from the JSON returned by TowerData. Use `email.ok` for a quick check if the email address is valid.

#### Towerdata::Email
This object corresponds very closely with the JSON response that comes back from Tower Data. It has the following fields:

* **status_code**:       Tower Data's code specifying the success/failure of the validation
* **status_desc**:       A text description of the status code
* **ok?**:               `true` if the address is considered valid, `false` otherwise
* **validation_level**:  Level of verification used to validate address
* **address**:           full email address
* **username**:          stuff before the @
* **domain**:            stuff after the @
* **corrections**:       if the address is invalid but something similar is valid, it will be in this field
 (e.g. suggesting `user@gmail.com` as a substitute for `user@gmial.com`)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request