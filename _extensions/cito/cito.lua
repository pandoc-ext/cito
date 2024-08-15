-- Copyright © 2017–2022 Albert Krewinkel, Robert Winkler,
--+          © 2023-2024 Albert Krewinkel, Egon Willighagen
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.

local _version = '1.1.0'
local properties_and_aliases = {
  agreesWith = {
    'agreeWith',
    'agree_with',
    'agrees_with',
  },
  citation = {
  },
  cites = {
  },
  citesAsAuthority = {
    'asAuthority',
    'cites_as_authority',
    'as_authority',
    'authority'
  },
  citesAsDataSource = {
    "asDataSource",
    "dataSource",
    'cites_as_data_source',
    "as_data_source",
    "data_source"
  },
  citesAsEvidence = {
    'asEvidence',
    'cites_as_evidence',
    'as_evidence',
    'evidence'
  },
  citesAsMetadataDocument = {
    'asMetadataDocument',
    'metadataDocument',
    'cites_as_metadata_document',
    'as_metadata_document',
    'metadata_document',
    'metadata'
  },
  citesAsPotentialSolution = {
    'cites_as_potential_solution',
    'potentialSolution',
    'potential_solution',
    'solution'
  },
  citesAsRecommendedReading = {
    'asRecommendedReading',
    'recommendedReading',
    'cites_as_recommended_reading',
    'as_recommended_reading',
    'recommended_reading'
  },
  citesAsRelated = {
    'cites_as_related',
    'related',
  },
  citesAsSourceDocument = {
    'cites_as_source_document',
    'sourceDocument',
    'source_document'
  },
  citesForInformation = {
    'cites_for_information',
    'information',
  },
  compiles = {
  },
  confirms = {
  },
  containsAssertionFrom = {
  },
  corrects = {
  },
  credits = {
  },
  critiques = {
  },
  derides = {
  },
  describes = {
  },
  disagreesWith = {
    'disagrees_with',
    'disagree',
    'disagrees'
  },
  discusses = {
  },
  disputes = {
  },
  documents = {
  },
  extends = {
  },
  includesExcerptFrom = {
    'excerptFrom',
    'excerpt',
    'excerpt_from',
    'includes_excerpt_from',
  },
  includesQuotationFrom = {
    'quotationFrom',
    'includes_quotation_from',
    'quotation',
    'quotation_from'
  },
  linksTo = {
    'links_to',
    'link'
  },
  obtainsBackgroundFrom = {
    'backgroundFrom',
    'obtains_background_from',
    'background',
    'background_from'
  },
  providesDataFor = {
  },
  obtainsSupportFrom = {
  },
  qualifies = {
  },
  parodies = {
  },
  refutes = {
  },
  repliesTo = {
    'replies_to',
  },
  retracts = {
  },
  reviews = {
  },
  ridicules = {
  },
  speculatesOn = {
  },
  supports = {
  },
  updates = {
  },
  usesConclusionsFrom = {
    'uses_conclusions_from'
  },
  usesDataFrom = {
    'dataFrom',
    'uses_data_from',
    'data',
    'data_from'
  },
  usesMethodIn = {
    'methodIn',
    'uses_method_in',
    'method',
    'method_in'
  },
}

local default_cito_property = 'citation'

--- Map from cito aliases to the actual cito property.
local properties_by_alias = {}
for property, aliases in pairs(properties_and_aliases) do
  -- every property is an alias for itself
  properties_by_alias[property] = property
  for _, alias in pairs(aliases) do
    properties_by_alias[alias] = property
  end
end

--- Split citation ID into cito property and the actual citation ID. If
--- the ID does not seem to contain a CiTO property, the
--- `default_cito_property` will be returned, together with the
--- unchanged input ID.
local function split_cito_from_id (citation_id)
  local pattern = '^([^:]+):(.+)$'
  local prop_alias, split_citation_id = citation_id:match(pattern)

  if properties_by_alias[prop_alias] then
    return properties_by_alias[prop_alias], split_citation_id
  end

  return default_cito_property, citation_id
end

--- Citations by CiTO properties.
local function store_cito (cito_cites, prop, cite_id)
  if not prop then
    return
  end
  if not cito_cites[prop] then
    cito_cites[prop] = {}
  end
  table.insert(cito_cites[prop], cite_id)
end

--- Returns a Cite filter function which extracts CiTO information and
--- add it to the given collection table.
local function extract_cito (cito_cites)
  return function (cite)
    local placeholder = cite.content
    for _, citation in pairs(cite.citations) do
      local cito_prop, cite_id = split_cito_from_id(citation.id)
      store_cito(cito_cites, cito_prop, cite_id)
      cite.content = cite.content:walk {
        -- replace in placeholder
        Str = function (str)
          return str.text:gsub(citation.id, cite_id)
        end
      }
      citation.id = cite_id
    end

    return cite
  end
end

return {
  {
    Pandoc = function (doc)
      --- Lists of citation IDs, indexed by CiTO properties.
      local citations_by_property = {}
      doc = doc:walk{Cite = extract_cito(citations_by_property)}
      doc.meta.cito_cites = citations_by_property
      return doc
    end
  }
}
