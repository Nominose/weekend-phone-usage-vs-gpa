# Weekend Phone Usage vs Academic Performance (9th Grade Only)

This project explores whether weekend smartphone usage affects academic performance (GPA) among 9th grade students.

## Files
- `phone_usage_analysis_with_comments.R`: R script for data cleaning, visualization, and hypothesis testing
- `teen_phone_addiction_dataset.csv`: Raw dataset
- `Final Project.pdf`: Final report (detailed analysis)
- `Final Project.pptx`: Presentation slides

## Methods
- Outlier removal using Interquartile Range (IQR)
- Group classification (High vs Low phone usage based on median)
- Visualizations (Histogram, Boxplot, Bar chart, Regression line)
- Linear Regression modeling
- Two-sample T-test for group comparison

## Results
- **Linear regression**: slope ≈ 0, p = 0.885, R² ≈ 0 → no predictive power
- **T-test**: p = 0.7264 → no significant GPA difference between high vs low usage groups
- Conclusion: Weekend phone usage is **not** a strong predictor of GPA for 9th grade students.
