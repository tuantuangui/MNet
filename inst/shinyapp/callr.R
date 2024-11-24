library(shiny)
library(callr)
library(DT)
library(shinyWidgets)

ui <- fluidPage(
  actionButton("start", "开始任务"),
  numericInput("num1", "参数 1:", value = 5, min = 1, max = 10),
  numericInput("num2", "参数 2:", value = 10, min = 1, max = 20),
  fileInput("file_meta", "上传 Meta 数据文件", accept = ".txt"),
  fileInput("file_gene", "上传 Gene 数据文件", accept = ".txt"),
  fileInput("file_group", "上传 Group 数据文件", accept = ".txt"),
  shinyWidgets::progressBar(id = "progress", value = 0, display_pct = TRUE),
  verbatimTextOutput("analysis_status"),
  DTOutput("table1"),
  DTOutput("table2")
)

server <- function(input, output, session) {
  # 状态存储
  status <- reactiveVal("等待任务开始...")
  
  # 定期更新 UI
  output$analysis_status <- renderText({ status() })
  
  observeEvent(input$start, {
    updateProgressBar(session, id = "progress", value = 0)
    status("正在启动任务 1...")
    
    num1 <- input$num1
    num2 <- input$num2
    req(input$file_meta, input$file_gene, input$file_group)
    
    meta_data <- read.table(input$file_meta$datapath, header = TRUE, sep = "\t")
    gene_data <- read.table(input$file_gene$datapath, header = TRUE, sep = "\t")
    group_data <- read.table(input$file_group$datapath, header = TRUE, sep = "\t")
    
    task1 <- r_bg(function(meta_data, gene_data, group_data, num1, num2) {
      Sys.sleep(5)
      meta_data <- data.frame(A = 1:5, B = runif(5) * num1)
      gene_data <- data.frame(C = 1:5, D = runif(5) * num2)
      group_data <- data.frame(E = 1:5, F = runif(5))
      list(meta_data = meta_data, gene_data = gene_data, group_data = group_data)
    }, supervise = TRUE, args = list(meta_data = meta_data, 
                                     gene_data = gene_data, 
                                     group_data = group_data, 
                                     num1 = num1, 
                                     num2 = num2))
    
    observeEvent(task1$wait(), {
      results <- task1$get_result()
      meta_data <- results$meta_data
      gene_data <- results$gene_data
      group_data <- results$group_data
      
      updateProgressBar(session, id = "progress", value = 30)
      status("任务 1 完成！正在启动任务 2...")
      output$table1 <- renderDT(meta_data)
      saveRDS(meta_data, file.path(tempdir(), "table1.rds"))
      
      task2 <- r_bg(function(meta_data, gene_data, group_data) {
        Sys.sleep(5)
        combined_data <- cbind(meta_data, gene_data, group_data)
        data.frame(Combined = apply(combined_data, 1, sum))
      }, supervise = TRUE, args = list(meta_data = meta_data,
                                       gene_data = gene_data,
                                       group_data = group_data))
      
      observeEvent(task2$wait(), {
        data2 <- task2$get_result()
        updateProgressBar(session, id = "progress", value = 100)
        status("任务 2 完成！分析已全部结束。")
        output$table2 <- renderDT(data2)
        saveRDS(data2, file.path(tempdir(), "table2.rds"))
      })
    })
  })
}

shinyApp(ui, server)
