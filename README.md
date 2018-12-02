<!-- README.md is generated from README.Rmd. Please edit that file -->
mmpipe
======

Install with `devtools::install_gh("moodymudskipper/mmpipe")`

This package proposes new pipe operators, a function to define custom operators easily, 2 other pipe friendly functions for conditional steps or printing and a `-.gg` methods which makes `-` an alias for `%>%` when used on a ggplot object.

-   **%W&gt;%** : silence **w**arnings
-   **%V&gt;%** : uses `View()` on the output
-   **%L&gt;%** : **L**ogs the relevant call to the console
-   **%P&gt;%** : uses `print()` on the output
-   **%S&gt;%** : prints the `summary()` of the output
-   **%G&gt;%** : uses `tibble::glimpse` on the output
-   **%D&gt;%** : **D**ebugs the pipe chain at the relevant step
-   **%C&gt;%** : **C**locks the relevant step
-   **add\_pipe** : build custom pipe
-   **pif** : conditional steps
-   **pprint** : pipe friendly printing
-   **-.gg** : Just like `%>%` but the different operator precedence makes it sometimes more convenient.

`magrittr`'s operators are also exported so they can be used without attaching alias functions.

new operators
-------------

When we attach `mmpipe` the functions `magrittr:::is_pipe` and `magrittr:::wrap_function` are modified to register our new pipes in the package, thus a couple warnings are displayed.

``` r
library(mmpipe)
#> Warning: changing locked binding for 'is_pipe' in 'magrittr' whilst loading
#> 'mmpipe'
#> Warning: changing locked binding for 'wrap_function' in 'magrittr' whilst
#> loading 'mmpipe'
```

silence a warning:

``` r
data.frame(a = c(1,-1)) %W>% transform(a = sqrt(a))
#>     a
#> 1   1
#> 2 NaN
```

log steps in the console:

``` r
iris %L>% {Sys.sleep(1);head(.,2)} %L>% {Sys.sleep(2);.[4:5]}
#> {
#>     Sys.sleep(1)
#>     head(., 2)
#> }
#> {
#>     Sys.sleep(2)
#>     .[4:5]
#> }
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa
```

use print, summary or glimpse on output:

``` r
iris %P>% head(2) %P>% `[`(4:5)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa

iris %S>% head(2) %S>% `[`(4:5)
#>   Sepal.Length   Sepal.Width     Petal.Length  Petal.Width        Species 
#>  Min.   :4.90   Min.   :3.000   Min.   :1.4   Min.   :0.2   setosa    :2  
#>  1st Qu.:4.95   1st Qu.:3.125   1st Qu.:1.4   1st Qu.:0.2   versicolor:0  
#>  Median :5.00   Median :3.250   Median :1.4   Median :0.2   virginica :0  
#>  Mean   :5.00   Mean   :3.250   Mean   :1.4   Mean   :0.2                 
#>  3rd Qu.:5.05   3rd Qu.:3.375   3rd Qu.:1.4   3rd Qu.:0.2                 
#>  Max.   :5.10   Max.   :3.500   Max.   :1.4   Max.   :0.2                 
#> 
#>   Petal.Width        Species 
#>  Min.   :0.2   setosa    :2  
#>  1st Qu.:0.2   versicolor:0  
#>  Median :0.2   virginica :0  
#>  Mean   :0.2                 
#>  3rd Qu.:0.2                 
#>  Max.   :0.2
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa

iris %G>% head(2) %G>% `[`(4:5)
#> Observations: 2
#> Variables: 5
#> $ Sepal.Length <dbl> 5.1, 4.9
#> $ Sepal.Width  <dbl> 3.5, 3.0
#> $ Petal.Length <dbl> 1.4, 1.4
#> $ Petal.Width  <dbl> 0.2, 0.2
#> $ Species      <fct> setosa, setosa
#> 
#> Observations: 2
#> Variables: 2
#> $ Petal.Width <dbl> 0.2, 0.2
#> $ Species     <fct> setosa, setosa
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa
```

view steps of chain in the viewer:

``` r
iris %V>% head(2) %V>% `[`(4:5)
```

debug the chain:

``` r
iris %>% head(2) %D>% `[`(4:5)
#> debugging in: pipe_browse()
#> debug: .[4:5]
#> exiting from: pipe_browse()
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa
```

time operations:

``` r
iris %C>% head(2) %C>% {Sys.sleep(2);.} 
#>    user  system elapsed 
#>       0       0       0 
#> 
#>    user  system elapsed 
#>       0       0       2
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
```

Create your own pipe operators with `add_pipe`
----------------------------------------------

We create an operator by feeding to `add_pipe` its raw name and the modified body of the expression a regular pipe call would return.

the operator is created and *magrittr*'s namespace is modified to make the new operator compatible.

This is not obvious so let's see some examples, if we wanted to recreate existing operators.

Redefining `%P2>%` as `%P>%` twin :

``` r
 add_pipe(`%P2>%`, substitute({. <- print(b);cat("\n"); .}, list(b = body)))
 iris %P2>% head(3) %>% head(2)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
```

Redefining `%T2>%` as `%T>%` twin :

``` r
 add_pipe(`%T2>%`, call("{", body, quote(.)))
 iris %T2>% {message("side effect")} %>% head(2)
#> side effect
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
```

Redefining `%W2>%` as `%W>%` twin :

``` r
 add_pipe(`%W2>%`, substitute(
     {options(warn = -1); on.exit(options(warn = w)); b},
     list(w = options()$warn, b = body)))
 data.frame(a = c(1,-1)) %W2>% transform(a = sqrt(a))
#>     a
#> 1   1
#> 2 NaN
```

See `magrittr:::wrap_function`'s code for a better understanding.

See also functions `rm_pipe` and `list_pipes`.

spare parenthesis by piping ggplot objects with `-`
---------------------------------------------------

``` r
library(ggplot2)
library(plotly,quietly = TRUE, warn.conflicts = FALSE)
iris %>% ggplot(aes(Sepal.Width)) + geom_density() - ggplotly()
```

easy conditional steps with `pif`
---------------------------------

Using functions:

``` r
iris %>% pif(is.data.frame, dim, nrow)
#> [1] 150   5
```

Using formulas:

``` r
iris %>% pif(~is.numeric(Species), ~"numeric :)",~paste(class(Species)[1],":("))
#> [1] "factor :("
```

Using raw expressions:

``` r
iris %>% pif(nrow(iris) > 2, head(iris,2))
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
```

Be careful with expressions!

``` r
iris %>% pif(TRUE, dim,  warning("this will be evaluated"))
#> Warning in pif(., TRUE, dim, warning("this will be evaluated")): this will
#> be evaluated
#> [1] 150   5
iris %>% pif(TRUE, dim, ~warning("this won't be evaluated"))
#> [1] 150   5
```

print info on intermediate steps with `pprint`
----------------------------------------------

``` r
iris %>%
  pprint(~"hello")           %>%
  head(2)                    %>%
  transform(Species = NULL)  %>%
  pprint(rowSums,na.rm = TRUE) %>%
  pprint(~setNames(.[1:2],toupper(names(.[1:2])))) %>%
  pprint(dim)
#> [1] "hello"
#>    1    2 
#> 10.2  9.5 
#>   SEPAL.LENGTH SEPAL.WIDTH
#> 1          5.1         3.5
#> 2          4.9         3.0
#> [1] 2 4
```
