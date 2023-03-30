# extractOz 0.1.3.9000

## Major changes

-   Move from {cropgrowdays} to {weatherOz}, this allows for more flexibility in the queries that can be performed in SILO.
{cropgrowdays} only supports APSIM data returns, {weatherOz} supports the full compliment of SILO data options.

-   Use a named list of latitude and longitude input values rather than a `data.frame`.
To help users, a new function, `df_to_list()` has been added so that the workflow disruption can be minimised.

-   Enhanced tests

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
