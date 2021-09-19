# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#' Generate phenotype and other values according to selection criterion
#'
#' Build date: Jul 14, 2019
#' Last update: Nov 5, 2019
#'
#' @author Dong Yin
#'
#' @param effs a list of selected markers and their effects
#' @param FR list of fixed effects, random effects, and their combination
#' @param cv list of population Coefficient of Variation or family Coefficient of Variation
#' @param pop population information of generation, family ID, within-family ID, individual ID, paternal ID, maternal ID, and sex
#' @param pop.geno genotype matrix of the population, an individual has two columns
#' @param pos.map marker information of the population
#' @param var.pheno the phenotype variance, only used in single-trait simulation
#' @param h2.tr1 heritability vector of a single trait, every element are corresponding to a, d, aXa, aXd, dXa, dXd respectively
#' @param gnt.cov genetic covaiance matrix among all traits
#' @param h2.trn heritability among all traits
#' @param sel.crit selection criteria with the options: "TGV", "TBV", "pEBVs", "gEBVs", "ssEBVs", and "pheno"
#' @param pop.total total population information
#' @param sel.on whether to add selection
#' @param inner.env R environment of parameter "effs"
#' @param verbose whether to print detail
#'
#' @return phenotype of population
#' @export
#'
#' @examples
#' pop <- getpop(100, 1, 0.5)
#' pop.geno <- genotype(num.marker = 49336, num.ind = 100, verbose = TRUE)
#' a <- simer.sample(paste0("a", 1:3), 100)
#' b <- simer.sample(paste0("b", 1:50), 100)
#' pop$a <- a # load your fixed  effects
#' pop$b <- b # load your random effects
#' pop.env <- environment()
#' 
#' # combination of fixed effects
#' cmb.fix <- list(tr1 = c("mu", "gen", "sex", "a"), # trait 1
#'                 tr2 = c("mu", "diet", "season")) # trait 2
#'             
#' fix <- list( 
#'          mu = list(level = "mu", eff = 20),  				      
#'         gen = FALSE,         
#'         sex = list(level = c("1", "2"), eff = c(50, 30)), 
#'        diet = list(level = c("d1", "d2", "d3"), eff = c(10, 20, 30)),
#'      season = list(level = c("s1", "s2", "s3", "s4"), eff = c(10, 20, 30, 20)), 
#'           a = list(level = c("a1", "a2", "a3"), eff = c(10, 20, 30))) 
#'           
#' # combination and variance ratio of random effects
#' tr1 <- list(rn = c("PE"), ratio = 0.1)
#' tr2 <- list(rn = c("litter", "b"), ratio = c(0.1, 0.1))          
#' cmb.rand <- list(tr1 = tr1, tr2 = tr2)   
#'       
#' rand <- list(       
#'          PE = list(level = paste0("p", 1:50), eff = rnorm(50)), 
#'      litter = list(level = paste0("l", 1:50), eff = rnorm(50)),    
#'           b = list(level = paste0("b", 1:50), eff = rnorm(50)))      
#'   
#' FR <- list(cmb.fix = cmb.fix, fix = fix, cmb.rand = cmb.rand, rand = rand)
#' 
#' effs <-
#'     cal.effs(pop.geno = pop.geno,
#'              cal.model = "A",
#'              num.qtn.tr1 = c(2, 6, 10),
#'              sd.tr1 = c(0.4, 0.2, 0.02, 0.02, 0.02, 0.02, 0.02, 0.001),
#'              dist.qtn.tr1 = rep("normal", 6),
#'              prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
#'              shape.tr1 = c(1, 1, 1, 1, 1, 1),
#'              scale.tr1 = c(1, 1, 1, 1, 1, 1),
#'              multrait = FALSE,
#'              num.qtn.trn = matrix(c(18, 10, 10, 20), 2, 2),
#'              sd.trn = diag(c(1, 0.5)),
#'              qtn.spot = rep(0.1, 10),
#'              maf = 0, 
#'              verbose = TRUE)
#' 
#' pop.pheno <-
#'     phenotype(effs = effs,
#'               FR = FR, 
#'               cv = list(fam = 0.5), 
#'               pop = pop,
#'               pop.geno = pop.geno,
#'               pos.map = NULL,
#'               h2.tr1 = c(0.3, 0.1, 0.05, 0.05, 0.05, 0.01),
#'               gnt.cov = matrix(c(1, 2, 2, 15), 2, 2),
#'               h2.trn = c(0.3, 0.5),  
#'               sel.crit = "pheno", 
#'               pop.total = pop, 
#'               sel.on = TRUE, 
#'               inner.env = pop.env, 
#'               verbose = TRUE)
#' str(pop)              
#' pop <- pop.pheno$pop
#' str(pop)
#' pop.pheno$pop <- NULL           
#' str(pop.pheno)
#' 
#' effs <-
#'     cal.effs(pop.geno = pop.geno,
#'              cal.model = "A",
#'              num.qtn.tr1 = c(2, 6, 10),
#'              sd.tr1 = c(0.4, 0.2, 0.02, 0.02, 0.02, 0.02, 0.02, 0.001),
#'              dist.qtn.tr1 = rep("normal", 6),
#'              prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
#'              shape.tr1 = c(1, 1, 1, 1, 1, 1),
#'              scale.tr1 = c(1, 1, 1, 1, 1, 1),
#'              multrait = TRUE,
#'              num.qtn.trn = matrix(c(18, 10, 10, 20), 2, 2),
#'              sd.trn = diag(c(1, 0.5)),
#'              qtn.spot = rep(0.1, 10),
#'              maf = 0, 
#'              verbose = TRUE)
#' 
#' pop.pheno <-
#'     phenotype(effs = effs,
#'               FR = FR, 
#'               cv = list(fam = c(0.3, 0.7)), 
#'               pop = pop,
#'               pop.geno = pop.geno,
#'               pos.map = NULL,
#'               h2.tr1 = c(0.3, 0.1, 0.05, 0.05, 0.05, 0.01),
#'               gnt.cov = matrix(c(1, 2, 2, 15), 2, 2),
#'               h2.trn = c(0.3, 0.5), 
#'               sel.crit = "pheno", 
#'               pop.total = pop, 
#'               sel.on = FALSE, 
#'               inner.env = pop.env, 
#'               verbose = TRUE)
#' str(pop)              
#' pop <- pop.pheno$pop
#' str(pop)
#' pop.pheno$pop <- NULL  
#' str(pop.pheno)
phenotype <-
    function(effs = NULL,
             FR = NULL, 
             cv = NULL, 
             pop = NULL,
             pop.geno = NULL,
             pos.map = NULL,
             var.pheno = NULL, 
             h2.tr1 = c(0.3, 0.1, 0.05, 0.05, 0.05, 0.01),
             gnt.cov = matrix(c(1, 2, 2, 16), 2, 2),
             h2.trn = c(0.3, 0.5), 
             sel.crit = "pheno", 
             pop.total = NULL, 
             sel.on = TRUE, 
             inner.env =  NULL, 
             verbose = TRUE) {

# Start phenotype
  
  pop.env <- environment()
  nind <- nrow(pop)
  if (is.null(pop.geno)) {
    multrait <- effs
    geno <- NULL
    
  } else {
    multrait <- length(effs) > 2
    if (ncol(pop.geno) == 2*nind) {
      geno <- geno.cvt1(pop.geno)
    } else if (ncol(pop.geno) == nind) {
      geno <- pop.geno
    } else {
      stop("Genotype matrix is not match population information!")
    }
  }
  
  if (multrait) {
    eff1 <- effs$eff1
    len.eff <- length(eff1)
    if (len.eff >= 2) stop("Only A model in multiple trait simulatioin!")
    nqt <- nrow(gnt.cov)
    
    df.ind.a <- lapply(1:nqt, function(i) { return(rep(0, nind)) })
    df.ind.a <- as.data.frame(df.ind.a)
    nts <- paste(" tr", 1:nqt, sep = "")
    names(df.ind.a) <- nts
    
    if (!is.null(geno)) {
      # calculate for corelated additive effects
      for (i in 1:nqt) {
        eff.a <- effs[[2*i]]$eff.a
        qtn.a <- geno[effs[[2*i-1]], ]
        ind.a <- as.vector(crossprod(qtn.a, eff.a))
        df.ind.a[, i] <- ind.a
      }
      if (!sel.on) {
        logging.log(" Build genetic correlation for traits...\n", verbose = verbose)
        # calculate additive effects with correlation
        # df.ind.a <- mvrnorm(n = nind, mu = rep(0, nqt), Sigma = gnt.cov, empirical = TRUE)
        df.ind.a <- build.cov(df.ind.a, Sigma = gnt.cov)
        
        # adjust markers effects
        effs.adj <- get("effs", envir = inner.env)
        logging.log(" Adjust effects of markers...\n", verbose = verbose)
        for (i in 1:nqt) {
          qtn.a <- geno[effs[[2*i-1]], ]
          ind.a <- df.ind.a[, i]
          eff.a <- c(crossprod(ginv(qtn.a), ind.a))
          effs.adj[[2*i]]$eff.a <- eff.a
        }
        assign("effs", effs.adj, envir = inner.env)
      }
    } # end if (!is.null(geno))
    
    var.add <- var(df.ind.a)
    var.pheno <- diag(var.add) / h2.trn
    if (is.null(geno)) var.pheno <- sample(100, nqt)
    
    info.eff <- lapply(1:nqt, function(i) return(NULL))
    names(info.eff) <- nts
    
    # calculate for fixed effects and random effects
    if (!is.null(FR)) {
      # calculate for fixed effects and random effects
      fr <- cal.FR(pop = pop, FR = FR, var.pheno = var.pheno, pop.env = pop.env, verbose = verbose)
      var.fr <- unlist(lapply(1:length(fr), function(i) {  return(sum(apply(fr[[i]]$rand, 2, var))) }))
      mat.fr <- do.call(cbind, lapply(1:length(fr), function(i) { return(apply(cbind(fr[[i]]$fix, fr[[i]]$rand), 1, sum)) }))
    } else {
      fr <- NULL
      var.fr <- 0
      mat.fr <- 0
    }

    # calculate for environmental effects
    var.env <- var.pheno - var.fr - diag(var.add)
    mat.env <- mvrnorm(nind, mu = rep(0, length(var.env)), Sigma = diag(var.env), empirical = TRUE)
    mat.env <- as.data.frame(mat.env)
    names(mat.env) <- nts
    var.env <- var(mat.env)
    h2 <- diag(var.add) / (diag(var.add) + var.fr + diag(var.env))
    
    # calculate for phenotype
    ind.pheno <- df.ind.a + mat.fr + mat.env
    
    var.env <- var(mat.env)
    if(any(var(df.ind.a) == 0)) {
      gnt.cor <- matrix(0, nqt, nqt)
    } else {
      gnt.cor <- cor(df.ind.a)
    }
    logging.log(" Total additive    covariance matrix of all traits: \n", verbose = verbose)
    simer.print(var.add, verbose = verbose)
    logging.log(" Total environment covariance matrix of all traits: \n", verbose = verbose)
    simer.print(var.env, verbose = verbose)
    logging.log(" Heritability:", h2, "\n", verbose = verbose)
    logging.log(" Genetic correlation of all traits: \n", verbose = verbose)
    simer.print(gnt.cor, verbose = verbose)
    info.tr <- list(Covg = var.add, Cove = var.env, h2 = h2, gnt.cor = gnt.cor)
    
    for (i in 1:nqt) {
      if (!is.null(fr)) info.eff[[i]] <- cbind(fr[[i]]$fix, fr[[i]]$rand)
      info.eff[[i]]$ind.a <- df.ind.a[, i]
      info.eff[[i]]$ind.env <- mat.env[, i]
      if (!is.data.frame(info.eff[[i]])) info.eff[[i]] <- as.data.frame(info.eff[[i]])
    }
    names(df.ind.a) <- names(ind.pheno) <- paste("tr", 1:nqt, sep = "")
    info.pheno <- data.frame(TBV = df.ind.a, TGV = df.ind.a, pheno = ind.pheno)
    pheno <- list(info.tr = info.tr, info.eff = info.eff, info.pheno = info.pheno)
    
    # check data quality
    if (options("simer.show.warning") == TRUE) {
      for (i in 1:nqt) {
        idx.len <- unlist(lapply(1:ncol(pheno$info.eff[[i]]), function(j) {  return(length(unique(pheno$info.eff[[i]][, j]))) }))
        info.eff.t <- pheno$info.eff[[i]][, idx.len != 1]
        info.eff.cor <- cor(info.eff.t)
        info.eff.f <- names(info.eff.t)[names(info.eff.t) %in% c("ind.d", "ind.aa", "ind.ad", "ind.da", "ind.dd")]
        info.eff.cor[info.eff.f, ] <- 0
        info.eff.cor[, info.eff.f] <- 0
        if (any(info.eff.cor[lower.tri(info.eff.cor)] > 0.5))
          warning(" There are hign-correlations between fixed effects or fixed effects and random effects, and it will reduce the accuracy of effects in the simulation!")
      }
    }
    
  } else {
    nqt <- 1
    # calculate for genetic effects
    info.eff <- cal.gnt(geno = geno, var.pheno = var.pheno, h2 = h2.tr1, effs = effs, sel.on = sel.on, inner.env = inner.env, verbose = verbose)
    
    if (!is.null(info.eff)) {
      # calculate for phenotype variance
      ind.a <- info.eff$ind.a
      var.pheno <- var(ind.a) / h2.tr1[1]

    } else {
      ind.a <- rep(0, nind)
      if (is.null(var.pheno)) {  var.pheno <- sample(100, 1) }
    }
    
    # calculate for fixed effects and random effects
    if (!is.null(FR)) {
      fr <- cal.FR(pop = pop, FR = FR, var.pheno = var.pheno, pop.env = pop.env, verbose = verbose)
    } else {
      fr <- NULL
    }

    # calculate for phenotype
    pheno <- cal.pheno(fr = fr, info.eff = info.eff, h2 = h2.tr1, num.ind = nind, var.pheno = var.pheno, verbose = verbose)
    
    # check data quality
    if (options("simer.show.warning") == TRUE) {
      idx.len <- unlist(lapply(1:ncol(pheno$info.eff), function(i) {  return(length(unique(pheno$info.eff[, i]))) }))
      info.eff.t <- pheno$info.eff[, idx.len != 1]
      info.eff.cor <- cor(info.eff.t)
      info.eff.f <- names(info.eff.t)[names(info.eff.t) %in% c("ind.d", "ind.aa", "ind.ad", "ind.da", "ind.dd")]
      info.eff.cor[info.eff.f, ] <- 0
      info.eff.cor[, info.eff.f] <- 0
      if (any(info.eff.cor[lower.tri(info.eff.cor)] > 0.5))
        warning(" There are hign-correlations between fixed effects or fixed effects and random effects, and it will reduce the accuracy of effects in the simulation!")
    }
  }
  
  # adjust phenotype for C.V.
  if (!is.null(cv)) {
    logging.log(" Adjust phenotype for C.V. ...\n", verbose = verbose)
    if (length(cv[[1]]) != nqt) stop("The length of C.V. should be consistent with the number of traits!")
    if (!is.null(cv$fam) & is.null(cv$pop)) {
      for (i in 1:nqt) {
        if (nqt == 1) {
          fam.var <- tapply(pheno$info.pheno$pheno, pop$fam, var)
          fam.mu  <- tapply(pheno$info.pheno$pheno, pop$fam, mean)
          dev.mu <- sqrt(fam.var) / unlist(cv)[i] - fam.mu
          if (any(is.na(dev.mu))) dev.mu[is.na(dev.mu)] <- 0
          mu <- rep(dev.mu, table(pop$fam))
          if (is.null(pheno$info.eff$mu)) {
            pheno$info.eff <- cbind(mu, pheno$info.eff)
          } else {
            pheno$info.eff$mu <- pheno$info.eff$mu + mu
          }
          pheno$info.pheno$pheno <- pheno$info.pheno$pheno + mu
          
        } else {
          fam.var <- tapply(pheno$info.pheno[, 2*nqt+i], pop$fam, var)
          fam.mu  <- tapply(pheno$info.pheno[, 2*nqt+i], pop$fam, mean)
          dev.mu <- sqrt(fam.var) / unlist(cv)[i] - fam.mu
          if (any(is.na(dev.mu))) dev.mu[is.na(dev.mu)] <- 0
          mu <- rep(dev.mu, table(pop$fam))
          if (is.null(pheno$info.eff[[i]]$mu)) {
            pheno$info.eff[[i]] <- cbind(mu, pheno$info.eff[[i]])
          } else {
            pheno$info.eff[[i]]$mu <- pheno$info.eff[[i]]$mu + mu
          }
          pheno$info.pheno[, 2*nqt+i] <- pheno$info.pheno[, 2*nqt+i] + mu
        }
      } # end for (i in 1:nqt) 
      
    } else if (is.null(cv$fam) & !is.null(cv$pop)) {
      for (i in 1:nqt) {
        if (nqt == 1) {
          pop.var <- var(pheno$info.pheno$pheno)
          pop.mu  <- mean(pheno$info.pheno$pheno)
          mu <- sqrt(pop.var) / unlist(cv)[i] - pop.mu
          if (any(is.na(mu))) mu[is.na(mu)] <- 0
          if (is.null(pheno$info.eff$mu)) {
            pheno$info.eff <- cbind(mu, pheno$info.eff)
          } else {
            pheno$info.eff$mu <- pheno$info.eff$mu + mu
          }
          pheno$info.pheno$pheno <- pheno$info.pheno$pheno + mu
          
        } else {
          pop.var <- var(pheno$info.pheno[, 2*nqt+i])
          pop.mu  <- mean(pheno$info.pheno[, 2*nqt+i])
          if (any(is.na(pop.var))) { break  }
          mu <- sqrt(pop.var) / unlist(cv)[i] - pop.mu
          if (is.null(pheno$info.eff[[i]]$mu)) {
            pheno$info.eff[[i]] <- cbind(mu, pheno$info.eff[[i]])
          } else {
            pheno$info.eff[[i]]$mu <- pheno$info.eff[[i]]$mu + mu
          }
          pheno$info.pheno[, 2*nqt+i] <- pheno$info.pheno[, 2*nqt+i] + mu
        }
      } # end for (i in 1:nqt) 
      
    } else {
      stop("cv should only has fam or pop!")
    }
  }
  
  if (sel.crit == "pEBVs" | sel.crit == "gEBVs" | sel.crit == "ssEBVs") {
    geno.id <- as.data.frame(pop$index)
    pn <- grep(pattern = "pheno", x = names(pheno$info.pheno), value = TRUE)
    pheno1 <- cbind(pop$index, subset(pheno$info.pheno, select = pn))
    pedigree <- subset(pop.total, select = c("index", "sir", "dam"))
    pedigree$index <- as.character(pedigree$index)
    map <- pos.map[, 1:3]
    mode <- ifelse("ind.d" %in% names(pheno$info.eff), "AD", "A")
    
    # prepare fixed effects and random effects
    CV <- NULL
    R <- NULL
    bivar.CV <- NULL
    bivar.R <- NULL
    bivar.pos <- NULL
    if (ncol(pheno1) > 2) bivar.pos <- 2:ncol(pheno1)
    fcf <- NULL
    fcr <- NULL
    if (!is.null(fr)) {
      for (i in 1:length(fr)) {
        fcf[[i]] <- fr[[i]]$fix
        fcr[[i]] <- fr[[i]]$rand
      }
      names(fcr) <- names(fcf) <- paste0("tr", 1:length(fr))
    }
    if (!is.null(fcf)) {
      CV.t <- lapply(1:length(fcf), function(jf) {
        cv.t <- model.matrix(~., data = fcf[[jf]])
        if (!is.data.frame(cv.t)) cv.t <- as.data.frame(cv.t)
        return(cv.t)
      })
      if (ncol(pheno1) == 2) {
        CV <- CV.t[[1]]
      } else {
        bivar.CV <- CV.t
      }
    }
    if (!is.null(fcr)) {
      R.t <- lapply(1:length(fcr), function(jr) {
        if (!is.data.frame(fcr[[jr]])) fcr[[jr]] <- as.data.frame(fcr[[jr]])
        r.t <- fcr[[jr]]
        if (!is.data.frame(r.t)) r.t <- as.data.frame(r.t)
        return(r.t)
      })
      if (ncol(pheno1) == 2) {
        R <- R.t[[1]]
      } else {
        bivar.R <- R.t
      }
    } 
    
    gebv <- NULL
    eval(parse(text = "tryCatch({
      if (!(\"hiblup\" %in% .packages())) suppressWarnings(suppressMessages(library(hiblup)))
      gebv <- hiblup(pheno = pheno1, bivar.pos = bivar.pos, geno = geno, map = map, 
                     geno.id = geno.id, file.output = FALSE, pedigree = pedigree, mode = mode, 
                     CV = CV, R = R, bivar.CV = bivar.CV, bivar.R = bivar.R, snp.solution = FALSE)
    }, error=function(e) { 
      stop(\"Something wrong when running HIBLUP!\") })"))
    
    idx <- gebv$ebv[, 1] %in% pop$index
    ebv <- gebv$ebv[idx, 2:ncol(gebv$ebv)]
    if (!is.data.frame(ebv)) ebv <- as.data.frame(ebv)
    if ((!multrait) & (mode == "AD")) ebv <- apply(ebv, 1, sum)
    pheno$info.pheno <- cbind(pheno$info.pheno, ebv)
    pheno$info.hiblup <- gebv
  } 
  
  pop <- set.pheno(pop, pheno, sel.crit)
  pheno$pop <- pop
  return(pheno)
}

#' Generate genetic effects
#'
#' Build date: Nov 3, 2019
#' Last update: Nov 3, 2019
#'
#' @author Dong Yin
#'
#' @param geno genotype matrix of the population, an individual has two columns
#' @param var.pheno the phenotype variance, only used in single-trait simulation
#' @param h2 heritability vector of the trait, every elements are corresponding to a, d, aXa, aXd, dXa, dXd respectively
#' @param effs a list of selected markers and their effects
#' @param sel.on whether to add selection
#' @param inner.env R environment of parameter "effs"
#' @param verbose whether to print detail
#'
#' @return phenotype of population
#' @export
#' @references Kao C and Zeng Z (2002) <https://www.genetics.org/content/160/3/1243.long>
#'
#' @examples
#' basepop <- getpop(nind = 100, from = 1, ratio = 0.1)
#' basepop.geno <- genotype(num.marker = 48353, num.ind = 100, verbose = TRUE)
#' geno <- geno.cvt1(basepop.geno)
#' effs <-
#'     cal.effs(pop.geno = basepop.geno,
#'              cal.model = "A",
#'              num.qtn.tr1 = c(2, 6, 10),
#'              sd.tr1 = c(0.4, 0.2, 0.02, 0.02, 0.02, 0.02, 0.02, 0.001),
#'              dist.qtn.tr1 = rep("normal", 6),
#'              prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
#'              shape.tr1 = c(1, 1, 1, 1, 1, 1),
#'              scale.tr1 = c(1, 1, 1, 1, 1, 1),
#'              multrait = FALSE,
#'              num.qtn.trn = matrix(c(18, 10, 10, 20), 2, 2),
#'              sd.trn = diag(c(1, 0.5)),
#'              qtn.spot = rep(0.1, 10),
#'              maf = 0, 
#'              verbose = TRUE)
#' info.eff <- cal.gnt(geno = geno, h2 = c(0.3, 0.1, 0.05, 0.05, 0.05, 0.01), 
#'     effs = effs, sel.on = TRUE, inner.env = NULL, verbose = TRUE)
#' str(info.eff)
cal.gnt <- function(geno = NULL, var.pheno = NULL, h2 = NULL, effs = NULL, sel.on = TRUE, inner.env = NULL, verbose = TRUE) {
  if (is.null(geno)) return(NULL)
  
  mrk1 <- effs$mrk1
  qtn1 <- geno[mrk1, ]
  eff1 <- effs$eff1
  len.eff <- length(eff1)
  
  # change code from (0, 1, 2) to (-1, 0, 1)
  qtn.a <- qtn1 - 1
  eff.a <- eff1$eff.a
  ind.a <- as.vector(crossprod(qtn.a, eff.a))
  var.add <- var(ind.a)
  
  # adjust effects according to var.pheno
  if (!is.null(var.pheno)) {
    sel.on <- FALSE
    ind.a <- ind.a * sqrt(var.pheno * h2[1] / var.add)
    eff.a <- eff.a * sqrt(var.pheno * h2[1] / var.add)
    effs.adj <- get("effs", envir = inner.env)
    logging.log(" Adjust additive effects of markers...\n", verbose = verbose)
    effs.adj$eff1$eff.a <- eff.a
    assign("effs", effs.adj, envir = inner.env)
  }
  
  info.eff <- data.frame(ind.a = ind.a)
  var.add <- var(ind.a)
  if (verbose) logging.log(" Total additive            variance:", var.add, "\n", verbose = verbose)
  
  if (h2[1] > 0 & h2[1] <=1) {
    var.pheno <- var.add / h2[1]
  } else if (h2[1] == 0){
    var.pheno <- 1
    ind.a <- ind.a * 0
    var.add <- 0
  } else {
    stop(" Heritability of additive should be no more than 1 and no less than 0!")
  }
  
  # dominance effect
  if (len.eff >= 2) {
    # change code from (0, 1, 2) to (-0.5, 0.5, -0.5)
    qtn.d <- qtn1
    qtn.d[qtn.d == 2] <- 0
    qtn.d <- qtn.d - 0.5
    eff.d <- eff1$eff.d
    ind.d <- as.vector(crossprod(qtn.d, eff.d))
    var.dom <- var(ind.d)

    if (!sel.on ) {
      if (var.dom != 0) {
        # adjust dominance effect according to ratio of additive variance and dominance variance
        ind.d <- ind.d * sqrt(var.pheno * h2[2] / var.dom)
        eff.d <- eff.d * sqrt(var.pheno * h2[2] / var.dom)
        var.dom <- var(ind.d)
      }
      effs.adj <- get("effs", envir = inner.env)
      logging.log(" Adjust dominance effects of markers...\n", verbose = verbose)
      effs.adj$eff1$eff.d <- eff.d
      assign("effs", effs.adj, envir = inner.env)
    }
    
    info.eff$ind.d <- ind.d
    if (verbose) logging.log(" Total dominance           variance:", var.dom, "\n", verbose = verbose)
  }
  
  # interaction effect
  if (len.eff == 6) {
    # two part of qtn
    ophalf <- 1:(nrow(qtn.a) %/% 2)
    edhalf <- ((nrow(qtn.a) %/% 2)+1):nrow(qtn.a)
    
    qtn.aa <- qtn.a[ophalf, ] * qtn.a[edhalf, ]
    qtn.ad <- qtn.a[ophalf, ] * qtn.d[edhalf, ]
    qtn.da <- qtn.d[ophalf, ] * qtn.a[edhalf, ]
    qtn.dd <- qtn.d[ophalf, ] * qtn.d[edhalf, ]
    eff.aa <- eff1$eff.aa
    eff.ad <- eff1$eff.ad
    eff.da <- eff1$eff.da
    eff.dd <- eff1$eff.dd
    ind.aa <- as.vector(crossprod(qtn.aa, eff.aa))
    ind.ad <- as.vector(crossprod(qtn.ad, eff.ad))
    ind.da <- as.vector(crossprod(qtn.da, eff.da))
    ind.dd <- as.vector(crossprod(qtn.dd, eff.dd))
    var.aa <- var(ind.aa)
    var.ad <- var(ind.ad)
    var.da <- var(ind.da)
    var.dd <- var(ind.dd)
    
    if (!sel.on) {
      # adjust interaction effect according to ratio of additive variance and interaction variance
      if (var.aa != 0) {
        ind.aa <- ind.aa * sqrt(var.pheno * h2[3] / var.aa)
        eff.aa <- eff.aa * sqrt(var.pheno * h2[3] / var.aa)
        var.aa <- var(ind.aa)
      }
      if (var.ad != 0) {
        ind.ad <- ind.ad * sqrt(var.pheno * h2[4] / var.ad)
        eff.ad <- eff.ad * sqrt(var.pheno * h2[4] / var.ad)
        var.ad <- var(ind.ad)
      }
      if (var.da != 0) {
        ind.da <- ind.da * sqrt(var.pheno * h2[5] / var.da)
        eff.da <- eff.da * sqrt(var.pheno * h2[5] / var.da)
        var.da <- var(ind.da)
      }
      if (var.dd != 0) {
        ind.dd <- ind.dd * sqrt(var.pheno * h2[6] / var.dd)
        eff.dd <- eff.dd * sqrt(var.pheno * h2[6] / var.dd)
        var.dd <- var(ind.dd)
      } 
      effs.adj <- get("effs", envir = inner.env)
      logging.log(" Adjust interaction effects of markers...\n", verbose = verbose)
      effs.adj$eff1$eff.aa <- eff.aa
      effs.adj$eff1$eff.ad <- eff.ad
      effs.adj$eff1$eff.da <- eff.da
      effs.adj$eff1$eff.dd <- eff.dd
      assign("effs", effs.adj, envir = inner.env)
    }
    
    info.eff$ind.aa <- ind.aa
    info.eff$ind.ad <- ind.ad
    info.eff$ind.da <- ind.da
    info.eff$ind.dd <- ind.dd
    if (verbose) {
      logging.log(" Total additiveXadditive   variance:", var.aa,  "\n", verbose = verbose)
      logging.log(" Total dominanceXadditive  variance:", var.ad,  "\n", verbose = verbose)
      logging.log(" Total dominanceXadditive  variance:", var.da,  "\n", verbose = verbose)
      logging.log(" Total dominanceXdominance variance:", var.dd,  "\n", verbose = verbose)
    }
  }
  
  return(info.eff)
}

#' Calculate for fixed effects and random effects
#'
#' Build date: Nov 1, 2019
#' Last update: Nov 1, 2019
#'
#' @author Dong Yin
#'
#' @param pop population information
#' @param FR list of fixed effects, random effects, and their combination
#' @param var.pheno phenotype variances of all traits
#' @param pop.env R environment of population information
#' @param verbose whether to print detail
#'
#' @return list of fixed effects and random effects
#' @export
#'
#' @examples
#' pop <- getpop(100, 1, 0.5)
#' a <- simer.sample(paste0("a", 1:3), 100)
#' b <- simer.sample(paste0("b", 1:50), 100)
#' pop$a <- a # load your fixed  effects
#' pop$b <- b # load your random effects
#' pop.env <- environment()
#' 
#' # combination of fixed effects
#' cmb.fix <- list(tr1 = c("mu", "gen", "sex", "a"), # trait 1
#'                 tr2 = c("mu", "diet", "season")) # trait 2
#'             
#' fix <- list( 
#'          mu = list(level = "mu", eff = 20),  				      
#'         gen = FALSE,         
#'         sex = list(level = c("1", "2"), eff = c(50, 30)), 
#'        diet = list(level = c("d1", "d2", "d3"), eff = c(10, 20, 30)),
#'      season = list(level = c("s1", "s2", "s3", "s4"), eff = c(10, 20, 30, 20)), 
#'           a = list(level = c("a1", "a2", "a3"), eff = c(10, 20, 30))) 
#'           
#' # combination and variance ratio of random effects
#' tr1 <- list(rn = c("PE"), ratio = 0.1)
#' tr2 <- list(rn = c("litter", "b"), ratio = c(0.1, 0.1))          
#' cmb.rand <- list(tr1 = tr1, tr2 = tr2)   
#'       
#' rand <- list(       
#'          PE = list(level = paste0("p", 1:50), eff = rnorm(50)), 
#'      litter = list(level = paste0("l", 1:50), eff = rnorm(50)),    
#'           b = list(level = paste0("b", 1:50), eff = rnorm(50)))      
#'   
#' FR <- list(cmb.fix = cmb.fix, fix = fix, cmb.rand = cmb.rand, rand = rand)
#' fr <- cal.FR(pop = pop, FR = FR, var.pheno = c(100, 100), pop.env = pop.env, verbose = TRUE)
#' str(fr) 	          	         	          	         
cal.FR <- function(pop = NULL, FR, var.pheno = NULL, pop.env = NULL, verbose = TRUE) {
  
  nind <- nrow(pop)
  len.tr <- length(var.pheno)
  pop[is.na(pop)] <- "0"
  cmb.fix <- FR$cmb.fix
  fix <- FR$fix
  cmb.rand <- FR$cmb.rand
  rand <- FR$rand
  
  # generate fixed effects of individuals
  fn <- names(fix)
  if (is.null(fn)) {
    fes <- NULL
    
  } else {
    fes <- lapply(1:length(fn), function(i) { return(rep(0, nind)) })
    fes <- as.data.frame(fes)
    names(fes) <- fn
    for (i in 1:length(fix)) { # for
      if (!is.list(fix[[i]])) next
      lev.fix <- fix[[i]]$level
      eff.fix <- fix[[i]]$eff
      if (length(lev.fix) != length(eff.fix)) stop(fn[i], ": Levels should be consistent with effects!")
      len.fix <- length(lev.fix)
      if (fn[i] %in% names(pop)) {
        pt <- pop[fn[i]]
        fe <- rep(0, nind)
        ele.pt <- unique(as.character(unlist(pt)))
        if (len.fix != length(ele.pt)) { 
          stop(fn[i], ": Level length should be equal to effects length in the population!")
        } else if (!setequal(lev.fix, ele.pt)) {
          stop(fn[i], " in fix should be corresponding to ", fn[i], " in the poplation!")
        }
        for (j in 1:len.fix) {
          fe[pt == lev.fix[j]] <- eff.fix[j]
        }
        
      } else {
        sam <- simer.sample(1:len.fix, nind)
        fl <- lev.fix[sam]
        if (fn[i] %in% unlist(cmb.fix)) {
          pop.adj <- get("pop", envir = pop.env)
          logging.log(" Add", fn[i], "to population...\n", verbose = verbose)
          pop.adj <- cbind(pop.adj, fl)
          names(pop.adj)[names(pop.adj) == "fl"] <- fn[i]
          assign("pop", pop.adj, envir = pop.env)
        }
        fe <- eff.fix[sam]
      }
 
      fes[[i]] <- fe
    } # end for
  }
  
  # combine fixed effects
  fix <- lapply(1:len.tr, function(i) { return(fes[cmb.fix[[i]]]) })
  names(fix) <- names(cmb.fix[1:len.tr])
  
  # generate random effects of individuals
  rn <- names(rand)
  if (is.null(rn)) {
    res <- NULL
    
  } else {
    res <- lapply(1:length(rn), function(i) { return(rep(0, nind)) })
    res <- as.data.frame(res)
    names(res) <- rn
    for (i in 1:length(rand)) { # for
      if (!is.list(rand[[i]])) next
      lev.rand <- rand[[i]]$level
      eff.rand <- rand[[i]]$eff
      if (length(lev.rand) != length(eff.rand)) stop(rn[i], ": Levels should be consistent with effects!")
      len.rand <- length(lev.rand)
      if (len.rand < 50)
        stop("Group number must be no less than 50 in random effects!")
      while (shapiro.test(eff.rand)$p.value < 0.05) {
        eff.rand <- rnorm(length(eff.rand))
      }
      
      if (rn[i] %in% names(pop)) {
        pt <- pop[rn[i]]
        re <- rep(0, nind)
        ele.pt <- unique(as.character(unlist(pt)))
        if (len.rand != length(ele.pt)) { 
          stop(rn[i], ": Level length should be equal to effects length!")
        } else if (!setequal(lev.rand, ele.pt)) {
          stop(rn[i], " in rand should be corresponding to ", rn[i], " in the poplation!")
        }
        for (j in 1:len.rand) {
          re[pt == lev.rand[j]] <- eff.rand[j]
        }
        
      } else {
        sam <- simer.sample(1:len.rand, nind)
        rl <- lev.rand[sam]
        if (rn[i] %in% unlist(cmb.rand)) {
          pop.adj <- get("pop", envir = pop.env)
          logging.log(" Add", rn[i], "to population...\n", verbose = verbose)
          pop.adj <- cbind(pop.adj, rl)
          names(pop.adj)[names(pop.adj) == "rl"] <- rn[i]
          assign("pop", pop.adj, envir = pop.env)
        }
        re <- eff.rand[sam]
      }
      
      res[[i]] <- re
    } # end for
  }
  
  # combine random effects
  rand <- lapply(1:len.tr, function(i) { 
    rn <- cmb.rand[[i]]$rn
    if (is.null(rn)) return(res[NULL])
    ratio <- cmb.rand[[i]]$ratio
    if (length(rn) != length(ratio))
      stop("Phenotype variance ratio of random effects should be corresponding to random effects names!")
    rt <- res[rn]
    scale <- sqrt(var.pheno[i]*ratio / apply(rt, 2, var))
    rt <- sweep(rt, 2, scale, "*")
    var.r <- apply(rt, 2, var)
    logging.log(" The variance of", names(rt), "of", paste("trait", paste0(i, ":")), var.r, "\n", verbose = verbose)
    return(rt)
  })
  names(rand) <- names(cmb.rand[1:len.tr])
  
  fr <- lapply(1:len.tr, function(i) { return(list(fix = fix[[i]], rand = rand[[i]])) })
  names(fr) <- names(cmb.fix[1:len.tr])
  return(fr)
}

#' Calculate for phenotype
#'
#' Build date: Nov 4, 2019
#' Last update: Nov 4, 2019
#'
#' @author Dong Yin
#'
#' @param fr list of fixed effects and random effects
#' @param info.eff list of phenotype decomposition
#' @param h2 heritability vector of the trait, every elements are corresponding to a, d, aXa, aXd, dXa, dXd respectively
#' @param num.ind population size
#' @param var.pheno phenotype variance
#' @param verbose whether to print detail
#'
#' @return list of phenotype
#' @export
#'
#' @examples
#' pop <- getpop(nind = 100, from = 1, ratio = 0.1)
#' pop.geno <- genotype(num.marker = 48353, num.ind = 100, verbose = TRUE)
#' geno <- geno.cvt1(pop.geno)
#' num.ind <- ncol(geno)
#' h2 <- 0.3
#' effs <-
#'     cal.effs(pop.geno = pop.geno,
#'              cal.model = "A",
#'              num.qtn.tr1 = c(2, 6, 10),
#'              sd.tr1 = c(0.4, 0.2, 0.02, 0.02, 0.02, 0.02, 0.02, 0.001),
#'              dist.qtn.tr1 = rep("normal", 6),
#'              prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
#'              shape.tr1 = c(1, 1, 1, 1, 1, 1),
#'              scale.tr1 = c(1, 1, 1, 1, 1, 1),
#'              multrait = FALSE,
#'              num.qtn.trn = matrix(c(18, 10, 10, 20), 2, 2),
#'              sd.trn = diag(c(1, 0.5)),
#'              qtn.spot = rep(0.1, 10),
#'              maf = 0, 
#'              verbose = TRUE)
#'         
#' info.eff <- cal.gnt(geno = geno, h2 = h2, effs = effs, 
#'     sel.on = TRUE, inner.env = NULL, verbose = TRUE)
#' 
#' var.pheno <- var(info.eff$ind.a) / h2
#' pheno.list <- cal.pheno(fr = NULL, info.eff = info.eff, h2 = h2,
#'     num.ind = num.ind, var.pheno = var.pheno, verbose = TRUE)
#' str(pheno.list)
cal.pheno <- function(fr = NULL, info.eff = NULL, h2 = NULL, num.ind = NULL, var.pheno = NULL, verbose = TRUE) {
  if (!is.null(info.eff)) {
    ind.a <- info.eff$ind.a
    TBV <- ind.a
    TGV <- apply(info.eff, 1, sum)
    var.gnt <- apply(info.eff, 2, var)
  } else {
    ind.a <- rep(0, num.ind)
    TBV <- ind.a
    TGV <- ind.a
    var.gnt <- 0
  }
  
  if (!is.null(fr)) {
    if (is.null(info.eff)) {
      info.eff <- cbind(fr[[1]]$fix, fr[[1]]$rand)
    } else {
      info.eff <- cbind(fr[[1]]$fix, fr[[1]]$rand, info.eff)
    }
    var.fr <- apply(fr[[1]]$rand, 2, var)
  } else {
    var.fr <- 0
  }
  
  var.env <- var.pheno - sum(var.fr, var.gnt)

  if (var.env <= 0) 
    stop("Please reduce your fixed variance, random variance or genetic variance to get a positive environmental variance!")
  
  ind.env <- rnorm(num.ind, 0, 1)
  ind.env <- ind.env * sqrt(var.env / var(ind.env))
  info.eff$ind.env <- ind.env
  if (!is.data.frame(info.eff)) info.eff <- as.data.frame(info.eff) 
 
  # get phenotype
  ind.pheno <- apply(info.eff, 1, sum)
  
  Vg <- var.gnt
  Ve <- var(ind.env)
  h2.new <- Vg / sum(Vg, var.fr, Ve)
  logging.log(" Total environment         variance:", Ve, "\n", verbose = verbose)
  logging.log(" Heritability:", h2.new, "\n", verbose = verbose)
  info.tr <- list(Vg = Vg, Ve = Ve, h2 = h2.new)
  info.pheno <- data.frame(TBV = TBV, TGV = TGV, pheno = ind.pheno)
  pheno.list <- list(info.tr = info.tr, info.eff = info.eff, info.pheno = info.pheno)
  return(pheno.list)  
}

#' Calculate for genetic effects list of selected markers
#'
#' Build date: Sep 11, 2018
#' Last update: Jul 30, 2019
#'
#' @author Dong Yin
#'
#' @param pop.geno genotype of population, a individual has two columns
#' @param incols the column number of an individual in the input genotype matrix, it can be 1 or 2
#' @param cal.model phenotype models with the options: "A", "AD", "ADI"
#' @param num.qtn.tr1 integer or integer vector, the number of QTN in a single trait
#' @param sd.tr1 standard deviation of different effects, the last 5 vector elements are corresponding to d, aXa, aXd, dXa, dXd respectively and the rest elements are corresponding to a
#' @param dist.qtn.tr1 distributions of the QTN effects with the options: "normal", "geometry", "gamma", and "beta", vector elements are corresponding to a, d, aXa, aXd, dXa, dXd respectively
#' @param prob.tr1 unit effect of geometric distribution, its length should be same as dist.qtn.tr1
#' @param shape.tr1 shape of gamma distribution of a single trait, its length should be same as dist.qtn.tr1
#' @param scale.tr1 scale of gamma distribution of a single trait, its length should be same as dist.qtn.tr1
#' @param shape1.tr1 non-negative parameters of the Beta distribution, its length should be same as dist.qtn.tr1
#' @param shape2.tr1 non-negative parameters of the Beta distribution, its length should be same as dist.qtn.tr1
#' @param ncp.tr1 non-centrality parameter, its length should be same as dist.qtn.tr1
#' @param multrait whether to apply multiple traits, TRUE represents applying, FALSE represents not
#' @param num.qtn.trn QTN distribution matrix, diagonal elements are QTN number of the trait, non-diagonal elements are QTN number of overlap QTN between two traits
#' @param sd.trn a matrix with the standard deviation of the QTN effects
#' @param qtn.spot QTN probability in every block
#' @param maf Minor Allele Frequency, marker selection range is from  maf to 0.5
#' @param verbose whether to print detail
#'
#' @return a list with number of overlap markers, selected markers, effect of markers
#' @export
#'
#' @examples
#' basepop.geno <- genotype(num.marker = 48353, num.ind = 100, verbose = TRUE)
#' effs <-
#'     cal.effs(pop.geno = basepop.geno,
#'              cal.model = "A",
#'              num.qtn.tr1 = c(200, 200, 100),
#'              sd.tr1 = c(0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.07, 0.03),
#'              dist.qtn.tr1 = rep("normal", 6),
#'              prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
#'              shape.tr1 = c(1, 1, 1, 1, 1, 1),
#'              scale.tr1 = c(1, 1, 1, 1, 1, 1),
#'              shape1.tr1 = c(1, 1, 1, 1, 1, 1),
#'              shape2.tr1 = c(1, 1, 1, 1, 1, 1),
#'              ncp.tr1 = c(0, 0, 0, 0, 0, 0), 
#'              multrait = FALSE,
#'              num.qtn.trn = matrix(c(400, 100, 100, 400), 2, 2),
#'              sd.trn = matrix(c(0.07, 0, 0, 0.07), 2, 2),
#'              qtn.spot = rep(0.1, 10),
#'              maf = 0, 
#'              verbose = TRUE)
#' str(effs)
cal.effs <-
    function(pop.geno = NULL,
             incols = 2, 
             cal.model = "A",
             num.qtn.tr1 = c(2, 6, 10),
             sd.tr1 = c(0.4, 0.2, 0.02, 0.02, 0.02, 0.02, 0.02, 0.001),
             dist.qtn.tr1 = rep("normal", 6),
             prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
             shape.tr1 = c(1, 1, 1, 1, 1, 1),
             scale.tr1 = c(1, 1, 1, 1, 1, 1),
             shape1.tr1 = c(1, 1, 1, 1, 1, 1),
             shape2.tr1 = c(1, 1, 1, 1, 1, 1),
             ncp.tr1 = c(0, 0, 0, 0, 0, 0), 
             multrait = FALSE,
             num.qtn.trn = matrix(c(18, 10, 10, 20), 2, 2),
             sd.trn = matrix(c(1, 0, 0, 0.5), 2, 2),
             qtn.spot = rep(0.1, 10),
             maf = 0, 
             verbose = TRUE) {

# Start calculation

  if (is.null(pop.geno)) return(multrait)
  if (incols == 2) {
    # combine odd and even columns genotype matrix
    geno <- geno.cvt1(pop.geno)
  } else {
    geno <- pop.geno
  }
  num.marker <- nrow(geno)
  num.ind <- ncol(geno) / incols
      
  # calculate weight of every marker
  num.block <- length(qtn.spot)
  len.block <- num.marker %/% num.block
  tail.block <- num.marker %% num.block + len.block
  num.inblock <- c(rep(len.block, (num.block-1)), tail.block)
  wt.marker <- rep(qtn.spot / num.inblock, num.inblock)

  if (maf != 0) {
    pop.maf <- rep(0, nrow(geno))
    for (i in 1:nrow(geno)) {
      v <- geno[i, ]
      pop.maf[i] <- min(c(sum(v == 0)+sum(v == 1)/2, sum(v == 2)+sum(v == 1)/2) / length(v))
    }
    wt.marker[pop.maf < maf] <- 0
  }
  
  if (multrait) {
    if (nrow(num.qtn.trn) != ncol(num.qtn.trn) || any(num.qtn.trn != t(num.qtn.trn)))
      stop("num.qtn.trn should be symmetric matrix!")
    if (any(dim(num.qtn.trn) != dim(sd.trn))) 
      stop("non-conformable arrays!")
    
    num.qtn <- sum(num.qtn.trn[lower.tri(num.qtn.trn)]) + sum(diag(num.qtn.trn))
    sel.marker <- sample(1:num.marker, num.qtn, replace = FALSE, prob = wt.marker)
    k <- 1
    nqt <- nrow(num.qtn.trn)
    effs <- lapply(1:(2*nqt), function(i) { return(NULL) })
    names(effs) <- paste(rep(c("mrk", "eff"), nqt), rep(1:nqt, each=2), sep = "")
    for (i in 1:nqt) {
      for (j in i:nqt) {
        num.t <- num.qtn.trn[i, j]
        mrk.t <- sel.marker[k:(k+num.t-1)]
        effs[[2*i-1]] <- c(effs[[2*i-1]], mrk.t)
        if (i != j) {
          effs[[2*j-1]] <- c(effs[[2*j-1]], mrk.t)
        }
        k <- k + num.t
      }
      effs[[2*i]] <- list(eff.a = rnorm(length(effs[[2*i-1]]), 0, sd.trn[i, i]))
      logging.log(" Number of selected markers of trait", i, ":", length(effs[[2*i-1]]), "\n", verbose = verbose)
    }

  } else {
    num.qtn <- sum(num.qtn.tr1)
    sel.marker <- sort(sample(1:num.marker, num.qtn, replace = FALSE, prob = wt.marker))
    len.qtn <- length(num.qtn.tr1)
    logging.log(" Number of selected markers of trait 1:", num.qtn.tr1, "\n", verbose = verbose)
    
    if (cal.model == "A") {
      logging.log(" Apply A model...\n", verbose = verbose)
      if (length(sd.tr1) < length(num.qtn.tr1))
        stop("The length of sd.tr1 should be no less than length of num.qtn.tr1!")
      eff.a <- cal.eff(num.qtn.tr1, sd.tr1[1:len.qtn], dist.qtn.tr1[1], prob.tr1[1], shape.tr1[1], scale.tr1[1], shape1.tr1[1], shape2.tr1[1], ncp.tr1[1])
      eff1 <- list(eff.a=eff.a)
      
    } else if (cal.model == "AD") {
      logging.log(" Apply AD model...\n", verbose = verbose)
      eff.a <- cal.eff(num.qtn.tr1, sd.tr1[1:len.qtn], dist.qtn.tr1[1], prob.tr1[1], shape.tr1[1], scale.tr1[1], shape1.tr1[1], shape2.tr1[1], ncp.tr1[1])
      eff.d <- cal.eff(sum(num.qtn.tr1), sd.tr1[len.qtn+1], dist.qtn.tr1[2], prob.tr1[2], shape.tr1[2], scale.tr1[2], shape1.tr1[2], shape2.tr1[2], ncp.tr1[2])
      eff1 <- list(eff.a=eff.a, eff.d=eff.d)
      
    } else if (cal.model == "ADI") {
      logging.log(" Apply ADI model...\n", verbose = verbose)
      if (num.qtn %% 2 != 0) stop("The number of qtn should be even in the ADI model!")
      # the first part of qtn
      ophalf <- num.qtn %/% 2
      eff.a  <- cal.eff(num.qtn.tr1,      sd.tr1[1:len.qtn], dist.qtn.tr1[1], prob.tr1[1], shape.tr1[1], scale.tr1[1], shape1.tr1[1], shape2.tr1[1], ncp.tr1[1])
      eff.d  <- cal.eff(sum(num.qtn.tr1), sd.tr1[len.qtn+1], dist.qtn.tr1[2], prob.tr1[2], shape.tr1[2], scale.tr1[2], shape1.tr1[2], shape2.tr1[2], ncp.tr1[2])
      eff.aa <- cal.eff(ophalf,           sd.tr1[len.qtn+2], dist.qtn.tr1[3], prob.tr1[3], shape.tr1[3], scale.tr1[3], shape1.tr1[3], shape2.tr1[3], ncp.tr1[3])
      eff.ad <- cal.eff(ophalf,           sd.tr1[len.qtn+3], dist.qtn.tr1[4], prob.tr1[4], shape.tr1[4], scale.tr1[4], shape1.tr1[4], shape2.tr1[4], ncp.tr1[4])
      eff.da <- cal.eff(ophalf,           sd.tr1[len.qtn+4], dist.qtn.tr1[5], prob.tr1[5], shape.tr1[5], scale.tr1[5], shape1.tr1[5], shape2.tr1[5], ncp.tr1[5])
      eff.dd <- cal.eff(ophalf,           sd.tr1[len.qtn+5], dist.qtn.tr1[6], prob.tr1[6], shape.tr1[6], scale.tr1[6], shape1.tr1[6], shape2.tr1[6], ncp.tr1[6])
      eff1 <- list(eff.a=eff.a, eff.d=eff.d, eff.aa=eff.aa, eff.ad=eff.ad, eff.da=eff.da, eff.dd=eff.dd)
    }

    effs <- list(mrk1=sel.marker, eff1=eff1)
  }

  return(effs)
}

#' Calculate for genetic effects vector of selected markers
#'
#' Build date: Nov 14, 2018
#' Last update: Jul 30, 2019
#'
#' @author Dong Yin
#'
#' @param num.qtn number of QTN
#' @param eff.sd standard deviation of different effects
#' @param dist.qtn distribution of QTN's effects with options: "normal", "geometry", "gamma", and "beta"
#' @param prob unit effect of geometric distribution
#' @param shape shape of gamma distribution
#' @param scale scale of gamma distribution
#' @param shape1 non-negative parameters of the Beta distribution
#' @param shape2 non-negative parameters of the Beta distribution
#' @param ncp non-centrality parameter
#'
#' @return genetic effects vector of selected markers
#' @export
#'
#' @examples
#' num.qtn <- c(2, 6, 10) # three qtn groups
#' eff.sd <- c(0.4, 0.2, 0.02) # three variance of qtn group
#' eff <- cal.eff(num.qtn = num.qtn, eff.sd = eff.sd, dist.qtn = "normal",
#'         prob = 0.5, shape = 1, scale = 1)
#' str(eff)
#'
#' num.qtn <- sum(num.qtn)
#' eff.sd <- sum(eff.sd)
#' eff <- cal.eff(num.qtn = num.qtn, eff.sd = eff.sd, dist.qtn = "normal",
#'                prob = 0.5, shape = 1, scale = 1, 
#'                shape1 = 1, shape2 = 1, ncp = 0)
#' str(eff)
cal.eff <- function(num.qtn, eff.sd, dist.qtn, prob, shape, scale, shape1, shape2, ncp=0) {
  if (sum(num.qtn) == 0) return(0)
  # Judge which kind of distribution of QTN
  eff.qtn <- NULL
  if (dist.qtn == "normal") {
    for (nq in 1:length(num.qtn)) {
    	eff.qtn <- c(eff.qtn, rnorm(num.qtn[nq], 0, eff.sd[nq]))
    }

  } else if (dist.qtn == "geometry") {
    for (nq in 1:length(num.qtn)) {
    	eff.qtn <- c(eff.qtn, rgeom(num.qtn[nq], prob))
    }

  } else if (dist.qtn == "gamma") {
    for (nq in 1:length(num.qtn)) {
    	eff.qtn <- c(eff.qtn, rgamma(num.qtn[nq], shape, scale))
    }
    
  } else if (dist.qtn == "beta") {
    for (nq in 1:length(num.qtn)) {
      eff.qtn <- c(eff.qtn, rbeta(num.qtn[nq], shape1, shape2, ncp))
    }
    
  } else {
    stop("Please input a right QTN effect!")
  }

  return(eff.qtn)
}

#' Set the phenotype of the population
#'
#' @param pop population information of generation, family ID, within-family ID, individual ID, paternal ID, maternal ID, and sex
#' @param pop.pheno phenotype information
#' @param sel.crit selection criteria with the options: "TGV", "TBV", "pEBVs", "gEBVs", "ssEBVs", and "pheno"
#'
#' @return population information with phenotype
#' @export
#'
#' @examples
#' pop <- getpop(nind = 100, from = 1, ratio = 0.1)
#' pop.geno <- genotype(num.marker = 48353, num.ind = 100, verbose = TRUE)
#' effs <-
#'     cal.effs(pop.geno = pop.geno,
#'              cal.model = "A",
#'              num.qtn.tr1 = c(2, 6, 10),
#'              sd.tr1 = c(0.4, 0.2, 0.02, 0.02, 0.02, 0.02, 0.02, 0.001),
#'              dist.qtn.tr1 = rep("normal", 6),
#'              prob.tr1 = c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
#'              shape.tr1 = c(1, 1, 1, 1, 1, 1),
#'              scale.tr1 = c(1, 1, 1, 1, 1, 1),
#'              multrait = FALSE,
#'              num.qtn.trn = matrix(c(18, 10, 10, 20), 2, 2),
#'              sd.trn = diag(c(1, 0.5)),
#'              qtn.spot = rep(0.1, 10),
#'              maf = 0, 
#'              verbose = TRUE)
#' 
#' pop.pheno <-
#'     phenotype(effs = effs,
#'               FR = NULL, 
#'               cv = list(fam = 0.5), 
#'               pop = pop,
#'               pop.geno = pop.geno,
#'               pos.map = NULL,
#'               h2.tr1 = c(0.3, 0.1, 0.05, 0.05, 0.05, 0.01),
#'               gnt.cov = matrix(c(1, 2, 2, 15), 2, 2),
#'               h2.trn = c(0.3, 0.5),  
#'               sel.crit = "pheno", 
#'               pop.total = pop, 
#'               sel.on = TRUE, 
#'               inner.env = pop.env, 
#'               verbose = TRUE)
#' 
#' str(pop)
#' pop <- set.pheno(pop, pop.pheno, sel.crit = "pheno")
#' str(pop)
set.pheno <- function(pop, pop.pheno, sel.crit) {
  f1 <- grep(pattern = "TBV|TGV|pheno|ebv|u1", x = names(pop), value = FALSE)
  if (length(f1) != 0) pop <- pop[, -f1]
  if (sel.crit == "TBV") {
    pn <- grep(pattern = "TBV", x = names(pop.pheno$info.pheno), value = TRUE)
  } else if (sel.crit == "TGV") {
    pn <- grep(pattern = "TGV", x = names(pop.pheno$info.pheno), value = TRUE)
  } else if (sel.crit == "pheno") {
    pn <- grep(pattern = "pheno", x = names(pop.pheno$info.pheno), value = TRUE)
  } else if (sel.crit == "pEBVs" | sel.crit == "gEBVs" | sel.crit == "ssEBVs") {
    pn <- grep(pattern = c("ebv|u1"), x = names(pop.pheno$info.pheno), value = TRUE)
  } else {
    stop("Please select correct selection criterion!")
  }
  pop <- cbind(pop, subset(pop.pheno$info.pheno, select = pn))
  return(pop)
}
