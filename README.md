# faastruby-sendgrid-ruby-template
Use this template to handle SendGrid inbound parse webhooks
https://sendgrid.com/docs/ui/account-and-settings/inbound-parse/

## Getting started
### Prerequisites
* [FaaStRuby](https://faastruby.io) version 0.4.16 or higher.
```
# To install
~$ gem install faastruby

# To update
~$ gem update faastruby
```
### How to deploy this function
```
~$ cd FUNCTION_FOLDER
~/FUNCTION_FOLDER$ faastruby deploy-to WORKSPACE_NAME
```
### How to use this function as a template
```
~$ faastruby new FUNCTION_NAME --template github:cwise/faastruby-sendgrid-ruby-template
```
## SendGridInbound
The message is parsed for processing including extraction of mail headers and body.