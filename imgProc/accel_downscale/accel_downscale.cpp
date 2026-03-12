#include "hls_stream.h"
#include "ap_int.h"
#include "common/xf_common.hpp"
#include "common/xf_infra.hpp"
#include "common/xf_axi_io.hpp" // For the AXI-Stream converters
#include "imgproc/xf_cvt_color.hpp" // For rgb2gray
#include "imgproc/xf_resize.hpp"    // For downscaling

// Define maximum hardware sizes (1080p in, 270p out)
#define MAX_IN_HEIGHT 1080
#define MAX_IN_WIDTH  1920
#define MAX_OUT_HEIGHT 270 // Exactly 1/4th of 1080p
#define MAX_OUT_WIDTH  480 // Exactly 1/4th of 1080p

// Define format types
#define IN_TYPE  XF_8UC3  // 8-bit, 3 channel (RGB)
#define GRAY_TYPE XF_8UC1 // 8-bit, 1 channel (Grayscale)
#define NPPC     XF_NPPC1 // Process 1 pixel per clock cycle

// AXI-Stream interfaces
// Input is 24-bit RGB, Output is 8-bit Grayscale
typedef ap_axiu<24, 1, 1, 1> in_stream_type;
typedef ap_axiu<8, 1, 1, 1> out_stream_type;

// --------------------------------------------------------
// TOP LEVEL FUNCTION
// --------------------------------------------------------
void image_accelerator(
    hls::stream<in_stream_type>& video_in, 
    hls::stream<out_stream_type>& video_out,
    int in_rows, 
    int in_cols,
    int out_rows, 
    int out_cols
) {
    // 1. Hardware Interface Pragmas
    #pragma HLS INTERFACE axis port=video_in
    #pragma HLS INTERFACE axis port=video_out
    #pragma HLS INTERFACE s_axilite port=in_rows
    #pragma HLS INTERFACE s_axilite port=in_cols
    #pragma HLS INTERFACE s_axilite port=out_rows
    #pragma HLS INTERFACE s_axilite port=out_cols
    #pragma HLS INTERFACE s_axilite port=return

    // 2. Dataflow Pragma for Parallel Execution
    #pragma HLS DATAFLOW

    // 3. Internal Hardware FIFOs (Using Vitis Mats)
    xf::cv::Mat<IN_TYPE, MAX_IN_HEIGHT, MAX_IN_WIDTH, NPPC> img_in(in_rows, in_cols);
    xf::cv::Mat<GRAY_TYPE, MAX_IN_HEIGHT, MAX_IN_WIDTH, NPPC> img_gray(in_rows, in_cols);
    xf::cv::Mat<GRAY_TYPE, MAX_OUT_HEIGHT, MAX_OUT_WIDTH, NPPC> img_out(out_rows, out_cols);

    // 4. Stream to Matrix Conversion
    xf::cv::AXIvideo2xfMat(video_in, img_in);

    // 5. RGB to Grayscale Conversion
    xf::cv::rgb2gray<IN_TYPE, GRAY_TYPE, MAX_IN_HEIGHT, MAX_IN_WIDTH, NPPC>(img_in, img_gray);

    // 6. Image Downscaling 
    // Uses Bilinear Interpolation with a maximum hardware downscale factor of 4
    xf::cv::resize<XF_INTERPOLATION_AREA, GRAY_TYPE, MAX_IN_HEIGHT, MAX_IN_WIDTH, MAX_OUT_HEIGHT, MAX_OUT_WIDTH, NPPC, 4>(img_gray, img_out);

    // 7. Matrix back to AXI-Stream Output
    xf::cv::xfMat2AXIvideo(img_out, video_out);
}