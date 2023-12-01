# Administration

Site admin can do the following administrative tasks:

- edit, delete any recording
- make recording a featured one
- make recording public/private

There isn't a dedicated admin UI, all of the above actions are done through the
gear dropdown available on asciicast's view page (below the player, on the
right).

### Making user an admin

To make user an admin, run the following command with the email address of
existing account:

    docker compose run --rm phoenix admin_add email@example.com

To remove admin bit from a user, run:

    docker compose run --rm phoenix admin_rm email@example.com

Both above commands allow passing multiple email adresses (as separate
arguments).
