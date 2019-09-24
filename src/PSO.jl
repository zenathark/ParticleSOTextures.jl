module PSO

using Logging, IOLogging, Base.Threads

logger = IOLogger()
oldGlobal = global_logger(logger)


struct Particle
    speed::Int
    pos::NamedTuple{(:x, :y),Tuple{Int,Int}}
    dir::NamedTuple{(:x, :y),Tuple{Int,Int}}
end

struct ParticleList
    particles::Array{Particle,1}
    dim::NamedTuple{(:w, :h),Tuple{Int,Int}}
    size::Int
end

ispeed = 0
idir = (x = 0, y = 0)

newparticles!(dest::Array{Particle,1}, maxx::Int, maxy::Int, amount::Int) =
    map!(i->Particle(ispeed, NamedTuple{(:x, :y)}(i), idir), 
         dest,
         collect(zip(rand(2:maxx, amount), rand(2:maxy, amount))))

newparticleslist(dest::Array{Particle,1}, dim::NamedTuple{(:w, :h),Tuple{Int,Int}}, amount::Int) =
    _newparticlelist(newparticles!(dest, dim[:w], dim[:h], amount))

_newparticlelist(p::Array{Particle,1}, dim::NamedTuple{(:w, :h),Tuple{Int,Int}}) = 
    ParticleList(p, dim, dim[:w] * dim[:h])


function omnidirectional_coocurrence!(dest, image, p::Particle, size::NamedTuple{(:w, :h),Tuple{Int,Int}})
    for (x_local, y_local) in Iterators.product(1:size[:w], 1:size[:h])
        x = x_local + p.pos[:x]
        y = y_local + p.pos[:y]
        i = image[x,y]
        j = image[x,y - 1]    #(0, 1)
        dest[i,j] += 1
        j = image[x - 1,y - 1]  #(-1, 1)
        dest[i,j] += 1
        j = image[x - 1,y]    #(-1, 0)
        dest[i,j] += 1
        j = image[x - 1,y - 1]    #(-1, -1)
        dest[i,j] += 1
    end
    return nothing
end

function directional_coocurrence!(dest, image, particle, size, direction)
    for (x_local, y_local) in Iterators.product(1:size[:w], 1:size[:h])
        x = x_local + particle.pos[:x]
        y = y_local + particle.pos[:y]
        i = image[x,y]
        j = image[x + direction[:x], y + direction[:y]]
        dest[i, j] += 1
    end
    return nothing
end

linearindex(plist::ParticleList, pidx::Int, x::Int, y::Int) = 
    plist.size * pidx + x * y

function fromlinearindex(plist::ParticleList, pos::Int)
    pidx = div(pos - 1, plist.size)
    localsize = pos - 1 - plist.size * pidx
    x = div(localsize, plist.dim[:w])
    y = mod(localsize, plist.dim[:w])
    return (pidx + 1, x + 1, y + 1)
end

function coocurencepar!(dest::Array{Int,3}, image, plist::ParticleList, start::Int, amount::Int)
    for c in start:start + amount - 1
        pidx, xlocal, ylocal = fromlinearindex(plist, c)
        x = xlocal + plist.particles[pidx].pos[:x]
        y = ylocal + plist.particles[pidx].pos[:y]
        i = image[x,y]
        j = image[x,y - 1]    #(0, 1)
        dest[pidx, i,j] += 1
        j = image[x - 1,y - 1]  #(-1, 1)
        dest[pidx, i,j] += 1
        j = image[x - 1,y]    #(-1, 0)
        dest[pidx, i,j] += 1
        j = image[x - 1,y - 1]    #(-1, -1)
        dest[pidx, i,j] += 1
    end
    return nothing
end

function run_parallel!(dest::Array{Int,3}, image, plist::ParticleList)
    amount = div((plist.size * size(plist.particles, 1)), nthreads())
    @threads for i in 1:nthreads()
        coocurencepar!(dest, image, plist, (i - 1) * amount + 1, amount)
    end
    return nothing
end

end # module
