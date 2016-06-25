d=$1

function create_graph
{
	echo digraph kaka 
	echo { 
	echo labelloc="t"; 
	echo node1 [shape="underline",label=\"Comparative performace of temporal methods.\\n\\n Arrow from A to B indicates that method A\\n has a lower classification error than method B \"];

	for m in fremen gmm location static adaptive interval
	do	
		for n in fremen gmm location static adaptive interval
		do
			#echo -ne Comparing $m and $n' ';
			if [ $(paste $m.txt $n.txt|tr \\t ' '|./t-test|grep -c higher) == 1 ]
			then
				echo $n '->' $m;
			fi
		done
	done
	echo }
}

for m in fremen gmm 
do
	errmin=100
	indmin=0
	for o in 1 2 3 4 5
	do
		err=$(cat ../results/$d/$m\_$o\_confmat.txt |sed -n 7,1000p|awk '{i=i+1;a=a+1-$5}END{print a/i}')
		#echo $m $o $err $errmin
		sm=$(echo $err $errmin|awk '{a=0}($1 > $2){a=1}{print a}')
		if [ $sm == 0 ];
		then
			errmin=$err
			indmin=$o
		fi
done
	cat ../results/$d/$m\_$indmin\_confmat.txt |sed -n 7,1000p|awk '{print 1-$5}' >$m.txt
done

for m in interval 
do
	errmin=100
	indmin=0
	for o in 1 24 96 288 720 1440 
	do
		err=$(cat ../results/$d/$m\_$o\_confmat.txt |sed -n 7,1000p|awk '{i=i+1;a=a+1-$5}END{print a/i}')
		#echo $m $o $err $errmin
		sm=$(echo $err $errmin|awk '{a=0}($1 > $2){a=1}{print a}')
		if [ $sm == 0 ];
		then
			errmin=$err
			indmin=$o
		fi
done
	cat ../results/$d/$m\_$indmin\_confmat.txt |sed -n 7,1000p|awk '{print 1-$5}' >$m.txt
done

for m in adaptive 
do
	errmin=100
	indmin=0
	for o in 1 10 50 100 500 1000 
	do
		err=$(cat ../results/$d/$m\_$o\_confmat.txt |sed -n 7,1000p|awk '{i=i+1;a=a+1-$5}END{print a/i}')
		#echo $m $o $err $errmin
		sm=$(echo $err $errmin|awk '{a=0}($1 > $2){a=1}{print a}')
		if [ $sm == 0 ];
		then
			errmin=$err
			indmin=$o
		fi
done
	cat ../results/$d/$m\_$indmin\_confmat.txt |sed -n 7,1000p|awk '{print 1-$5}' >$m.txt
done


cat ../results/$d/location_confmat.txt |sed -n 7,1000p|awk '{print 1-$5}' >location.txt
cat ../results/$d/fremen_0_confmat.txt |sed -n 7,1000p|awk '{print 1-$5}' >static.txt

#for m in fremen gmm location static
#do	
#for n in fremen gmm location static
#do
	#echo -ne Comparing $m and $n' ';paste $m.txt $n.txt|tr \\t ' '|./t-test
#done
#done


#echo 'digraph { rankdir=LR; A -> B [label="T-test indicates that \n A achieves lower error then B"];'

create_graph|dot -Tpdf >$d.pdf
create_graph
