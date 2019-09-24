struct Particle
    speed::Int
    pos::NamedTuple{(:x, :y),Tuple{Int,Int}}
    dir::NamedTuple{(:x, :y),Tuple{Int,Int}}
    size::NamedTuple{(:w, :h),Tuple{Int,Int}}
end

Particle(x, y, size) = Particle(0, (x = x, y = y), (x = 0, y = 0, size))

struct ParticleList
    particles::Array{Particle,1}
    size::Int
end

struct CoocurrenceMatrix
    coocurrence::Array{UInt}
    Δq::Int
end

CoocurrenceMatrix(Δq) = CoocurrenceMatrix(zeros(UInt, Δq, Δq), Δq)

struct CoocurrenceMatrixGroup
    coocurrence::Array{UInt,3}
    Δq::Int
    particle_size::Int
end

CoocurrenceMatrixGroup(Δq, particle_size) = 
    CoocurrenceMatrixGroup(zeros(UInt, particle_size, Δq, Δq), Δq, particle_size)
