#' @title change the compound name to refmet name
#' @description if the compound name can not be changed to kegg id, then the compound name is changed to refmet id
#' @param metabolites_name the compound name need to changed to refmet name
#'
#' @return test
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr rename select mutate filter 
#' @importFrom jsonlite fromJSON
#' @importFrom utils download.file
#' @importFrom tidyselect everything
#' @export
#'
#' @examples
#' compound_name <- c("2-Hydroxybutyric acid","1-Methyladenosine","tt","2-Aminooctanoic acid")
#' name2refmet(compound_name)
#'
name2refmet <- function(metabolites_name) {
  # `Input name` <- NULL
  #数据库中已经有的代谢物名称
  #  standardized_1 <- refmet_database
  #    dplyr::filter(`Input name` %in% metabolites_name)
  
  #数据库中没有的代谢物名称
  metabolites_to_standardized <- metabolites_name
  
  #[which(!metabolites_name %in% refmet_database$`Input name`)]
  
  metabolites_to_standardized_temp <- gsub(" |[)]|[(]|[/]|[?]", "", metabolites_to_standardized)
  
  if (length(metabolites_to_standardized_temp) != 0) {
    standardized_2 <- data.frame()
    
    for (i in seq(1, length(metabolites_to_standardized_temp))) {
      name = metabolites_to_standardized_temp[i]
      name1 = metabolites_to_standardized[i]
      
      if (length(grep("AC$", name1)) > 0 &
          length(grep("^C", name1)) > 0) {
        name1_new <- gsub("^C", "CAR+", name1)
        name <- gsub(" AC$", "", name1_new)
      }
      
      if (length(grep(",OH FA$", name1)) > 0 &
          length(grep("^C", name1)) > 0) {
        name = gsub(",OH FA$", "-OH", name1)
      }
      
      if (length(grep(" FA$", name1)) > 0 &
          length(grep("^C", name1)) > 0 & length(grep("OH", name1)) == 0) {
        name_temp = gsub(" FA$", ")", name1)
        name = gsub("^C", "FA(", name_temp)
      }
      
      if (name1 == "C14:0,DC FA") {
        name = "Tetradecanedioicacid"
      }
      
      url <- paste(
        "https://www.metabolomicsworkbench.org/rest/refmet/match/",
        name,
        "/name/json",
        sep = ""
      )
      
      ref <- paste("test.data.", i, sep = "")
      file.remove(ref)
      if (file.access(ref)) {
        utils::download.file(url, ref)
      }
      aa <- jsonlite::fromJSON(ref)
      
      if (length(aa) == 0) {
        aa <- data.frame(
          refmet_name = NA,
          formula = NA,
          exactmass = NA,
          super_class = NA,
          main_class = NA,
          sub_class = NA,
          class_index = NA
        )
      } else if ("Row1" %in% names(aa)) {
        aa <- as.data.frame(aa$Row1)
        if (!"refmet_name" %in% names(aa)) {
          aa$refmet_name = NA
        } else if (!"formula" %in% names(aa)) {
          aa$formula = NA
        } else if (!"exactmass" %in% names(aa)) {
          aa$exactmass = NA
        } else if (!"super_class" %in% names(aa)) {
          aa$super_class = NA
        } else if (!"main_class" %in% names(aa)) {
          aa$main_class = NA
        } else if (!"sub_class" %in% names(aa)) {
          aa$sub_class = NA
        } else if (!"class_index" %in% names(aa)) {
          aa$class_index = NA
        }
      } else{
        aa <- as.data.frame(aa)
        if (!"refmet_name" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(refmet_name = NA)
          #aa$refmet_name=NA
        }
        if (!"formula" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(formula = NA)
          #aa$formula=NA
        }
        if (!"exactmass" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(exactmass = NA)
          #aa$exactmass=NA
        }
        if (!"super_class" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(super_class = NA)
          #aa$super_class=NA
        }
        if (!"main_class" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(main_class = NA)
          #aa$main_class=NA
        }
        if (!"sub_class" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(sub_class = NA)
          #aa$sub_class=NA
        }
        if (!"class_index" %in% names(aa)) {
          aa <- aa %>%
            dplyr::mutate(class_index = NA)
          #aa$class_index=NA
        }
      }
      aa <- aa %>%
        dplyr::mutate(`Input name` = name1)
      #aa$`Input name` <- name1
      
      if (!is.na(aa$refmet_name)) {
        if (aa$refmet_name == "CAR 4:0") {
          aa$refmet_name = "Butyrylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 2:0") {
          aa$refmet_name = "L-Acetylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 3:0") {
          aa$refmet_name = "Propionylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 5:0") {
          aa$refmet_name = "Valerylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 6:0") {
          aa$refmet_name = "Hexanoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 8:0") {
          aa$refmet_name = "Octanoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 8:1") {
          aa$refmet_name = "Octenoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 10:0") {
          aa$refmet_name = "Decanoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 10:1") {
          aa$refmet_name = "Decenoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 10:2") {
          aa$refmet_name = "Decadienylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 10:3") {
          aa$refmet_name = "Decatrienoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 11:0") {
          aa$refmet_name = "Dimethylnonanoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 12:0") {
          aa$refmet_name = "Dodecanoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 12:1") {
          aa$refmet_name = "Dodecenoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 14:1") {
          aa$refmet_name = "Tetradecenoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 14:2") {
          aa$refmet_name = "Tetradecadienylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 16:0") {
          aa$refmet_name = "Palmitoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 16:0;OH") {
          aa$refmet_name = "Hydroxyhexadecanoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 18:0") {
          aa$refmet_name = "Stearoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 18:1") {
          aa$refmet_name = "Oleylcarnitine"
        }
        
        if (aa$refmet_name == "CAR 18:2") {
          aa$refmet_name = "Linoleoylcarnitine"
        }
        
        if (aa$refmet_name == "CAR DC5:0") {
          aa$refmet_name = "Glutarylcarnitine"
        }
        
        if (aa$refmet_name == "CAR DC5:0;3Me") {
          aa$refmet_name = "3-Methylglutarylcarnitine"
        }
        
      }
      
      if (length(grep("^LPC ", aa$refmet_name)) > 0) {
        aa$refmet_name = aa$`Input name`
      }
      
      if (length(grep("^LPE ", aa$refmet_name)) > 0) {
        aa$refmet_name = aa$`Input name`
      }
      
      if (length(grep("^LPI ", aa$refmet_name)) > 0) {
        aa$refmet_name = aa$`Input name`
      }
      
      if (length(grep("^MG ", aa$refmet_name)) > 0) {
        temp1 = gsub("^MG ", "MG(", aa$refmet_name)
        temp2 = gsub("$", ")", temp1)
        aa$refmet_name = temp2
      }
      
      if ("refmet_id" %in% names(aa)) {
        aa <- aa %>% dplyr::select(-.data$refmet_id)
      }
      if ("refmet_id" %in% names(standardized_2)) {
        standardized_2 <- standardized_2 %in% dplyr::select(-.data$refmet_id)
      }
      
      standardized_2 <- rbind(standardized_2, aa)
      file.remove(ref)
    }
    result <- standardized_2
  } else {
    result <- NULL
  }
  result[which(is.na(result$refmet_name)), 2] <- result[which(is.na(result$refmet_name)), 1]
  result[which(result$refmet_name == "-"), "refmet_name"] <- result[which(result$refmet_name ==
                                                                            "-"), "Input name"]
  
  result <- result %>%
    dplyr::select(-.data$class_index, -.data$exactmass) %>%
    dplyr::select(.data$`Input name`, everything()) %>%
    dplyr::rename("Input_name" = "Input name") %>%
    dplyr::rename("Refmet_name" = "refmet_name") %>%
    dplyr::rename("Formula" = "formula") %>%
    dplyr::rename("Super_class" = "super_class") %>%
    dplyr::rename("Main_class" = "main_class") %>%
    dplyr::rename("Sub_class" = "sub_class")
  
  return(result)
}
