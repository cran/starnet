## ----start,include=FALSE------------------------------------------------------
knitr::opts_chunk$set(echo=TRUE,eval=FALSE)
#setwd("...")
#source("starnet/R/functions.R")
#devtools::install_github("rauschenberger/starnet")
#install.packages("starnet_0.0.1.tar.gz",repos=NULL,type ="source")
#library(starnet)
blue <- "blue" #00007F
red <- "red" #FF3535

## ----figure,fig.width=5,fig.height=3------------------------------------------
#  #<<start>>
#  ellipse <- function(x,y,type=TRUE,text=NULL,a=0.5,b=0.5,border="black",col=NULL,txt.col="black",...){
#      n <- max(c(length(x),length(y)))
#      if(is.null(col)){col <- rep(grey(0.9),times=n)}
#      if(length(col)==1){col <- rep(col,times=n)}
#      if(length(x)==1){x <- rep(x,times=n)}
#      if(length(y)==1){y <- rep(y,times=n)}
#      if(length(text)==1){text <- rep(text,times=n)}
#      if(length(border)==1){border <- rep(border,times=n)}
#      for(i in seq_len(n)){
#          if(type){
#            angle <- seq(from=0,to=2*pi,length=100)
#            xs <- x[i] + a * cos(angle)
#            ys <- y[i] + b * sin(angle)
#            graphics::polygon(x=xs,y=ys,col=col[i],border=border[i])
#          } else {
#            graphics::polygon(x=x[i]+c(-a,-a,a,a),y=y[i]+c(-b,b,b,-b),border=border[i],col=col[i])
#          }
#          graphics::text(labels=text[i],x=x[i],y=y[i],col=txt.col,...)
#      }
#  }
#  
#  txt <- list()
#  txt$y <- expression(hat(y))
#  txt$omega <- eval(parse(text=paste0("expression(",paste0("hat(omega)[",c(1:3,"k","m"),"]",collapse=","),")")))
#  txt$alpha <- eval(parse(text=paste0("expression(",paste0("hat(y)*\"|\"*alpha[",c(1:3,"k","m"),"]",collapse=","),")")))
#  txt$beta <- eval(parse(text=paste0("expression(",paste0("hat(beta)[",c(1:3,"j","p"),"]*\"|\"*alpha[k]",collapse=","),")")))
#  txt$x <- eval(parse(text=paste0("expression(",paste0("x[\"",c(1:3,"j","p"),"\"]",collapse=","),")")))
#  txt$dots <- expression(cdots)
#  
#  pos <- list()
#  pos$y <- 4
#  pos$alpha <- c(1,2,3,5,7)
#  pos$x <- c(0.5,1.5,2.5,5.5,7.5)
#  pos$omega <- pos$y+(pos$alpha-pos$y)/2
#  pos$beta <- 5+(pos$x-5)/2
#  pos$beta[1] <- pos$beta[1] - 0.3
#  pos$beta[3] <- pos$beta[3] + 0.3
#  
#  a <- b <- 0.3
#  #grDevices::pdf(file="manuscript/figure_NET.pdf",width=5,height=3)
#  graphics::plot.new()
#  graphics::par(mar=c(0,0,0,0),mfrow=c(1,1))
#  graphics::plot.window(xlim=c(0.4,7.6),ylim=c(0.8,5.2))
#  
#  # omega
#  segments(x0=4,y0=5-a,x1=pos$alpha,y1=3+a,lwd=2,col=red)
#  ellipse(x=pos$omega,y=4,text=txt$omega,a=0.2,b=0.21,cex=1.2,col="white",border=red,txt.col=red,type=FALSE)
#  
#  # beta
#  segments(x0=rep(pos$alpha,each=length(pos$x)),y0=3-a,x1=rep(pos$x,times=length(pos$alpha)),y1=1+a,lwd=2,col="grey")
#  segments(x0=pos$x,y0=1+a,y1=3-a,x1=5,lwd=2,col=blue)
#  ellipse(x=pos$beta,y=2,text=txt$beta,a=0.35,b=0.27,cex=1.2,col="white",border=blue,txt.col=blue,type=FALSE)
#  
#  # x and y
#  ellipse(x=pos$x,y=1,text=txt$x,a=a,b=b,cex=1.2)
#  text(x=c(4,6.5),y=1,labels=txt$dots,cex=1.2)
#  ellipse(x=pos$alpha,y=3,text=txt$alpha,a=a+0.1,b=b,cex=1.2)
#  text(x=c(4,6),y=3,labels=txt$dots,cex=1.2)
#  ellipse(x=pos$y,y=5,text=txt$y,a=a,b=b,cex=1.2)
#  #grDevices::dev.off()

## ----pre_script,eval=FALSE----------------------------------------------------
#  #<<start>>
#  n <- 10000; p <- 500
#  fold <- rep(c(0,1),times=c(100,n-100))
#  mode <- rep(c("sparse","dense","mixed"),times=100)
#  family <- "gaussian"
#  
#  for(id in c(1,NA,0)){
#    loss <- list()
#    for(i in seq_along(mode)){
#      set.seed(i)
#      cat(round(100*i/length(mode),digits=2)," ")
#      data <- .simulate.block(n=n,p=p,mode=mode[i],family=family)
#      nzero <- seq_len(10)*switch(mode[i],sparse=1,dense=10,mixed=5,stop())
#      set.seed(i)
#      loss[[i]] <- tryCatch(cv.starnet(y=data$y,X=data$X,family=family,foldid.ext=fold,alpha.meta=id,nzero=nzero),error=function(x) NULL)
#    }
#    #save(loss,mode,file=paste0("results/sim_prediction_",id,".RData"))
#  }
#  
#  #writeLines(text=capture.output(utils::sessionInfo(),cat("\n"),
#  #        sessioninfo::session_info()),con="results/sim_prediction.txt")

## ----pre_boxplot,fig.height=2-------------------------------------------------
#  # <<start>>
#  load("results/sim_prediction_1.RData")
#  cond <- sapply(loss,is.null)
#  loss <- loss[!cond]; mode <- mode[!cond]
#  
#  #grDevices::pdf(file="manuscript/figure_BOX.pdf",width=5,height=2)
#  graphics::par(mfrow=c(1,3),mar=c(2.1,2,0.5,0.5),oma=c(0,2,0,0))
#  meta <- sapply(loss,function(x) x$meta)
#  base <- sapply(loss,function(x) x$base[c("alpha0.05","alpha0.95")])
#  table <- t(rbind(base,meta))
#  
#  names <- c("ridge","lasso","tune","stack")
#  col <- ifelse(grepl(pattern="ridge|alpha|lasso",x=names),red,blue)
#  
#  modes <- c("sparse","dense","mixed")
#  median <- winner <- pvalue <- matrix(data=NA,nrow=length(modes),ncol=length(names),
#                            dimnames=list(modes,names))
#  
#  for(i in modes){
#    values <- table[mode==i,names]
#  
#    # information
#    median[i,] <- apply(values,2,median)
#    winner[i,] <- rowMeans(apply(values,1,rank)<2)
#    pvalue[i,] <- apply(values,2,function(x) suppressWarnings(wilcox.test(x=values[,"stack"],y=x,paired=TRUE,alternative="two.sided")$p.value))
#  
#    # boxes
#    graphics::plot.new()
#    graphics::plot.window(xlim=c(0.4,4.6),ylim=range(values))
#    y <- apply(values,2,function(x) stats::quantile(x,p=c(0.05,0.25,0.50,0.75,0.95)))
#  
#    # whiskers
#    graphics::segments(x0=seq_len(ncol(values)),y0=y["5%",],y1=y["95%",])
#  
#    # boxes
#    graphics::boxplot(values,cex.axis=1,col=col,medcol="white",names=rep("",times=ncol(values)),whiskcol=NA,staplecol=NA,outcol=NA,add=TRUE)
#  
#    # whiskers
#    graphics::segments(x0=seq_len(ncol(values))-0.15,x1=seq_len(ncol(values))+0.15,y0=y["5%",])
#    graphics::segments(x0=seq_len(ncol(values))-0.15,x1=seq_len(ncol(values))+0.15,y0=y["95%",])
#  
#    for(j in seq_len(4)){
#      cond <- values[,j]>y["95%",j] | values[,j]<y["5%",j]
#      points(x=rep(j,times=sum(cond)),y=values[cond,j],cex=0.7)
#    }
#  
#    even <- seq(from=1,to=ncol(values),by=2)
#    odd <- seq(from=2,to=ncol(values),by=2)
#    graphics::axis(side=1,labels=colnames(values)[even],at=even)
#    graphics::axis(side=1,labels=colnames(values)[odd],at=odd)
#  
#    graphics::points(x=1,y=median(table[mode==i,"alpha0.05"]),pch=21,col="black",bg=red,cex=1.2)
#    graphics::points(x=2,y=median(table[mode==i,"alpha0.95"]),pch=21,col="black",bg=red,cex=1.2)
#  
#  }
#  graphics::title(ylab=paste0(paste0(rep(" ",times=12),collapse=""),"mean squared error"),outer=TRUE,line=1)
#  #grDevices::dev.off()
#  
#  round(median,digits=2)
#  round(winner,digits=2)
#  signif(9*pvalue,digits=2)

## ----pre_scatter,fig.height=2-------------------------------------------------
#  #<<start>>
#  load("results/sim_prediction_1.RData")
#  cond <- sapply(loss,is.null)
#  loss <- loss[!cond]; mode <- mode[!cond]
#  
#  #grDevices::pdf(file="manuscript/figure_PHS.pdf",width=5,height=2)
#  graphics::par(mfrow=c(1,3),mar=c(3.3,2,0.5,0.5),oma=c(0,2,0,0))
#  for(i in c("sparse","dense","mixed")){
#    x <- as.numeric(colnames(loss[mode==i][[1]]$extra))
#    names <- list(rownames(loss[[1]]$extra),x,seq_len(sum(mode==i)))
#    X <- array(unlist(lapply(loss[mode==i],function(x) x$extra)),dim=sapply(names,length),dimnames=names)
#    X <- apply(X,c(1,2),median)
#    lasso <- median(sapply(loss[mode==i],function(x) x$meta["lasso"]))
#    stack <- median(sapply(loss[mode==i],function(x) x$meta["stack"]))
#    graphics::plot.new()
#    graphics::plot.window(xlim=range(x,na.rm=TRUE),ylim=range(c(lasso,stack,X)))
#    graphics::box()
#    graphics::axis(side=1)
#    graphics::axis(side=2)
#    graphics::abline(h=lasso,col="grey",lty=2)
#    graphics::abline(h=stack,lty=2)
#    graphics::lines(y=X["lasso",],x=x,col="grey")
#    graphics::points(y=X["lasso",],x=x,pch=21,col="grey",bg="white")
#    graphics::lines(y=X["stack",],x=x)
#    graphics::points(y=X["stack",],x=x,pch=21,bg="white")
#    graphics::title(xlab="nzero",line=2.5)
#  }
#  graphics::title(ylab=paste0(paste0(rep(" ",times=12),collapse=""),"mean squared error"),outer=TRUE,line=1)
#  #grDevices::dev.off()

## ----est_script,eval=FALSE----------------------------------------------------
#  #<<start>>
#  n <- 10000; p <- 500
#  fold <- rep(c(0,1),times=c(100,n-100))
#  
#  family <- "gaussian"
#  mode <- rep(c("sparse","dense","mixed"),times=100)
#  
#  for(id in c(1,NA,0)){
#    loss <- list()
#    mae0 <- mae1 <- mse0 <- mse1 <- sapply(c("lasso","ridge","tune","stack"),function(x) numeric())
#    sel0 <- sel1 <- TP <- FP <- TN <- FN <- sapply(c("lasso","enet","stack"),function(x) numeric())
#    graphics::par(mfrow=c(1,3),mar=c(2,2,0,0))
#    for(i in seq_along(mode)){
#      cat(round(100*i/length(mode),digits=2)," ")
#      set.seed(i)
#      data <- .simulate.mode(n=n,p=p,mode=mode[i])
#  
#      #--- prediction ---
#      nzero <- seq_len(10)*switch(mode[i],sparse=1,dense=10,mixed=5,stop("Invalid mode."))
#      set.seed(i)
#      loss[[i]] <- tryCatch(cv.starnet(y=data$y,X=data$X,family=family,alpha.meta=id,foldid.ext=fold,nzero=nzero),error=function(x) NULL)
#      tryCatch(graphics::title(main=paste0("mode=",mode[i])),error=function(x) NULL)
#  
#      #--- estimation ---
#  
#      set.seed(i)
#      model <- starnet(y=data$y[fold==0],X=data$X[fold==0,],family=family,alpha.meta=id)
#  
#      # unrestricted model
#      coef <- list()
#      coef$ridge <- coef(model$base$alpha0$glmnet.fit,
#                             s=model$base$alpha0$lambda.min)[-1]
#      coef$lasso <- coef(model$base$alpha1$glmnet.fit,
#                             s=model$base$alpha1$lambda.min)[-1]
#      coef$stack <- coef(model)$beta
#      select <- which.min(sapply(model$base,function(x) x$cvm[x$id.min]))
#      coef$tune <- coef(model$base[[select]]$glmnet.fit,
#                            s=model$base[[select]]$lambda.min)[-1]
#  
#      for(k in names(coef)){
#        # mean absolute error
#        mae0[[k]][i] <- mean(abs(data$beta[data$beta==0]-coef[[k]][data$beta==0]))
#        mae1[[k]][i] <- mean(abs(data$beta[data$beta!=0]-coef[[k]][data$beta!=0]))
#        # mean squared error
#        mse0[[k]][i] <- mean((data$beta[data$beta==0]-coef[[k]][data$beta==0])^2)
#        mse1[[k]][i] <- mean((data$beta[data$beta!=0]-coef[[k]][data$beta!=0])^2)
#      }
#  
#      # restricted model
#      coef <- list()
#      coef$stack <- coef(model,nzero=10)$beta
#      lasso <- .cv.glmnet(y=data$y[fold==0],x=data$X[fold==0,],alpha=1,family=family,foldid=model$info$foldid,nzero=10)
#      coef$lasso <- stats::coef(lasso,s="lambda.min")[-1]
#      enet <- .cv.glmnet(y=data$y[fold==0],x=data$X[fold==0,],alpha=0.95,family=family,foldid=model$info$foldid,nzero=10)
#      coef$enet <- stats::coef(enet,s="lambda.min")[-1]
#  
#      for(k in names(coef)){
#        sel0[[k]][i] <- sum(coef[[k]][data$beta==0]!=0)
#        sel1[[k]][i] <- sum(coef[[k]][data$beta!=0]!=0)
#         # continue here
#        TP[[k]][i] <- sum(coef[[k]][data$beta!=0]!=0)
#        FP[[k]][i] <- sum(coef[[k]][data$beta==0]!=0)
#        TN[[k]][i] <- sum(coef[[k]][data$beta==0]==0)
#        FN[[k]][i] <- sum(coef[[k]][data$beta!=0]==0)
#      }
#  
#    }
#    #save(mode,mae0,mae1,mse0,mse1,sel0,sel1,TP,FP,TN,FN,loss,file=paste0("results/sim_estimation_",id,".RData"))
#  }
#  
#  #writeLines(text=capture.output(utils::sessionInfo(),cat("\n"),
#  #        sessioninfo::session_info()),con="results/sim_estimation.txt")

## ----est_results--------------------------------------------------------------
#  #<<start>>
#  load("results/sim_estimation_1.RData")
#  
#  # estimation accuracy (mean absolute error)
#  round(tapply(X=100*(mae0$stack-mae0$tune)/mae0$tune,INDEX=mode,FUN=median),digits=1)
#  round(tapply(X=100*(mae1$stack-mae1$tune)/mae1$tune,INDEX=mode,FUN=mean),digits=1)
#  signif(3*tapply(X=mae1$stack-mae1$tune,INDEX=mode,FUN=function(x) stats::wilcox.test(x)$p.value),digits=2)
#  
#  # estimation accuracy (mean squared error)
#  round(tapply(X=100*(mse0$stack-mse0$tune)/mae0$tune,INDEX=mode,FUN=median),digits=1)
#  round(tapply(X=100*(mse1$stack-mse1$tune)/mae1$tune,INDEX=mode,FUN=mean),digits=1)
#  signif(3*tapply(X=mse1$stack-mse1$tune,INDEX=mode,FUN=function(x) stats::wilcox.test(x)$p.value),digits=2)
#  
#  # selection accuracy (true/false positives)
#  round(mean(TP$stack),digits=1); round(mean(TP$lasso),digits=1)
#  round(mean(FP$stack),digits=1); round(mean(FP$lasso),digits=1)
#  
#  # selection accuracy (precision)
#  round(tapply(X=TP$stack/(TP$stack+FP$stack),INDEX=mode,FUN=mean),digits=3)
#  round(tapply(X=TP$lasso/(TP$lasso+FP$lasso),INDEX=mode,FUN=mean),digits=3)
#  round(tapply(X=TP$enet/(TP$enet+FP$enet),INDEX=mode,FUN=mean),digits=3)
#  
#  ## selection accuracy (true/false positives)
#  #round(tapply(X=FP$stack,INDEX=mode,FUN=mean),digits=1)
#  #round(tapply(X=FP$lasso,INDEX=mode,FUN=mean),digits=1)
#  #round(tapply(X=TP$stack,INDEX=mode,FUN=mean),digits=1)
#  #round(tapply(X=TP$lasso,INDEX=mode,FUN=mean),digits=1)
#  
#  ## selection accuracy (recall)
#  #round(tapply(X=TP$stack/(TP$stack+FN$stack),INDEX=mode,FUN=mean),digits=3)
#  #round(tapply(X=TP$lasso/(TP$lasso+FN$lasso),INDEX=mode,FUN=mean),digits=3)
#  #round(tapply(X=TP$enet/(TP$enet+FN$enet),INDEX=mode,FUN=mean),digits=3)
#  
#  ## prediction accuracy
#  #cond <- sapply(loss,is.null)
#  #loss <- loss[!cond]; mode <- mode[!cond]
#  #stack <- sapply(loss,function(x) x$meta["stack"])
#  #tune <- sapply(loss,function(x) x$meta["tune"])
#  #tapply(100*(stack-tune)/tune,mode,median)

## ----sta_script,eval=FALSE----------------------------------------------------
#  # <<start>>
#  names <- c("colon","leukaemia",paste0("SRBCT",seq_len(4)))
#  y <- X <- loss <- sapply(names,function(x) list(),simplify=FALSE)
#  data(Colon,package="plsgenomics")
#  y$colon <- Colon$Y-1
#  X$colon <- Colon$X # 62 x 2000
#  data(leukemia,package="plsgenomics")
#  y$leukaemia <- leukemia$Y-1
#  X$leukaemia <- leukemia$X # 38 x 3051
#  data(SRBCT,package="plsgenomics")
#  for(i in seq_len(4)){
#    y[[paste0("SRBCT",i)]] <- 1*(SRBCT$Y==i)
#    X[[paste0("SRBCT",i)]] <- SRBCT$X # 83 x 2308
#  }
#  n0 <- vapply(X=y,FUN=function(x) sum(x==0),FUN.VALUE=numeric(1))
#  n1 <- vapply(X=y,FUN=function(x) sum(x==1),FUN.VALUE=numeric(1))
#  
#  nzero <- c(seq(from=2,to=20,by=2),Inf)
#  for(id in c(1,NA,0)){
#    for(k in seq_along(names)){
#      cat("---",names[k],"---","\n")
#      for(seed in seq_len(11)){
#        cat("---",seed,"---","\n")
#        set.seed(seed)
#        loss[[k]][[seed]] <- tryCatch(cv.starnet(y=y[[k]],X=X[[k]],family="binomial",nzero=nzero,alpha.meta=id),error=function(x) NULL)
#      }
#    }
#    #save(loss,n0,n1,file=paste0("results/app_standard_",id,".RData"))
#  }
#  
#  #writeLines(text=capture.output(utils::sessionInfo(),cat("\n"),
#  #        sessioninfo::session_info()),con="results/app_standard.txt")

## ----sta_table,echo=TRUE------------------------------------------------------
#  #<<start>>
#  load("results/app_standard_1.RData")
#  loss <- lapply(loss,function(x) x[-2]) # error at id=1, seed=2, leukaemia
#  
#  median <- list()
#  for(i in names(loss)){
#    for(j in c("meta","base")){
#      median[[i]][[j]] <- apply(sapply(loss[[i]],function(x) x[[j]]),1,median)
#    }
#    list <- lapply(loss[[i]],function(x) x$extra)
#    array <- array(data=unlist(list),dim=c(3,11,10),dimnames=list(rownames(list[[1]]),colnames(list[[1]]),seq_len(10)))
#    median[[i]]$extra <- apply(X=array,MARGIN=1:2,FUN=median)
#  }
#  
#  meta <- t(sapply(median,function(x) x$meta[c("ridge","lasso","tune","stack")]))
#  post <- sapply(median,function(x) x$extra["stack","Inf"])
#  
#  table <- cbind("\\#0"=n0,"\\#1"=n1,format(meta,digits=1,nsmall=2)," "=format(post,digits=1,nsmall=2))
#  index <- cbind(seq_len(nrow(meta)),apply(meta,1,which.min)+2)
#  table[index] <- paste0("\\underline{",table[index],"}")
#  colnames(table) <- paste0("\\text{",colnames(table),"}")
#  rownames(table)[3:6] <- paste0("\\textsc{",tolower(rownames(table)[3:6]),"}")
#  rownames(table) <- paste0("\\text{",tolower(rownames(table)),"}")
#  table[,c(1,2)] <- paste0("\\textcolor{gray}{",table[,c(1,2)],"}")
#  table[,ncol(table)] <- paste0("\\textcolor{gray}{(",table[,ncol(table)],")}")
#  xtable <- xtable::xtable(table,align=c("l|rrccccc"),digits=c(NA,0,0,2,2,2,2,2))
#  xtable::print.xtable(xtable,sanitize.text.function=function(x) x)

## ----sta_figure,fig.height=2--------------------------------------------------
#  #<<start>>
#  #<<sta_table>>
#  #grDevices::pdf(file="manuscript/figure_STA.pdf",width=5,height=2)
#  graphics::par(mfrow=c(1,3),mar=c(3.3,2,0.5,0.5),oma=c(0,2,0,0))
#  median$SRBCT <- list()
#  median$SRBCT$meta <- rowMeans(sapply(median[paste0("SRBCT",1:4)],
#                                       function(x) x$meta))
#  median$SRBCT$base <- rowMeans(sapply(median[paste0("SRBCT",1:4)],
#                                       function(x) x$base))
#  for(i in c("colon","leukaemia","SRBCT")){
#    alpha <- as.numeric(substring(names(median[[i]]$base),first=6))
#    base <- median[[i]]$base
#    meta <- median[[i]]$meta
#    graphics::plot.new()
#    graphics::plot.window(xlim=range(alpha),ylim=range(c(base,meta[c("tune","ridge","lasso","stack")])))
#    graphics::axis(side=1)
#    graphics::axis(side=2)
#    graphics::box()
#    graphics::title(xlab=expression(alpha),line=2.5)
#    graphics::abline(h=meta["tune"],lty=2,col="grey")
#    graphics::abline(h=meta["stack"],lty=2)
#    graphics::arrows(x0=0,y0=meta["tune"],y1=meta["stack"],length=0.05,lwd=2)
#    graphics::points(x=alpha,y=base,pch=21,col="black",bg="white")
#    graphics::points(x=0,y=meta["ridge"],pch=16)
#    graphics::points(x=1,y=meta["lasso"],pch=16)
#  
#  }
#  graphics::title(ylab=paste0(paste0(rep(" ",times=16),collapse=""),"logistic deviance"),outer=TRUE,line=1)
#  #grDevices::dev.off()
#  
#  sapply(median,function(x) names(which.min(x$base)))

## ----ext_script,eval=FALSE----------------------------------------------------
#  #<<start>>
#  type <- c("ACC","BLCA","BRCA","CESC","CHOL","COAD","DLBC","ESCA","GBM","HNSC","KICH","KIRC","KIRP","LAML","LGG","LIHC","LUAD","LUSC","MESO","OV","PAAD","PCPG","PRAD","READ","SARC","SKCM","STAD","TGCT","THCA","THYM","UCEC","UCS","UVM")
#  y <- x <- sapply(type,function(x) NULL)
#  for(i in seq_along(type)){
#    cat(rep(c("-",type[i],"-"),times=c(10,1,10)),"\n")
#    data <- curatedTCGAData::curatedTCGAData(diseaseCode=type[i],assays= "RNASeq2GeneNorm",dry.run=FALSE)
#    data <- MultiAssayExperiment::mergeReplicates(data)
#    X <- t(SummarizedExperiment::assay(data))
#    Y <- TCGAutils::TCGAbiospec(rownames(X))$sample_definition
#    print(table(Y))
#    cond <- Y %in% c("Solid Tissue Normal","Primary Solid Tumor")
#    Y <- Y[cond]; X <- X[cond,]
#    Y <- 1*(Y=="Primary Solid Tumor")
#    sd <- apply(X,2,sd)
#    X <- X[,sd>=sort(sd,decreasing=TRUE)[2000]]
#    X <- scale(X)
#    y[[i]] <- Y; x[[i]] <- X
#  }
#  print(object.size(x),units="Mb")
#  #save(y,x,type,file=paste0("results/tcga_data.RData"))
#  
#  #writeLines(text=capture.output(utils::sessionInfo(),cat("\n"),
#  #        sessioninfo::session_info()),con="results/app_processing.txt")
#  
#  # cross-validation
#  
#  load("results/tcga_data.RData")
#  type <- names(y)
#  nzero <- c(seq(from=2,to=20,by=2),Inf)
#  for(id in c(1,NA,0)){
#    loss <- sapply(type,function(x) NULL)
#    for(i in seq_along(type)){
#      cat(rep(c("-",type[i],"-"),times=c(10,1,10)),"\n")
#      if(sum(y[[i]]==0)<5|sum(y[[i]]==1)<5){next}
#      set.seed(1)
#      loss[[i]] <- tryCatch(cv.starnet(y=y[[i]],X=x[[i]],family="binomial",alpha.meta=id,nzero=nzero),error=function(x) NA)
#    }
#    #save(loss,file=paste0("results/app_extension_",id,".RData"))
#  }
#  
#  #writeLines(text=capture.output(utils::sessionInfo(),cat("\n"),
#  #        sessioninfo::session_info()),con="results/app_extension.txt")

## ----ext_table----------------------------------------------------------------
#  #<<start>>
#  load("results/tcga_data.RData")
#  load("results/app_extension_1.RData")
#  n0 <- sapply(y,function(x) sum(x==0))
#  n1 <- sapply(y,function(x) sum(x==1))
#  cond <- sapply(loss,function(x) !is.null(x)&!all(is.na(x)))
#  all(1*((n0>=5)&(n1>=5))==1*cond)
#  meta <- t(sapply(loss[cond],function(x) x$meta[c("ridge","lasso","tune","stack")]))
#  
#  post <- sapply(loss[cond],function(x) x$extra["stack","Inf"])
#  table <- cbind("\\#0"=n0[cond],"\\#1"=n1[cond],format(meta,digits=1,nsmall=3)," "=format(post,digits=1,nsmall=3))
#  index <- cbind(seq_len(nrow(meta)),apply(meta,1,which.min)+2)
#  table[index] <- paste0("\\underline{",table[index],"}")
#  colnames(table) <- paste0("\\text{",colnames(table),"}")
#  rownames(table) <- paste0("\\text{\\textsc{",tolower(rownames(table)),"}}")
#  table[,c(1,2)] <- paste0("\\textcolor{gray}{",table[,c(1,2)],"}")
#  table[,ncol(table)] <- paste0("\\textcolor{gray}{(",table[,ncol(table)],")}")
#  xtable <- xtable::xtable(table,align=c("l|rrccccc"),digits=c(NA,0,0,2,2,2,2,2))
#  xtable::print.xtable(xtable,sanitize.text.function=function(x) x)
#  
#  sum(meta[,"lasso"]<meta[,"ridge"]); nrow(meta)
#  sum(meta[,"stack"]<meta[,"tune"]); nrow(meta)
#  mean(100*(meta[,"stack"]-meta[,"tune"])/meta[,"tune"])
#  wilcox.test(meta[,"stack"]-meta[,"tune"])$p.value
#  round((post-meta[,"stack"])/meta[,"stack"],digits=2)

