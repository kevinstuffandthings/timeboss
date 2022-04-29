# TimeBoss Period Specifiers
Below is a list of examples for TimeBoss period specifiers. This list is by no means comprehensive, but hopefully serves as a guide to help
you understand how to communicate with TimeBoss.

All specifiers are resolved within the context of the utilized calendar (Gregorian, Broadcast, etc).

## Absolute Periods
An "absolute" period is one that never changes, regardless of the current date. "December of 2019" always references the same time period,
regardless of what today is.

_Assuming the Broadcast calendar is in use:_
| Specifier                  | Description                         | Resolution              |
| -------------------------- | ----------------------------------- | ----------------------- |
| `2020Q3`                   | 3rd quarter of 2020                 | 6/29/2020 - 9/27/2020   |
| `2022M1`                   | 1st month of 2022                   | 12/27/2021 - 1/30/2022  |
| `2021H1M2`                 | 2nd month of the first half of 2021 | 2/1/2021 - 2/28/2021    |
| `2020W40`                  | 40th week of 2020                   | 9/28/2020 - 10/4/2020   |
| `2027`                     | 2027                                | 12/28/2026 - 12/26/2027 |
| `1999-07-31` or `19990731` | July 31, 1999                       | 7/31/1999 - 7/31/1999   |

The sub-identifiers for period granularities are:
- `D`: day
- `W`: week
- `M`: month
- `Q`: quarter
- `H`: half

## Relative Periods
A "relative" period is one that changes based on the current date. "Last week" means something different today than it will a month from now.

_Assuming today is April 29, 2022, in the Gregorian calendar:_
| Specifier       | Description                         | Resolution            |
| --------------- | ----------------------------------- | --------------------- |
| `last_month`    | March 2022                          | 3/1/2022 - 3/31/2022  |
| `this_month-2`  | February 2022                       | 2/1/2022 - 2/28/2022  |
| `this_week`     | Week of April 25, 2022              | 4/25/2022 - 5/1/2022  |
| `yesterday`     | April 28, 2022                      | 4/28/2022 - 4/28/2022 |
| `today+4`       | May 3, 2022                         | 5/3/2022 - 5/3/2022   |
| `next_year`     | 2023                                | 1/1/2023 - 12/31/2023 |

The relative prefixes can be used in conjuction with any period granularity. The terms here should be joined with the underscore (`_`) character as in the examples above.

Relative prefixes are:
- `last`
- `this`
- `next`

Period granularities are:
- `day`
- `week`
- `month`
- `quarter`
- `half`
- `year`

Accepted single-day specifiers:
- `yesterday`
- `today`
- `tomorrow`

## Compound Periods
Absolute and/or relative periods can be combined together to build "compound" periods by utilizing TimeBoss' "range" operator (`..`):

_Assuming today is April 29, 2022, in the Gregorian calendar:_
| Specifier                  | Description                                                              | Resolution            |
| -------------------------- | ------------------------------------------------------------------------ | --------------------- |
| `yesterday..today`         | Yesterday and Today                                                      | 4/28/2022 - 4/29/2022 |
| `last_quarter..this_month` | From the first day of last quarter, through the end of the current month | 1/1/2022 - 4/30/2022  |
| `this_week-2..next_week`   | From the first day of 2 weeks ago, through the last day of next week     | 4/11/2022 - 5/8/2022  |
| `2022M2..this_year`        | From the first day of February, through the last day of this year        | 2/1/2022 - 12/31/2022 |
