if (!require("pacman")) install.packages("pacman")
 pacman::p_load(tidyverse, rvest, lubridate, janitor, data.table, hrbrthemes)
 theme_set(hrbrthemes::theme_ipsum())
 m100 = read_html("http://en.wikipedia.org/wiki/Men%27s_100_metres_world_record_progression")
 m100
 pre_iaaf =
   m100 %>%
   html_element("div+ .wikitable :nth-child(1)") %>% 
   html_table() 
 pre_iaaf
 pre_iaaf =
   pre_iaaf %>%
   clean_names() %>% 
   mutate(date = mdy(date)) 
 pre_iaaf
 iaaf_76 =
   m100 %>%
   html_element("#mw-content-text > div > table:nth-child(14)") %>%
   html_table()
 iaaf_76 =
   iaaf_76 %>%
   clean_names() %>%
   mutate(date = mdy(date))
 iaaf_76
 iaaf =
   m100 %>%
   html_element("#mw-content-text > div > table:nth-child(19)") %>%
   html_table() %>%
   clean_names() %>%
   mutate(date = mdy(date))
 iaaf
 wr100 =
   rbind(
     pre_iaaf %>% select(time, athlete, nationality, date) %>% mutate(era = "Pre-IAAF"),iaaf_76 %>% select(time, athlete, nationality, date) %>% mutate(era = "Pre-automatic"),
     iaaf %>% select(time, athlete, nationality, date) %>% mutate(era = "Modern")
   )
 wr100
 wr100 %>%
   ggplot(aes(x=date, y=time, col=fct_reorder2(era, date, time))) +
   geom_point(alpha = 0.7) +
   labs(
     title = "Men's 100m world record progression",
     x = "Date", y = "Time",
     caption = "Source: Wikipedia"
   ) +
   theme(legend.title = element_blank()) 
 