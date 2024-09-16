# Recamans

[![Build Status](https://github.com/jlapeyre/Recamans.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jlapeyre/Recamans.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jlapeyre/Recamans.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jlapeyre/Recamans.jl)

### [Recamán's sequence](https://en.wikipedia.org/wiki/Recam%C3%A1n%27s_sequence)

This code is performant, for simple code. But it is far from [research code](https://benchaffin.com/).

Here are some examples
```julia
julia> using Recamans
julia> r = recaman(10); # construct the first 10 entries in the sequence
julia> r[1]
0
julia> numunique(recaman(100))
91
```

A list of the entries among the first 50 with multiplicity 2.
```julia
julia> print(multmap(recaman(50))[2])
[43, 42, 79, 78]
```

A list of multiplicities of entries and the number of values with that multiplicity.
```julia
julia> sort(Dict( m => length(v) for (m, v) in multmap(recaman(10_000))))
OrderedCollections.OrderedDict{Int64, Int64} with 7 entries:
  1 => 6276
  2 => 1009
  3 => 294
  4 => 64
  5 => 22
  6 => 74
  7 => 2
```

The return type of `recaman` is `Recaman`, which contains the sequence as a `Vector` and
a `Set` of the entries. The latter is necessary when building the sequence and is
preserved in the result. `Base.in(::Recaman)` is forwarded to the set.

See `Recamans.multmap`. `Recamans.numunique`.

Several methods that forward the call to the list (the `Vector`) are present.

* `StatsBase.countmap`
* In `Base`: `getindex`, `maximum`, `minimum`, `extrema`, `length`, `unique`, `sort`, `view`
