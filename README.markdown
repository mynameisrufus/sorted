# sorted

This wee gem lets you sort tables (or somthing else) using a view helper and a custom scope.

It will toggle your sort order for you and will even work across pages with `will_paginate`

## Example

in the view:

  link_to "Email", users_path(sorted(:email))

in the model

  @users = User.sorted(params[:sorted]).paginate(:page => params[:page])

This will make somthing like this

  http://myapp/users?sorted=email_asc

Or

  http://myapp/users?sorted=email_asc|name_desc

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Rufus Post. See LICENSE for details.
