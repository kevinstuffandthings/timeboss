# TimeBoss Period Specifiers
Below is a list of examples for TimeBoss period specifiers. This list is by no means comprehensive, but hopefully serves as a guide to help
you understand how to communicate with TimeBoss.

All specifiers are resolved within the context of the utilized calendar (Gregorian, Broadcast, etc).

## Simple Absolute Periods
An "absolute" period is one that never changes, regardless of the current date. "December of 2019" always references the same time period,
regardless of what today is.

| Specifier       | Description                         | Details                                              |
| --------------- | ----------------------------------- | ---------------------------------------------------- |
| `2020Q3`        | 3rd quarter of 2020                 |                                                      |
| `2022M1`        | 1st month of 2022                   |                                                      |
| `2021H1M2`      | 2nd month of the first half of 2021 | When using "nested periods", go from broad -> narrow |
| `2020W40`       | 40th week of 2020                   |                                                      |
| `2027`          | 2027                                |                                                      |

The sub-identifiers for period granularities are:
- `D`: day
- `W`: week
- `M`: month
- `Q`: quarter
- `H`: half

## Simple Relative Periods
A "relative" period is one that changes based on the current date. "Last week" means something different today than it will a month from now.

_Assuming today is April 29, 2022, in the Gregorian calendar:_
| Specifier       | Description                         |
| --------------- | ----------------------------------- |
| `last_month`    | March 2020                          |
| `this_week`     | Week of April 25, 2022              |
| `yesterday`     | April 28, 2022                      |
| `next_year`     | 2023                                

The relative prefixes (`last`, `this`, `next`) can be used in conjuction with any period granularity (`day`, `week`, etc). The terms here should be joined with the underscore (`_`) character as in the examples above.

## Compound Periods
Absolute and/or relative periods can be combined together to build "compound" periods by utilizing TimeBoss' "range" operator (`..`):

| Specifier                  | Description                                                              |
| -------------------------- | ------------------------------------------------------------------------ |
| `yesterday..today`         | Yesterday and Today                                                      |
| `last_quarter..this_month` | From the first day of last quarter, through the end of the current month |
| `this_week-2..next_week`   | From the first day of 2 weeks ago, through the last day of next week     |
| `2022M2..this_year`        | From the first day of February, through the last day of this year        |
