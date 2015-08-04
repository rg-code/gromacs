#!/bin/bash

if (-f /usr/local/apps/gromacs-4.5.5-modff/bin/GMXRC.csh) then
    source /usr/local/apps/gromacs-4.5.5-modff/bin/GMXRC.csh
endif
if (-f /share/apps/gromacs-4.5.5/bin/GMXRC.csh) then
    source /share/apps/gromacs-4.5.5/bin/GMXRC.csh
endif

if ( $#argv != 3 ) then
    echo "Script requires 3 arguments: protein name, # NA and # CL"
    exit( 1 )
endif
# Test that you have the necessary files
if (! -f em.mdp || ! -f pr.mdp || ! -f md_300.mdp || ! -f md_380.mdp) then
    echo ">>PROBLEM: Missing at least one of the .mdp files"
    exit( 1 )
endif
if (! -f $1.pdb) then
    echo ">>PROBLEM: Could not find starting pdb file $1.pdb"
    exit( 1 )
endif

if (-f $1.gro) then
    rm $1.gro 
endif
if (-f $1.top) then
    rm $1.top
endif

pdb2gmx -f $1.pdb -ff amber99sb-ildn -ignh -water tip3p -o $1.gro -p $1.top >& $1.pdb2gmx.log
set success=`cat $1.pdb2gmx.log | grep "You have successfully"`
if ( ${%success} == 0 ) then
    echo "pdb2gmx unsuccessful"
    exit( 1 )
endif
set success=`cat $1.pdb2gmx.log | grep "Total charge"`
echo "**$success"
echo "*Pdb2gmx successful"

editconf -bt cubic -f $1.gro -d 2.0 -c -o $1.gro >& $1.editconf.log
set success=`cat $1.editconf.log | grep "new box volume"`
if ( ${%success} == 0 ) then
    echo "editconf unsuccessful"
    exit( 1 )
endif
echo "*Editconf successful"

genbox -cp $1.gro -cs spc216.gro -o $1.gro -p $1.top >& $1.genbox.log
set success=`cat $1.genbox.log | grep "Number of SOL molecules"`
if ( ${%success} == 0 ) then
    echo "genbox unsuccessful"
    echo $success
    exit( 1 )
endif
echo "**$success"
echo "*Genbox successful"

if (-f $1.em.tpr) then
    rm $1.em.tpr
endif
grompp -f em.mdp -o $1.em.tpr -c $1.gro -p $1.top >& $1.em.grompp.log 
if (! -f $1.em.tpr) then
    echo "Problem: grompp before genion failed"
    exit( 1 )
endif
echo "*Grompp before genion successful"

#exit()

genion -s $1.em.tpr -nn $3 -nname CL -np $2 -pname NA -o $1.gro -p $1.top >& $1.genion.log <<EOF
13
EOF
set success=`tail -1 $1.genion.log`
echo $success
if ($success[10] != $2 || $success[13] != $3) then
    echo "Meant to add $2 NA and $3 CL"
    echo "but actually added $success[10] NA and $success[13] CL"
    exit( 1 )
endif
echo "*Genion successfully added $2 NA and $3 CL"

#Use pdb2gmx to test for total neutral charge
#pdb2gmx -f $1.gro -o tmp.gro -p tmp.top -ff amber99sb-ildn -ignh -water tip3p >& $1.pdb2gmx.test.log
#set success=`cat $1.pdb2gmx.test.log | grep "Total charge in system"`
#if ($success[5] != "0.000" && $success[5] != "-0.000") then
#    echo ">>PROBLEM: non-zero charge after genion"
#    echo $success
#    exit( 1 )
#endif
#echo "*Pdb2gmx confirmed neutral charge"

rm $1.em.tpr
grompp -f em.mdp -o $1.em.tpr -c $1.gro -p $1.top >& $1.em.grompp.log 
if (! -f $1.em.tpr) then
    echo ">>PROBLEM: grompp before energy minimization failed"
    exit( 1 )
endif 
echo "*Grompp before EM successful"

if (-f $1.em.gro) then
    rm $1.em.gro
endif
echo "-Starting energy minization"
mdrun -deffnm $1.em >& $1.em.md.log
if (! -f $1.em.gro) then
    echo ">>PROBLEM: energy minimization md failed"
    exit( 1 )
endif 
echo "*Energy minimization successful"

if (-f $1.pr.tpr) then
    rm $1.pr.tpr
endif
grompp -f pr.mdp -o $1.pr.tpr -c $1.em.gro -p $1.top >& $1.pr.grompp.log 
if (! -f $1.pr.tpr) then
    echo ">>PROBLEM: grompp before constrained run failed"
    exit( 1 )
endif 
echo "*Grompp before contrained MD successful"

exit()

echo "-Starting constrained MD"

if (-f $1.pr.gro) then
    rm $1.pr.gro
endif
mdrun -deffnm $1.pr >& $1.pr.md.log
if (! -f $1.pr.gro) then
    echo ">>PROBLEM: constrained md failed"
    exit( 1 )
endif 
echo "* Constrained MD sucessful"
echo "******All Setup Steps Successful for $1******"
