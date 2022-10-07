
''' Import libraries ___________________________________'''

from PIL import Image                                   # Pillow to render image
from numpy import log as ln, arctan as taninv, e        # Natural logarithm, inverse tangent, and Euler's constant
from random import uniform                              # Random number generator


''' Variables and parameters ___________________________'''

num_points = 100000     # Number of points to render, positive integer
iterations = 10         # Number of times of iterative transformations, positive integer, default 10
span = 50               # Extent of spiral rendering (in radians), positive real
k = 0.80                # Defines polar slope of the spiral (the greater the value of k, the less the slope), real in the interval (0, 1) 
lnk = ln(k)             # Natural logarithm of k
downscale = 3.0/k       # Downscaling factor of size of spirals between successive iterations, deafult 3.0/k
width, height = 800, 800                                            # Width and height (in pixels) of final output image , preferably width = height
img_scaling = 1.5                                                   # Upscaling factor to generate size of image rendering canvas, default 1.5
resx, resy = round(width*img_scaling), round(height*img_scaling)    # Size of image rendering canvas in pixels
img = Image.new('RGB', (resx, resy))                                # Create a new image object


''' Defining the signum function _______________________'''

def sgn(num) :
    if num > 0 : return  1
    if num < 0 : return -1
    return 0


''' Random number generator 
    with a -ln(abs(x/span)) probability density ________'''

def rand():
    q = uniform(0, span)
    return uniform(-q, q)


''' Generate points on the fractal _____________________'''

for point in range(num_points) :

    m = round(rand())
    theta = rand()
    z = 2*m + sgn(theta) * (1 - e**(abs(theta)*(lnk+1j)))       # Z(0), the basic set 

    for iter in range(iterations):                              # Iterations to add spirals in spirals
        m = round(rand())
        theta = z.real / downscale
        y = (k**abs(theta)) * z.imag / downscale
        z = 2*m + sgn(theta) * ( 1 - e**(abs(theta)*(lnk+1j))) + ( y * (e**(1j*(abs(theta)-taninv(lnk)))))      # Map the Z(n-1) to the base spiral to create Z(n)
    
    theta = z.real/downscale
    y = (k**abs(theta)) * z.imag/downscale
    z = sgn(theta) * ( 1 - e**(abs(theta)*(lnk+1j))) + ( y * (e**(1j*(abs(theta)-taninv(lnk)))))    # The final mapping

    x = round(z.real * resx/4 + resx/2)         # |
    y = round(z.imag * resy/4 + resy/2)         # | Draw the point if
    try : img.putpixel((x, y), (255,255,255))   # | it falls inside image
    except : ()                                 # |

    if not (point*100)%num_points : print(f'{(point*100)//num_points+1}% completed')      # Progress update


''' Export image _______________________________________'''

print('Processing Image...')
img = img.resize((width,height), Image.LANCZOS)     # Downscale image
img.save('output.png')                              # Save image
print('Done.')
img.show()                                          # Display image