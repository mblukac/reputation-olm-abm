library(tidyverse)
library(reshape2)
# devtools::install_github("zeehio/facetscales")
library(facetscales)

#### 1. Employers' selection strategies under different levels of -------------
####    information asymmetry (Figure 2)

# Setup
set.seed(123)
coef_values <- c(0.004, 0.021, 0.061, 0.21)     # information asymmetry param.
complexity <- floor(seq(0, 100, 0.1))           # job complexity

# Calculate
all <- c()
results <- c()
for(i in 1:length(coef_values)){
  prob_strategy <- exp(coef_values[i] * (complexity - 50)) /
    (1 + exp(coef_values[i] * (complexity - 50)))
  all <- cbind(prob_strategy, complexity, coef = coef_values[i])
  results <- rbind(results, all)
}
results <- as.data.frame(results)

# Labels to be added
high_tau <- expression(atop("High Information",
                            "Asymmetry;" ~ tau == 0.21, ")"))
low_tau <- expression(atop("Low Information",
                           "Asymmetry;" ~ tau == 0.004, ")"))

# Plot Figure 2, panel (a)
ggplot(results, aes(y = prob_strategy, x = complexity, 
                    color = factor(log(coef)), group = coef)) +
  geom_line(size = 1.1) +
  theme_bw() +
  scale_y_continuous(breaks = c(0, 0.5, 1)) +
  scale_color_grey(start = 0.8, end = 0.2) +
  annotate("text", x = 45, y = 0.1, label = as.character(high_tau),
           size = 3.5, hjust = 0, parse = T, color = "black") +
  annotate("text", x = 5, y = 0.6, label = as.character(low_tau),
           size = 3.5, hjust = 0, parse = T, color = "grey60") +
  theme(
    legend.position = "none",
    panel.border = element_blank()
  ) +
  ylab("Relative weight") +
  xlab(expression("" ~ z[k[cent]])) +
  geom_hline(yintercept = 0) -> plot_selectionstrategy
ggsave("SelectionStrtgy_InformationAsymmetry.png", height = 3.5, width = 4.2)

# Plot Figure 2, panel (b)
# (specific example with tau == 0.061)
tau <- expression("" ~ tau == 0.061)
results %>%
  filter(coef == 0.061) %>%
  ggplot(aes(x = complexity)) +
  geom_ribbon(aes(ymin = 0, ymax = prob_strategy, 
                  fill = "Reputation"), alpha = 0.5) +
  geom_ribbon(aes(ymin = prob_strategy, ymax = 1, 
                  fill = "Bid"), alpha = 0.5) +
  scale_fill_grey() +
  geom_line(aes(y = prob_strategy)) +
  theme_bw() +
  scale_y_continuous(breaks = c(0, 0.5, 1)) +
  geom_hline(yintercept = 0.5, alpha = 0.5, linetype = 2) +
  geom_hline(yintercept = 0) +
  theme(
    legend.position = "none",
    panel.border = element_blank()
  ) +
  ylab("") +
  xlab(expression("" ~ z[k[cent]])) +
  annotate("text", hjust = 0, y = 0.9, x = 5, 
           label = "Bid", color = "white") +
  annotate("text", hjust = 1, y = 0.1, x = 95, 
           label = "Reputation", color = "black") +
  annotate("text", y = 0.03, x = 0, hjust = 0, 
           label = as.character(tau), 
           parse = T, size = 3) -> plot_selection_example

ggpubr::ggarrange(plot_selectionstrategy, plot_selection_example,
                  labels = c("(a)", "(b)"), 
                  hjust = 0) -> plot_selection_consolidated
ggsave("Vizualizations/SelectionStrtgy_Consolidated.png", 
       width = 8, height = 3.5)
  


#### 2. Earnings and number of jobs received under different levels -----------
####    of information asymmetry (Figure 3)

# Read in simulation results
data <- read.csv("20190213 RecMechOLM info_asym_auctiontype-table.csv", 
                 skip = 6)

# Data preparation
# Earnings:
data %>%
  select(coef.strategy, auction, starts_with("earn.rep")) %>%
  reshape2::melt(id = c("coef.strategy", "auction")) %>%
  mutate(Reputation = recode(variable, 
                             'earn.rep0_30' = "Low",
                             'earn.rep30_70' = "Medium",
                             'earn.rep70_100' = "High"),
         Auction = recode(auction,
                          'open' = "Open",
                          'sealed' = "Sealed"),
         value_type = "Earnings") -> data_earn
# Number of jobs:
data %>%
  select(coef.strategy, auction, starts_with("jobs.rep")) %>%
  reshape2::melt(id = c("coef.strategy", "auction")) %>%
  mutate(Reputation = recode(variable, 
                             'jobs.rep0_30' = "Low",
                             'jobs.rep30_70' = "Medium",
                             'jobs.rep70_100' = "High"),
         Auction = recode(auction,
                          'open' = "Open",
                          'sealed' = "Sealed"),
         value_type = "Number of jobs received") -> data_jobs
data_pooled <- rbind(data_earn, data_jobs)

# Different scales for earnings & number of jobs
scales_y <- list(
  Earnings = scale_y_continuous(limits = c(0, 1000)),
  'Number of jobs received' = scale_y_continuous()
)

# Plot Figure 3, panel (a)
ggplot(data_pooled, aes(y = value, x = coef.strategy, 
                        group = Reputation, color = Reputation)) +
    geom_smooth(method = "loess", span = 1, size = 0.8, se = F) +
    theme_bw() +
    xlab(expression(paste(~ tau))) +
    ylab("") +
    theme(
      legend.position = c(0.5, 0.95),
      legend.direction = "horizontal",
      legend.title = element_blank(),
      legend.justification=c(0.5, 0.5),
      legend.background = element_blank(),
      legend.key = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(face = "bold"),
      panel.border = element_blank(),
      panel.grid.minor.y = element_blank(),
      axis.ticks.y = element_blank(),
      strip.placement = "outside"
    ) +
    facetscales::facet_grid_sc(cols = vars(Auction), rows = vars(value_type), 
                               scales = list(y = scales_y), switch = "y") +
    scale_color_grey(start = 0.7, end = 0.1) +
    geom_hline(yintercept = 0, size = 0.8) -> viz_earn
ggsave("Sim_auction_All.png", height = 5.5, width = 6)


# Plot Figure 3, panel (b)
data %>%
  mutate(ratio_earnings = earn.rep70_100/earn.rep0_30,
         ratio_nrjobs = jobs.rep70_100/jobs.rep0_30) %>%
  select(coef.strategy, auction, starts_with("ratio")) %>%
  reshape2::melt(id = c("coef.strategy", "auction")) %>%
  mutate(Variable = recode(variable, 
                           'ratio_earnings' = "Earnings",
                           'ratio_nrjobs' = "Number of jobs received"),
         Auction = recode(auction,
                          'open' = "Open",
                          'sealed' = "Sealed"),
         facet_helper = " ") -> data_ratio

ggplot(data_ratio, aes(y = value, x = coef.strategy, group = Auction)) +
  geom_smooth(method = "loess", span = 1.3, se = F, linetype = "dashed",
              aes(color = Auction), size = 0.7) +
  scale_linetype_manual(values=c("solid", "dashed")) +
  facet_grid(Variable ~ facet_helper, scales = "free_y") +
  scale_y_log10(limits = c(1, 100)) +
  scale_x_continuous(limits = c(0, 0.4)) +
  theme_bw() +
  scale_color_grey(start = 0.7, end = 0.3) +
  ylab("") +
  xlab(expression(paste(~ tau))) +
  annotation_logticks(size = 0.3, sides = "l") +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(face = "bold"),
    panel.border = element_blank(),
    panel.grid.minor.y = element_blank(),
    legend.position = c(0.99, 0.99),
    legend.direction = "horizontal",
    legend.title = element_blank(),
    legend.justification=c(1,1),
    legend.background = element_blank(),
    legend.key = element_blank(),
    strip.placement = "outside"
  ) +
  geom_hline(yintercept = 0, size = 1.2) -> viz_inequality

viz_final <- ggpubr::ggarrange(viz_earn, viz_inequality, widths = c(1.5, 1), 
                               align = "h", ncol = 2, vjust = 1.05, 
                               hjust = -0.2, 
                               labels = c("(a) Simulation averages", 
                                          "(b) Inequality"),
                               font.label = list(size = 10))
ggsave("Sim_final.png", plot = viz_final, device = "png", height = 4)


#### 3. Proportion of workers who have not received any work and their
####    reputation (Figure 4)

# Load data
data_nw <- read.csv("20190213 RecMechOLM info_asym_auctiontype-table.csv", 
                    skip = 6)

# Count employees with no work
data_nw %>%
  mutate(pct_no_work = count.no.work / num.employees) %>%
  select(coef.strategy, auction, pct_no_work) %>%
  melt(id = c("coef.strategy", "auction")) -> data_cnw
# Get their average reputation
data_nw %>%
  select(coef.strategy, auction, meanrep.no.work) %>%
  melt(id = c("coef.strategy", "auction")) -> data_rep_cnw

# Pool data together and prepare for plotting
data_nw_pooled <- rbind(data_cnw, data_rep_cnw) %>%
  mutate(Variable = recode(variable,
                           'pct_no_work' = "% without jobs",
                           'meanrep.no.work' = "Mean reputation"),
         Auction = recode(auction,
                          'open' = "Open",
                          'sealed' = "Sealed"))

# Plot Figure 4
ggplot(data_nw_pooled, aes(y = value, x = coef.strategy, 
                           color = Auction, group = Auction)) +
  geom_smooth(method = "loess", span = 1, se = F) +
  theme_bw() +
  geom_hline(aes(yintercept = 50),
             data = subset(data_nw_pooled, variable == "meanrep.no.work"),
             linetype = "dashed") +
  facet_wrap(. ~ Variable, scales = "free_y", shrink = F) +
  xlab(expression(paste(~ tau))) +
  ylab("") +
  scale_x_continuous(limits = c(0, 0.4)) +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(face = "bold"),
    panel.border = element_blank(),
    panel.grid.minor.x = element_blank(),
    legend.position = c(0.98, 0.98),
    legend.direction = "horizontal",
    legend.title = element_blank(),
    legend.justification=c(1,1),
    legend.background = element_blank(),
    legend.key = element_blank()
  ) +
  geom_hline(aes(yintercept = 0),
             data = subset(data_nw_pooled, variable == "pct_no_work")) +
  geom_hline(aes(yintercept = 30),
             data = subset(data_nw_pooled, variable == "meanrep.no.work")) +
  scale_color_grey()
ggsave("Sim_auction_NoWork.png", height = 3, width = 5.5)
