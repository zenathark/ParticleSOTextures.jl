using CuArrays, CUDAnative

function gpu_add1!(y, x)
	for i = 1:length(y)
		@inbounds y[i] += x[i]
	end
	return nothing
end

function gpu_add2!(y, x)
	index = threadIdx().x
	stride = blockDim().x
	for i = index:stride:length(y)
		@inbounds y[i] += x[i]
	end
	return nothing
end

function bench_gpu1!(y, x)
	CuArrays.@sync begin
		@cuda gpu_add1!(y, x)
	end
end

function bench_gpu2!(y, x)
	CuArrays.@sync begin
		@cuda threads=256 gpu_add2!(y, x)
	end
end

