library(polmineR)
use("polmineR")

testthat::context("ngrams-method")

test_that("ngrams",{
  o <- corpus("REUTERS")
  n <- ngrams(o, n = 2)
  dt <- data.table::as.data.table(n)
  data.table::setorderv(dt, cols = "count", order = -1L)
  dt_min <- dt[!dt[["word_1"]] %in% tm::stopwords("en")]
  for (i in 1L:5L){
    n <- count(
      corpus("REUTERS"),
      query = sprintf('"%s" "%s"', dt_min[["word_1"]][i], dt_min[["word_2"]][i])
    )[["count"]]
    expect_equal(n, dt_min[["count"]][i])
  }
  
  
  p <- partition("REUTERS", places = "saudi-arabia", regex = TRUE)
  n <- ngrams(p, n = 2)
  dt <- data.table::as.data.table(n)
  data.table::setorderv(dt, cols = "count", order = -1L)
  dt_min <- dt[!dt[["word_1"]] %in% tm::stopwords("en")]
  for (i in 1L:5L){
    n <- count(
      p,
      query = sprintf('"%s" "%s"', dt_min[["word_1"]][i], dt_min[["word_2"]][i])
    )[["count"]]
    expect_equal(n, dt_min[["count"]][i])
  }
})


test_that("ngrams - character",{
  o <- corpus("REUTERS")
  n <- ngrams(o, n = 3, char = "")
  expect_identical(
    length(grep("oil", get_token_stream(o, p_attribute = "word"))),
    n["oil",][["count"]]
  )
})
