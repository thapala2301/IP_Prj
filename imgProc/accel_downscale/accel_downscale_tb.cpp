#include <iostream>
#include "hls_stream.h"
#include "ap_int.h"
#include "ap_axi_sdata.h" // <-- The missing AXI-Stream definitions!

// Redefine interfaces for the testbench
typedef ap_axiu<24, 1, 1, 1> in_stream_type;
typedef ap_axiu<8, 1, 1, 1> out_stream_type;

// Prototype of your hardware function
void image_accelerator(
    hls::stream<in_stream_type>& video_in, 
    hls::stream<out_stream_type>& video_out,
    int in_rows, 
    int in_cols,
    int out_rows, 
    int out_cols
);

int main() {
    // 1. Create the hardware streams
    hls::stream<in_stream_type> src_stream("src");
    hls::stream<out_stream_type> dst_stream("dst");

    // 2. Define the exact resolutions
    int in_rows = 1080;
    int in_cols = 1920;
    int out_rows = 270;
    int out_cols = 480;

    std::cout << "----------------------------------------" << std::endl;
    std::cout << "Generating synthetic 1080p input frame..." << std::endl;

    // 3. Generate a fake 1080p image and convert to AXI4-Stream
    for (int row = 0; row < in_rows; row++) {
        for (int col = 0; col < in_cols; col++) {
            in_stream_type pixel;
            
            // Set pixel color (e.g., pure white: RGB = 255, 255, 255)
            pixel.data = 0xFFFFFF; 
            
            // Vitis Vision requires exact hardware signals to know image boundaries
            // TUSER = 1 indicates the very first pixel of the frame
            pixel.user = (row == 0 && col == 0) ? 1 : 0; 
            
            // TLAST = 1 indicates the last pixel of a row
            pixel.last = (col == (in_cols - 1)) ? 1 : 0; 
            
            src_stream << pixel;
        }
    }

    std::cout << "Firing Hardware Accelerator IP..." << std::endl;

    // 4. Run the IP
    image_accelerator(src_stream, dst_stream, in_rows, in_cols, out_rows, out_cols);

    std::cout << "Hardware processing complete!" << std::endl;
    std::cout << "Verifying output AXI4-Stream..." << std::endl;

    // 5. Read the output stream and count the pixels
    int pixel_count = 0;
    int expected_pixels = out_rows * out_cols;

    while (!dst_stream.empty()) {
        out_stream_type out_pixel;
        dst_stream >> out_pixel; // Pull a pixel out of the FIFO
        pixel_count++;
    }

    // 6. Check if the downscaler produced the exact right amount of pixels
    if (pixel_count == expected_pixels) {
        std::cout << ">>> TEST PASSED: Successfully downscaled and converted to Grayscale! <<<" << std::endl;
        std::cout << "Output frame size: " << out_cols << "x" << out_rows 
                  << " (" << pixel_count << " pixels)." << std::endl;
        std::cout << "----------------------------------------" << std::endl;
        return 0; // Return 0 means the testbench passed
    } else {
        std::cout << ">>> TEST FAILED! <<<" << std::endl;
        std::cout << "Expected " << expected_pixels << " pixels, but got " << pixel_count << std::endl;
        return 1; // Return 1 means failure
    }
}