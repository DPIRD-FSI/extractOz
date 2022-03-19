#' Digital Atlas of Australian Soils
#'
#' @description
#' The digital version of the Atlas of Australian Soils was created by
#' \acronum{NRIC} (National Resource Information Centre) in 1991 from scanned
#' tracings of the published hardcopy maps (1 - 10), Northcote et al. (1960 -
#' 1968).
#'
#' @details
#' The Atlas of Australian Soils (Northcote et al, 1960-68) was compiled by
#' \acronym{CSIRO} in the 1960's to provide a consistent national description of
#' Australia's soils. It comprises a series of ten maps and associated
#' explanatory notes, compiled by K.H. Northcote and others. The maps were
#' published at a scale of 1:2,000,000, but the original compilation was at
#' scales from 1:250,000 to 1:500,000.
#'
#' Mapped units in the Atlas are soil landscapes, usually comprising a number of
#' soil types. The explanatory notes include descriptions of soils landscapes
#' and component soils. Soil classification for the Atlas is based on the
#' Factual Key.
#'
#' The Factual Key (Northcote 1979) was the most widely used soil classification
#' scheme prior to the Australian Soil Classification (Isbell 2002). It dates
#' from 1960 and was essentially based on a set of about 500 profiles largely
#' from south-eastern Australia. It is an hierarchical scheme with 5 levels,
#' the most detailed of which is the principal profile form (\acronym{PPF}).
#' Most of the keying attributes are physical soil characteristics, and can be
#' determined in the field.
#'
#' The "mapunit" code contained within the digital dataset represents and links
#' to the soil landscapes described in the explanatory notes,
#' (explanatoryNotes.txt).The dominant and top 5 soils (as \acronym{PPF}\
#' classes) listed within the explanatory notes have been estimated from the
#' text and are also included with this dataset (muppf5.txt).
#'
#' @section Additional Works:
#' Additional work by various groups has added some value to the dataset by
#' providing look up tables that link to some interpretations of the mapping
#' units or dominant soil type (\acronym{PPF}). Some examples of this include:
#'
#'   McKenzie, N. J. and Hook, J. (1992). Interpretations of the Atlas of
#'   Australian Soils. Consulting Report to the Environmental Resources
#'   Information Network (ERIN). CSIRO Division of Soils Technical Report
#'   94/1992.
#'
#'   McKenzie NJ, Jacquier DW, Ashton LJ and Cresswell HP (2000) Estimation of
#'   soil properties using the Atlas of Australian Soils. CSIRO Land and Water
#'   Technical Report 11/00, February 2000.
#'
#'   Ashton, L.J. and McKenzie, N.J. (2001) Conversion of the Atlas of
#'   Australian Soils to the Australian Soil Classification, CSIRO Land and
#'   Water (unpublished).
#'
#' @section Dataset History:
#' The Digital version of the Atlas of Australian Soils was constructed from
#' scanned tracings of the published hardcopy source maps, the thirteen sheets
#' of the Atlas of Australian Soils. Use of the hard copies was necessary as the
#' original printer's separates could not be located. The positional errors
#' inherent in the original source maps would have been added and errors
#' introduced by subsequent processes, beginning with the natural process of
#' paper stretch. This was followed by the data processing steps which were, in
#' order of execution: tracing, manual digitizing, transformation of coordinates
#' and rubber sheeting to edge-match the digital versions of the adjacent sheets.
#'
#' @section Dataset Citation:
#' Bureau of Rural Sciences (2009) Digital Atlas of Australian Soils.
#' Bioregional Assessment Source Dataset. Viewed 29 September 2017,
#' \url{http://data.bioregionalassessments.gov.au/dataset/9e7d2f5b-ff51-4f0f-898a-a55be8837828}.
#'
#' @format An \CRANpkg{sf} object with seven fields:
#' \describe{
#'   \item{AREA}{Polygon area}
#'   \item{PERIMETER}{Perimeter}
#'   \item{MAP_UNIT}{Map unit}
#'   \item{MAP_CODE}{Map code}
#'   \item{SOIL_CODE}{Soil code}
#'   \item{SOIL_SYMBO}{Soil classification symbol}
#'   \item{SOIL}{Soil classification}
#' }
#' @source \url{http://data.bioregionalassessments.gov.au/dataset/9e7d2f5b-ff51-4f0f-898a-a55be8837828}
"daas"
