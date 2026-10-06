# Combine all files in a directory into a single file

Lists the files in `input_dir` that match `pattern`, reads each one and
writes their contents, in alphabetical order, to `output_file`. Each
file's contents are preceded by a `# FILE: <path>` header block so the
origin of every section is visible. If `output_file` lies inside
`input_dir`, it is excluded so the file does not include itself.

## Usage

``` r
combine_files(
  input_dir = "working_functions",
  output_file = "all_functions.R",
  pattern = "\\.[Rr]$",
  recursive = TRUE
)
```

## Arguments

- input_dir:

  Character string. Directory to read files from. Default
  `"working_functions"`.

- output_file:

  Character string. Path of the combined file to write. An existing file
  is overwritten. Default `"all_functions.R"`.

- pattern:

  Regular expression passed to
  [`list.files`](https://rdrr.io/r/base/list.files.html) to select
  files. Default `"\\.[Rr]$"` selects R scripts. Use `NULL` to include
  every file.

- recursive:

  Logical. If `TRUE` (default), files in subdirectories of `input_dir`
  are included; if `FALSE`, only files directly in `input_dir`.

## Value

Invisibly returns a character vector with the paths of the combined
files. Called for its side effect of writing `output_file`.

## Examples

``` r
# input_dir <- file.path(tempdir(), "combine_files_example")
# dir.create(file.path(input_dir, "sub"), recursive = TRUE, showWarnings = FALSE)
# writeLines("a <- 1", file.path(input_dir, "a.R"))
# writeLines("b <- 2", file.path(input_dir, "sub", "b.R"))
# output_file <- file.path(tempdir(), "combined.R")
# combine_files(input_dir = input_dir, output_file = output_file)
# cat(readLines(output_file), sep = "\n")
# combine_files(input_dir = input_dir, output_file = output_file, recursive = FALSE)
```
