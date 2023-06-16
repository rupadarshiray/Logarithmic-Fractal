# Logarithmic-Fractal
A spiraling fractal on the complex plane.  

![Full fractal](Full.png)  
  
![Cropped](Cropped.png)  
  
The basic fractal is defined as the set $z_n$ as $n$ tends to $\infty$, where

$$\begin{aligned}
  z_{n+1}&=\left\{\left(2 m+\operatorname{sgn}(\operatorname{Re}(\mathrm{z}))\left(1-\mathrm{e}^{|\operatorname{Re}(z)|(\ln (k)+i)}\right)+k^{|\operatorname{Re}(z)|} e^{i(|\operatorname{Re}(z)|-\arctan (\ln (k))} \ln(z)\right) \mid z \in z_n, m \in \mathbb{Z}\right\} \\
 z_0&=\left\{\left(2 m+\operatorname{sgn}(\operatorname{Re}(\theta))\left(1-\mathrm{e}^{|\operatorname{Re}(\theta)|(\ln (k)+i)}\right) \mid \theta \in \mathbb{R}, \mathrm{m} \in \mathbb{Z}\right\}\right. 
\end{aligned}$$
where $k\in(0,1)$ It is a fractal of logarithmic spirals.
