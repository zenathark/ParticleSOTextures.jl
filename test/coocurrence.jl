using PSO
using Test

@testset "Co-ocurrence" begin
	@testset "single co-ocurrence" begin
		p = PSO.Particle(0, (x = 2, y = 2), (x = 0, y = 0))
		testimage = reshape(Vector(1:49), (7,7))
		got = zeros(Int, 256, 256)
		PSO.coocurrence!(got, testimage, p, (w = 4, h = 4))
		@test got[27,20] == 1
	end

	@testset "parallel" begin
		particles_data = Array{PSO.Particle}(undef, 3)
		PSO.newparticles!(particles_data, 11, 11, 3)
		particles = PSO.ParticleList(particles_data, (w = 4, h = 4), 16)
		testimage = reshape(rand(1:256, 256 * 256), (256, 256))
		p1 = zeros(Int, 256, 256)
		p2 = zeros(Int, 256, 256)
		p3 = zeros(Int, 256, 256)
		par = zeros(Int, 3, 256, 256)
		PSO.coocurrence!(p1, testimage, particles_data[1], (w = 4, h = 4))
		PSO.coocurrence!(p2, testimage, particles_data[2], (w = 4, h = 4))
		PSO.coocurrence!(p3, testimage, particles_data[3], (w = 4, h = 4))
		PSO.coocurencepar!(par, testimage, particles, 1, 48)
		@test p1 == par[1,:,:]
		@test p2 == par[2,:,:]
		@test p3 == par[3,:,:]
	end
end
