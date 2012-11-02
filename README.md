uservoice-sh
============

This Ruby script will allow you to get started with UserVoice API easily. Just run the script and follow the instructions to set up a configuration file .uservoicerc where to store your API client and access tokens.

Prerequisites
-------------

* Ruby 1.8/1.9

Installation
-----

```
bundle
make install
```

Usage
-----
```bash
./uservoice_client get '/api/v1/users/current'
# Prints:
# You are making requests as no user. Request an access token.
# Type the email of the user whose access token you want (default: owner):

./uservoice_client get_collection '/api/v1/suggestions'
# => [{"url":"http://feedback.uservoice.com/forums/....},{....}]
# => Total: 63

./uservoice_client sso_url '{"email": "user@example.com", "trusted": true }'
# => http://feedback.uservoice.com/login_success?sso=SDF%SDF...
```

