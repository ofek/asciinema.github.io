---
hide:
  - toc
---

# Administration

asciinema server admins can perform the following administrative tasks:

- edit metadata and delete any recording
- add a recording to a "Featured" list
- change visibility of a recording to public/private

There's no dedicated admin section - you can perform the above tasks through the
Settings menu (gear icon) on a recording page. The menu can be found below the
player, on the right side of the page.

To make yourself or another user an admin, run the following command with the
account's email address:

```sh
docker compose exec asciinema admin_add email@example.com
```

Similarly, to remove admin role from a user, run:

```sh
docker compose exec asciinema admin_rm email@example.com
```
