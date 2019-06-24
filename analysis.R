#load database
countries <- read.csv('./data/countries.csv', row.names = 1)
lat_long <- read.csv('./data/lat_long.csv', row.names = 1)
leagues <- read.csv('./data/leagues.csv', row.names = 1)
matches0 <- read.csv('./data/matches.csv', row.names = 1)
player_attributes <- read.csv('./data/player_attributes.csv', row.names = 1)
players <- read.csv('./data/player.csv', row.names = 1)
sequence <- read.csv('./data/sequence.csv', row.names = 1)
team_attributes <- read.csv('./data/team_attributes.csv', row.names = 1)
teams <- read.csv('./data/teams.csv', row.names = 1)
values <- read.csv('./data/values.csv', row.names = 1)

# p1
library(dplyr)
games <- matches %>%
  select(season, home_team_api_id,home_team_goal,away_team_goal) %>%
  mutate(win = ifelse(home_team_goal > away_team_goal, 'win', 'lose'))

games <- games %>%
  group_by(season, home_team_api_id, win) %>%
  count()
# win percentage of every team
games1 <- left_join(games, select(teams,team_api_id, team_long_name, team_short_name), by = c("home_team_api_id" = "team_api_id"))

library(tidyverse)
games1 <- games1 %>%
  spread(win, n) %>%
  mutate(total_game = lose + win) %>%
  mutate(win_pctg = win / total_game) 

games1 <- games1 %>% 
  separate(col = season, sep = '/', into = c('start','end'),remove = FALSE) %>%
  left_join(., select(teams, team_short_name, country), by = "team_short_name")


write.csv(games1, './data/q1.csv')

library(plotly)

g <- games1 %>%
  filter(team_short_name == 'ACA' & start %in% 2010:2017) %>%
  ggplot2::ggplot(., aes(x = season, y = win_pctg)) + 
  geom_line(group = 1) + geom_point(size=2, shape=20)
  
 
#ggplotly(ggplot2::ggplot(x = season, y = win_pctg))
ggplotly(g)


leagues <- leagues %>%
  left_join(., countries, by = c("id","id")) %>%
  rename(., name_league = name.x, name_country = name.y) %>%
  left_join(., select(lat_long, latitude, longitude, name), c("name_country","name"))



games1 %>%
  filter(start %in% 2010:2017 & country == "Poland" & team_short_name %in% c('CHO','BIA')) %>%
  ggplot(., aes(x = season, y = win_pctg)) + 
  geom_line(aes(group = team_short_name, color = team_short_name)) + 
  geom_point(size=2, shape=20, aes(color = team_short_name)) +
  theme(legend.position="bottom", legend.box = "horizontal")
  
unique(q1$country)

unique(filter(q1,country %in% c('Poland',' Belgium'))$team_short_name)



players <- player_attributes %>%
  separate(col = date, sep = ' ', into = c('date','time')) %>%
  select(-time, -id)


players <- players %>%
  left_join(., player, by = c("player_api_id", "player_api_id"))


q2 <- q2 %>%
  separate(col = birthday, sep = ' ', into = c('date','time')) %>%
  separate(col = date, sep = '-', into = c("year", "month", "day")) %>%
  select(-time, -month, -day)
  
q2_1 <- q2 %>%
  group_by(player_name, weight, height, year, preferred_foot) %>%
  summarise(overall_rating = round(mean(overall_rating),2), potential =  round(mean(potential),2)) %>%
  rename(birthday = year)

write.csv(q2_1 , './data/q2_1.csv')

write.csv(players,'./data/playername.csv' )




hw <- matches %>%
  select(season, home_team_goal, away_team_goal) %>%
  separate(season, into = c('start', 'end'), sep = '/') %>%
  mutate(win = ifelse(home_team_goal > away_team_goal, 'home win', ifelse(home_team_goal < away_team_goal, 'away win', 'draw'))) %>%
  group_by(start,win) %>%
  count() 

write.csv(hw, './data/q3.csv')

ggplot() +
  geom_col(data = hw, aes(x = start, y = n, fill = win), position = "dodge")



q4 <- matches %>%
  mutate(goal = home_team_goal + away_team_goal) %>%
  select(country_id, season, goal) %>%
  left_join(., countries, by = c("country_id"="id"))

write.csv(q4, './data/q4.csv')


library(RColorBrewer)
display.brewer.all()

q4 %>%
  group_by(name, season) %>%
  summarise(goal = sum(goal), n = n()) %>%
  ggplot() +
  geom_col(aes(x = season, y = goal, fill = name), position = "dodge") +
  scale_fill_brewer(
    palette = "Set3") 

library(tidyverse)
library(forcats)

t <- q4 %>%
  group_by(name) %>%
  count() 

t$name <- factor(t$name, levels = t$name[order(t$n)])

t%>%
  ggplot() +
  geom_col(aes(x = name, y = n,fill = name)) +
  scale_fill_brewer(
    palette = "Set3") +
  coord_flip() + theme(legend.position = "top")


players <- players %>%
  separate(col = birthday, into = c("date","time"), sep = ' ') %>%
  separate(col = date, into = c("year","month","day"), sep = '-') %>%
  select(-month, -day, -time)

player <- player_attributes %>%
  separate(col = birthday, into = c("date","time"), sep = ' ') %>%
  separate(col = date, into = c("year","month","day"), sep = '-') %>%
  select(-month, -day, -time) %>%
  left_join(players, by = c("player_api_id" = "player_api_id"))

player <- player %>%
  mutate(age = as.integer(year.x) - as.integer(year.y)) %>%
  select(-1, -2, -3, -4, -7, -8, -9, -46, -45, -43)

model <- lm(formula = overall_rating~.-player_name-potential, data = player)
coe <- summary(model)$coefficients[,1]
coe <- data.frame(coe)
coe$index <- c("Intercept", "crossing", "finishing","heading_accuracy","short_passing","volleys","dribbling","curve",
             "free_kick_accuracy","long_passing","ball_control","acceleration","sprint_speed","agility","reactions",
             "balance","shot_power","jumping","stamina","strength","long_shots","aggression","interceptions",
             "positioning","vision","penalties","marking","standing_tackle","sliding_tackle","gk_diving","gk_handling",
             "gk_kicking","gk_positioning","gk_reflexes","height","weight","age")

rownames(coe) <- 1:nrow(coe)

write.csv(coe[-1,], './data/coe.csv')


ggplot(coe[-1,]) +
  geom_col(aes(x = index, y = coe, fill = index)) + coord_flip() + theme(legend.position = "none") 
  
value_win <- value_win %>%
  filter(!is.na(home_player_1) | !is.na(home_player_2) | !is.na(home_player_3) | !is.na(home_player_4)  
         | !is.na(home_player_5) | !is.na(home_player_6) | !is.na(home_player_7) | !is.na(home_player_8)
         | !is.na(home_player_9) | !is.na(home_player_10) | !is.na(home_player_11))


values_year_nation <- values %>%
  group_by(Clubs, Seasons, Nations) %>%
  summarise(Value = sum(Values) / n()) %>%
  filter(Nations %in% c("Belgium","England","France","Germany" ,"Italy" ,"Netherlands","Poland" ,"Portugal","Scotland","Spain","Switzerland"))


value_win <- value_win %>%
  group_by(season, team_long_name, country, win) %>%
  count() %>%
  spread(win,n) %>%
  mutate(win_pctg = win/(win+`not win`))


values_year_nation <- values_year_nation %>%
  separate(Seasons, into = c("start","end"), sep = '/') %>%
  mutate(start = 2000 + as.numeric(start), end = 2000 + as.numeric(end)) %>%
  mutate(start = as.character(start), end = as.character(end))

value_win <- value_win %>%
  separate(season, into = c("start","end"), sep = '/')


test <- inner_join(value_win, values_year_nation, c("start" = "start", "end" = "end", "team_long_name" = "Clubs"))
write.csv(test, './data/value.csv')

ggplot(test, aes(x = Value, y = win_pctg)) + 
  geom_point(aes(color = country))





