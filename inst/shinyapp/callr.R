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
  DTOutput("table1"),
  DTOutput("table2")
)

server <- function(input, output, session) {
  # 使用 reactiveValues 来存储 task1 的多个结果
  task1_results <- reactiveValues(meta_data = NULL, gene_data = NULL, group_data = NULL)
  
  observeEvent(input$start, {
    updateProgressBar(session, id = "progress", value = 0)
    
    # 获取 input 组件的参数值
    num1 <- input$num1
    num2 <- input$num2
    
    # 检查文件上传
    req(input$file_meta, input$file_gene, input$file_group)
    
    # 读取上传的文件
    meta_data <- read.table(input$file_meta$datapath, header = TRUE, sep = "\t")
    gene_data <- read.table(input$file_gene$datapath, header = TRUE, sep = "\t")
    group_data <- read.table(input$file_group$datapath, header = TRUE, sep = "\t")
    
    # 第一个计算任务
    task1 <- r_bg(function(meta_data, gene_data, group_data, num1, num2) {
      Sys.sleep(5)  # 模拟长时间计算 1
      meta_data <- data.frame(A = 1:5, B = runif(5) * num1)  # 使用 num1 参数
      gene_data <- data.frame(C = 1:5, D = runif(5) * num2)  # 使用 num2 参数
      group_data <- data.frame(E = 1:5, F = runif(5))
      list(meta_data = meta_data, gene_data = gene_data, group_data = group_data)
    }, supervise = TRUE, args = list(meta_data = meta_data, 
                                     gene_data = gene_data, 
                                     group_data = group_data, 
                                     num1 = num1, 
                                     num2 = num2))  # 传递 input 参数
    
    observeEvent(task1$wait(), {
      task1_results$meta_data <- task1$get_result()$meta_data
      task1_results$gene_data <- task1$get_result()$gene_data
      task1_results$group_data <- task1$get_result()$group_data
      updateProgressBar(session, id = "progress", value = 30)
      output$table1 <- renderDT(task1_results$meta_data)
      saveRDS(task1_results$meta_data, file.path(tempdir(), "table1.rds"))
      
      # 第二个计算任务，传递 task1 的多个结果
      task2 <- r_bg(function(meta_data, gene_data, group_data) {
        Sys.sleep(5)  # 模拟长时间计算 2
        # 使用第一个任务的多个结果进行第二个任务的分析
        combined_data <- cbind(meta_data, gene_data, group_data)
        data.frame(Combined = apply(combined_data, 1, sum))  # 示例分析：行加和
      }, supervise = TRUE, args = list(meta_data = task1_results$meta_data,
                                       gene_data = task1_results$gene_data,
                                       group_data = task1_results$group_data))
      
      observeEvent(task2$wait(), {
        data2 <- task2$get_result()
        updateProgressBar(session, id = "progress", value = 100)
        output$table2 <- renderDT(data2)
        saveRDS(data2, file.path(tempdir(), "table2.rds"))
      })
    })
  })
}

shinyApp(ui, server)
