if [ $# -ne 4 ]
then
  echo "Usage: ./runmakeforest.sh <filenum> <inputlist> <outdir> <pythonconfig>"
  exit 1
fi
echo sleeping $((${1}%300))
sleep $((${1}%300))
source /osg/app/cmssoft/cms/cmsset_default.sh
cd /cvmfs/cvmfs.cmsaf.mit.edu/hidsk0001/higroup/velicanu/CMSSW_4_4_2_patch8/src
eval `scramv1 runtime -sh`
# cmsenv
declare $( printenv | grep export/d00 | sed 's/export\/d00/cvmfs\/cvmfs.cmsaf.mit.edu\/hidsk0001/g' )
cd -


# start=$(($6*2799))
filenum=$(($1+1))
echo $start
echo $filenum
echo filename=`head -n${filenum} $2 | tail -n1`
filename=`head -n${filenum} $2 | tail -n1`
sed "s@_file_flag_@${filename}@g" ${4} > run.py
cmsRun run.py
#mv forest_data.root ${3}/forest_data_${filenum}.root 
#rm run.py
