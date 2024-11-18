library(shiny)
library(promises)
library(future)
library(DT)
library(shinyWidgets)

plan(multisession)  # 使用多线程计划

ui <- fluidPage(
  actionButton("start", "开始任务"),
  shinyWidgets::progressBar(id = "progress", value = 0, display_pct = TRUE),
  DTOutput("table1"),
  DTOutput("table2")
)

server <- function(input, output, session) {
  observeEvent(input$start, {
    # 初始化进度条
    updateProgressBar(session, id = "progress", value = 0)
    
    future({
      Sys.sleep(5)  # 模拟长时间计算 1
      data1 <- data.frame(A = 1:5, B = runif(5))
      return(list(progress = 30, data = data1))
    }, seed = TRUE) %...>% 
      (function(result1) {
        # 进度更新放在主线程
        updateProgressBar(session, id = "progress", value = result1$progress)
        output$table1 <- renderDT(result1$data)
        saveRDS(result1$data, file.path(tempdir(), "table1.rds"))
        
        future({
          Sys.sleep(5)  # 模拟长时间计算 2
          data2 <- data.frame(C = letters[1:5], D = runif(5))
          return(list(progress = 100, data = data2))
        }, seed = TRUE)
      }) %...>% 
      (function(result2) {
        # 更新最终进度
        updateProgressBar(session, id = "progress", value = result2$progress)
        output$table2 <- renderDT(result2$data)
        saveRDS(result2$data, file.path(tempdir(), "table2.rds"))
      })
  })
}

shinyApp(ui, server)
