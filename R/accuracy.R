#' Calculate bias, RMSE, corelation etc of two vectors.
#'
#' @description Calculates: corelation coeficient,
#'  bias (absolute and relative), RMSE (absolute and relative), and performes statistical test to check if the differences between \code{reference} and \code{estimate} are significant.
#'  Correlation coefficient as well as statistical test depend on the \code{dist.normal} value.
#'  Optionally statistics can be calculated for groups of data, specified with the \code{by} parameter.
#' @param reference a vector of reference values
#' @param estimate a vector of estimated values
#' @param by Optional grouping variable
#' @param noinfo Logical. Should the additional information on the calculations be displayed?
#' @param dist.normal Logical. Is the distribution normal? If TRUE t-test and Pearson correlation is calculated. If FALSE, Wilcoxon paired test and Spearman corelation is calculated.
#' @param short Logical. Calculate only a subset of summary statistics.
#' @return summary statistics of the differences between \code{reference} and \code{estimate}.
#' @export

accuracy <-function(reference,estimate,by=NULL,noinfo=TRUE,dist.normal=TRUE,short=FALSE) {

  #check input variables
  if (!is.numeric(reference) | !is.numeric(estimate)) {
    stop("Input values not numeric!")
  }

  #check if input values are equal length
  if(length(reference) != length(estimate)) {
    stop("Input variable not of equal length")
  }

  if(is.null(by) == FALSE) {
    if(length(reference) != length(by) | length(reference) != length(by)) {
      stop("Input variable not of equal length")
    }
  }

  if(noinfo==FALSE) { #display information about how the differnce is calculated
    message("The difference is calculated with following equations:") ;
    message(paste("bias =",deparse(substitute(estimate)),"-",deparse(substitute(reference))));
    message(paste("bias% = (",deparse(substitute(estimate)),"-",deparse(substitute(reference)),") / ",deparse(substitute(reference)),"* 100"))
    #if (dist.normal == T) {
    #  message("Correlation method: Pearson. Stat test: t-test (paired)")
    #} else {
    #  message("Correlation method: Spearman Stat test: Wilcoxon (paired)")
    #}
  }


  #Initialize out variable (stats in group)
  out<- NULL

  #stats in groups
  if(is.null(by) == FALSE) {
    df <- data.frame(reference,estimate,by)  #create temporary data frame
    f <- levels(as.factor(df$by))

    #create placeholders for results
    count<-cor_coeff<-R2<-bias<-RMSE<-bias_perc<-RMSE_perc<-p_val<-stat<-c()

    for (i in 1:length(f)) {
      subs <- subset(df,df$by==f[i])
      stats.metrics <- calc_error(reference=subs$reference,estimate=subs$estimate)

      out <- rbind(out,data.frame(factor=f[i],
                                  count=stats.metrics$count,
                                  R2=stats.metrics$R2,
                                  RMSE=stats.metrics$RMSE,
                                  RMSE_perc=stats.metrics$RMSE_per,
                                  bias=stats.metrics$bias,
                                  bias_perc=stats.metrics$bias_per
                                  ))
    }

    #stat_for_all<-calc.error(reference,estimate,noinfo=TRUE,dist.normal=dist.normal) #recursive!:) #stats for all data to add as the last row
    #out<-data.frame(factor=f,count,cor_coeff,R2,bias,bias_perc,RMSE,RMSE_perc,stat,p_val)
    #out<-rbind(out,stat_for_all)
    #return(out)

  }else{
  #calculations for ungrouped data
  f<-"all"
  df <- data.frame(reference,estimate)
  stats.metrics <- calc_error(reference=df$reference,estimate=df$estimate)

  out <- data.frame(factor=f,
                    count=stats.metrics$count,
                    R2=stats.metrics$R2,
                    RMSE=stats.metrics$RMSE,
                    RMSE_perc=stats.metrics$RMSE_per,
                    bias=stats.metrics$bias,
                    bias_perc=stats.metrics$bias_per
                              )
  }
  return(out)

}

#' Calculate bias, RMSE, corelation etc of two vectors.
#'
#' Internal function used by \code{\link[foster]{acuracy}}
#'
#' @param reference a vector of reference values
#' @param estimate a vector of estimated values
#' @param by Optional grouping variable
#' @param noinfo Logical. Should the additional information on the calculations be displayed?
#' @param dist.normal Logical. Is the distribution normal? If TRUE t-test and Pearson correlation is calculated. If FALSE, Wilcoxon paired test and Spearman corelation is calculated.
#' @param short Logical. Calculate only a subset of summary statistics.
#' @return summary statistics of the differences between \code{reference} and \code{estimate}.
#' @export


calc_error <- function(reference,estimate) {
  count <- length(reference)
  bias <- mean(estimate - reference,na.rm=T)
  RMSE <- sqrt(mean((estimate - reference)^2, na.rm = TRUE))
  R2 <- 1 - sum((reference-estimate)^2)/sum((reference-mean(reference))^2)
  #bias_perc_int <- mean((dfs$estimate - dfs$reference) / dfs$reference, na.rm=T)*100
  bias_per <- bias / mean(reference, na.rm=T)*100
  RMSE_per <- RMSE / abs(mean(reference,na.rm=T))*100

  #if (is.infinite(bias_perc_int)) bias_perc <- mean((dfs$estimate - dfs$reference) / ifelse(dfs$reference==0,NA,dfs$reference*100),na.rm=T)


  # if (dist.normal == T) {
  #   if (short==FALSE) {test <- t.test(x = dfs$reference,y = dfs$estimate,paired=T)}
  #   if (short==FALSE) {p_val <- test$p.value; stat <- as.numeric(test$statistic)} else {p_val<-NA; stat<-NA}
  #   if (short==FALSE) {cor_coeff<-cor(dfs$reference,dfs$estimate,method="pearson",use="pairwise.complete.obs")} else {cor_coeff <- NA}
  # } else {
  #   if (short==FALSE) {test <-wilcox.test(dfs$reference,dfs$estimate,paired=T)}
  #   if (short==FALSE) {p_val<-test$p.value; stat<-as.numeric(test$statistic)} else {p_val<-NA; stat<-NA}
  #   if (short==FALSE) {cor_coeff<-cor(dfs$reference,dfs$estimate,method="spearman",use="pairwise.complete.obs")} else {cor_coeff <- NA}
  # }

return(list(count=count,R2=R2,RMSE=RMSE,bias=bias,RMSE_per=RMSE_per,bias_per=bias_per))

}