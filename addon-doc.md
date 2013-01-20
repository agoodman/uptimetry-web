[Uptimetry](http://addons.heroku.com/uptimetry) is an [add-on](http://addons.heroku.com) for monitoring your app's vital resources. Think of it as real-time view testing. Make sure your sign up page is displaying correctly by confirming HTTP 200 OK and matching content in the response via CSS selector or XPath. Receive email when your page is not rendering as designed.

## Provisioning the add-on

Uptimetry can be attached to a Heroku application via the  CLI:

<div class="callout" markdown="1">
A list of all plans available can be found at http://addons.heroku.com/uptimetry.
</div>

    :::term
    $ heroku addons:add uptimetry
    -----> Adding uptimetry micro to your-app... done, v18 ($3/mo)

Once Uptimetry has been added a `UPTIMETRY_URL` setting will be available in the app configuration and will contain the URL used to access the newly provisioned Uptimetry service instance. This can be confirmed using the `heroku config:get` command.

    :::term
    $ heroku config:get UPTIMETRY_URL
    http://user:pass@instance.ip/resourceid

After installing Uptimetry the application should be configured to fully integrate with the add-on.

## Migrating between plans

<div class="note" markdown="1">Application owners should carefully manage the migration timing to ensure proper application function during the migration process.</div>

Use the `heroku addons:upgrade` command to migrate to a new plan.

    :::term
    $ heroku addons:upgrade uptimetry:large
    -----> Upgrading uptimetry:large to your-app... done, v18 ($20/mo)
           Your plan has been updated to: uptimetry:large

## Removing the add-on

Uptimetry can be removed via the  CLI.

<div class="warning" markdown="1">This will destroy all associated data and cannot be undone!</div>

    :::term
    $ heroku addons:remove uptimetry
    -----> Removing uptimetry from your-app... done, v20 (free)

## Support

All Uptimetry support and runtime issues should be submitted via on of the [Heroku Support channels](support-channels). Any non-support related issues or product feedback is welcome on Twitter @uptimetry.
