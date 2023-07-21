# TL - 200723
## This scripts generates the input files for DILS

## root to all data
rootdir=$(echo "/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf")

## Define the focal species
Species1=$(echo "Mellifera")
Species2=$(echo "Ligustica")
nbloci=$(echo "200" | bc)
constant_or_variable_Ne_through_time=$(echo "constant") # constant: Ne constant after split or variable: to consider population growth / bottleneck
use_the_SFS=$(echo "no") # yes/no

## list sequences in bed.tmp files
# Sp1
rm $rootdir/"$Species1"_list_genomic_regions.txt
for i in $rootdir/$Species1/*.bed.tmp; do
	cd $i
	ls *.fasta | grep -v "clean" > list_tmp
	while read line; do
		echo "$i/$line" >> $rootdir/"$Species1"_list_genomic_regions.txt
	done < list_tmp
	rm list_tmp
	cd ..
done

# Sp2
rm $rootdir/"$Species2"_list_genomic_regions.txt
for i in $rootdir/$Species2/*.bed.tmp; do
        cd $i
        ls *.fasta | grep -v "clean" > list_tmp
        while read line; do
                echo "$i/$line" >> $rootdir/"$Species2"_list_genomic_regions.txt
        done < list_tmp
        rm list_tmp
        cd ..
done

# randomly select n loci of the genome
shuf -n "$nbloci" $rootdir/"$Species1"_list_genomic_regions.txt > $rootdir/"$Species1"_list_genomic_regions.subset"$nbloci".txt
rm $rootdir/Loci_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt

species1=$(echo "$Species1" | tr '[:upper:]' '[:lower:]')
species2=$(echo "$Species2" | tr '[:upper:]' '[:lower:]')
while read line; do 
	firstcolumn=$(echo $line) # >> $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt
	seqsp2=$(echo "$line" | sed "s/$Species1/$Species2/g" | sed "s/$species1/$species2/g")
	#echo $firstcolumn
	#echo $seqsp2
	secondcolumn=$(echo $seqsp2) #
	echo "$firstcolumn	$secondcolumn" >> $rootdir/Loci_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt
done < $rootdir/"$Species1"_list_genomic_regions.subset"$nbloci".txt

# Extract regions and generate the input files for sequences in DILS
rm $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt # rm if exists
rm "$Species1"_list_individuals.tmp "$Species2"_list_individuals.tmp # rm if exists
while read line; do
	# Collect and format sequence data for species 1 for the current locus
	first_file=$(echo $line | awk '{print $1}')
	less $first_file > tmpsp1
	locusID=$(echo "$first_file" | sed "s;$rootdir;;g" | sed 's/\.bed\.tmp/\t/g' | awk '{print $2}' | sed 's/recontrseq_//g' | sed "s/$Species1//g" | sed "s/$species1//g" | sed 's/_\+//g' | sed 's;/\+;;g' | sed 's/\.fasta//g' | sed 's/1\.filtered//g' | sed 's/\.vcf//g' | sed 's/\.\+/\./g' | awk -F "." '{print $2"_"$3":"$4"-"$5}')
	echo $first_file
	echo $locusID
	while read line2; do
		if [ "${line2:0:1}" = ">" ]; then
			individualID=$(echo "$line2" | sed 's/:/\t/g' | awk '{print $1}' | sed 's/>//g')
			echo "$individualID" >> "$Species1"_list_individuals.tmp
			echo ">$locusID|$Species1|$individualID|Allele1" >> $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt #All are allele since the sequences come from haploid drones
		else
			echo "$line2" >> $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt
		fi
	done < tmpsp1
	# Collect and format sequence data for species 2 for the current locus
	second_file=$(echo "$line" | awk '{print $2}')
	less $second_file > tmpsp2
        while read line2; do
                if [ "${line2:0:1}" = ">" ]; then
           		individualID2=$(echo "$line2" | sed 's/:/\t/g' | awk '{print $1}' | sed 's/>//g')
			echo "$individualID2" >> "$Species2"_list_individuals.tmp
                        echo ">$locusID|$Species2|$individualID2|Allele1" >> $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt #All are allele since the sequences come from haploid drones
                else
                        echo "$line2" >> $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt
                fi
        done < tmpsp2
	rm tmpsp1 tmpsp2
done < $rootdir/Loci_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt
sort "$Species1"_list_individuals.tmp | uniq > "$Species1"_list_individuals.txt
sort "$Species2"_list_individuals.tmp | uniq > "$Species1"_list_individuals.txt

# Generate the input files including the yaml file
new_rootdir=$(echo "/work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS")
cd $new_rootdir
mkdir "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup
cd "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup
cp $rootdir/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt .

# generate the yaml file
echo "mail_address: thibault.leroy@inrae.fr" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "infile: $new_rootdir/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup/Sequences_"$Species1"_"$Species2"_randomlyselected_"$nbloci"_genomic_regions.txt" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "region: coding" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "nspecies: 2" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "nameA: $Species1" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "nameB: $Species2" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "nameOutgroup: NA" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "lightMode: TRUE" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
if [ "$use_the_SFS" == "no" ]; then
	echo "No SFS used"
	echo "useSFS: 0" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
elif [ "$use_the_SFS" == "yes" ]; then
	echo "SFS used"
	echo "useSFS: 1" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
else
	echo "Please revise the script in order to indicate if the SFS should be used or not in the summary statistics!!!"
fi
echo "config_yaml: $new_rootdir/$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "timeStamp: resDILS_"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "population_growth: $constant_or_variable_Ne_through_time" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
if [ "$constant_or_variable_Ne_through_time" == "constant" ]; then
	echo "Mode used: constant Ne through time"
elif [ "$constant_or_variable_Ne_through_time" == "variable" ]; then
	echo "Tchanges min: 100" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
	echo "Tchanges max: 1000000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
	echo "Mode used: variable Ne through time [by default priors: 100-1000000]"
fi
echo "modeBarrier: bimodal" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "max_N_tolerated: 0.5" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "Lmin: 1000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "nMin: 7" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml #this corresponds to the number of individuals considering diploids (so 14 haploid sequences, here the minimum number of individuals in the dataset is 16 haploid)
echo "mu: 0.0000000034" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml # the mutation rate by default is 0.00000002763, here adjusted for honeybee based on https://pubmed.ncbi.nlm.nih.gov/28007973/ & https://www.nature.com/articles/nature14649
echo "rho_over_theta: 0.5" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "N_min: 0" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "N_max: 500000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "Tsplit_min: 0">> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "Tsplit_max: 2000000" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "M_min: 1" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml
echo "M_max: 40" >> "$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml

# cp the cluster_test.json in the directory
cp $rootdir/cluster_test.json .
mv cluster_test.json cluster.json

# cp script_lanceur_DILS.sh in the directory
cp $rootdir/script_lanceur_DILS.sh .
my_new_yaml_file=$(echo "$new_rootdir"/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup.yaml)
my_new_json_file=$(echo ""$new_rootdir"/"$Species1"_"$Species2"_"$constant_or_variable_Ne_through_time"Ne_"$use_the_SFS"SFS_nooutgroup/cluster.json")
sed "s;/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/bidon.yaml;$my_new_yaml_file;g" script_lanceur_DILS.sh | sed "s;/work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Demo_DILS_tests/cluster_test.json;$my_new_json_file;g" > script_lanceur_DILS.tmp
mv script_lanceur_DILS.tmp script_lanceur_DILS.sh
