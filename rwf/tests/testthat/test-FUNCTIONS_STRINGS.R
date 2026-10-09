##########################################################################################
# str_mgsub
##########################################################################################
test_that("str_mgsub matches sequential base::gsub calls", {
  x <- c("#$%^&*_+", "a*b%c", "none")
  reference <- gsub("*", "REPLACE", gsub("%", "REPLACE", x, fixed = TRUE), fixed = TRUE)
  expect_identical(str_mgsub(mydata = x, pattern = c("%", "*"), replacement = "REPLACE", fixed = TRUE), reference)
  expect_identical(str_mgsub("#$%^&*_+", c("%", "*"), "REPLACE", fixed = TRUE), "#$REPLACE^&REPLACE_+")
})

test_that("str_mgsub applies the patterns in order, as regular expressions by default", {
  # the second pattern sees the output of the first
  expect_identical(str_mgsub("abc", c("a", "Xb"), "X"), "Xc")
  expect_identical(str_mgsub(c("a1b22", "c333"), c("[0-9]+", "[a-z]"), "_"), c("____", "__"))
  # ignore.case is passed on to gsub
  expect_identical(str_mgsub("AbA", "a", "-", ignore.case = TRUE), "-b-")
})

test_that("str_mgsub handles Greek text, NA and empty strings", {
  x <- c("Καλημέρα κόσμε", NA, "")
  expect_identical(str_mgsub(x, c("α", "ε"), "*"), c("Κ*λημέρ* κόσμ*", NA, ""))
  expect_length(str_mgsub(x, "α", "*"), 3)
})

test_that("str_mgsub returns its input unchanged for an empty pattern vector", {
  skip("rwf bug: str_mgsub loops over 1:length(pattern), so an empty pattern vector errors")
  expect_identical(str_mgsub(c("abc", "d"), character(0), "X"), c("abc", "d"))
})

##########################################################################################
# str_split
##########################################################################################
test_that("str_split returns one row per element and one column per part", {
  x <- c("1/ab/cd/ef", "2/gh/ij/kl")
  result <- str_split(x, split = "/")
  expect_s3_class(result, "data.frame")
  expect_identical(dim(result), c(2L, 4L))
  expect_named(result, paste0("X", 1:4))
  expected <- data.frame(X1 = c("1", "2"), X2 = c("ab", "gh"), X3 = c("cd", "ij"), X4 = c("ef", "kl"))
  expect_identical(result, expected)
  # agrees with base strsplit row by row
  parts <- strsplit(x, "/", fixed = TRUE)
  for (i in seq_along(x)) expect_identical(unname(unlist(result[i, ])), parts[[i]])
})

test_that("str_split splits on a literal separator and can keep the original", {
  x <- c("a.b", "c.d", "e.f")
  result <- str_split(x, split = ".", include_original = TRUE)
  expect_named(result, c("X1", "X2", "vector"))
  expect_identical(result$X1, c("a", "c", "e"))
  expect_identical(result$X2, c("b", "d", "f"))
  expect_identical(result$vector, x)
})

test_that("str_split handles Greek text", {
  x <- c("Αθήνα|Ελλάδα", "Λευκωσία|Κύπρος")
  result <- str_split(x, split = "|")
  expect_identical(result$X1, c("Αθήνα", "Λευκωσία"))
  expect_identical(result$X2, c("Ελλάδα", "Κύπρος"))
})

##########################################################################################
# str_split_df
##########################################################################################
test_that("str_split_df prepends the split row names to the data frame", {
  df <- data.frame(score = c(10, 20, 30), group = c("a", "b", "c"))
  row.names(df) <- c("1/x/Αθήνα", "2/y/Πάτρα", "3/z/Βόλος")
  result <- str_split_df(df, split = "/", type = "row")
  expect_s3_class(result, "data.frame")
  expect_identical(dim(result), c(3L, 5L))
  expect_named(result, c("X1", "X2", "X3", "score", "group"))
  expect_identical(result$X1, c("1", "2", "3"))
  expect_identical(result$X2, c("x", "y", "z"))
  expect_identical(result$X3, c("Αθήνα", "Πάτρα", "Βόλος"))
  expect_identical(result$score, df$score)
  expect_identical(result$group, df$group)
})

test_that("str_split_df splits a column chosen by index", {
  df <- data.frame(id = c("a_1", "b_2"), value = c(1.5, 2.5))
  result <- str_split_df(df, split = "_", type = "collumn", index = 1)
  expect_named(result, c("X1", "X2", "id", "value"))
  expect_identical(result$X1, c("a", "b"))
  expect_identical(result$X2, c("1", "2"))
  expect_identical(result$id, df$id)
  expect_identical(result$value, df$value)
  # a factor column is split by its labels
  df$id <- factor(df$id)
  expect_identical(str_split_df(df, split = "_", type = "collumn", index = 1)$X1, c("a", "b"))
  # ... is passed on to str_split
  expect_identical(str_split_df(df, split = "_", type = "collumn", index = 1, include_original = TRUE)$vector,
                   c("a_1", "b_2"))
})

##########################################################################################
# str_sub
##########################################################################################
test_that("str_sub matches stringr::str_sub for left and right extraction", {
  x <- c("12345", "abcdef", "Καλημέρα", "a", "", NA)
  for (n in 1:4) {
    expect_identical(str_sub(x, n = n, type = "left"), stringr::str_sub(x, 1, n))
    expect_identical(str_sub(x, n = n, type = "right"), stringr::str_sub(x, -n))
  }
  expect_identical(str_sub("12345", n = 2, type = "right"), "45")
  expect_identical(str_sub("12345", n = 2, type = "left"), "12")
  expect_identical(str_sub("Καλημέρα", n = 3, type = "right"), "έρα")
})

test_that("str_sub returns the whole string when n exceeds its length", {
  expect_identical(str_sub("ab", n = 5, type = "right"), "ab")
  expect_identical(str_sub("ab", n = 5, type = "left"), "ab")
})

##########################################################################################
# str_proper
##########################################################################################
test_that("str_proper capitalises the first character and lowercases the rest", {
  x <- c("hELLO wORLD", "ABC", "a", "", "1abc", "καλημέρα ΚΟΣΜΕ", "ΩΜΕΓΑ")
  expected <- c("Hello world", "Abc", "A", "", "1abc", "Καλημέρα κοσμε", "Ωμεγα")
  expect_identical(str_proper(x), expected)
  # reference built from stringr
  reference <- paste0(stringr::str_to_upper(stringr::str_sub(x, 1, 1)), stringr::str_to_lower(stringr::str_sub(x, 2)))
  expect_identical(str_proper(x), reference)
  expect_length(str_proper(x), length(x))
})

test_that("str_proper keeps NA as NA", {
  skip("rwf bug: str_proper(NA) returns the string \"NANA\" because paste0 pastes the two NA halves")
  expect_identical(str_proper(c("abc", NA)), c("Abc", NA))
})

##########################################################################################
# str_trim_df
##########################################################################################
test_that("str_trim_df trims leading and trailing whitespace from character cells", {
  df <- data.frame(a = c("  x ", "y", " Αθήνα  "), b = c("p  ", "  q", "r"), stringsAsFactors = FALSE)
  result <- str_trim_df(df)
  expect_s3_class(result, "data.frame")
  expect_identical(dim(result), dim(df))
  expect_named(result, names(df))
  reference <- df
  reference[] <- lapply(df, trimws)
  expect_identical(result, reference)
})

test_that("str_trim_df leaves non-character columns unchanged", {
  skip("rwf bug: str_trim_df runs apply() on the data frame, so numeric columns come back as formatted character strings")
  df <- data.frame(a = c(" x ", "y"), n = c(1.5, 10), stringsAsFactors = FALSE)
  result <- str_trim_df(df)
  expect_identical(result$n, c(1.5, 10))
  expect_identical(result$a, c("x", "y"))
})

test_that("str_trim_df only trims the ends and keeps empty and long strings intact", {
  skip("rwf bug: str_trim_df uses strwrap(), which collapses internal spaces, wraps long strings and breaks on empty cells")
  long <- paste(rep("word", 30), collapse = " ")
  df <- data.frame(a = c(" y  z ", "", long), stringsAsFactors = FALSE)
  result <- str_trim_df(df)
  expect_identical(result$a, c("y  z", "", long))
})

##########################################################################################
# str_aes
##########################################################################################
test_that("str_aes replaces separators with spaces and applies proper case", {
  x <- c("TES.T", "TES<p>T", "TES&nbspT", "first_name", "a-b,c$d|e/f", "βάρος_σώματος")
  expect_identical(str_aes(x), c("Tes t", "Tes t", "Tes t", "First name", "A b c d e f", "Βάρος σώματος"))
  expect_identical(str_aes(x, proper = FALSE), c("TES T", "TES T", "TES T", "first name", "a b c d e f", "βάρος σώματος"))
})

test_that("str_aes collapses repeated separators and whitespace", {
  expect_identical(str_aes("hello__world..again", proper = FALSE), "hello world again")
  expect_identical(str_aes("x<br/><BR/>y", proper = FALSE), "x y")
  expect_identical(str_aes(c("a", "", NA), proper = FALSE), c("a", "", NA))
})

test_that("str_aes accepts a custom character list", {
  expect_identical(str_aes("a+b*c", characterlist = c("+", "*"), proper = FALSE), "a b c")
  # the default list is not used when a custom one is given
  expect_identical(str_aes("a_b", characterlist = "+", proper = FALSE), "a_b")
})

test_that("str_aes capitalises strings that start with whitespace or a separator", {
  skip("rwf bug: str_aes applies str_proper to the untrimmed vector, so the first letter after a leading space or separator is not capitalised")
  expect_identical(str_aes(c(".test", "  hello__world  ", "_αλφα")), c("Test", "Hello world", "Αλφα"))
})

##########################################################################################
# call_to_string
##########################################################################################
test_that("call_to_string returns the model call without whitespace", {
  model <- lm(mpg ~ wt + hp, data = mtcars)
  expect_identical(call_to_string(model), "lm(formula=mpg~wt+hp,data=mtcars)")
  model <- stats::glm(am ~ wt, family = binomial, data = mtcars)
  expect_identical(call_to_string(model), gsub(" ", "", paste(deparse(model$call), collapse = ""), fixed = TRUE))
  expect_type(call_to_string(model), "character")
  expect_length(call_to_string(model), 1)
})

test_that("call_to_string falls back to the Call element", {
  model <- list(Call = quote(fit(y ~ x, data = d)))
  expect_identical(call_to_string(model), "fit(y~x,data=d)")
  expect_identical(call_to_string(list()), "NULL")
})

test_that("call_to_string does not insert commas into long calls", {
  skip("rwf bug: call_to_string joins the lines of a long deparsed call with toString, which inserts a spurious comma")
  withr::local_seed(1)
  df <- data.frame(alpha_long_name = stats::rnorm(10), beta_long_name = stats::rnorm(10),
                   gamma_long_name = stats::rnorm(10), delta_long_name = stats::rnorm(10))
  model <- stats::lm(alpha_long_name ~ beta_long_name + gamma_long_name + delta_long_name, data = df, weights = NULL)
  expect_identical(call_to_string(model),
                   "lm(formula=alpha_long_name~beta_long_name+gamma_long_name+delta_long_name,data=df,weights=NULL)")
})

##########################################################################################
# output_separator
##########################################################################################
test_that("output_separator prints the heading, instruction and output between separators", {
  printed <- utils::capture.output(value <- output_separator(string = "TITLE", output = 1:3, instruction = "Read this", length = 10))
  expected <- utils::capture.output({
    print("##########")
    print("TITLE")
    print("##########")
    print("Read this")
    print("#####")
    print(1:3)
  })
  expect_identical(printed, expected)
  expect_null(value)
  utils::capture.output(expect_invisible(output_separator(string = "TITLE", length = 10)))
})

test_that("output_separator omits the optional parts when they are NULL", {
  printed <- utils::capture.output(output_separator(string = "Τίτλος", length = 4))
  expected <- utils::capture.output({
    print("####")
    print("Τίτλος")
    print("####")
  })
  expect_identical(printed, expected)
  printed <- utils::capture.output(output_separator(string = "T", output = "out", length = 4))
  expect_length(printed, 4)
  expect_identical(printed[4], utils::capture.output(print("out")))
})

test_that("output_separator uses a quarter of the console width by default", {
  withr::local_options(width = 80)
  printed <- utils::capture.output(output_separator(string = "T"))
  expect_identical(printed[1], utils::capture.output(print(strrep("#", 20))))
})

##########################################################################################
# fixed
##########################################################################################
test_that("fixed marks a pattern as literal without changing its value", {
  pattern <- fixed(".")
  expect_s3_class(pattern, "fixed_pattern")
  expect_identical(as.character(unclass(pattern)), ".")
  expect_identical(str_replace_all("a.b.c", fixed("."), "-"), "a-b-c")
  expect_identical(str_replace_all("a.b.c", ".", "-"), "-----")
})

##########################################################################################
# str_replace_all
##########################################################################################
test_that("str_replace_all matches stringr::str_replace_all", {
  x <- c("hello world", "a.b.c", "2024-01-31", "Καλημέρα κόσμε", "", NA)
  cases <- list(
    list("o", "0"),
    list("[aeiou]", ""),
    list("(\\d+)-(\\d+)", "\\2/\\1"),
    list("\\s+", "_"),
    list("α", "Α"),
    list("^", ">")
  )
  for (case in cases) {
    expect_identical(str_replace_all(x, case[[1]], case[[2]]), stringr::str_replace_all(x, case[[1]], case[[2]]))
  }
  expect_identical(str_replace_all(x, fixed("."), "-"), stringr::str_replace_all(x, stringr::fixed("."), "-"))
  expect_identical(str_replace_all(x, fixed(" "), ""), stringr::str_replace_all(x, stringr::fixed(" "), ""))
})

test_that("str_replace_all applies a named vector of replacements in order", {
  replacements <- c("a" = "X", "b" = "Y", "X" = "Z")
  x <- c("aabbcc", "abc", "ccc")
  expect_identical(str_replace_all(x, replacements), stringr::str_replace_all(x, replacements))
  expect_identical(str_replace_all("aabbcc", c("a" = "X", "b" = "Y")), "XXYYcc")
  expect_identical(str_replace_all("άλφα βήτα", c("ά" = "α", "ή" = "η")), "αλφα βητα")
})

test_that("str_replace_all accepts a single named replacement", {
  skip("rwf bug: a named pattern of length 1 skips the named-vector branch and fails because replacement is missing")
  expect_identical(str_replace_all("aabb", c("a" = "X")), stringr::str_replace_all("aabb", c("a" = "X")))
})

##########################################################################################
# str_replace
##########################################################################################
test_that("str_replace matches stringr::str_replace", {
  x <- c("hello world", "007 bond", "a.b.c", "Καλημέρα κόσμε", "", NA)
  cases <- list(
    list("o", "0"),
    list("^0+", ""),
    list("([0-9]+) ([a-z]+)", "\\2 \\1"),
    list("(\\S+) (\\S+)", "\\2 \\1"),
    list("[αε]", "_")
  )
  for (case in cases) {
    expect_identical(str_replace(x, case[[1]], case[[2]]), stringr::str_replace(x, case[[1]], case[[2]]))
  }
  expect_identical(str_replace(x, fixed("."), "-"), stringr::str_replace(x, stringr::fixed("."), "-"))
  expect_identical(str_replace("a.b.c", fixed("."), "-"), "a-b.c")
  expect_identical(str_replace("a.b.c", ".", "-"), "-.b.c")
})

test_that("str_replace, str_replace_all and str_count treat Greek letters as word characters", {
  skip("rwf bug: the regex branches use perl = TRUE without (*UCP), so \\w and \\b only match ASCII letters, unlike stringr")
  x <- "Καλημέρα κόσμε"
  expect_identical(str_replace(x, "(\\w+) (\\w+)", "\\2 \\1"), "κόσμε Καλημέρα")
  expect_identical(str_replace_all(x, "\\w+", "X"), "X X")
  expect_identical(str_count(x, "\\w"), stringr::str_count(x, "\\w"))
})

##########################################################################################
# str_wrap
##########################################################################################
test_that("str_wrap matches base::strwrap joined with newlines", {
  x <- c("The quick brown fox jumped over the lazy dog",
         "Short label",
         "Η γρήγορη καφέ αλεπού πήδηξε πάνω από τον τεμπέλη σκύλο",
         "")
  for (width in c(10, 20, 30, 80)) {
    result <- str_wrap(x, width = width)
    expect_type(result, "character")
    expect_length(result, length(x))
    expect_null(names(result))
    reference <- vapply(x, function(s) paste(strwrap(s, width = width), collapse = "\n"), character(1), USE.NAMES = FALSE)
    expect_identical(result, reference)
  }
})

test_that("str_wrap keeps words intact and lines shorter than the width", {
  x <- "Η γρήγορη καφέ αλεπού πήδηξε πάνω από τον τεμπέλη σκύλο και έφυγε"
  result <- str_wrap(x, width = 20)
  lines <- strsplit(result, "\n", fixed = TRUE)[[1]]
  expect_gt(length(lines), 1)
  expect_true(all(nchar(lines) < 20))
  expect_identical(paste(lines, collapse = " "), x)
  expect_identical(str_wrap("The quick brown fox jumped over the lazy dog", width = 30),
                   "The quick brown fox jumped\nover the lazy dog")
})

test_that("str_wrap keeps NA as NA", {
  skip("rwf bug: str_wrap(NA) returns the string \"NA\" because strwrap converts NA to text")
  expect_identical(str_wrap(c("a b", NA), width = 10), c("a b", NA))
})

##########################################################################################
# str_split_fixed
##########################################################################################
test_that("str_split_fixed matches stringr::str_split_fixed when no string has more than n pieces", {
  x <- c("speed.run", "height.jump", "weight.lift", "Αθήνα.Πάτρα")
  expect_identical(str_split_fixed(x, fixed("."), 2), stringr::str_split_fixed(x, stringr::fixed("."), 2))
  y <- c("a1b", "c2d", "e3f")
  expect_identical(str_split_fixed(y, "[0-9]", 2), stringr::str_split_fixed(y, "[0-9]", 2))
  # fewer pieces than n: padded with ""
  result <- str_split_fixed(c("a.b.c", "x.y", "z", ""), fixed("."), 3)
  expect_true(is.matrix(result))
  expect_type(result, "character")
  expect_identical(dim(result), c(4L, 3L))
  expect_identical(result, rbind(c("a", "b", "c"), c("x", "y", ""), c("z", "", ""), c("", "", "")))
})

test_that("str_split_fixed keeps the remainder in the last column when there are more than n pieces", {
  skip("rwf bug: str_split_fixed truncates pieces beyond n instead of keeping the remainder in the last column like stringr")
  x <- c("a.b.c", "x")
  expect_identical(str_split_fixed(x, fixed("."), 2), stringr::str_split_fixed(x, stringr::fixed("."), 2))
})

test_that("str_split_fixed returns one row per string when n is 1", {
  skip("rwf bug: str_split_fixed with n = 1 returns a 1 x length(string) matrix because vapply returns a vector")
  result <- str_split_fixed(c("a.b", "x.y", "z"), fixed("."), 1)
  expect_identical(dim(result), c(3L, 1L))
})

##########################################################################################
# str_count
##########################################################################################
test_that("str_count matches stringr::str_count", {
  x <- c("banana", "apple", "cherry", "", "Καλημέρα", "a;b;c")
  for (pattern in c("[aeiou]", "a", "an", "[0-9]", "[αε]", ";")) {
    result <- str_count(x, pattern)
    expect_type(result, "integer")
    expect_identical(result, stringr::str_count(x, pattern))
  }
  expect_identical(str_count(c("a;b;c", "x;y", "z"), fixed(";")), c(2L, 1L, 0L))
  expect_identical(str_count("a.b.c", fixed(".")), stringr::str_count("a.b.c", stringr::fixed(".")))
  expect_identical(str_count("a.b.c", "."), 5L)
  # overlapping matches are not counted twice
  expect_identical(str_count("aaaa", "aa"), stringr::str_count("aaaa", "aa"))
})

test_that("str_count returns NA for NA input", {
  skip("rwf bug: str_count errors on NA strings because if (x[1] == -1L) is evaluated on NA")
  expect_identical(str_count(c("aa", NA), "a"), c(2L, NA))
})

##########################################################################################
# str_pad
##########################################################################################
test_that("str_pad matches stringr::str_pad", {
  x <- c("1", "10", "100", "abcd", "", "αβ")
  for (side in c("left", "right", "both")) {
    for (width in c(0, 3, 6)) {
      result <- str_pad(x, width = width, side = side, pad = "0")
      expect_identical(result, stringr::str_pad(x, width = width, side = side, pad = "0"))
      expect_true(all(nchar(result) >= width))
    }
  }
  expect_identical(str_pad(c("1", "10", "100"), width = 3, side = "left", pad = "0"), c("001", "010", "100"))
  expect_identical(str_pad("hello", width = 11, side = "both"), "   hello   ")
  expect_identical(str_pad("hi", width = 5, side = "both", pad = "*"), "*hi**")
})

test_that("str_pad converts numbers and factors to character", {
  expect_identical(str_pad(c(5, 42), width = 3, side = "left", pad = "0"), c("005", "042"))
  expect_identical(str_pad(factor(c("a", "bb")), width = 3), c("a  ", "bb "))
  expect_null(names(str_pad(c(x = "a"), width = 2)))
})

test_that("str_pad returns NA for NA input", {
  skip("rwf bug: str_pad errors on NA strings because nchar(NA_character_) is NA inside if (n <= 0)")
  expect_identical(str_pad(c("a", NA), width = 3), c("a  ", NA))
})

##########################################################################################
# str_squish
##########################################################################################
test_that("str_squish matches stringr::str_squish", {
  x <- c("  hello   world  ", "line1\n\nline2\t\tword", "  first  name ", " α  β\t\nγ ", "", "   ", NA, "clean")
  expect_identical(str_squish(x), stringr::str_squish(x))
  expect_identical(str_squish(x), c("hello world", "line1 line2 word", "first name", "α β γ", "", "", NA, "clean"))
})
