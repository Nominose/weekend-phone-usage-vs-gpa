# ------------------------------
# Project: Weekend Phone Usage vs Academic Performance (9th Grade Only)
# Language: R
# ------------------------------

# Load required libraries
library(readr)
library(dplyr)
library(ggplot2)

# ------------------------------
# Step 0: Load and Filter Data
# ------------------------------
# Load the dataset
data <- read_csv("C:/Users/ROG/Desktop/Project/teen_phone_addiction_dataset.csv")

# Filter to include only 9th grade students and select the first 2000 rows
# This is to comply with laptop performance constraints
data <- data %>%
  filter(School_Grade == "9th") %>%
  head(2000) %>%
  select(Weekend_Usage_Hours, Academic_Performance)

# ------------------------------
# Step 1: Remove Outliers (based on IQR)
# ------------------------------
# Define a function to remove outliers using the Interquartile Range (IQR) method
remove_outliers <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  return(x >= lower & x <= upper)
}

# Apply the IQR filter to both Weekend_Usage_Hours and Academic_Performance
data <- data %>%
  filter(remove_outliers(Weekend_Usage_Hours) & remove_outliers(Academic_Performance))

# ------------------------------
# Step 2: Create Usage Group (High vs Low)
# ------------------------------
# Divide the dataset into two groups: High and Low usage
# based on the median value of Weekend_Usage_Hours
median_usage <- median(data$Weekend_Usage_Hours, na.rm = TRUE)

data <- data %>%
  mutate(Usage_Group = ifelse(Weekend_Usage_Hours > median_usage, "High", "Low"))

# ------------------------------
# Step 3: Histogram of Weekend Usage Hours
# ------------------------------
# Visualize the distribution of Weekend_Usage_Hours
# Dashed red line shows the median used for grouping
ggplot(data, aes(x = Weekend_Usage_Hours)) +
  geom_histogram(binwidth = 0.5, fill = "skyblue", color = "black") +
  geom_vline(xintercept = median_usage, linetype = "dashed", color = "red") +
  labs(title = "Distribution of Weekend Phone Usage (Filtered by IQR)",
       x = "Weekend Phone Usage (hours)", y = "Frequency") +
  theme_minimal()

# ------------------------------
# Step 4: Boxplot of Academic Performance by Group
# ------------------------------
# Compare GPA distributions between High and Low usage groups
ggplot(data, aes(x = Usage_Group, y = Academic_Performance, fill = Usage_Group)) +
  geom_boxplot() +
  labs(title = "Academic Performance by Weekend Usage Group (Filtered)",
       x = "Weekend Phone Usage Group", y = "Academic Performance") +
  theme_minimal()

# ------------------------------
# Step 5: Bar Chart of Mean GPA by Group
# ------------------------------
# Show the average GPA for each group
data %>%
  group_by(Usage_Group) %>%
  summarise(mean_gpa = mean(Academic_Performance, na.rm = TRUE)) %>%
  ggplot(aes(x = Usage_Group, y = mean_gpa, fill = Usage_Group)) +
  geom_col() +
  labs(title = "Mean GPA by Weekend Usage Group (Filtered)",
       x = "Usage Group", y = "Mean GPA") +
  theme_light()

# ------------------------------
# Step 6: Scatter Plot + Linear Regression
# ------------------------------
# Investigate whether higher weekend phone usage is associated with lower GPA
# Use linear regression to observe the trend
# If the regression line slopes downward, it suggests a negative relationship
ggplot(data, aes(x = Weekend_Usage_Hours, y = Academic_Performance)) +
  geom_point(alpha = 0.5) +  # Each point is one student
  geom_smooth(method = "lm", color = "blue", se = FALSE) +  # Regression line
  labs(title = "GPA vs Weekend Phone Usage (with Linear Regression)",
       x = "Weekend Phone Usage (hours)", y = "Academic Performance") +
  theme_classic()

# Build the linear regression model
model <- lm(Academic_Performance ~ Weekend_Usage_Hours, data = data)

# Print summary of the model
print(model)

# ------------------------------
# Step 7: T-test for Group Difference
# ------------------------------
# Perform a two-sample t-test to check if GPA is significantly different
# between High and Low phone usage groups
# A p-value < 0.05 suggests the difference is statistically significant
t_result <- t.test(Academic_Performance ~ Usage_Group, data = data)
cat("\nT-test Results:\n")
print(t_result)
