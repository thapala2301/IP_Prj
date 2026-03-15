<project xmlns="com.autoesl.autopilot.project" name="accel_downscale" top="image_accelerator">
    <includePaths/>
    <libraryPaths/>
    <Simulation>
        <SimFlow name="csim" csimMode="0" lastCsimMode="0"/>
    </Simulation>
    <files xmlns="">
        <file name="../accel_downscale_tb.cpp" sc="0" tb="1" cflags=" -I../../../../../../../../Vitis_Libraries/vision/L1/include -std=c++14 -Wno-unknown-pragmas" csimflags=" -Wno-unknown-pragmas" blackbox="false"/>
        <file name="accel_downscale/accel_downscale.cpp" sc="0" tb="false" cflags="-IC:/Vitis_Libraries/vision/L1/include -std=c++14" csimflags="" blackbox="false"/>
    </files>
    <solutions xmlns="">
        <solution name="solution1" status="active"/>
    </solutions>
</project>

