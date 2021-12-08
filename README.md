# Domain of Interest:  Olympics

* **Why are you interested in this field/domain?**

Sports are integral parts of our lives—not only are they beneficial to maintaining good health but also as sources of enjoyment when we watch athletes compete on Television. Due to the COVID-19 pandemic, the _2020 Tokyo Olympics_ have been postponed for a year, coming to a close in the summer of 2021.

We are interested in Olympics data fields as most of our group members are sports fans. We wish to understand the specific features of Olympic athletes, as well as the significance of physical determinants in different sports. Analyzing these will give us holistic information of the actual performances based on categories, which may contribute to eliminating stereotypes in sports-based discussions.

* **What other examples of data driven projects have you found related to this domain?**

1. [Visual Analysis of Olympics Data: ](https://towardsdatascience.com/visual-analysis-of-olympics-data-16273f7c6cf2)How do different factors come into play into winning Olympics medals?\
This project investigates the relationship between a country's Olympic performance and its overall economic condition, including population, economic resources, and political structures.

2. [Olympic history data:](https://www.kaggle.com/heesoo37/olympic-history-data-a-thorough-analysis)\
An analysis of data including the number of athletes, sports, nations, who win medals, and characteristics of the athletes.

3. [Team vs Individual:](https://www.kaggle.com/aliaamiri/team-vs-individul-olympic-medals) Olympic Medals\
This article investigates whether the Olympics really promote or punish team sports, using the Tokyo 2020 dataset.

* **What data-driven questions do you hope to answer about this domain?**


Olympics data are _large-scaled_. In order to gain a broad image of the events, we should first ask general questions such as:

- Throughout history, which country has won the most medals?
- What percentage of athletes are male or female?
- What are the sports that each country is good at?

Then we can move on to some inquiry-driven questions:

- What effects does economics or society have on medals won?
- What effect does the host country have on the medals won at the Olympics?
- What are the main physical characteristics of each sport? Which sport requires the most height or weight?
- What is the career expectancy of each sport? Which has the oldest or youngest athletes?
- What is the relationship between athletes' physical characteristics and performance over time? In what aspects have athletes become better?

# Finding Data

* **Where did you download the data?**

  + [Source 1: ](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results)120 years of Olympic history: athletes and results
  + [Source 2: ](https://www.kaggle.com/arjunprasadsarkhel/2021-olympics-in-tokyo)2021 Olympics in Tokyo
  + [Source 3: ](https://www.kaggle.com/divyansh22/summer-olympics-medals)Summer Olympics Medals (1976-2008)
  + [Source 4: ](https://www.kaggle.com/ramontanoeiro/summer-olympic-medals-1986-2020/version/1)Summer Olympic Medals (1896 - 2020) - Less column information than the last one

* **How was the data collected or generated? Make sure to explain who collected the data (not necessarily the same people that host the data), and who or what the data is about?**

  + **Source 1**: The data was collected by a group of Olympic history enthusiasts and self-proclaimed “statistorians” at sports-reference.com. This dataset is the historical Olympic dataset from 1896-2016. It contains columns such as the names, countries represented, disciplines, and genders of every Olympic athlete.
  + __Source 2__: This dataset is collected from the Tokyo Olympics 2020 Website by a Kaggle expert, Arjun Prasad Sarkhel. It mainly contains detailed information about over 11,000 athletes with 47 disciplines.  along with 743 Teams taking part in the 2020 Tokyo Olympics. In addition, the dataset collects details about coaches and teams. Names, countries represented, discipline, gender of competitors, and name of the coaches are all included in.
  + __Source 3__: This source, collected by Divyansh Agrawal, is a list of all medal winners from the 1976 to 2008 Olympics, including every medal awarded and the corresponding sports events within this period and the athletes’ basic information.
  + __Source 4__: The dataset, scraped from Wikipedia pages by Ramon Tanoeiro, a Kaggle contributor, comprises information on all medals won by countries that have participated in the Olympic games all the way from 1896 to 2020, including the numbers of gold, silver, and bronze medals and the hosting locations.

* **How many observations (rows) are in your data?**

  + __Source 1__: 271,116 rows.
  + __Source 2__: 5 files with a total of 12361 rows
  + __Source 3__: 15433 rows
  + __Source 4__: 1344 rows

* **How many features (columns) are in the data?**

  + __Source 1__: 15 columns in total
  + __Source 2__: 5 files with a total of 22 columns
  + __Source 3__: 11 columns
  + __Source 4__: 1 column

* **What questions (from above) can be answered using the data in this dataset?**

  + __Source 1:__
    + Throughout history, which country has won the most medals?
    + What percentage of athletes are male, or female?
    + Which country participates the most in the Olympics?
    + What are the sports that each country is good at?
    + What are the physical characteristics of athletes in each sport? Which sport requires the most height or weight?
    + What is the career expectancy of each sport? Which has the oldest or youngest athletes?
    + With the progress of society, what is the relationship between athletes' physical characteristics and performance over time?
    + In what aspects have athletes become better over time?

  + __Source 2:__
    + What percentage of athletes are male or female?
    + What are the sports that each country is good at?

  + __Source 3:__
    + What percentage of athletes are male or female?
    + What are the sports that each country is good at?
    + What effect does the host country have on the medals won at the Olympics?

  + __Source 4:__
    + What effect does the host country have on the medals won at the Olympics?
    + Throughout history, which country has won the most medals?
