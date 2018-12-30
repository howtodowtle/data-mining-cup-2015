# Winning the Data Mining Cup 2015

Our team of students from Humboldt-Universität zu Berlin (HU Berlin) in the course "Applied Predictive Analytics" of [Professor Lessmann](https://www.wiwi.hu-berlin.de/de/professuren/bwl/wi/personen/hl) won the international machine learning competition Data Mining Cup in 2015.

![DMC 2015 winners!](https://www.data-mining-cup.com/wp-content/uploads/data-mining-cup-2015_winning-team_humboldt-uni-berlin-1200x801.jpg)

## The Competition

A short overview over the competition task and the datasets can be found on the [competition website](https://www.data-mining-cup.com/reviews/dmc-2015/).

### Task

- Setting: Coupons in online shops
- Questions: 
  - “Who responds to coupons?”
  - “What is the impact on the basket value?”
- **Data: historical order data from an online shop**
  - Original/raw features (28): 
    - order ID, order time, user ID
    - product data (price, categorgy, product line, premium product?, ...)
    - coupon data (ID, time of generation)
    - An overview over all provided features was part of the provided task description (link).
  - Targets (4):
    - 3 different coupons (binary classification: redempted or not?)
    - basekt value (regression)

### Evaluation

The predictions were evaluated using a custom evluation function:

![DMC 2015 evaluation function](https://i.imgur.com/358nhuN.png)

This function looked harmless at first but had many implications:
- 3 parts of the sum relate to the coupons, 1 to the basket value
- Errors in the coupon predictions are weighted inversely to that coupon's average redemption. (E.g. errors for a coupon that is redempted 20 % of the time are much more costly than errors for a coupon that is redempted 70 % of the time.)
- It seemed important to detect very large basket value outliers in the test data since these had a potentially huge impact while basket values close to the mean almost would not matter. *(This is where our hand-crafted econometric models outperformed the machine learning models and might have given us the edge over teams only applying standard machine learning tools.)*

### Our Approach

We believe our success in this competition can be ascribed to:
- Great guidance in the process by Professor Lessmann (no help apart from general advice, as this was a student only competition).
- Loose division of responsibilities: This enabled parts of the team to start training models right away while new data sets kept coming from the feature engineering team and everyone got more insight into the specifics of the task.
- A very deep dive into the data and extensive feature engineering.
- Training lots of machine learning models.
- Forecast combination of machine learning and econometric approaches using hold-out data.
- A good portion of luck. :)

More details in our report and short slide deck.

### Final Ranking

1. **HU Berlin 2 (Germany)**
2. Iowa State 2 (USA)
3. Iowa State 1 (USA)
4. École Polytechnique Fédérale De Lausanne (Switzerland)
5. École Polytechnique Fédérale De Lausanne (Switzerland)
6. HU Berlin 1 (Germany)
7. Gadjah-Mada (Indonesia)
8. U Marburg (Germany)
9. TU Dortmund (Germany)
10. KIT (Germany)

