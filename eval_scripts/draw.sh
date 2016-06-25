for i in fremen gmm adaptive interval
do
gnuplot draw_$i.gnu >params_$i.fig
done

i='confmat';gnuplot -e "diag='$i';max='24.9';min='0.0'" draw_summary.gnu >summary_$i.fig
i='80';gnuplot -e "diag='$i';max='79.9';min='0.0'" draw_summary.gnu >summary_$i.fig
i='20';gnuplot -e "diag='$i';max='79.9';min='0.0'" draw_summary.gnu >summary_$i.fig
