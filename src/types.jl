struct Particle
    speed::Int
    pos::NamedTuple{(:x, :y),Tuple{Int,Int}}
    dir::NamedTuple{(:x, :y),Tuple{Int,Int}}
    size::NamedTuple{(:w, :h),Tuple{Int,Int}}
end

struct ParticleList
    particles::Array{Particle,1}
    size::Int
end

struct CoocurrenceMatrix
    coocurrence::Array{UInt}
    Δq::Int
    CoocurrenceMatrix(coocurrence, Δq) = Δq > 0 && ndims(coocurrence) == 2
end

CoocurrenceMatrix(Δq::UInt) = CoocurrenceMatrix(zeros(UInt, Δq, Δq), Δq)