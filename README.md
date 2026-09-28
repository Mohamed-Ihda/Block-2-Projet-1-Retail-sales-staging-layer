# Block-2-Projet-1-Retail-sales-staging-layer
End-to-end data staging layer built in Microsoft Fabric with Dataflow Gen2 and Data Pipelines. Ingests eight messy CSV sources into a lakehouse, cleans and conforms them into dimension and fact tables, and orchestrates the load on a schedule. DP-700 practice project.

# Block 2 — Project 1: Retail Sales Staging Layer

A low-code ETL solution built in Microsoft Fabric, part of my DP-700
(Fabric Data Engineer Associate) preparation.

## What it does

Takes eight CSV files from four simulated source systems — a POS export,
a CRM extract, an ERP item master and reference data — and produces a
clean staging layer of five dimension tables and one fact table in a
lakehouse, loaded on a daily schedule.

## Built with

- **Dataflow Gen2** — six dataflows handling ingestion and transformation
- **Data Pipeline** — orchestration with parallel branches and dependencies
- **Lakehouse** — Delta tables as the destination
- **Scheduling and monitoring** — daily refresh, run history

## The interesting part

The source data is deliberately dirty: 26 known defects including mixed
date formats across files, a semicolon-delimited source with comma
decimals, junk header rows, near-duplicate customer records, orphan
foreign keys and — the one worth noting — whitespace and case drift in a
join key that silently drops rows from a merge without raising an error.

See `data/project1/README.md` for the full defects log.

## Output

| Table | Rows | Type |
|---|---|---|
| dim_category | 8 | dimension |
| dim_store | 6 | dimension |
| dim_supplier | 6 | dimension |
| dim_customer | 30 | dimension |
| dim_product | 201 | dimension |
| fact_transaction | ~12,480 | fact |
