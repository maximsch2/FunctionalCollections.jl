module FunctionalCollections

include("BitmappedVectorTrie.jl")

include("PersistentVector.jl")

typealias pvec PersistentVector

export PersistentVector, pvec,
       append, push,
       assoc,
       peek,
       pop

include("PersistentMap.jl")
include("PersistentArrayMap.jl")
include("PersistentHashMap.jl")

typealias phmap PersistentHashMap

export PersistentArrayMap,
       PersistentHashMap, phmap,
       assoc,
       dissoc

include("PersistentSet.jl")

typealias pset PersistentSet

export PersistentSet, pset,
       disj

include("PersistentList.jl")

typealias plist PersistentList

export PersistentList, plist,
       EmptyList,
       cons, ..,
       head,
       tail

include("PersistentQueue.jl")

export PersistentQueue, queue,
       enq

export @Persistent

fromexpr(ex::Expr, ::Type{pvec}) = :(pvec($(esc(ex))))
function fromexpr(ex::Expr, ::Type{phmap})
    kvtuples = [Expr(:tuple, map(esc, kv.args)...) for kv in ex.args]
    :(phmap($(kvtuples...)))
end

macro Persistent(ex)
    hd = ex.head

    if is(hd, :vcat) || is(hd, :cell1d)
        fromexpr(ex, pvec)
    elseif is(hd, :dict)
        fromexpr(ex, phmap)
    else
        error("Unsupported @Persistent syntax")
    end
end

end # module FunctionalCollections
