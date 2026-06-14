# PartKeeper database migration report — schema 23

## Canonical magnetic-components category

The previous categories `Inductors`, `Coils`, `Дроссели` and `Ферритовые фильтры`
were merged into one canonical English category:

`Inductors, Coils and Chokes`

This name is used consistently by the application, parser, merge validation,
SQLite category dictionary and migration aliases.

## Actual database migration

- Schema: `21` → `23`
- Components: `407` → `407`
- Lots: `430` → `430`
- Total quantity: `67938` → `67938`
- UUIDs preserved: `407 / 407`
- Unknown categories sent to quarantine: `0`
- Category values normalized: `146`

### Applied mappings

| Original category | Canonical category | Components |
|---|---|---:|
| Конденсаторы керамические | Capacitors | 57 |
| Дроссели | Inductors, Coils and Chokes | 17 |
| Резисторы | Resistors | 15 |
| Inductors | Inductors, Coils and Chokes | 12 |
| Конденсаторы танталовые | Capacitors | 8 |
| Стабилизаторы напряжения | Integrated Circuits - PMIC | 8 |
| TVS-диоды и ESD-защита | Protection Devices | 7 |
| Диоды Шоттки | Semiconductors - Diodes | 6 |
| Светодиоды | Optoelectronics - LEDs | 3 |
| Драйверы светодиодов | Integrated Circuits - Drivers | 2 |
| ИК-светодиоды | Optoelectronics - LEDs | 2 |
| Операционные усилители | Integrated Circuits - Op Amps and Comparators | 2 |
| Стабилитроны | Semiconductors - Diodes | 2 |
| Coils | Inductors, Coils and Chokes | 1 |
| Микроконтроллеры и радиосистемы | Integrated Circuits - Embedded | 1 |
| Преобразователи DC/DC | Integrated Circuits - PMIC | 1 |
| Транзисторы | Semiconductors - Transistors | 1 |
| Ферритовые фильтры | Inductors, Coils and Chokes | 1 |

## Integrity checks

- `PRAGMA foreign_key_check`: no violations
- `PRAGMA quick_check`: `ok`
- Rebuild from `schema.sql` + `data.sql`: successful
- Automated tests: 10 passed

## Remaining language cleanup

Category names are now entirely English. Other free-text fields were deliberately
left unchanged because translating technical descriptions without verifying each
MPN could damage data. The current database still contains Cyrillic in some
component descriptions, values, package text and notes. This should be handled as
a separate verified-data cleanup pass.
