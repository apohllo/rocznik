# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


User.create(email: "admin@admin.com", password: "admin", password_confirmation: "admin", admin: true)
Storytime::Site.create(title: "Rocznik Kognitywistyczny", root_post_id: 1, subscription_email_from:
                       "rocznik@kognitywistyka.eu", layout: "application", user_id: 1, custom_domain:
                       "rocznik.kognitywistyka.eu")
