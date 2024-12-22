# Interpolator 2D by bicubic spline in Odin
This is a simple implementation and test setup of interpolator of 2D slices using bicubic splines in the Odin programming language.

## Description
A simple lib function to make interpolation of a 2D slice by bicubic splines. The function interpolate_2d_bicubic_spline( ) receives a 2D slice, it's dimensions, and a scale factor to interpolate the 2D slice. The function returns a new 2D slice with the interpolated values, and its dimensions.

## To compile and run do

``` bash
$ make
$ make run
```

## Examples of execution

```
Begin interpolate 2d slice by bicubic spline...
  
Source image len_x: 4 len_y 4 :

 0.0  1.0  2.0  3.0
 4.0  5.0  6.0  7.0
 8.0  9.0 10.0 11.0
12.0 13.0 14.0 15.0

Scalled image 1.5x len_x: 6 len_y 6 :

-0.3  0.2  0.9  1.6  2.3  2.8	
 1.7  2.2  2.9  3.6  4.3  4.8	
 4.6  5.1  5.8  6.5  7.2  7.7	
 7.3  7.8  8.5  9.2  9.9 10.4	
10.2 10.7 11.4 12.1 12.8 13.3	
12.2 12.7 13.4 14.1 14.8 15.3	

Scalled image 0.5x len_x: 2 len_y 2 :

 2.2  4.3	
10.7 12.8	

...end interpolate 2d slice by bicubic spline.

```

## References on Catmull–Rom spline
- Wikipedia Catmull–Rom spline <br>
  [https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Catmull%E2%80%93Rom_spline](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Catmull%E2%80%93Rom_spline)

<br>

- Catmull-Rom splines by Christopher Twigg <br>
  [https://www.cs.cmu.edu/~fp/courses/graphics/asst5/catmullRom.pdf](https://www.cs.cmu.edu/~fp/courses/graphics/asst5/catmullRom.pdf)


## License
MIT Open Source License.


## Have fun!
Best regards, <br>
João Carvalho

