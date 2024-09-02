---
perevir:
  filters:
  - cito.lua
  metastrings-to-inlines: true
---

``` markdown {#input}
# Abstract

This is an example article. It was written under the influence of
coffee, which acts to counter fatigue [@cites_as_evidence:Li95].

# Further reading

Authors struggling to fill their document with content are referred to
@recommended_reading:Upper_writers_1974.
```

``` markdown {#expected}
---
cito_cites:
  citesAsEvidence:
  - Li95
  citesAsRecommendedReading:
  - Upper_writers_1974
---

# Abstract

This is an example article. It was written under the influence of
coffee, which acts to counter fatigue [@Li95].

# Further reading

Authors struggling to fill their document with content are referred to
@Upper_writers_1974.
```
