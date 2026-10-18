# Data Quality Note — Downtime Categories

## Finding

For plant PLT-004 and work center WC-039:
- Total unplanned downtime: **1,851.43 minutes**
- Sum of six recorded downtime categories: **1,658.20 minutes**
- Unreconciled difference: **193.23 minutes**

Category totals:
- Mechanical: 918.0 minutes
- Electrical: 316.4 minutes
- Tooling: 190.6 minutes
- Quality hold: 96.3 minutes
- Material: 74.9 minutes
- Operator: 62.0 minutes

Mechanical downtime represents approximately **55.4% of the categorized total** (918 / 1,658.2).

## Validation

The discrepancy was present in the source data and was not introduced by the Power Query merge. Category-level totals should not be presented as a complete reconciliation of total unplanned downtime.

## Recommended follow-up

1. Review maintenance logs and failure records for WC-039 at PLT-004.
2. Investigate recurring mechanical stoppages.
3. Reconcile the 193.23-minute difference against the original event records.
4. Review data-entry and category-coding rules to prevent future discrepancies.
