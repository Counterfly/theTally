# theScore "the Rush" Interview Challenge
At theScore, we are always looking for intelligent, resourceful, full-stack developers to join our growing team. To help us evaluate new talent, we have created this take-home interview question. This question should take you no more than a few hours.

**All candidates must complete this before the possibility of an in-person interview. During the in-person interview, your submitted project will be used as the base for further extensions.**

### Why a take-home challenge?
In-person coding interviews can be stressful and can hide some people's full potential. A take-home gives you a chance work in a less stressful environment and showcase your talent.

We want you to be at your best and most comfortable.

### A bit about our tech stack
As outlined in our job description, you will come across technologies which include a server-side web framework (like Elixir/Phoenix, Ruby on Rails or a modern Javascript framework) and a front-end Javascript framework (like ReactJS)

### Challenge Background
We have sets of records representing football players' rushing statistics. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/rushing.json).

##### Challenge Requirements
1. Create a web app. This must be able to do the following steps
    1. Create a webpage which displays a table with the contents of [`rushing.json`](/rushing.json)
    2. The user should be able to sort the players by _Total Rushing Yards_, _Longest Rush_ and _Total Rushing Touchdowns_
    3. The user should be able to filter by the player's name
    4. The user should be able to download the sorted data as a CSV, as well as a filtered subset
    
2. The system should be able to potentially support larger sets of data on the order of 10k records.

3. Update the section `Installation and running this solution` in the README file explaining how to run your code

### Submitting a solution
1. Download this repo
2. Complete the problem outlined in the `Requirements` section
3. In your personal public GitHub repo, create a new public repo with this implementation
4. Provide this link to your contact at theScore

We will evaluate you on your ability to solve the problem defined in the requirements section as well as your choice of frameworks, and general coding style.

### Help
If you have any questions regarding requirements, do not hesitate to email your contact at theScore for clarification.


### Setup and Install

#### Data Prep

1. Replace thousand-comma notation from strings disguised as ints

On MacOS:
```sh
$ cat rushing.json | sed -E 's/"([1-9]),([0-9]+)"/\1\2/g' > rushing-parsed.json
```

On Unix:
```sh
$ cat rushing.json | sed -r 's/"([1-9]),([0-9]+)"/\1\2/g' > ruhsing-parsed.json
```

<!-- this is only used if using SQL to perform a COPY operation to seed the database -->
<!-- 2. Replace newlines with emptystring
This is for the sql inject since it doesn't like newlines :man_shrugging:

```sh
$ tr -d '\n' < rushing-parsed.json > compose/db/docker-entrypoint-initdb.d/seed.json
``` -->

#### Setup Database

##### Local
If you have a local instance of postgres running great! just run the `.sql` files in alphabetical order at `compose/db/docker-entrypoint-initdb.d/`.
Note, you may have to change the port since the code currently connects over port 5439.

##### Docker
Otherwise, use the available docker-compose by running:
```sh
$ docker-compose up
```
postgres should start and run the initial database creation and ingestion (assuming the data transformation is done and located at [`compose/db/docker-entrypoint-initdb.d/seed.json`](compose/db/docker-entrypoint-initdb.d/seed.json) for you.


#### Install

0. Optionall install [postgres](https://wiki.postgresql.org/wiki/Detailed_installation_guides)
NOTE: this is optional, because a docker (compose) file is provided that will run postgres as well.

1. Since we use webpack, we'll need `npm`, and thus [Nodejs](https://nodejs.org/en/download/)

2. If yarn is not installed see [yarn's homepage](https://classic.yarnpkg.com/en/docs/install), which says to do the following:
```sh
npm install --global yarn
```

3. Install dependencies
```sh
$ cd assets && yarn
```

4. Install [elixir](https://elixir-lang.org/install.html)
```sh
$ brew install elixir
```

5. Install hex and [phoenix web framework](https://hexdocs.pm/phoenix/installation.html)
```sh
$ mix local.hex
$ mix archive.install hex phx_new 1.5.8
```

6. Ensure all elixir dependies are installed
```sh
$ mix deps.get
```

7. Create and seed database
```sh
$ mix ecto.migrate
```

7. b) NOTE: if you ever want to start anew you can do the following which will drop and re-setup the database with the initial seed at using `./rushing-parsed.json`.
```sh
$ mix ecto.drop && mix ecto.setup
```

8. Done! Now we've installed Nodejs, yarn, elixir with phoenix, (optionally) postgres, and even created the database with initial seed data.

#### Run

Make sure you've done everything in Setup first.
```sh
$ ./runServer.sh
```
The server should be listening on [localhost:4000](localhost:4000)
