"""
Recamán's sequence.

Exported `recaman, Recaman, multmap, numunique, countmap`.

Extended `Base.in(n::Int, rec::Recaman)`.

Extended in `Base`: `:maximum, :minimum, :extrema, :length, :unique, :sort, :view, :getindex`
"""
module Recamans

using StatsBase: StatsBase

export recaman, Recaman, multmap, numunique, countmap

"""
    struct Recaman

Data for constructing Recamán's sequence.

The `struct` includes a `Vector{Int}` representing the sequence and a `Set{Int}` of
sequence elements to allow fast lookup while constructing the sequence.
"""
struct Recaman
    list::Vector{Int}
    set::Set{Int}
end

"""
    Base.in(n::Int, rec::Recaman)

Return `true` if `n` is in the Recamán's sequence `rec`.
"""
Base.in(n::Int, rec::Recaman) = in(n, rec.set)

"""
    numunique(r::Recaman)

Return the number of unique elements in `r`.
"""
numunique(r::Recaman) = length(r.set)

"""
    numunique(r::Recaman)

Return `numunique(recaman(N))`.
"""
numunique(N::Integer) = numunique(recaman(N))

for f in (:maximum, :minimum, :extrema, :length, :unique, :sort, :view, :getindex)
    @eval Base.$f(rec::Recaman, args...) = $f(rec.list, args...)
end

"""
    countmap(r::Recaman)

Run StatsBase.countmap on `r`.

This function is defined in `Recaman`. It is *not* a method of
StatsBase.countmap
"""
countmap(r::Recaman) = StatsBase.countmap(r.list)

"""
    countmap(N::Integer)

Run `countmap(recaman(N))`.
"""
countmap(N::Integer) = countmap(recaman(N))

"""
    multmap(r::Recaman)
    multmap(cmap::Dict{Int, Int})
    multmap(N::Integer)

Return a map from multiplicities of entries in `r` to lists of entries with the
corresponding multiplicity.

The second method takes countmap of a Recamán sequence, and returns the same map from
multiplicities of entries to vectors. The first method constructs the countmap as an
intermediate step.

The third method, runs `multmap(recaman(N))`

# Example
```juliarepl
julia> r = recaman(100);
julia> cmap = countmap(r);
julia> multmap(cmap) == multmap(r)
true
```
"""
function multmap(cmap::Dict{Int, Int})
    mmap = Dict{Int, Vector{Int}}()
    for (n, count) in cmap
        arr = get!(mmap, count, Int[])
        push!(arr, n)
    end
    mmap
end
multmap(r::Recaman) = multmap(countmap(r))
multmap(N::Integer) = multmap(recaman(N))

# Initialize the data for constructing Recamán's sequence up to `N`.
function _init_recaman(N::Integer)
    list = Vector{Int}(undef, N)
    list[1] = 0
    set = Set([0])
    Recaman(list, set)
end

# This is similar to setindex. But we don't want this to be in the API
function _add_entry!(r::Recaman, i::Int, val::Int)
        r.list[i+1] = val
        push!(r.set, val)
end

# `a_n` is `a_(n-1) - n` if it is greater than zero and does not already
# appear in the sequence for smaller i. Otherwise `a_n` is `a_(n-1) + n`.
"""
    recaman(N::Int)

Compute a list of the first `N` entries in Recamán's sequence.
"""
function recaman(N::Int)
    rec = _init_recaman(N)
    @inbounds for n in 1:(N-1)
        trial = rec[n] - n
        if trial < 0 || in(trial, rec)
            trial = rec[n] + n
        end
        _add_entry!(rec, n, trial)
    end
    rec
end

end
