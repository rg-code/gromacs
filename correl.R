################################################################################################################
#                                                                                                              #
# Copyright (C) {2015}  {Rohit Gupta, University of California, Merced}      #
#                                                                                                              #
#                                                                                                              #
# This program is free software: you can redistribute it and/or modify                                         #
# it under the terms of the GNU General Public License as published by                                         #
# the Free Software Foundation, either version 3 of the License, or                                            #
# (at your option) any later version.                                                                          #
#                                                                                                              #
# This program is distributed in the hope that it will be useful,                                              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                                #
# GNU General Public License for more details.                                                                 #
#                                                                                                              #
# This program comes with ABSOLUTELY NO WARRANTY;                                                              #
# This is free software, and you are welcome to redistribute it                                                #
# under certain conditions;                                                                                    #
#                                                                                                              #
###########################################################################################################


##read in correlation data matrix to create heatmap image####
correl2png = function(fnm,msize,pngtitle="")
{
  cdat = read.table(fnm,skip=1,fill=TRUE)
  cdat = array(t(cdat),dim=c(prod(dim(cdat))))
  cdat = as.numeric(cdat[1:(msize * msize)])
  cdat = array(cdat,dim=c(msize,msize))
  
  x = c(1:msize)
  y = c(1:msize)
  
  xdat = seq(0,1,length.out=1000)
  ydat = seq(0,1,length.out=2)
  bdat = array(dim=c(1000,2))
  bdat[,1] = seq(0,1,length.out=1000)
  bdat[,2] = seq(0,1,length.out=1000)
  
  png(paste(fnm, ".correl.png", sep = ""), width=1500, height=1000)
  layout(matrix(c(0,0,0,1,1,2,3,0,0),3,3),widths=c(1,20,15),heights=c(4,4,1))
  image(x, y, cdat, zlim=c(0,1), main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
  image(xdat, ydat, bdat, zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  hist(cdat, main="", xlim=c(0,1), xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
  dev.off()
  
  return(cdat)
}


newcorr2png = function(fnm, makepng = TRUE, revcolors = TRUE, setzlim = FALSE, pngtitle = "")
{
  cdat  = as.matrix(read.table(fnm))
  msize = dim(cdat)[1]
  
  x = c(1:msize)
  y = c(1:msize)
  
  if (setzlim)
  {
    xdat = seq(0, 1, length.out=1000)
  } else {
    xdat = seq(min(cdat), max(cdat), length.out=1000)
  }
  ydat = seq(0,1,length.out=2)
  bdat = array(dim=c(1000,2))
  bdat[,1] = seq(0,1,length.out=1000)
  bdat[,2] = seq(0,1,length.out=1000)
  
  if (makepng)
  {
    figcolors = rainbow(1000, end = 0.66)
    if (revcolors)
    {
      figcolors = rev(figcolors)
    }
    png(paste(fnm, ".correl.png", sep = ""), width=1500, height=1000)
    layout(matrix(c(0,0,0,1,1,2,3,0,0),3,3),widths=c(1,20,15),heights=c(4,4,1))
    if (setzlim)
    {
    image(x, y, cdat, zlim=c(0,1), main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=figcolors, useRaster=T)
    image(xdat, ydat, bdat, zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=figcolors, useRaster=T)
    hist(cdat, main="", xlim=c(0,1), xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
    } else {
    image(x, y, cdat, main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=figcolors, useRaster=T)
    image(xdat, ydat, bdat, xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=figcolors, useRaster=T)
    hist(cdat, main="", xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
    }
    dev.off()
  }
  
  return(cdat)
}


avgdatfiles = function(fnmlist, pngfnm, nozlim = TRUE, myzlim = c(0,1), pngtitle="")
{
  nfnm  = length(fnmlist)
  sdat  = as.matrix(read.table(fnmlist[1]))
  msize = dim(sdat)[1]
  
  for (i in seq(2,nfnm))
  {
    sdat = sdat + as.matrix(read.table(fnmlist[i]))
  }
  sdat = sdat / nfnm
  
  x = c(1:msize)
  y = c(1:msize)
  write(sdat, file="M2H_allch.dat",ncolumns=msize)

  if (nozlim)
  {
    xdat = seq(min(sdat),max(sdat),length.out=1000)
  } else {
    xdat = seq(0,1,length.out=1000)
  }
  ydat = seq(0,1,length.out=2)
  bdat = array(dim=c(1000,2))
  bdat[,1] = seq(0,1,length.out=1000)
  bdat[,2] = seq(0,1,length.out=1000)
  
  png(pngfnm, width=1500, height=1000)
  layout(matrix(c(0,0,0,1,1,2,3,0,0),3,3),widths=c(1,20,15),heights=c(4,4,1))
  if (nozlim)
  {
    image(x, y, sdat, main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
    image(xdat, ydat, bdat, xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  } else {
    image(x, y, sdat, zlim = myzlim, main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
    image(xdat, ydat, bdat, zlim = myzlim, xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  }
  hist(sdat, main="", xlim=c(0,1), xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
  dev.off()
  
  return(sdat)
}


diffdatfiles = function(fnmlist, pngfnm, zl = 0.2, cutoff = 0.0)
{
  nfnm  = length(fnmlist)
  dlist = vector(mode = "list", length = nfnm)
  if (cutoff > 0.0)
  {
    clim = 0.5 + c(-cutoff / (2 * zl), cutoff / (2 * zl))
  }
  
  for (i in seq(1,nfnm))
  {
    dlist[[i]] = as.matrix(read.table(fnmlist[i]))
  }
  msize = dim(dlist[[1]])[1]
  
  x = c(1:msize)
  y = c(1:msize)
  
  #xdat = seq(0,1,length.out=1000)
  #ydat = seq(0,1,length.out=2)
  #bdat = array(dim=c(1000,2))
  #bdat[,1] = seq(0,1,length.out=1000)
  #bdat[,2] = seq(0,1,length.out=1000)
  
  png(pngfnm, width= 400 * nfnm, height= 400 * nfnm)
  layout(t(matrix(seq(1, nfnm * nfnm), nfnm, nfnm)))
  for (i in seq(1,nfnm))
  {
    for (j in seq(1,nfnm))
    {
      ddat = ((dlist[[i]] - dlist[[j]]) / (2 * zl)) + 0.5
      ddat[ddat > 1.0] = 1.0
      ddat[ddat < 0.0] = 0.0
      if (cutoff > 0.0)
      {
        ddat[(ddat > clim[1]) & (ddat < clim[2])] = -1.0
        cat("Number that do not meet cutoff: ", sum(ddat == -1.0), "\n")
      }
      image(x, y, ddat, zlim=c(0, 1), main = paste(fnmlist[i], "minus", fnmlist[j], sep = " "), xlab = "", ylab = "", cex.main = 2, cex.axis = 1.5, col = rev(rainbow(1000, end=0.66)), useRaster=T)
    }
  }
  #image(xdat, ydat, bdat, zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  dev.off()
  
  return(dlist)
}


old2newcorrel = function(oldfnm,newfnm,msize)
{
  cdat = read.table(oldfnm,skip=1,fill=TRUE)
  cdat = array(t(cdat),dim=c(prod(dim(cdat))))
  cdat = as.numeric(cdat[1:(msize * msize)])
  cdat = array(cdat,dim=c(msize,msize))

  sink(file = newfnm)
  for (i in seq(1,msize))
  {
    for (j in seq(1,msize))
    {
      cat(sprintf("%10.5f ",cdat[i,j]))
    }
    cat(sprintf("\n"))
  }
  sink()

  return(cdat)
}


correl2dat = function(cdat,fnm)
{
  isize = dim(cdat)[1]
  jsize = dim(cdat)[2]
  sink(file = fnm)
  for (i in seq(1,isize))
  {
    for (j in seq(1,jsize))
    {
      cat(sprintf("%10.5f ",cdat[i,j]))
    }
    cat(sprintf("\n"))
  }
  sink()
}


indexcorrel2png = function(fnm,msize,pngtitle="")
{
  cdat = read.table(fnm)
  cdat = array(cdat[,3],dim=c(msize,msize))
  
  x = c(1:msize)
  y = c(1:msize)

  xdat = seq(0,1,length.out=1000)
  ydat = seq(0,1,length.out=2)
  bdat = array(dim=c(1000,2))
  bdat[,1] = seq(0,1,length.out=1000)
  bdat[,2] = seq(0,1,length.out=1000)

  png(paste(fnm, ".indexcorrel.png", sep = ""), width=1500, height=1000)
  layout(matrix(c(0,0,0,1,1,2,3,0,0),3,3),widths=c(1,20,15),heights=c(4,4,1))
  image(x, y, cdat, zlim=c(0,1), main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
  image(xdat, ydat, bdat, zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  hist(cdat, main="", xlim=c(0,1), xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
  dev.off()

  return(cdat)
}


avgcorrel = function(fnm,isize,osize,rclist,pngtitle="")
{
  cdat = read.table(fnm,skip=1,fill=TRUE)
  cdat = array(t(cdat),dim=c(prod(dim(cdat))))
  cdat = as.numeric(cdat[1:(isize * isize)])
  cdat = array(cdat,dim=c(isize,isize))
  
  odat = array(0,c(osize,osize))
  
  for (i in seq(1,(length(rclist) %/% 4)))
  {
    j  = 4 * (i - 1)
    r1 = rclist[j + 1]
    r2 = rclist[j + 2]
    c1 = rclist[j + 3]
    c2 = rclist[j + 4]
    odat = odat + cdat[r1:r2,c1:c2]
  }
  odat = odat / (length(rclist) %/% 4)
  
  x = c(1:osize)
  y = c(1:osize)
  
  xdat = seq(0,1,length.out=1000)
  ydat = seq(0,1,length.out=2)
  bdat = array(dim=c(1000,2))
  bdat[,1] = seq(0,1,length.out=1000)
  bdat[,2] = seq(0,1,length.out=1000)

  png(paste(fnm, ".avgcorrel.png", sep = ""), width=1500, height=1000)
  layout(matrix(c(0,0,0,1,1,2,3,0,0),3,3),widths=c(1,20,15),heights=c(4,4,1))
  image(x, y, odat, zlim=c(0,1), main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
  image(xdat, ydat, bdat, zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  hist(odat, main="", xlim=c(0,1), xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
  dev.off()
  
  return(odat)
}


diff2png = function(fnm1, fnm2, outfnm = "diffcorrel.png", pngtitle = "", zl = 0.2, cutoff = 0.0)
{
  cdat1=as.matrix(read.table(fnm1))
  cdat2=as.matrix(read.table(fnm2))
  ddat = cdat1 - cdat2
  msize = dim(ddat)[1]
  if (cutoff > 0.0)
  {
    clim = 0.5 + c(-cutoff / (2 * zl), cutoff / (2 * zl))
  }
  
  x = c(1:msize)
  y = c(1:msize)
  
  xdat = seq(0,1,length.out=1000)
  ydat = seq(0,1,length.out=2)
  bdat = array(dim=c(1000,2))
  bdat[,1] = seq(0,1,length.out=1000)
  bdat[,2] = seq(0,1,length.out=1000)
  
  png(outfnm, width=1600, height=900)
  layout(matrix(c(1,2,3,4,4,5,6,0,0),3,3),widths=c(4,8,4),heights=c(4,4,1))
  image(x, y, cdat1, zlim=c(0,1), main="", xlab="Residue Number", ylab="Residue Number", cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
  image(x, y, cdat2, zlim=c(0,1), main="", xlab="Residue Number", ylab="Residue Number", cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
  image(xdat, ydat, bdat, zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)

  xdat = seq(-zl, zl, length.out=1000)
  idat = (ddat / (2 * zl)) + 0.5
  idat[idat > 1.0] = 1.0
  idat[idat < 0.0] = 0.0
  if (cutoff > 0.0)
  {
    idat[(idat > clim[1]) & (idat < clim[2])] = -1.0
    bdat[(bdat > clim[1]) & (bdat < clim[2])] = -1.0
    cat("Number that do not meet cutoff: ", sum(idat == -1.0), "\n")
  }
  image(x, y, idat, zlim=c(0,1), main=pngtitle, xlab="Residue Number", ylab="Residue Number", cex.main=2, cex.axis=1.5, cex.lab=1.5, col=rev(rainbow(1000, end=0.66)), useRaster=T)
  image(xdat, ydat, bdat, xlim=c(-zl, zl), zlim=c(0,1), xlab="Correlation", ylab="", yaxt='n', cex.lab=1.5, cex.axis=1.5, col=rev(rainbow(1000, end = 0.66)), useRaster=T)
  hist(ddat, main="", xlim=c(-1.0,1.0), xlab="Correlation", yaxt='n', cex.lab=1.5, cex.axis=1.5, breaks="fd")
  dev.off()
  
  return(ddat)
}


compnew2old = function(fnmnew,fnmold,isize)
{
  odat = read.table(fnmold,skip=1,fill=TRUE)
  odat = array(t(odat),dim=c(prod(dim(odat))))
  odat = as.numeric(odat[1:(isize * isize)])
  odat = array(odat,dim=c(isize,isize))
  
  ndat = read.table(fnmnew,fill=TRUE)
  ndat = as.numeric(ndat)
  
  return(sum(sum(abs(ndat-odat))))
}
