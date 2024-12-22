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

package interpolator_2d_bicubic_spline

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"

// Choose a scale factor > 1 to enlarge, or < 1 to shrink.
// Here we pick 1.5 as an example. Feel free to test 0.5, 2.25.
//
// IMPORTANT: The caller is responsible for freeing the memory
//            of the returned slice with a delete( ).
interpolate_2d_bicubic_spline :: proc ( source_img   : [] f64,
                                        source_len_x : int,
                                        source_len_y : int,
                                        scale_factor : f64 ) ->
                                      ( scalled_image : [ ]f64,
                                        sc_len_x      : int,
                                        sc_len_y      : int  ) {
    
    // Compute new dimensions
    new_len_x : int = int( math.floor_f64( f64( source_len_x ) * scale_factor + 0.5 ) )
    new_len_y : int = int( math.floor_f64( f64( source_len_y ) * scale_factor + 0.5 ) )

    interpolated_image : [ ]f64 = make( [ ]f64, new_len_x * new_len_y )

    // Perform bicubic interpolation for each pixel in the output image
    for dest_y in 0 ..< new_len_y {

        for dest_x in 0 ..< new_len_x {

            // Map ( dest_x, dest_y ) in the new image back to the original image space
            // src_x : f64 = f64( dest_x  ) / scale_factor
            // src_y : f64 = f64( dest_y  ) / scale_factor

            src_x : f64 = ( f64( dest_x ) + 0.5) / scale_factor - 0.5
            src_y : f64 = ( f64( dest_y ) + 0.5) / scale_factor - 0.5

            // Interpolate and store the result
            val : f64 = bicubic_interpolate( source_img,
                                             source_len_x,
                                             source_len_y,
                                             src_x,
                                             src_y  )
            
            interpolated_image[ dest_y * new_len_x + dest_x ] = val
        }
    }

    sc_len_x = new_len_x
    sc_len_y = new_len_y

    return interpolated_image,
           sc_len_x,
           sc_len_y
}

//  Bicubic interpolation of a 2D image at ( x, y ) using the
//  Catmull-Rom interpolation in both directions.
//
//  image : slice to the original 2D array in row-major order
//  width, height : dimensions of the original image
//  x, y : the floating-point coordinates where we want to interpolate
@(private="file")
bicubic_interpolate :: proc ( image : [] f64,
                              len_x : int,
                              len_y : int,
                              x     : f64,
                              y     : f64  ) ->
                            ( res_value : f64 ) {

    // Floor indices
    x_int : int = int( math.floor( x ) )
    y_int : int = int( math.floor( y ) )

    // Fractional part of x and y
    tx : f64 = x - f64( x_int )
    ty : f64 = y - f64( y_int )

    // Gather 4 sample rows for the y-direction:
    //   row indices: y_int - 1, y_int, y_int + 1, y_int + 2
    col_values : [ 4 ]f64

    for row : int = -1; row <= 2; row += 1 {

        // For each of these 4 rows, we do a 1D cubic interpolation in x
        p0 : f64 = get_pixel_clamped( image, len_x, len_y, x_int - 1, y_int + row )
        p1 : f64 = get_pixel_clamped( image, len_x, len_y, x_int,     y_int + row )
        p2 : f64 = get_pixel_clamped( image, len_x, len_y, x_int + 1, y_int + row )
        p3 : f64 = get_pixel_clamped( image, len_x, len_y, x_int + 2, y_int + row )

        col_values[ row + 1 ] = cubic_interpolate( p0, p1, p2, p3, tx )
    }

    // Now interpolate these 4 results along y
    res_value = cubic_interpolate( col_values[ 0 ], col_values[ 1 ],
                                   col_values[ 2 ], col_values[ 3 ], ty )

    return res_value
}

// Safe access function to get pixel value ( f64 ) from the
// original image with boundary clamping.
@(private="file")
get_pixel_clamped :: #force_inline proc "contextless" (
                            image : [] f64,
                            len_x : int,
                            len_y : int,
                            x     : int,
                            y     : int  ) ->
                          ( pixel_value : f64 ) {

    x := x
    y := y
    if x < 0 { x = 0 }
    if x >= len_x { x = len_x - 1 }
    if y < 0 { y = 0 }
    if y >= len_y { y = len_y - 1 }

    pixel_value = image[ y * len_x + x ]

    return pixel_value
}


// Catmull-Rom spline-based cubic interpolation in 1D.
//   Given four samples p0, p1, p2, p3, and a fractional t in [ 0, 1 ],
//   it returns the interpolated value at t.
//
//   Reference formula for Catmull-Rom:
//      f(t) = p1 + 0.5 * t * ( p2 - p0 
//                + t * ( 2 * p0 - 5 * p1 + 4 * p2 - p3 
//                + t * ( -p0 + 3 * p1 - 3 * p2 + p3 ) ) )
//
@(private="file")
cubic_interpolate :: #force_inline proc "contextless" ( 
                         p0 : f64,
                         p1 : f64,
                         p2 : f64,
                         p3 : f64,
                         t  : f64  ) ->
                       ( interpolated_value : f64 ) {

    a : f64 = -p0 + 3.0 * p1 - 3.0 * p2 + p3
    b : f64 =  2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3
    c : f64 = -p0 + p2
    d : f64 =  2.0 * p1

    t2 : f64 = t * t
    t3 : f64 = t2 * t

    interpolated_value = 0.5 * ( a * t3 + b * t2 + c * t + d )

    return interpolated_value
}
