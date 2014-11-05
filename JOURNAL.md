# A brief journal #

First of all, this was fun. A nice brain teaser. The task is deceptively complex and I wanted to solve it without looking at any external resources. Considering that I am not the person to go to with algorithms and that I have spent last couple of years working primarily with Rails, this was a nice refreshment.

While I had only time on Sunday (and not a lot of it) to begin with the task, from the moment I have read the description, I was naively constructing it in my head.

## Day one (Sunday, 02.11.2014) ##

I wanted to keep it simple, so my first idea was:

> Oh, this is simple. We just iterate over "pivot_table", locate each user, intersect it with user we are building a recommendation for and if intersection is greater than 0, add products to the list of recommendations.

Immediately after I realized that certain weight should be attached to each recommendation based on the intersection size and that recommendations should be sorted according to it. I also realized that for large data sets this would be computationaly expensive and terribly slow.

Never the less, this was MVP and since I wanted to keep it simple, I decided not to use database and just write MVP which will work with data in memory using global variables as external storage representation.

So I sat down, defined structure, wrote down some test data and specs. Implemented these two, redefining structure until I was happy with it and also caching user objects.

This took a bit of time, so I ended for the day after this implementation with nagging feeling that since there is bound to be less users than `user_products_likes`, I should iterate over them. Ah, yes, I also wrote specs.

## Day two (Wednesday, 05.11.2014) ##


### Morning ###

Re-factored naive strategies to (1) stop using reduce, which is as we know very slow, and instead just put values in previously initialized `Set` and (2) moved naive condition into it's own method in order to DRY the code.

I took a look at the book provided and started with implementing Jaccard similarity ratio strategy. Also, logically, started by iterating over users. Since users that liked exactly the same products as well as those whose likes do not intersect are equally unwanted, they were skipped.

### Afternoon ###

After lunch I had some free time and wanted to read up on MinHash which is the next strategy I wanted to visit, so I can be done with it. Well figuring this algorithm from description was not as easy as I imagined and I had no time to dedicate to slow and painful process. So, I cheated and found an alternative explanation of [minHash](http://www.toao.com/minhashing/) which combined with book provided made it possible for me to understand the Algorithm and then write it down.

P.S. [Mining of Massive Datasets](http://www.mmds.org/) is awesome. I have got to find some time to read it.