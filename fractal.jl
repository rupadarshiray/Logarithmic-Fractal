#=
Replication of the python code in Julia.
This code is wayyy faster (like whooshh) than the python one, and supports multithreaded rendering.
Run this with as many cores as you can (.❛ ᴗ ❛.)
TODO => Render the fractal for a specified Hausdorff dimension.
And ummm... sorry for the messy ternary expressions.
=#

using Images                    # Images library to render image

const width  = 20000            # Width of rendered image, in pixels
const height = width            # Height of rendered image, in pixels
const num_points = 100000000    # Number of points to render, positive integer
const iterations = 10           # Number of times of iterative transformations, positive integer, default 10
const span       = 50.0         # Extent of spiral rendering (in radians), positive real
const k          = 0.80         # Defines polar slope of the spiral (the greater the value of k, the less the slope), real in the interval (0, 1)
const lnk        = log(k)       # Natural logarithm of k
const atanlnk    = atan(lnk)    # Arctangent of natural logarithm of k
const downscale  = 3.0/k        # Downscaling factor of size of spirals between successive iterations, deafult 3.0/k
const lnkplusi   = lnk+im       # Precomputed Complex constant with value log(k) + i 
const wby2 = width/2.0          # Half of width
const hby2 = height/2.0         # Half of height
const tvr1 = span * lnkplusi    # Precomputed real constant ...
const kmod = k^(1/downscale)    # Another precomputed real constant ...
const tvr2 = lnkplusi/downscale # And another one ...

disp = fill(false, (width, height))     # Empty image array

Threads.@threads for i in 1:num_points  # Render points in multiple threads
    z = 2 * round((2 * rand() - 1) * span * rand()) + (1 - exp(tvr1 * rand() * rand())) * rand((-1, 1))     # Z(0), the basic set
    for j in 1:iterations       # Iterations to add spirals
        real.(z) > 0  ?  z = 2 * round((2 * rand() - 1) * span * rand()) + (1 - exp( tvr2 * real.(z))) + (((kmod^real.(z))  * imag.(z) / downscale) * exp(im*(real.(z)/downscale-atanlnk)))  :  z = 2 * round((2 * rand() - 1) * span * rand()) - (1 - exp(-tvr2 * real.(z))) + (((kmod^(-real.(z))) * imag.(z) / downscale) * exp(im*(-real.(z)/downscale-atanlnk))) 
    end
    real.(z) > 0  ?  z = (1 - exp( tvr2 * real.(z))) + (((kmod^real.(z))  * imag.(z) / downscale) * exp(im*(real.(z)/downscale-atanlnk)))  :  z = - (1 - exp(-tvr2 * real.(z))) + (((kmod^(-real.(z))) * imag.(z) / downscale) * exp(im*(-real.(z)/downscale-atanlnk)))     # Last transformation
    @inbounds  try  disp[round(Int, (imag.(z)/2+1)*wby2), round(Int, (real.(z)/2+1)*hby2)] = true  catch;  end      # Draw the point if possible
end

save("output.png", colorview(Gray, disp))       # Save the image
