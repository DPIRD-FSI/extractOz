# extractOz 1.1.1

## Minor changes

-   Ensure that all checks are passed
  -   Updates {vcr} cassette
  -   Updates WORDLIST

# extractOz 1.1.0

## Major changes

-   Introduce `extract_patched_point()` to get SILO Patched Point station data from the nearest station(s) to a given set of geographic coordinates.

-   Introduce `extract_data_drill()` to get SILO Data Drill interpolated data from a given set of geographic coordinates.

## Minor changes

-   GRDC Agroecoregions geopackage file is reduced in size by reducing the complexity through,
    ```r
    rmapshaper::ms_simplify(aez, keep = 0.1, keep_shapes = FALSE)
    ```
    
-   Internal GRDC Agroecoregions object uses the same simplified GPKG and is saved using "xz" compression to save more file space.

-   Use {roxyglobals} for tracking global objects in the package in a tidier fashion.

# extractOz 1.0.0

## Major changes

-   All functions related to retrieving or extracting data are now prefixed as `extract_noun()`.

-   Revert using internal data as geopackage, use in examples but use .Rda internally.

-   Add support for extracting weather data from the NASA POWER database, `extract_power()`.

-   Move from {cropgrowdays} to {weatherOz}, this allows for more flexibility in the queries that can be performed in SILO.
{cropgrowdays} only supports APSIM data returns, {weatherOz} supports the full compliment of SILO data options.

-   Use a named list of latitude and longitude input values rather than a `data.frame`.
To help users, a new function, `df_to_list()` has been added so that the workflow disruption can be minimised.

-   Any objects returned are a `data.table`, aligning with {weatherOz}.

-   Enhanced tests.

-   Add ability to manage DAAS soil order cache.

-   Add ability to download DAAS soil order data but not cache locally (default behaviour now).

## Bug fixes

-   Remove several `Warning` messages when performing {sf} operations.

# extractOz 0.1.3

## Bug fixes

-   Fixes bug where external data would load, but tests were not passing.

# extractOz 0.1.2

## Bug fixes

-   Fixes bug where data wasn't properly loaded or documented for the `aez` object.

# extractOz 0.1.1

-   Save spatial data as a geopackage object to save issues with *sf*, per <https://www.mm218.dev/posts/2022-12-01-sf-in-packages/>.

# extractOz 0.1.0

-   Download and locally cache soils data for major soil order classifications to reduce package size.

# extractOz 0.0.2

-   Add an example to vignette that illustrates how to import and create an object in a pipeline.

# extractOz 0.0.1

-   Initial release.

# extractOz 0.0.0.9000

-   Added a `NEWS.md` file to track changes to the package.
