# makeforest

TLDR of condor submission with cvmfs:

if before you had : 

```bash
cd /net/somedir/CMSSW_X_X_X/src 
cmsenv
cd -
```

you need to first put that directory into cvmfs via /export/d00/higroup

```bash
cd /export/d00/higroup/
mkdir username
cd username
cmsrel CMSSW_X_X_X
```

then wait a few hours for this to sync to the worker nodes, you can see if it's ready by doing the following query

```bash
ls /cvmfs/cvmfs.cmsaf.mit.edu/hidsk0001/higroup/username
```

once it's ready change your submission script from cd /net/...   to :

```bash
source /osg/app/cmssoft/cms/cmsset_default.sh
cd /cvmfs/cvmfs.cmsaf.mit.edu/hidsk0001/higroup/username/CMSSW_X_X_X/src 
eval `scramv1 runtime -sh`
declare \$( printenv | grep export/d00 | sed 's/export\/d00/cvmfs\/cvmfs.cmsaf.mit.edu\/hidsk0001/g' )
cd -
```

Long version here:  https://twiki.cern.ch/twiki/bin/view/CMS/MITLocalSubmission
