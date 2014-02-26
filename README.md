Reddit Search Download
======================

Small script to download reddit search results in json and xml format.

The function ```reddit_search_download(title,format,subreddit,query,sort,t)``` takes in 6 arguments:

* *title* - String, what you'd like your file to be titled
* *format* - String, either "json" or "xml"
* *subreddit* - String, what subreddit you wish to search
* *query* - String, what you actually want to search on that subreddit
* *sort* - String, what you sort by, from "relevance", "new", "hot", "top", "comments"
* *t* - What timeframe you'd like to search, from "all", "hour", "day", "week", "month", "year"

As an example, I downloaded search results in /r/manga for the query "[RT!]" from the past month based on relevance using this:

```ruby
reddit_search_download("mangaSearch","json","manga","[RT!]","relevance","month")
reddit_search_download("mangaSearch","xml","manga","[RT!]","relevance","month")
```