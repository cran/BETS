#' @title bcbExpectM
#' 
#' @description Market Expectations with mensal reference.
#' 
#' 
#' @param variables Possible options: "Media", "Mediana", "DesvioPadrao",
#' "CoeficienteVariacao", "Minimo", "Maximo".
#' @param start Initial date at which the data was projected, in ISO format.
#' @param end Final date at which the data was projected, in ISO format.
#' @param indicator  A string. Available indicator.
#' @param limit A integer. A limint of data in request, top is 10000.
#'
#'
#' @import rjson stringr dplyr
#' @return A data.frame.
#' @export 
#'
#' 
#' @note The available indicators are: IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-FIPE, Producao 
#'    industrial, Meta para taxa over-selic, Taxa de cambio .  
#' 
#' @examples 
#'  # bcbExpectM()
#' 
#' 
#' 



bcbExpectM <- function(indicator = 'IPCA-15',limit = 100, variables = c("Media","Mediana","DesvioPadrao","CoeficienteVariacao","Minimo","Maximo","numeroRespondentes","baseCalculo"), start, end ){
    
    
    indicator = str_replace_all(indicator," ","%20")
    
    if(limit > 10000 | limit < 0)stop("You need provid a limit in between 0 and 10000!")
    # variaveis
    variaveis_a <- paste("filter=Indicador%20eq%20'",indicator,"'",sep="")
    variaveis_b <- paste("top=",limit,sep="")
    k = paste(variables,collapse = ",")
    variaveis_c <- paste("Indicador,Data,DataReferencia", k, sep = ",")
    
    if(missing(start) & missing(end)){
        timespan <- ""
    }else if(missing(start) & !missing(end)){
        timespan <- paste0("%20and%20Data%20gt%20'", start,"'")
    }else if(!missing(start) & !missing(end)){
        timespan <- paste0("%20and%20Data%20gt%20'", start, "'%20and%20", "Data%20lt%20'", end,"'")
    }else{
        timespan <- paste0("%20and%20Data%20lt%20'", end,"'")  
    }
    
    
    baseurl <- "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/"
    query_url <- paste(baseurl, "ExpectativaMercadoMensais", "?$",variaveis_b,"&$",variaveis_a,timespan,
                       "&$select=",variaveis_c, sep = "", collapse = "")
    
    data <- fromJSON(file = query_url)$value
    data <- do.call("rbind", lapply(data, as.data.frame))
    
    # data$Data = as.Date(data$Data)
    # data$DataReferencia = as.Date(as.character(data$DataReferencia),format = "%m/%Y")
    # data = data %>% arrange(Data)
    # data = data %>% arrange(DataReferencia)
    # f = as.character(unique(data$DataReferencia))
    # f = (f[(str_detect(f,"2019"))])
    # 
    # if(trat){
    #     df =    setNames(data.frame(matrix(ncol = length(f),nrow = 1 )),f)
    # }
    
    return(data)
}





















































