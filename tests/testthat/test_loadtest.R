# =========================================================================
# Copyright © 2019 T-Mobile USA, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# See the LICENSE file for additional language around disclaimer of warranties.
# Trademark Disclaimer: Neither the name of "T-Mobile, USA" nor the names of
# its contributors may be used to endorse or promote products derived from this
# software without specific prior written permission.
# =========================================================================

library(loadtest)

test_that("loadtest returns a valid response", {
  threads <- 2
  loops <- 5
  results <- loadtest("https://www.microsoft.com", threads = threads, loops = loops, delay_per_request = 250)
  expect_is(results, "data.frame")
  expect_equal(nrow(results), threads*loops, label = "Table had invalid number of rows")
  expect_true(all(results$request_status=="Success"),label = "Some requests failed")

  expect_is(plot_elapsed_times(results),"ggplot")
  expect_is(plot_elapsed_times_histogram(results),"ggplot")
  expect_is(plot_requests_by_thread(results),"ggplot")
  expect_is(plot_requests_per_second(results),"ggplot")

  save_location <- tempfile(fileext=".html")

  loadtest_report(results,save_location)

  expect_true(file.size(save_location) > 1024^2, label = "Report not generated correctly")

  file.remove(save_location)
})

test_that("loadtest works with more method/headers/body", {
  threads <- 2
  loops <- 5
  results <- loadtest("http://httpbin.org/post",
                      method = "POST",
                      headers = c("version" = "v1.0"),
                      body = list(text = "example text"),
                      encode = "json",
                      threads = threads,
                      loops = loops,
                      delay_per_request = 250)
  expect_is(results, "data.frame")
  expect_equal(nrow(results), threads*loops, label = "Table had invalid number of rows")
  expect_true(all(results$request_status=="Success"),label = "Some requests failed")
})
