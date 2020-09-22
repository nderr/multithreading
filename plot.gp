set term pngcairo size 1100,700 font 'Helvetica,14'

set output 'threading.png'

cc='out_mat_mul_cc'
py='out_mat_mul_py'
py_v='out_mat_mul_py_v'

set multiplot layout 2,3

set title 'C++'
set xlabel 'threads'
set ylabel 'time'
set key
unset yrange
set logscale y
set format y "10^{%L}"
plot for[i=0:*] cc index i u 2:3 w l lw 7 title columnheader(1)

set title 'python (for + joblib)'
unset key
set xlabel 'threads'
set ylabel 'time'
unset yrange
set logscale y
set format y "10^{%L}"
plot for[i=0:*] py index i u 2:3 w l lw 7 title columnheader(1)

set title 'python (vectorized)'
set xlabel 'threads'
set ylabel 'time'
unset yrange
set logscale y
set format y "10^{%L}"
plot for[i=0:*] py_v index i u 2:3 w l lw 7 title columnheader(1)

unset title
unset logscale 
set ylabel 'efficiency'
set yrange [0:1.1]
unset format y
plot for[i=0:*] cc index i using 2:4 w l lw 7 title columnheader(1), 1. title 'perfect' w l lw 3 lc 'black' lt 2 dt 2, 1./x title 'no gain' w l lw 3 lc 'black' lt 2 dt 2

unset logscale 
set ylabel 'efficiency'
set yrange [0:1.1]
unset format y
plot for[i=0:*] py index i using 2:4 w l lw 7 title columnheader(1), 1. title 'perfect' w l lw 3 lc 'black' lt 2 dt 2, 1./x title 'no gain' w l lw 3 lc 'black' lt 2 dt 2

unset logscale 
set ylabel 'efficiency'
set yrange [0:1.1]
unset format y
plot for[i=0:*] py_v index i using 2:4 w l lw 7 title columnheader(1), 1. title 'perfect' w l lw 3 lc 'black' lt 2 dt 2, 1./x title 'no gain' w l lw 3 lc 'black' lt 2 dt 2

unset multiplot
unset output
