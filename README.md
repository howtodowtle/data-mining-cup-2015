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
- Data: historical order data from an online shop
- Targets:
  - 3 different coupons (binary classification: redempted or not?)
  - basekt value (regression)

### Evaluation

The predictions were evaluated using a custom evluation function:

![DMC 2015 evaluation function](https://i.imgur.com/358nhuN.png)

This function looked harmless at first but had many implications:
- 3 parts of the sum relate to the coupons, 1 to the basket value
- Errors in the coupon predictions are weighted inversely to that coupon's average redemption. (E.g. errors for a coupon that is redempted 20 % of the time are much more costly than errors for a coupon that is redempted 70 % of the time.)
- 

### Our Approach


More details in our report and short slide deck.

### Final Ranking

1. HU Berlin 2 (Germany)
2. Iowa State 2 (USA)
3. Iowa State 1 (USA)
4. École Polytechnique Fédérale De Lausanne (Switzerland)
5. École Polytechnique Fédérale De Lausanne (Switzerland)
6. HU Berlin 1 (Germany)
7. Gadjah-Mada (Indonesia)
8. U Marburg (Germany)
9. TU Dortmund (Germany)
10. KIT (Germany)

### 

