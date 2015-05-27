NAME="makeforest"
if [ $# -lt 3 ]
then
  echo "Usage: ./${NAME}.sh <inputlist> <outdir> <pythonconfig>"
  exit 1
fi
Queue=`wc -l $1 | awk '{print $1}'`
now="_${NAME}_$(date +"%Y_%m_%d__%H_%M_%S")_proddir"
mkdir $now
mkdir -p $2

cat <<EOF > "run${NAME}.sh"
if [ \$# -ne 4 ]
then
  echo "Usage: ./run${NAME}.sh <filenum> <inputlist> <outdir> <pythonconfig>"
  exit 1
fi
echo sleeping \$((\${1}%300))
sleep \$((\${1}%300))
source /osg/app/cmssoft/cms/cmsset_default.sh
cd /cvmfs/cvmfs.cmsaf.mit.edu/hidsk0001/higroup/velicanu/CMSSW_4_4_2_patch8/src
eval \`scramv1 runtime -sh\`
# cmsenv
declare \$( printenv | grep export/d00 | sed 's/export\/d00/cvmfs\/cvmfs.cmsaf.mit.edu\/hidsk0001/g' )
cd -


# start=\$((\$6*$Queue))
filenum=\$((\$1+1))
echo \$start
echo \$filenum
echo filename=\`head -n\${filenum} \$2 | tail -n1\`
filename=\`head -n\${filenum} \$2 | tail -n1\`
sed "s@_file_flag_@\${filename}@g" \${4} > run.py
cmsRun run.py
mv forest_data.root \${3}/forest_data_\${filenum}.root 
rm run.py
EOF

chmod +x run${NAME}.sh

cat <<EOF > "${NAME}.condor"
Universe     = vanilla
Initialdir   = $PWD/$now
Notification = Error
Executable   = $PWD/$now/run${NAME}.sh
Arguments    = \$(Process) $1 $2 $3
GetEnv       = True
Output       = /net/hisrv0001/home/$USER/logs/$now-\$(Process).out
Error        = /net/hisrv0001/home/$USER/logs/$now-\$(Process).err
Log          = /net/hisrv0001/home/$USER/logs/$now-\$(Process).log
Rank         = Mips
+AccountingGroup = "group_cmshi.user_flag"
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = $3,$1

Queue ${Queue}

EOF

cp $3 $1 run${NAME}.sh ${NAME}.condor $now

if [[ "${4}" ]]
then
  echo "\$4 = ${4}"
  condor_submit $now/${NAME}.condor
fi
