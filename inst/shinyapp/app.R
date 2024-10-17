## output
library(BiocManager)
library(dplyr)
library(ggplot2)
library(pathview)
r=BiocManager::repositories()
#getOption("repos")[["CRAN"]] = "http://cran.r-project.org"
r[6] <- "http://cran.r-project.org"
options(repos =r)


#remotes::install_github("tuantuangui/MNet")
#if (!requireNamespace("MNet")) {
#  pacman::p_load(remotes)
#  tryCatch(
#    remotes::install_github("tuantuangui/MNet"),
#  )
#}

pacman::p_load(
  shiny,
  ggplot2,
  dplyr,
  MNet
)

library(shinythemes)
library(shiny)
#library(bslib)
#' @import shiny
#my_path <- "/Users/guituantuan/Desktop/R_packages/MNet_shiny"
#addResourcePath("new_root", my_path)
addResourcePath("new_root","./")
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage(
    #"MNet",
    #id = "navbar",
    #theme="bootstrap.css",
    title = div(
      img(src = "new_root/www/MNet_logo.png",
          filetype = "image/png",
          height = 30)
   #   "MNet"
    ),
   # mainPanel(h1("test")),
  # tabPanel(
  #   title="MNet",
  #   sidebarLayout(
      # sidebarPanel(),
  #     mainPanel(h1("test"))
  #   )
  # ),

    ## Group-wise #####
    tabPanel(
      title="Group-wise",
      # tags$style('.form-group{margin-bottom: 0px;}'),
      sidebarLayout(
        sidebarPanel(
          tabsetPanel(
            id = "data",
            tabPanel(
              title = "Group-wise analysis",
              titlePanel(title = "Group-wise analysis"),
              helpText("group wise analysis"),
              # tags$hr(),
              fileInput("data", "Choose the metabolite data to upload: the row is the metabolite, and the column is the sample",
                        multiple = FALSE,
                        accept = c(".rds")),
              fileInput('group','Choose the group data to upload',
                        accept = c(
                          'text/csv',
                          'text/comma-separated-values',
                          '.csv',
                          '.rds')),
              # tags$hr(),
              titlePanel(title = "method"),
              selectInput(inputId = "differential_method",
                          label = "the method used to analysis differential metabolites",
                          choices = c("mlimma", "DM"),
                          selected = "mlimma",
                          width = "300px"
              ),
            ),
          ),
          actionButton(inputId = "submit_group", label = "Submit")
        ),
        mainPanel(
          width = 5,
          plotOutput("plot_pca"),
          downloadButton("downloadplot_pca","Download the plot"),
          tags$br(),
          tags$hr(),
          dataTableOutput("table_diff"),
          downloadButton("downloadtable_diff","Download the table")
        )
      )
    ),
    tabPanel(
      title="ID convert",
      sidebarLayout(
        sidebarPanel(
          tabsetPanel(
            id = "data",
            tabPanel(
              title = "ID convert",
              titlePanel(title = "ID convert"),
              # tags$hr(),
              textAreaInput("metabolite_name_list",
                            label = "Please input metabolite name, one per line",
                            height = "200px",
                            width="180px",
                            value="ATP"),
              #  textInput("metabolite", "metabolit name change","ATP\naa"),
              # tags$hr(),
              titlePanel(title = "convert to"),
              selectInput(inputId = "changeid_method",
                          label = "which id changed the metabolite name to",
                          choices = c("keggid", "refmetid","keggpathway"),
                          selected = "keggid",
                          width = "300px"
              ),
            ),
          ),
          actionButton(inputId = "submit_metabolite", label = "Submit")
        ),
        mainPanel(
          helpText("Note: After submit it may take 1-2 minutes. "),
          # tags$hr(),
          # textOutput("metabolite_name_info"),
          tags$hr(),
          DT::dataTableOutput(outputId = "metabolite_name_info_table"),
          tags$br(),
          tags$hr(),
          # dataTableOutput("metabolite_name_info"),
          downloadButton("downloadtable_name","Download the name")
        )
      )
    ),
    tabPanel(
      title="Network",
      # tags$style('.form-group{margin-bottom: 0px;}'),
      sidebarLayout(
        sidebarPanel(
          tabsetPanel(
            id = "data",
            tabPanel(
              title = "Network analysis",
              titlePanel(title = "Network analysis"),
              # tags$hr(),
              fileInput("diff_metabolite", "Choose the differential metabolite data to upload",
                        multiple = FALSE,
                        accept = c(".rds")),
              fileInput('diff_gene','Choose the differential gene data to upload',
                        accept = c(
                          'text/csv',
                          'text/comma-separated-values',
                          '.csv',
                          '.rds')),
            ),
          ),
          actionButton(inputId = "submit_network", label = "Submit")
        ),
        mainPanel(
          plotOutput("plot_network"),
          downloadButton("downloadplot_network","Download the plot")
        )
      )
    ),
    tabPanel(
      title="Pathway analysis",
      # tags$style('.form-group{margin-bottom: 0px;}'),
      sidebarLayout(
        sidebarPanel(
          tabsetPanel(
            id = "data",
            tabPanel(
              title = "Pathway analysis",
              titlePanel(title = "Pathway analysis"),
              # tags$hr(),
              fileInput("diff_metabolite1", "Choose the differential metabolite data to upload",
                        multiple = FALSE,
                        accept = c(".rds")),
              fileInput('diff_gene1','Choose the differential gene data to upload',
                        accept = c(
                          'text/csv',
                          'text/comma-separated-values',
                          '.csv',
                          '.rds')),
              textAreaInput("hsaid",
                            label = "Please input the kegg pathwayid, one per line",
                            height = "200px",
                            width="180px",
                            value="hsa00020")
            ),
          ),
          actionButton(inputId = "submit_pathway", label = "Submit")
        ),
        mainPanel(
          width = 5,
          plotOutput("plot_DAscore"),
          downloadButton("downloadplot_DAscore","Download the DAscore"),
          tags$br(),
          tags$hr(),
          plotOutput("plot_PAscore"),
          downloadButton("downloadplot_PAscore","Download the PAscore"),
          tags$br(),
          tags$hr(),
          plotOutput("plot_pathview"),
          downloadButton("downloadplot_pathview","Download the pathview")
        )
      )
    ),
    navbarMenu(
      title="Clinical analysis",
      tabPanel(
        "Time series analysis of clinical index",
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              id = "data",
              tabPanel(
                title = "Clinical of time series",
                titlePanel(title = "Clinical of time series"),
                # tags$hr(),
                fileInput("clinical_index", "Choose the clinical of time series data to upload",
                          multiple = FALSE,
                          accept = c(".rds")),
              ),
            ),
            actionButton(inputId = "submit_ClinicalIndex", label = "Submit")
          ),
          mainPanel(
            width = 5,
            plotOutput("plot_ClinicalIndex"),
            downloadButton("downloadplot_ClinicalIndex","Download the ClinicalIndex")
          )
        )
      ),
      tabPanel(
        title="Survival analysis",
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              id = "data",
              tabPanel(
                title = "Survival analysis",
                titlePanel(title = "Survival analysis"),
                # tags$hr(),
                fileInput("clinical_surv", "Choose the survival data to upload",
                          multiple = FALSE,
                          accept = c(".rds")),
              ),
            ),
            actionButton(inputId = "submit_survival", label = "Submit")
          ),
          mainPanel(
            width = 5,
            plotOutput("plot_Survival"),
            downloadButton("downloadplot_Survival","Download the Survival")
          )
        )
      ),
      tabPanel(
        title="Metabolites'survival analysis",
        sidebarLayout(
          sidebarPanel(
            tabsetPanel(
              id = "data",
              tabPanel(
                title = "Metabolits' survival analysis",
                titlePanel(title = "Metabolits' survival analysis"),
                # tags$hr(),
                fileInput("clinical_dat", "Choose the survival data to upload",
                          multiple = FALSE,
                          accept = c(".rds")),
              ),
            ),
            actionButton(inputId = "submit_SurvMetabolite", label = "Submit")
          ),
          mainPanel(
            width = 5,
            plotOutput("plot_SurvivalMeta"),
            downloadButton("downloadplot_SurvivalMeta","Download the SurvivalMeta")
          )
        )
      )
    )
  )
)

#' @importFrom data.table fread
server <- function(input, output, session){

  observeEvent(input$submit_ClinicalIndex,{
    withProgress(message = "Steps:",value = 0,{
      incProgress(1/7,detail = paste0("Waitting","1"))
      if(!is.null(input$clinical_index)){
        infile <- readRDS(input$clinical_index$datapath)
      }

      p_time_series <- pCliTS(clinical_index)

      output$plot_ClinicalIndex <- renderPlot({
        ggsave("time_series.pdf",p_time_series)
        p_time_series
      })

      output$downloadplot_ClinicalIndex <- downloadHandler(
        filename = function() {
          paste0("time_series.pdf")
        },
        content = function(file) {
          file.copy("time_series.pdf",file)
        }
      )
    })
  })


  ## survival
  observeEvent(input$submit_survival,{
    withProgress(message = "Steps:",value = 0,{
      incProgress(1/7,detail = paste0("Waitting","1"))
      if(!is.null(input$clinical_surv)){
        infile <- readRDS(input$clinical_surv$datapath)
      }

      p_survival = survCli(infile)
      ggsave("survival.pdf",p_survival$plot)

      output$plot_Survival <- renderPlot({
        p_survival$plot

      })

      output$downloadplot_Survival <- downloadHandler(
        filename = function() {
          paste0("survival.pdf")
        },
        content = function(file) {
          file.copy("survival.pdf",file)
        }
      )
    })
  })

  #### metabolites' survival
  observeEvent(input$submit_SurvMetabolite,{
    withProgress(message = "Steps:",value = 0,{
      incProgress(1/7,detail = paste0("Waitting","1"))
      if(!is.null(input$clinical_dat)){
        infile <- readRDS(input$clinical_dat$datapath)
      }

      metabolite <- "C03819"
      survMet(infile,metabolite,cluster_method="mean",out_dir="./")

      output$plot_SurvivalMeta <- renderImage({
        filename <- paste0(metabolite,".survival.png")
        list(src=filename)
      }, deleteFile = FALSE)

      output$downloadplot_SurvivalMeta <- downloadHandler(
        filename = function() {
          paste0(metabolite,".survival.png")
        },
        content = function(file) {
          file.copy(paste0(metabolite,".survival.png"),file)
        }
      )
    })
  })


  observeEvent(input$submit_pathway,{
    withProgress(message = "Steps:",value = 0,{
      incProgress(1/7,detail = paste0("Waitting","1"))
      if(!is.null(input$diff_metabolite1) & !is.null(input$diff_gene1)){
        diff_meta <- readRDS(input$diff_metabolite1$datapath)
        diff_gene <- readRDS(input$diff_gene1$datapath)
        diff_gene_increase <-  diff_gene %>%
          dplyr::filter(logFC>0.58) %>%
          dplyr::filter(adj.P.Val < 0.05)
        diff_gene_decrease <- diff_gene %>%
          dplyr::filter(logFC < -0.58) %>%
          dplyr::filter(adj.P.Val < 0.05)

        diff_meta_increase <- diff_meta %>%
          dplyr::filter(logFC>0.58) %>%
          dplyr::filter(adj.P.Val < 0.05)

        diff_meta_decrease <- diff_meta %>%
          dplyr::filter(logFC < -0.58) %>%
          dplyr::filter(adj.P.Val < 0.05)

        all_dat <- rbind(diff_gene,diff_meta) %>%
          dplyr::filter(logFC>0.58) %>%
          dplyr::filter(adj.P.Val < 0.05)

        result_PA <- PathwayAnalysis(all_dat$name,out="Extended",p_cutoff=0.01)
        p_PA <- result_PA$p_barplot

        DAscore_result <- DAscore(c(diff_gene_increase$name,diff_meta_increase$name),c(diff_gene_decrease$name,diff_meta_decrease$name),c(diff_gene$name,diff_meta$name),min_measured_num = 2,out="Extended")
        p_DA <- DAscore_result$p
        #result <- DAscore_result$result

        diff_metabolite <- rbind(diff_meta_decrease,diff_meta_increase)
        diff_gene1 <- rbind(diff_gene_decrease,diff_gene_increase)

        cpd.data <- diff_metabolite$logFC
        names(cpd.data) <- diff_metabolite$name
        gene.data <- diff_gene1$logFC
        names(gene.data) <- diff_gene1$name

        df<-as.data.frame(matrix(unlist(stringr::str_split(input$hsaid,"\n")),ncol=1))
        hsaid_input <- df$V1
        pPathview(cpd.data=cpd.data,gene.data=gene.data,hsaid=hsaid_input,outdir="./")

      }

      output$plot_DAscore <- renderPlot({
        #  message.time("group-wise analysis")
        #p <- cowplot::plot_grid(plotlist = list(p_pca$p1,p_pca$p2,p_pca$p3),nrow=1)
        ggsave("DAscore.pdf",p_DA,width=10,height = 8)
        p_DA
      }, height = 200, width = 800)

      output$downloadplot_DAscore <- downloadHandler(
        filename = function() {
          paste0("DAscore.pdf")
        },
        content = function(file) {
          file.copy("DAscore.pdf",file)
        }
      )

      output$plot_PAscore <- renderPlot({
        ggsave("PAscore.pdf",p_PA,width=15,height = 8)
        p_PA
      },height=400,width=800)

      output$downloadplot_PAscore <- downloadHandler(
        filename = function() {
          paste0("PAscore.pdf")
        },
        content = function(file) {
          file.copy("PAscore.pdf",file)
        }
      )

      hsaid_input <- input$hsaid

      output$plot_pathview <- renderImage({
        filename <- paste0(hsaid_input,".pathview.gene.metabolite.png")
        list(src=filename)
      }, deleteFile = FALSE)

      output$downloadplot_pathview <- downloadHandler(
        filename = function() {
          paste0(paste0(hsaid_input,".pathview.gene.metabolite.png"))
        },
        content = function(file) {
          file.copy(paste0(hsaid_input,".pathview.gene.metabolite.png"),file)
        }
      )

    })
  })

  observeEvent(input$submit_network,{
    withProgress(message = "Steps:",value = 0,{
      incProgress(1/7,detail = paste0("Waitting","1"))
      if(!is.null(input$diff_metabolite) & !is.null(input$diff_gene)){
        infile1 <- readRDS(input$diff_metabolite$datapath)
        infile2 <- readRDS(input$diff_gene$datapath)
       # updateProgress(value = 40, detail = "Compute Subcluster")
        # hemato.subc <- CreateSubclusterObject(object = object, n.core = 1)
       # updateProgress(value = 80, detail = "Create Subcluster Object")
      }
      png("network.png",width = 10, height = 8,units = 'in', res =80)
      a <- pdnet(infile1,infile2,nsize=100)
      dev.off()

     # test <- pdftools::pdf_render_page("network.pdf", page = 1, dpi = 300)
    #  png::writePNG(test, "network.png")

      output$plot_network <- renderImage({
        filename <- "network.png"
        list(src=filename)
      }, deleteFile = FALSE)
    })
  })

  #message.time("Start App!")
  observeEvent(input$submit_metabolite,{
    withProgress(message = "Steps:",value = 0,{
      incProgress(1/7,detail = paste0("Waitting","1"))
      text_area_input <- input$metabolite_name_list
      df<-as.data.frame(matrix(unlist(stringr::str_split(text_area_input,"\n")),ncol=1))
      print(df)
      print(class(df))
      if (input$`changeid_method` == "keggid") {
        name_out = name2keggid(df$V1)
      }else if (input$`changeid_method` == "refmetid") {
        name_out = name2refmet(df$V1)
      }else if (input$`changeid_method` == "keggpathway") {
        temp = name2pathway(df$V1)
        name_out = temp$name2pathway
      }
      print(class(text_area_input))
      print(text_area_input)
      incProgress(2/7,detail = paste0("Waitting","2"))

      output$metabolite_name_info_table<-DT::renderDataTable({
        DT::datatable(name_out)
      })
      output$downloadtable_name <- downloadHandler(
        filename = function() {
          paste("metabolite-", input$changeid_method, ".csv", sep="")
        },
        content = function(file) {
          write.csv(name_out, file,row.names=F,quote=F)
        }
      )
      print("bb")
    })
  })

  ## scRNA ######
  observeEvent(input$submit_group, {
    progress <- shiny::Progress$new()
    progress$set(message = "Start", value = 0)
    on.exit(progress$close())
    updateProgress <- function(value = NULL, detail = NULL) {
      if (is.null(value)) {
        value <- progress$getValue()
        value <- value + (progress$getMax() - value) / 5
      }
      progress$set(value = value, detail = detail)
    }

    updateProgress(value = 10, detail = "Read data")
    object <- NULL
    if(!is.null(input$data) & !is.null(input$group)){
      infile1 <- readRDS(input$data$datapath)
      infile2 <- readRDS(input$group$datapath)
      updateProgress(value = 40, detail = "Compute Subcluster")
      # hemato.subc <- CreateSubclusterObject(object = object, n.core = 1)
      updateProgress(value = 80, detail = "Create Subcluster Object")
    }

    output$plot_pca <- renderPlot({
      #  message.time("group-wise analysis")
      p_pca <- pPCA(infile1,infile2)
      p <- cowplot::plot_grid(plotlist = list(p_pca$p1,p_pca$p2,p_pca$p3),nrow=1)
      ggsave("PCA.pdf",p,width=15,height = 5)
      p
    }, height = 300, width = 800)

   output$downloadplot_pca <- downloadHandler(
     filename=function(){
       "PCA.pdf"
     },
     content = function(file) {
       file.copy("PCA.pdf",file)
     }
   )

    #message.time("Plot Circle.Tree")
    if (input$`differential_method`=="mlimma") {
      diff_result <- mlimma(infile1,infile2)

      diff_result_filter <- diff_result %>%
        dplyr::filter(logFC >0.37 | logFC < -0.37) %>%
        dplyr::filter(adj.P.Val<0.1)

    }else if (input$`differential_method`=="DM") {
      diff_result <- DM(2**infile1,infile2)
      diff_result_filter <- diff_result %>%
        dplyr::filter(Fold_change >1.2 | Fold_change < 1/1.2) %>%
        dplyr::filter(Padj_t<0.1)
    }

    output$table_diff <- renderDataTable({
      diff_result
    })

    output$downloadtable_diff <- downloadHandler(
      filename = function() {
        "diff_info.csv"
      },
      content = function(file) {
        write.csv(diff_result, file,row.names=F,quote=F)
      }
    )
  })
}
shinyApp(ui = ui, server = server)


#runApp <- function(options = list()){
#  options(shiny.maxRequestSize=200*1024^2)
#  shinyApp(ui = ui, server = server, options = list())
#}
