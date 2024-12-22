// Description: A simple lib function to make interpolation of a 2D slice by
//              bicubic splines. The function interpolate_2d_bicubic_spline( )
//              receives a 2D slice, it's dimensions, and a scale factor to
//              interpolate the 2D slice.
//              The function returns a new 2D slice with the interpolated
//              values, and its dimensions.
//
// License: MIT Open Source License.
//
// To compile and run do:
// 
// make
// make run
//
// References on Catmull–Rom spline:
//
//    Wikipedia Catmull–Rom spline
//    [https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Catmull%E2%80%93Rom_spline](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Catmull%E2%80%93Rom_spline)
//
//    Catmull-Rom splines by Christopher Twigg
//    [https://www.cs.cmu.edu/~fp/courses/graphics/asst5/catmullRom.pdf](https://www.cs.cmu.edu/~fp/courses/graphics/asst5/catmullRom.pdf)
//
// Have fun!


package main

import "core:fmt"
import "core:math"

import interp "./interpolator_2d_bicubic_spline"

LEN_X :: 4 
LEN_Y :: 4
TOTAL_SIZE :: LEN_X * LEN_Y 

main :: proc ( ) {

    fmt.println("\nBegin interpolator of 2d slices by bicubic spline ...\n  ")


    source_img := [ ? ]f64 {  0,  1,  2,  3,
                              4,  5,  6,  7,
                              8,  9, 10, 11,
                             12, 13, 14, 15  }

    // Times to scale the image.
    scale_factor := 1.5 

    scalled_image_bigger,
    sc_len_x_bigger,
    sc_len_y_bigger :=
    interp.interpolate_2d_bicubic_spline( source_img[ :],
                                          LEN_X,
                                          LEN_Y,
                                          scale_factor )
  
    scale_factor = 0.5 // Times to scale the image.

    scalled_image_smaller,
    sc_len_x_smaller,
    sc_len_y_smaller :=
         interp.interpolate_2d_bicubic_spline( source_img [ : ],
                                               LEN_X,
                                               LEN_Y,
                                               scale_factor )
  
    fmt.printfln("\nSource image len_x: %d len_y %d :", LEN_X, LEN_Y )
    print_slice( source_img[ : ], LEN_X, LEN_Y )

    fmt.printfln("\nScalled image 1.5x len_x: %d len_y %d :", sc_len_x_bigger, sc_len_y_bigger )
    print_slice( scalled_image_bigger[ : ], sc_len_x_bigger, sc_len_y_bigger )

    fmt.printfln("\nScalled image 0.5x len_x: %d len_y %d :", sc_len_x_smaller, sc_len_y_smaller )
    print_slice( scalled_image_smaller[ : ], sc_len_x_smaller, sc_len_y_smaller )

    fmt.println("\n...end interpolator of 2d slices by bicubic spline.\n  ")
}

// Convert 2D coordenates to 1D index.
c2d_to_1d :: #force_inline proc ( x     : int,
                                  y     : int,
                                  len_x : int ) -> 
                                ( index : int ) {

    return y * len_x + x
}

// Print array.
print_slice :: proc ( slice_vec : [ ]f64,
                      len_x     : int,
                      len_y     : int  ) {

    for y in 0 ..< len_y {

        for x in 0 ..< len_x {

            index := c2d_to_1d( x, y, len_x )
            fmt.printf( "%.1f\t", slice_vec[ index ] )
        }

        fmt.println( )
    }
}

