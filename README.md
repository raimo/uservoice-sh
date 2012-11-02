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

Try running to ensure installation was ok:
```bash
$ uservoice_client get_collection '/api/v1/users'
# => A template of .uservoicerc in your home directory:
# => subdomain_name: uservoice-subdomain
# => api_key: YOUR-API-KEY-ADMIN-CONS
# => api_secret: YOUR-API-SECRET-FROM-ADMIN-CONSOLE-HERE--
# => sso_key: YOUR-SSO-KEY-FOR-SSO-LOGINS
```

Bootstrap setup:

```bash
$ uservoice_client get_collection '/api/v1/users' > $HOME/.uservoicerc
# => Wrote the template of .uservoicerc into stdout.
```

Now open editor and place your Admin Console setup into .uservoicerc.

```bash
uservoice_client get_collection '/api/v1/users'
# => [{"url":"http://uservoice-subdomain.uservoice.com/users/....
# => Total: 75
```

That worked! Then let's try to do authenticated 2-legged request:

```bash
$ uservoice_client get '/api/v1/users/current'
# => You are making requests as no user. Request an access token.
# => Type the email of the user whose access token you want (default: owner):
# me@example.com
# => Ok, generating access token for me@example.com.
# => Perfect! Now add these two lines to your $HOME/.uservoice.rc or rerun this command with >> $HOME/.uservoicerc:
# => access_token: qlex1IhzK5qyFLGf3KwpHv
# => access_token_secret: vrfpo7Zoe5AQ8w3PqCuySeTTn4Dn3osIbDuOrtyCD
```

Seems cool, you can just copy those to .uservoicerc. Or you can be lazy and redirect output directly:

```bash
$ uservoice_client get '/api/v1/users/current' >> $HOME/.uservoicerc
# => You are making requests as no user. Request an access token.
# => Type the email of the user whose access token you want (default: owner):
me@example.com
# => Ok, generating access token for me@example.com.
# => Perfect! Wrote the tokens to stdout.
```

All done!

```bash
$ uservoice_client get_collection '/api/v1/suggestions'
# => [{"url":"http://uservoice-subdomain.uservoice.com/forums/....},{....}]
# => Total: 63
```

Awesome! Again, you may redirect the output to a file suggestions.json and you will get the JSON without the "Total: 63".

Generate a link for an SSO user:

```bash
$ uservoice_client sso_url '{"email": "user@example.com", "trusted": true }'
# => http://uservoice-subdomain.uservoice.com/login_success?sso=SDF%SDF...
```

Any feedback on uservoice-sh is welcome!

/Raimo, @raimo_t