"A Particle Swarm Optimization particle"
struct Particle
    "particle's speed"
    speed::Int
    "particle's current position over a given image"
    pos::NamedTuple{(:x, :y),Tuple{Int,Int}}
    "particle's direction"
    dir::NamedTuple{(:x, :y),Tuple{Int,Int}}
    "particle's window pixel dimentions on x and y"
    size::NamedTuple{(:w, :h),Tuple{Int,Int}}
end

"Creates a new particle initializing speed to 0, direction to 0,0, position to x,y and size to size"
Particle(x, y, size) = Particle(0, (x = x, y = y), (x = 0, y = 0), size)

struct ParticleList
    particles::Array{Particle,1}
    size::Int
    dim::NamedTuple{(:w, :h),Tuple{Int,Int}}
end

ParticleList(particles) = 
    ParticleList(particles, particles[0].size[:w] * particles[0].size[:h], particles[0].size)

struct CoocurrenceMatrix
    coocurrence::Array{UInt}
    Δq::Int
end

CoocurrenceMatrix(Δq) = CoocurrenceMatrix(zeros(UInt, Δq, Δq), Δq)

struct CoocurrenceMatrixGroup
    coocurrence::Array{UInt,3}
    Δq::Int
    particles::ParticleList
end

CoocurrenceMatrixGroup(Δq, particles::ParticleList) = 
    CoocurrenceMatrixGroup(zeros(UInt, particles.dim, Δq, Δq), Δq, particles)
