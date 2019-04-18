# Tinybeans iOS Development Challenge

Included with this package is a simple iOS app designed for candidates
to demonstrate their knowledge of iOS patterns and issues.

Imagine that a junior developer in your team has created a proof-of-concept
app and management decided that you're the person to make it production ready.

All the app does is pull a list of Reddit articles from our backend server and display them in a list.
The articles come combined in a (potentially large) zip file.
Inside the zip file is a bunch of JSON payloads collected from the Reddit public API.
The app is responsible for unzipping, parsing and displaying these articles in a list.
On every launch, the app wipes and pre-fills its database with some example articles.

## Instructions

## Required improvements

1) Currently the app is unusable whilst it is loading the articles;

2) The progress bar should continuously update to indicate the progress of the operation and only then disappear;

3) If the 'load articles' operation is run multiple times, there should not be any duplicates in the list;

4) There are a few 'code smells' within the project. Within reasonable limits, refactor the code to something
that you would be willing to maintain (perhaps for years);

5) Optionally, and time permitting, include a single unit test to ensure that we will never have the same article accidentally inserted twice in the database.

## New Features to add

1) The network operation should be cancellable;
After the user taps the 'load articles' button, whilst the operation is in progress,
the 'load articles' button should be replaced by a 'cancel' button.
Tapping cancel should terminate the operation as soon as possible

2) Add a new label to each cell to indicate the score of the corresponding article.
The `score` attribute can be fetched from the JSON payload under the `score` key of each article

3) Articles should be ordered by firstly by their `createdAt` parameter, then
by the `order` parameter, in descending order;

## FAQ

*Can I use third party libraries?*

Yes, but we will probably ask you to explain why you chose
each dependency (especially if a foundation alternative exists)

*Do I need to write tests?*

To keep the scope of this task small, you are <strong>not</strong>
required to write any tests for this project

*How much time should I spend on this?*

We would expect a Mid-Senior Dev candidate to spend around 4 hours on this task.
If you have ideas that don't fit into this time, we'd love to talk about them during your interview.

*Should I improve the UI?*

If you can fit them into your 4 hours, go for it. Otherwise we can talk about some of the ideas
you had when we review the challenge with you.
