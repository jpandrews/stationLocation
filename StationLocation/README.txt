Wunderground API utilized for weather requests.

Comments are added throughout the code to explain certain choices.  I made an attempt at MVVM by using a view model object on the map view.  It uses closures instead of delegate calls to allow the UI to handle updates.

One limitation is that there is no distinction between a query time-out and a query returning zero weather station data.  It seemed beyond the scope of the assignment but it would be a good choice to alert the user that the query is complete and no results were found.
