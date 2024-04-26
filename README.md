# DataExploration

## Information

Data collected from https://ourworldindata.org/covid-deaths, used PostgreSQL to explore data from the .csv by making queries and tables that are used in Tableau to visualize them better.

## Public Tableau Link

https://public.tableau.com/app/profile/muhammad.qamar4141/viz/DataExploration_17140942788300/Dashboard1?publish=yes 

## Tables used for Visualization

⁤1. The SQL query creates a table named `max_new_cases_deaths` to present an overview of the largest number of new COVID-19 cases and fatalities in a given day per location. ⁤⁤This approach is especially relevant for extracting the maximum value on a daily basis for the location where the cases and deaths peaked. ⁤⁤The view can be treated as a usual table for data analysis and visualization, it can be queried sort of regularly. ⁤⁤This view is based on the data found in the table, which contains data from COVID-19, and that data for each date and location is placed in different rows. ⁤⁤Each location's max values are calculated in parallel. ⁤⁤Through this measure, the assessment of the spread of the COVID-19 disease outbreak in different locations can be assessed. ⁤The map that is shown was used for this.
2. ⁤The SQL code builds a named view `percent_population_vaccinated` which will be utilized in future visualizations. ⁤⁤This visualization encompasses the continent, location, date, population, and number of vaccinations administered on that date along with the total number of people vaccinated till that date for each location. ⁤⁤The vaccinations total is determined using the window function, cumulative number of vaccinations. ⁤⁤Such an approach is particularly suited for determining the dynamics of COVID-19 vaccinations in different areas and over time in the same place. ⁤The bar graphs and the percentile graph are shown using this table.
