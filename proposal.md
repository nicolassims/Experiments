* Who’s on your team?

Our team consists of Andrew Duffy, Nicolas Karayakaylar, Fedor 
Kiriakidi and William Bridges. We are an eclectic bunch, 
spanning three time zones and three grades, but we all agree on two 
points--monster games are cool, and 2000 words is way more than we can
come up with for this fairly small project.

* What’s your project idea?

Our project is an incremental game that will play itself when players 
are not logged in. As the previous sentence implies, players will be 
able to make accounts and log into their unique profile, which will be
secured with encrypted passwords stored on the server. (Though such 
security may be a bit overkill for this project, it's a requirement of
the assignment, so it's gotta happen.) The gameplay of the game will 
be similar to a Monster Taming Game, such as *Tamagotchi*, or 
*Kittens Game.* Players, like in *Cookie Clicker,* will be tasked with
generating a food-themed resource that we're currently calling "Food."
Food can be used to feed monsters, powering them up, and can be used 
to lure new monsters into the player's inventory as well. Players are
then able to send these monsters to one of two virtual locations: "The
Farm" and "The Wild." Monsters in "The Farm" generate an amount of 
food based on their power. Monsters in "The Wild" become more 
powerful. In this way, players have two feedback loops that empower
the other, creating a fun and eternally-rewarding gameplay experience.

* What API do you plan to use?

We intend to have some social elements to the game, which we will be 
implementing with the Twitter API. With the flavorful idea that all 
our players are "Monster Farmers," perhaps living in a community 
together, players will be able to interact with other players' tweets
in order to benefit the monsters of the tweeter. For example, a like 
on a tweet might give the tweeter an hour's worth of food for their 
most productive monster. 

* What realtime behavior are you planning?

Players will be able to see each others' monster stashes, and see each
other's food count as well. These counts would update in real time, as
well the "food parcels" that players can gift each other, as described
in the prior bullet point. We'll be updating our checks on the twitter
API we use in real time, so these food parcels should come in at the 
exact moment the tweet is interacted with.

* What persistent state [...] will you be storing in a postgres DB?

We will be storing each player’s “Monsters” and food quantities in a
postgres DB. Food quantities will be a simple integer linked to the 
user’s ID, while each monster will require a type, xp amount, and 
potentially other attributes. Additionally, we can handle the twitter
“account linkage” by storing each user’s twitter access key in an 
account info table.

* What “something neat” thing are you going to do?

Since our project is an incremental game, also known as an idle game, 
a key aspect of the website will be that the game “plays itself.” This
means that the player will constantly be accumulating resources and 
gaining experience points on their monsters without having to take 
direct action. We plan to use background processes in our server code 
to ensure that the game can accomplish these tasks no matter what 
action the player is currently taking or what part of the website 
they are currently accessing.

* For each experiment:
  * What did you try?
  * What was the result?
  * What did you learn?

For our first experiment, we explored the usage of the Twitter API to
authenticate to Twitter with a users permission, as well as performing
calls to APIs on behalf of the authenticated user. Our first step 
required applying for a developer account on Twitter. This meant 
waiting about one day for approval to our application. We also learned
that using Twitter APIs requires keeping secrets related to the 
developer and using them as part of configuration for API calls. 
Conveniently, there is an Elixir module for using Twitter APIs named 
“ExTwitter”. 

Another key point and challenge of this process is the authorization 
of the user authenticating to Twitter and granting our application 
access to their Twitter account. First, we redirect the user to a 
Twitter url that we obtain  using an API. Although this API had an 
optional redirect parameter for automatically redirecting the user 
back to our application, we did not use this in our experiment. For 
this experiment, we used PIN-based authentication where the user, upon
successfully logging in and granting access, is given a PIN by Twitter
to manually give back to our application. The user must then navigate 
back to our main page, and then they enter the pin into a text-box 
form. This form will use the PIN provided with another Twitter API to 
obtain an access token that we extract from the result. From there, 
our Application can use that user’s access token in future API calls 
made on behalf of the user, provided we set the token in the ExTwitter
module’s configuration.

Once the user has successfully authenticated, we can make further calls
to the APIs with access to the information and actions available to the
user’s account. We demonstrate this in our experiment by displaying the
text of the user’s latest tweet in plain text. There is also another 
text-box form which allows the user to create a new tweet from our 
application. This is where we encountered another challenge of the 
experiment. At first, attempting to create a new tweet as the user 
returned an error stating that our application is READ-only and cannot
POST. It turned out that we needed to enable Write access as a setting
in the project within the developer account dashboard. Furthermore, we
also needed to regenerate our secrets in order to allow the newly 
enabled access to work on our application.

Overall, this Twitter API experiment was a success. We found that we 
are able to successfully authenticate to Twitter, obtain access from a
user to use their account, as well as perform actions using their 
account such as tweeting and obtaining their tweets. In the scope of 
the full project, we will likely look into converting the PIN-based 
authentication into token-based authentication which should be more 
convenient for the user to authorize our application. We learned that 
we will have to be mindful of how we handle the access token obtained 
from authorization. The user’s access token must be set into the 
ExTwitter module’s configuration in order to have the right 
authorization for an API call. In addition, we need to ensure that 
multiple users attempting to use our Twitter functionality are able to
do so without issue.

For the second experiment, I wanted to know if it was possible to have
a process running in the background that will continually make HTML 
calls to another page, updating the first page. In order to perform 
this experiment, I created a page "/clock," that used a process every
second to get the time from an elixir module, and print it to the 
screen. This worked, confirming that nonblocking processes can be used
to update a web page consistently. Though--and it's worth mentioning 
this--it wasn't nearly as easy as I describe it here. I struggled for 
hours to get the website to even update itself in a non-blocking 
process. And then, when I finally did that, I struggled even longer to
get the website to actually change the browser output. As it turned 
out, I had to use Phoenix's LiveView for that. But when I did, it 
worked exactly as intended. 

Having completed the first part of the app, I edited the index page to
use HTTPoison to send out HTTP GET requests to the "/clock" every 
second, and then echo the time-based content of the "/clock" page. 
This required quite a bit of pruning and translation (see below) of 
the HTTPoison response, confirming that translation of such data is 
possible.

```
echo = HTTPoison.get!(NeatthingWeb.Endpoint.url <> "/clock").body
|> String.split(~r/<h1>/)
|> tl
|> hd
|> String.split(~r/<\/h1>/)
|> hd
```

This experiment was, overall, a success. It might've taken a bleeding 
long time to accomplish, but it answered more questions than I set out
to ask, and taught me how to do several things that I didn't know how 
to do before this experiment began, or weren't covered in the 
lectures. In summary, this experiment now helps me understand if I 
can--and perhaps more importantly, how to--make an app that is 
continually updating itself while a player interacts with it, and 
watches numbers go up. It's also worth mentioning that my clock and 
echo functions are active and functional even when no browser is 
currently on them. Though, of course, the server doesn't go through 
the process of actually copying over the content of the clock page 
when there's no browser to render it on.

* What kinds of users do you expect to use your app?

We expect our userbase to be casual gamers. And, mostly, members of 
this class. Friends and family members that we could loop into playing
this game. However, if this app were ever to try and be its own 
"thing," away from the confines of this class, then we might expect it
to be engineers, or gamers of a more "hardcore" bent, as that is who, 
typically, plays incremental games. As an expanding and very popular 
genre--one need only look at game website Kongregate to see the 
veracity of that statement--it's also possible that we'd recruit 
younger children into our fold, as children go wild for idle games. We
might also expect twitter users to play it, as twitter integration, 
encouraging a somewhat pyramid-scheme like style of recruitment, would
be a selling point. Though I'd emphasize that a twitter account won’t 
be necessary, but will be encouraged. 

* For each kind of user, what is their most common workflow / user story?

As our app is a game, our user stories differ somewhat from the kind 
that might be more common amongst apps of a more practical bent. 
Here's how we imagine a player's experience might go--they're 
scrolling twitter. They see a friend posted a tweet that says 
something along the lines of "Like this app to feed my dragon!" They 
do so, and see that the tweet also has a link to cool.monstergame.com.
(Or whatever our equivalent is.) They click on the link, and are 
brought to a page that encourages them to sign up, providing fields 
for a username, password, etc. They decide to do so, and are brought 
to a page where they can choose their first monster. (Randomly 
generated species/colors/traits, perhaps? We might even give them 
portraits, as a stretch goal.) Upon selecting the monster, they're 
brought to their homepage, where they see a food count at zero, and 
their monster, which has zero power. They can then send this monster 
to two locations: "the farm" or "the wild." They send the monster to 
the wild, and see that its power starts to increase. After a while of 
seeing numbers go up, they bring the monster back to "the farm," and 
see their food count go up. After a while of this happening, two new 
buttons appear. "Feed monster" lets them feed a monster a portion of 
their food to increase the monster's power instantly, without waiting 
for them to train in the wild. The other button, "Get Monster," lets 
the player instantly grab a new monster that they can interact with 
in the same way as everything mentioned prior. This "Get Monster" cost
grows exponentially, of course, since the growth of food should also 
be exponential. 

This was the user story for a player who's new to the game, though. In
the event that a player already has an account in the game, they'll be
prompted to enter their username and password--the latter of which 
will be checked against the secure, encrypted version stored on our 
servers--and then, if the correct values are provided, they'll be 
brought immediately to their personal page, where the monsters and 
such are. Players, as mentioned before, will be able to see other 
users' pages, but they will not, of course, be able to reassign that 
other user's monsters or spend that user's food.