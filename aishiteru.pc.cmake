prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}/bin
libdir=${prefix}/lib
includedir=${prefix}/include

Name: @aishiteru_NAME@
Description: This code build by aziz faozi
URL: https://github.com/faoziaziz/aishteru.git
Version: @tesseract_VERSION@
Libs: -L${libdir} -l@aishiteru_OUTPUT_NAME@ 
Libs.private:
Cflags: -I${includedir}
