# -> Author:
# Author: benben-miao
# Email: benben.miao@outlook.com
# Github: https://github.com/benben-miao
# Date: 2024-10-21
# <- Author

options = list(warn = -1)
options(shiny.maxRequestSize = 100 * 1024 ^ 2)

library(shiny)
library(bs4Dash)
library(DT)
library(shinyWidgets)
library(colourpicker)
library(ggsci)
library(ggplot2)
library(MNet)
library(dplyr)
library(markdown)
library(Cairo)

log_file <- "user_access_log.txt"

if (!file.exists(log_file)) {
    write.table(
        data.frame(IP = character(), VisitTime = character()),
        log_file,
        sep = "\t",
        row.names = FALSE,
        col.names = TRUE
    )
}

ui <- shinyUI(
    #=== 1.bs4DashPage
    bs4DashPage(
        title = "MNet",
        skin = NULL,
        freshTheme = NULL,
        preloader = NULL,
        options = NULL,
        fullscreen = TRUE,
        help = TRUE,
        dark = FALSE,
        scrollToTop = TRUE,
        #=== 1.1 bs4DashNavbar
        {
            header = bs4DashNavbar(
                brand = span(
                    "| MNet for integrative analysis of metabolomic and transcriptomic data",
                    style = "margin-left: 10px;
                              color: #555555;
                              font-weight: bolder;
                              text-shadow: 3px 3px 10px #888888;"
                ),
                titleWidth = NULL,
                disable = FALSE,
                .list = NULL,
                # rightUi = bs4DropdownMenu(
                #     type = c("notifications"),
                #     badgeStatus = "primary",
                #     icon = icon("bell"),
                #     headerText = "Version Update:",
                #     href = "https://tuantuangui.github.io/MNet/index.html"
                # ),
                skin = "light",
                status = "white",
                border = TRUE,
                compact = FALSE,
                sidebarIcon = shiny::icon("bars"),
                fixed = FALSE
            )
        },
        #=== 1.2 bs4DashSidebar
        {
            sidebar = bs4DashSidebar(
                disable = FALSE,
                width = NULL,
                skin = "dark",
                status = "gray-dark",
                elevation = 3,
                collapsed = FALSE,
                minified = TRUE,
                expandOnHover = TRUE,
                fixed = TRUE,
                id = NULL,
                customArea = NULL,
                #=== 1.2.1.1 bs4SidebarUserPanel
                bs4SidebarUserPanel(name = strong("MNet"), image = "https://tuantuangui.github.io/MNet/logo.png"),
                #=== 1.2.1.2 bs4SidebarHeader
                # bs4SidebarHeader(title = strong("Function【4】")),
                # tags$div(verbatimTextOutput("stats")),
                actionButton(
                    inputId = "open_window",
                    label = "Manual",
                    icon = shiny::icon("book-open"),
                    width = "100%",
                    status = "warning",
                    gradient = FALSE,
                    outline = FALSE,
                    size = NULL,
                    flat = FALSE,
                    style = "margin: 0px;"
                ),
                hr(),
                tags$script(
                    '
                        Shiny.addCustomMessageHandler("openNewWindow", function(params) {
                            var newWindow = window.open(params.url, "_blank", "width=" + params.width + ",height=" + params.height);
                        });
                    '
                ),
                #=== 1.2.1 bs4SidebarMenu
                bs4SidebarMenu(
                    id = NULL,
                    .list = NULL,
                    flat = FALSE,
                    compact = FALSE,
                    childIndent = FALSE,
                    legacy = FALSE,
                    #=== 1.2.1.3 bs4SidebarMenuItem
                    bs4SidebarMenuItem(
                        text = "Home",
                        tabName = "home",
                        icon = icon("house"),
                        badgeLabel = "Intro",
                        badgeColor = "danger",
                        href = NULL,
                        newTab = TRUE,
                        selected = NULL,
                        expandedName = NULL,
                        startExpanded = FALSE,
                        condition = NULL
                    ),
                    bs4SidebarMenuItem(
                        text = "Knowledgebase",
                        tabName = "database",
                        icon = icon("database"),
                        badgeLabel = NULL,
                        badgeColor = "danger",
                        href = NULL,
                        newTab = TRUE,
                        selected = NULL,
                        expandedName = NULL,
                        startExpanded = FALSE,
                        condition = NULL
                    ),
                    br(),
                    # bs4SidebarMenuItem(
                    #     text = "1. Metabolite Analysis",
                    #     tabName = NULL,
                    #     icon = icon("atom"),
                    #     # badgeLabel = "6",
                    #     # badgeColor = "warning",
                    #     href = NULL,
                    #     newTab = TRUE,
                    #     selected = NULL,
                    #     expandedName = "samples_statistics",
                    #     startExpanded = TRUE,
                    #     condition = NULL,
                    #     bs4SidebarMenuSubItem(
                    #         text = "| Metabolite PCA",
                    #         tabName = "pca_plot",
                    #         href = NULL,
                    #         newTab = TRUE,
                    #         icon = icon("r-project"),
                    #         selected = NULL
                    #     ),
                    #     bs4SidebarMenuSubItem(
                    #         text = "| Metabolite Volcano",
                    #         tabName = "volcano_plot",
                    #         href = NULL,
                    #         newTab = TRUE,
                    #         icon = icon("r-project"),
                    #         selected = NULL
                    #     ),
                    #     bs4SidebarMenuSubItem(
                    #         text = "| Metabolite Heatmap",
                    #         tabName = "heatmap_plot",
                    #         href = NULL,
                    #         newTab = TRUE,
                    #         icon = icon("r-project"),
                    #         selected = NULL
                    #     )
                    # ),
                    bs4SidebarMenuItem(
                        text = "1. Metabolic Subnetwork",
                        tabName = NULL,
                        icon = icon("circle-nodes"),
                        # badgeLabel = "6",
                        # badgeColor = "warning",
                        href = NULL,
                        newTab = TRUE,
                        selected = NULL,
                        expandedName = "traits_analysis",
                        startExpanded = TRUE,
                        condition = NULL,
                        bs4SidebarMenuSubItem(
                            text = "| Met-Gene Subnetwork",
                            tabName = "network_plot",
                            href = NULL,
                            newTab = TRUE,
                            icon = icon("r-project"),
                            selected = NULL
                        )
                        # bs4SidebarMenuSubItem(
                        #     text = "| DiffExp Network",
                        #     tabName = "diff_network",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # ),
                        # bs4SidebarMenuSubItem(
                        #     text = "| Correlate Network",
                        #     tabName = "corr_network",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # )
                    ),
                    br(),
                    bs4SidebarMenuItem(
                        text = "2. Extended Pathway",
                        tabName = NULL,
                        icon = icon("dna"),
                        # badgeLabel = "6",
                        # badgeColor = "warning",
                        href = NULL,
                        newTab = TRUE,
                        selected = NULL,
                        expandedName = "defferential_expression",
                        startExpanded = TRUE,
                        condition = NULL,
                        bs4SidebarMenuSubItem(
                            text = "| ePEA Analysis",
                            tabName = "epea_plot",
                            href = NULL,
                            newTab = TRUE,
                            icon = icon("r-project"),
                            selected = NULL
                        ),
                        bs4SidebarMenuSubItem(
                            text = "| ePDA Ananysis",
                            tabName = "epda_plot",
                            href = NULL,
                            newTab = TRUE,
                            icon = icon("r-project"),
                            selected = NULL
                        ),
                        bs4SidebarMenuSubItem(
                            text = "| eSEA Analysis",
                            tabName = "esea_plot",
                            href = NULL,
                            newTab = TRUE,
                            icon = icon("r-project"),
                            selected = NULL
                        )
                        # bs4SidebarMenuSubItem(
                        #     text = "| mPEA Pathway",
                        #     tabName = "mpea_plot",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # ),
                        # bs4SidebarMenuSubItem(
                        #     text = "| gPEA Pathway",
                        #     tabName = "gpea_plot",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # )
                        # bs4SidebarMenuSubItem(
                        #     text = "| Volcano Plot",
                        #     tabName = "volcano_plot",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # ),
                        # bs4SidebarMenuSubItem(
                        #     text = "| MA Plot",
                        #     tabName = "ma_plot",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # ),
                        # bs4SidebarMenuSubItem(
                        #     text = "| Heatmap Group",
                        #     tabName = "heatmap_group",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # ),
                        # bs4SidebarMenuSubItem(
                        #     text = "| Circos Heatmap",
                        #     tabName = "circos_heatmap",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # ),
                        # bs4SidebarMenuSubItem(
                        #     text = "| Chord Plot",
                        #     tabName = "chord_plot",
                        #     href = NULL,
                        #     newTab = TRUE,
                        #     icon = icon("r-project"),
                        #     selected = NULL
                        # )
                    )
                    # bs4SidebarMenuItem(
                    #     text = "4. Clinical Analysis",
                    #     tabName = NULL,
                    #     icon = icon("stethoscope"),
                    #     # badgeLabel = "6",
                    #     # badgeColor = "warning",
                    #     href = NULL,
                    #     newTab = TRUE,
                    #     selected = NULL,
                    #     expandedName = "anvanced_analysis",
                    #     startExpanded = TRUE,
                    #     condition = NULL,
                    #     bs4SidebarMenuSubItem(
                    #         text = "| Gene Rank Plot",
                    #         tabName = "gene_rank_plot",
                    #         href = NULL,
                    #         newTab = TRUE,
                    #         icon = icon("r-project"),
                    #         selected = NULL
                    #     )
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Gene Cluster Trend",
                    #     #     tabName = "gene_cluster_trend",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Trend Plot",
                    #     #     tabName = "trend_plot",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Network Plot",
                    #     #     tabName = "network_plot",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Heatmap Cluster",
                    #     #     tabName = "heatmap_cluster",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # )
                    # ),
                    # bs4SidebarMenuItem(
                    #     text = "5. Feature Selection",
                    #     tabName = NULL,
                    #     icon = icon("square-root-variable"),
                    #     # badgeLabel = "6",
                    #     # badgeColor = "warning",
                    #     href = NULL,
                    #     newTab = TRUE,
                    #     selected = NULL,
                    #     expandedName = "go_and_kegg",
                    #     startExpanded = TRUE,
                    #     condition = NULL,
                    #     bs4SidebarMenuSubItem(
                    #         text = "| GO Enrich",
                    #         tabName = "go_enrich",
                    #         href = NULL,
                    #         newTab = TRUE,
                    #         icon = icon("r-project"),
                    #         selected = NULL
                    #     )
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| GO Enrich Stat",
                    #     #     tabName = "go_enrich_stat",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| GO Enrich Bar",
                    #     #     tabName = "go_enrich_bar",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| GO Enrich Dot",
                    #     #     tabName = "go_enrich_dot",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| GO Enrich Net",
                    #     #     tabName = "go_enrich_net",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| KEGG Enrich",
                    #     #     tabName = "kegg_enrich",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| KEGG Enrich Bar",
                    #     #     tabName = "kegg_enrich_bar",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| KEGG Enrich Dot",
                    #     #     tabName = "kegg_enrich_dot",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| KEGG Enrich Net",
                    #     #     tabName = "kegg_enrich_net",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # )
                    # ),
                    # bs4SidebarMenuItem(
                    #     text = "6. Metabolite Conversion",
                    #     tabName = NULL,
                    #     icon = icon("repeat"),
                    #     # badgeLabel = "6",
                    #     # badgeColor = "warning",
                    #     href = NULL,
                    #     newTab = TRUE,
                    #     selected = NULL,
                    #     expandedName = "tables_operations",
                    #     startExpanded = TRUE,
                    #     condition = NULL,
                    #     bs4SidebarMenuSubItem(
                    #         text = "| Table Split",
                    #         tabName = "table_split",
                    #         href = NULL,
                    #         newTab = TRUE,
                    #         icon = icon("r-project"),
                    #         selected = NULL
                    #     )
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Table Merge",
                    #     #     tabName = "table_merge",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Table Filter",
                    #     #     tabName = "table_filter",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # ),
                    #     # bs4SidebarMenuSubItem(
                    #     #     text = "| Table Cross",
                    #     #     tabName = "table_cross",
                    #     #     href = NULL,
                    #     #     newTab = TRUE,
                    #     #     icon = icon("r-project"),
                    #     #     selected = NULL
                    #     # )
                    # )
                    
                ),
                hr()
            )
        },
        #=== 1.3 bs4DashControlbar
        {
            controlbar = bs4DashControlbar(
                style = "padding: 10px;",
                id = NULL,
                disable = FALSE,
                width = 300,
                collapsed = TRUE,
                overlay = TRUE,
                skin = "light",
                pinned = FALSE,
                
                skinSelector()
                # sliderInput(
                #     inputId = "obs",
                #     label = "Number of observations:",
                #     min = 0,
                #     max = 1000,
                #     value = 500
                # )
            )
        },
        #=== 1.4 bs4DashFooter
        {
            # footer = bs4DashFooter(
            #     left = verbatimTextOutput("stats"),
            #     right = NULL,
            #     fixed = TRUE
            # )
        },
        #=== 1.5 bs4DashBody
        body = bs4DashBody(
            includeCSS("www/styles.css"),
            tags$head(tags$link(
                rel = "icon", type = "image/png", href = "favicon.png"
            )),
            #=== 1.5.1 bs4DashPage -> bs4DashBody -> bs4TabItems
            bs4TabItems(#=== 1.5.1.1 bs4DashPage home
                {
                    bs4TabItem(tabName = "home", fluidRow(
                        bs4Card(
                            # 1
                            style = "padding: 10px;",
                            inputId = NULL,
                            title = tags$b("MNet Documents"),
                            footer = NULL,
                            width = 12,
                            height = NULL,
                            status = "white",
                            elevation = 1,
                            solidHeader = FALSE,
                            headerBorder = FALSE,
                            gradient = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            maximizable = FALSE,
                            icon = icon("passport"),
                            boxToolSize = "lg",
                            label = NULL,
                            dropdownMenu = NULL,
                            sidebar = NULL,
                            # htmlOutput("home_markdown")
                            tags$iframe(
                                src = "https://tuantuangui.github.io/MNet/index.html",
                                width = "100%",
                                height = "840px",
                                style = "border: none; border-radius: 10px;"
                            )
                        )
                    ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "pca_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "pca_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "pca_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "pca_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "pca_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "pca_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "pca_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "pca_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "pca_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               textOutput("pca_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("pca_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "volcano_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "volcano_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "volcano_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "volcano_diff_method",
                                           label = "Diff Methods",
                                           choices = c("LIMMA" = "LIMMA", "OPLS-DA" = "OPLS-DA"),
                                           selected = "OPLS-DA",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "volcano_fold_change",
                                           label = "Fold Change",
                                           min = 0.00,
                                           max = 100.00,
                                           value = 1.50,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "volcano_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "volcano_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "volcano_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "volcano_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "volcano_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "volcano_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               textOutput("volcano_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("volcano_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "heatmap_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "heatmap_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "heatmap_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "heatmap_diff_method",
                                           label = "Diff Methods",
                                           choices = c("LIMMA" = "LIMMA", "OPLS-DA" = "OPLS-DA"),
                                           selected = "OPLS-DA",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "heatmap_fold_change",
                                           label = "Fold Change",
                                           min = 0.00,
                                           max = 100.00,
                                           value = 1.50,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "heatmap_padj_wilcox",
                                           label = "Padj Wilcox",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "heatmap_VIP",
                                           label = "OPLS-DA VIP",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.80,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "heatmap_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "heatmap_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "heatmap_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "heatmap_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "heatmap_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "heatmap_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               textOutput("heatmap_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("heatmap_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "network_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 2,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       br(),
                                       br(),
                                       tags$p("An example can be found in Demo, and click on ➕ to open it."),
                                       hr(),
                                       fileInput(
                                           inputId = "network_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "network_user_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "network_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       
                                       # h3("访问统计"),
                                       # verbatimTextOutput("stats"),
                                       # h3("最近的访问记录"),
                                       # tableOutput("log_table"),
                                       
                                       # actionButton(
                                       #     inputId = "network_demo",
                                       #     label = "Demo",
                                       #     icon = shiny::icon("person-running"),
                                       #     width = "100%",
                                       #     status = "info",
                                       #     gradient = FALSE,
                                       #     outline = FALSE,
                                       #     size = NULL,
                                       #     flat = FALSE
                                       # ),
                                       # br(),
                                       # br(),
                                       actionButton(
                                           inputId = "network_submit",
                                           label = "Submit",
                                           icon = shiny::icon("person-running"),
                                           width = "100%",
                                           status = "success",
                                           gradient = FALSE,
                                           outline = FALSE,
                                           size = NULL,
                                           flat = FALSE
                                       ),
                                       br(),
                                       br(),
                                       tags$b("2. ANALYSIS PARAMETERS:"),
                                       hr(),
                                       sliderInput(
                                           inputId = "network_nsize",
                                           label = "Nodes Num",
                                           min = 1,
                                           max = 1000,
                                           value = 100,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       tags$b("3. FIGURE CANVAS:"),
                                       hr(),
                                       selectInput(
                                           inputId = "network_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "network_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "network_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "network_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       )
                                   ),
                                   column(
                                       width = 10,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("Demo", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "warning",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_demo_meta_data_download",
                                                       label = "Metabolite Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "network_demo_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_demo_gene_data_download",
                                                       label = "Gene Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "network_demo_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_demo_group_data_download",
                                                       label = "Group Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("network_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Nodes Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_demo_nodes_data_download",
                                                       label = "Nodes Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Nodes Data**: Nodes of subnetworks.
                                                   "),
                                               hr(),
                                               DTOutput("network_demo_nodes_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Edges Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_demo_edges_data_download",
                                                       label = "Edges Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Edges Data**: Edges of subnetworks.
                                                   "),
                                               hr(),
                                               DTOutput("network_demo_edges_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Subnetwork Plot",
                                               markdown(
                                                   "
						                           A core metabolite-gene subnetwork can be downloaded as a PDF or JPEG file with specified width, height, and dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "http://www.mnet4all.com/mnet_manual/figure/subnetwork.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "Visualization of the identified optimal subnetwork that best explains the biological processes comparing two groups. The colors represent the logFC (logarithm of fold change) of genes, with red and green indicating different expression levels, while yellow and blue represent the logFC of metabolites, indicating varying levels."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "|",
                                           #     icon = NULL
                                           # ),
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "Manual",
                                           #     tags$iframe(
                                           #         src = "http://www.mnet4all.com/mnet_manual/",
                                           #         width = "100%",
                                           #         height = "720",
                                           #         frameborder = 0
                                           #     ),
                                           #     icon = shiny::icon("book-open")
                                           # )
                                       ),
                                       bs4TabCard(
                                           # ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("User", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "danger",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "network_user_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "network_user_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("network_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Nodes Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_user_nodes_data_download",
                                                       label = "Nodes Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Nodes Data**: Nodes of subnetworks.
                                                   "),
                                               hr(),
                                               DTOutput("network_user_nodes_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Edges Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_user_edges_data_download",
                                                       label = "Edges Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Edges Data**: Edges of subnetworks.
                                                   "),
                                               hr(),
                                               DTOutput("network_user_edges_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Subnetwork Plot",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_plot_download",
                                                       label = "Figure Download",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   A core metabolite-gene subnetwork can be downloaded as a PDF or JPEG file with specified width, height, and dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               imageOutput("network_plot", width = "100%", height = "auto"),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "Visualization of the identified optimal subnetwork that best explains the biological processes comparing two groups. The colors represent the logFC (logarithm of fold change) of genes, with red and green indicating different expression levels, while yellow and blue represent the logFC of metabolites, indicating varying levels."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                       )
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "diff_network", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "diff_network_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "diff_network_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "diff_network_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       hr(),
                                       sliderInput(
                                           inputId = "diff_network_padj",
                                           label = "Padjust Cutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "diff_network_logfc",
                                           label = "Log(FoldChange)",
                                           min = 0.00,
                                           max = 100.00,
                                           value = 1.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "diff_network_gene_num",
                                           label = "Gene Number",
                                           min = 0,
                                           max = 1000,
                                           value = 500,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "diff_network_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "diff_network_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "diff_network_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "diff_network_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "diff_network_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "diff_network_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "diff_network_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               textOutput("diff_network_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("diff_network_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "corr_network", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "corr_network_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "corr_network_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       hr(),
                                       sliderInput(
                                           inputId = "corr_network_threshold",
                                           label = "Padjust Cutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.95,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "corr_network_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "corr_network_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "corr_network_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "corr_network_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "corr_network_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "corr_network_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "corr_network_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("corr_network_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "epea_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 2,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       br(),
                                       br(),
                                       tags$p("An example can be found in Demo, and click on ➕ to open it."),
                                       hr(),
                                       fileInput(
                                           inputId = "epea_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "epea_user_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "epea_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       # actionButton(
                                       #     inputId = "epea_demo",
                                       #     label = "Demo",
                                       #     icon = shiny::icon("person-running"),
                                       #     width = "100%",
                                       #     status = "info",
                                       #     gradient = FALSE,
                                       #     outline = FALSE,
                                       #     size = NULL,
                                       #     flat = FALSE
                                       # ),
                                       # br(),
                                       # br(),
                                       actionButton(
                                           inputId = "epea_submit",
                                           label = "Submit",
                                           icon = shiny::icon("person-running"),
                                           width = "100%",
                                           status = "success",
                                           gradient = FALSE,
                                           outline = FALSE,
                                           size = NULL,
                                           flat = FALSE
                                       ),
                                       br(),
                                       br(),
                                       tags$b("2. ANALYSIS PARAMETERS:"),
                                       hr(),
                                       sliderInput(
                                           inputId = "epea_logfc",
                                           label = "Log(FoldChange)",
                                           min = 0.00,
                                           max = 10.00,
                                           value = 0.58,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epea_padj",
                                           label = "Padjust Cutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epea_p_cutoff",
                                           label = "Pathway Pcutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       tags$b("3. FIGURE CANVAS:"),
                                       hr(),
                                       selectInput(
                                           inputId = "epea_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "epea_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epea_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 12.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epea_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       )
                                   ),
                                   column(
                                       width = 10,
                                       # tags$script(
                                       #     '
                                       #          $(document).ready(function() {
                                       #              $("#myTabCard").addClass("collapsed");
                                       #              $(".tab-pane").click(function() {
                                       #                  var tabCard = $(this).closest(".card");
                                       #                  if (tabCard.hasClass("collapsed")) {
                                       #                      tabCard.removeClass("collapsed");
                                       #                  } else {
                                       #                      tabCard.addClass("collapsed");
                                       #                  }
                                       #              });
                                       #          });
                                       #      '
                                       # ),
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "myTabCard",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("Demo", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "warning",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_demo_meta_data_download",
                                                       label = "Metabolite Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epea_demo_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_demo_gene_data_download",
                                                       label = "Gene Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epea_demo_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_demo_group_data_download",
                                                       label = "Group Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("epea_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Up ePEA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_demo_up_data_download",
                                                       label = "Up ePEA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Up ePEA Terms**: Up-regulated pathways.
                                                   "),
                                               hr(),
                                               DTOutput("epea_demo_up_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Down ePEA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_demo_down_data_download",
                                                       label = "Down ePEA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Down ePEA Terms**: Down-regulated pathways.
                                                   "),
                                               hr(),
                                               DTOutput("epea_demo_down_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePEA Plot",
                                               markdown(
                                                   "
						                           Bar plot and dot plot illustrating enriched pathways are available, and can be downloaded as a PDF or JPEG file with specified width, height, and dpi settings.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "http://www.mnet4all.com/mnet_manual/figure/2.ePEA.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "Extended pathway enrichment analysis. (A) Barplot of up-regulated metabolic pathways corresponding to metabolites and genes. (B) Dotplot of up-regulated metabolic pathways corresponding to metabolites and genes. (C) Barplot of down-regulated metabolic pathways corresponding to metabolites and genes. (D) Dotplot of down-regulated metabolic pathways corresponding to metabolites and genes."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "|",
                                           #     icon = NULL
                                           # ),
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "Manual",
                                           #     tags$iframe(
                                           #         src = "http://www.mnet4all.com/mnet_manual/",
                                           #         width = "100%",
                                           #         height = "720",
                                           #         frameborder = 0
                                           #     ),
                                           #     icon = shiny::icon("book-open")
                                           # )
                                       ),
                                       bs4TabCard(
                                           # ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("User", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "danger",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epea_user_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epea_user_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("epea_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Up ePEA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_user_up_data_download",
                                                       label = "Up ePEA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Up ePEA Terms**: Up-regulated pathways.
                                                   "),
                                               hr(),
                                               DTOutput("epea_user_up_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Down ePEA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_user_down_data_download",
                                                       label = "Down ePEA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Down ePEA Terms**: Down-regulated pathways.
                                                   "),
                                               hr(),
                                               DTOutput("epea_user_down_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePEA Plot",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_plot_download",
                                                       label = "Figure Download",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   Bar plot and dot plot illustrating enriched pathways are available, and can be downloaded as a PDF or JPEG file with specified width, height, and dpi settings.
                                                   "
                                               ),
                                               hr(),
                                               imageOutput("epea_plot", width = "100%", height = "auto"),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "Extended pathway enrichment analysis. (A) Barplot of up-regulated metabolic pathways corresponding to metabolites and genes. (B) Dotplot of up-regulated metabolic pathways corresponding to metabolites and genes. (C) Barplot of down-regulated metabolic pathways corresponding to metabolites and genes. (D) Dotplot of down-regulated metabolic pathways corresponding to metabolites and genes."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                       )
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "epda_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 2,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       br(),
                                       br(),
                                       tags$p("An example can be found in Demo, and click on ➕ to open it."),
                                       hr(),
                                       fileInput(
                                           inputId = "epda_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "epda_user_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "epda_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       # actionButton(
                                       #     inputId = "epda_demo",
                                       #     label = "Demo",
                                       #     icon = shiny::icon("person-running"),
                                       #     width = "100%",
                                       #     status = "info",
                                       #     gradient = FALSE,
                                       #     outline = FALSE,
                                       #     size = NULL,
                                       #     flat = FALSE
                                       # ),
                                       # br(),
                                       # br(),
                                       actionButton(
                                           inputId = "epda_submit",
                                           label = "Submit",
                                           icon = shiny::icon("person-running"),
                                           width = "100%",
                                           status = "success",
                                           gradient = FALSE,
                                           outline = FALSE,
                                           size = NULL,
                                           flat = FALSE
                                       ),
                                       br(),
                                       br(),
                                       tags$b("2. ANALYSIS PARAMETERS:"),
                                       hr(),
                                       sliderInput(
                                           inputId = "epda_logfc",
                                           label = "Log(FoldChange)",
                                           min = 0.00,
                                           max = 10.00,
                                           value = 0.58,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epda_padj",
                                           label = "Padjust Cutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       tags$b("3. FIGURE CANVAS:"),
                                       hr(),
                                       selectInput(
                                           inputId = "epda_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "epda_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 12.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epda_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "epda_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       )
                                   ),
                                   column(
                                       width = 10,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("Demo", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "warning",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_demo_meta_data_download",
                                                       label = "Metabolite Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epda_demo_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_demo_gene_data_download",
                                                       label = "Gene Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epda_demo_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_demo_group_data_download",
                                                       label = "Group Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("epda_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePDA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_demo_result_data_download",
                                                       label = "ePDA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **ePDA Terms**: Result of ePDA analysis.
                                                   "),
                                               hr(),
                                               DTOutput("epda_demo_result_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePDA Plot",
                                               markdown(
                                                   "
						                           A DAscore plot captures the tendency for a pathway, and can be downloaded as a PDF or JPEG file with specified width, height, and dpi settings.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "http://www.mnet4all.com/mnet_manual/figure/2.ePDA.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "ePDA score captures the tendency for a pathway to exhibit increased or decreased levels of genes and metabolites that are statistically significant differences between two group."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "|",
                                           #     icon = NULL
                                           # ),
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "Manual",
                                           #     tags$iframe(
                                           #         src = "http://www.mnet4all.com/mnet_manual/",
                                           #         width = "100%",
                                           #         height = "720",
                                           #         frameborder = 0
                                           #     ),
                                           #     icon = shiny::icon("book-open")
                                           # )
                                       ),
                                       bs4TabCard(
                                           # ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("User", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "danger",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epda_user_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "epda_user_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("epda_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePDA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_user_result_data_download",
                                                       label = "ePDA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **ePDA Terms**: Result of ePDA analysis.
                                                   "),
                                               hr(),
                                               DTOutput("epda_user_result_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePDA Plot",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_plot_download",
                                                       label = "Figure Download",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   A DAscore plot captures the tendency for a pathway, and can be downloaded as a PDF or JPEG file with specified width, height, and dpi settings.
                                                   "
                                               ),
                                               hr(),
                                               imageOutput("epda_plot", width = "100%", height = "auto"),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "ePDA score captures the tendency for a pathway to exhibit increased or decreased levels of genes and metabolites that are statistically significant differences between two group."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                       )
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "esea_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 2,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       br(),
                                       br(),
                                       tags$p("An example can be found in Demo, and click on ➕ to open it."),
                                       hr(),
                                       fileInput(
                                           inputId = "esea_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "esea_user_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "esea_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       # actionButton(
                                       #     inputId = "esea_demo",
                                       #     label = "Demo",
                                       #     icon = shiny::icon("person-running"),
                                       #     width = "100%",
                                       #     status = "info",
                                       #     gradient = FALSE,
                                       #     outline = FALSE,
                                       #     size = NULL,
                                       #     flat = FALSE
                                       # ),
                                       # br(),
                                       # br(),
                                       actionButton(
                                           inputId = "esea_submit",
                                           label = "Submit",
                                           icon = shiny::icon("person-running"),
                                           width = "100%",
                                           status = "success",
                                           gradient = FALSE,
                                           outline = FALSE,
                                           size = NULL,
                                           flat = FALSE
                                       ),
                                       br(),
                                       br(),
                                       tags$b("2. ANALYSIS PARAMETERS:"),
                                       hr(),
                                       textInput(
                                           inputId = "esea_pathway",
                                           label = "Pathway Name",
                                           value = "Oxidative phosphorylation",
                                           placeholder = "Pathway Name",
                                           width = NULL
                                       ),
                                       tags$b("3. FIGURE CANVAS:"),
                                       hr(),
                                       selectInput(
                                           inputId = "esea_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "esea_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "esea_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "esea_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       )
                                   ),
                                   column(
                                       width = 10,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("Demo", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "warning",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_demo_meta_data_download",
                                                       label = "Metabolite Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "esea_demo_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_demo_gene_data_download",
                                                       label = "Gene Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "esea_demo_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_demo_group_data_download",
                                                       label = "Group Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("esea_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: eSEA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_demo_result_data_download",
                                                       label = "eSEA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **eSEA Terms**: Result of eSEA analysis.
                                                   "),
                                               hr(),
                                               DTOutput("esea_demo_result_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: eSEA Plot",
                                               markdown(
                                                   "
						                           Result of pathway set enrichment analysis can be downloaded as a PDF or JPEG file with specified width, height, and dpi settings.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "http://www.mnet4all.com/mnet_manual/figure/2.eSEA.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "Extended pathway set enrichment analysis."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "|",
                                           #     icon = NULL
                                           # ),
                                           # tabPanel(
                                           #     style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                           #     title = "Manual",
                                           #     tags$iframe(
                                           #         src = "http://www.mnet4all.com/mnet_manual/",
                                           #         width = "100%",
                                           #         height = "720",
                                           #         frameborder = 0
                                           #     ),
                                           #     icon = shiny::icon("book-open")
                                           # )
                                       ),
                                       bs4TabCard(
                                           # ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolite Data",
                                           title = tags$b("User", style = "color: #aaaaaa;"),
                                           width = 12,
                                           height = 800,
                                           side = "right",
                                           type = "tabs",
                                           footer = NULL,
                                           status = "danger",
                                           solidHeader = FALSE,
                                           background = NULL,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = FALSE,
                                           icon = NULL,
                                           gradient = FALSE,
                                           boxToolSize = "lg",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolite Data",
                                               markdown(
                                                   "
						                           **Metabolite Data** (required, in .txt format): An interactive table for user input, with rows corresponding to metabolites' KEGG IDs and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "esea_user_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Gene Data",
                                               markdown(
                                                   "
						                           **Gene Data** (required, in .txt format): an interactive table for user input, with rows corresponding to gene symble and columns corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "esea_user_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Group Data",
                                               markdown("
						                            **Group Data**: Sample's group information.
                                                   "),
                                               hr(),
                                               DTOutput("esea_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: eSEA Terms",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_user_result_data_download",
                                                       label = "eSEA Terms",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown("
						                            **eSEA Terms**: Result of eSEA analysis.
                                                   "),
                                               hr(),
                                               DTOutput("esea_user_result_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: eSEA Plot",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_plot_download",
                                                       label = "Figure Download",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   Result of pathway set enrichment analysis can be downloaded as a PDF or JPEG file with specified width, height, and dpi settings.
                                                   "
                                               ),
                                               hr(),
                                               imageOutput("esea_plot", width = "100%", height = "auto"),
                                               tags$p(
                                                   tags$b("Figure 1."),
                                                   "Extended pathway set enrichment analysis."
                                               ),
                                               icon = shiny::icon("image")
                                           )
                                       )
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "mpea_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "mpea_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolite Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "mpea_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       hr(),
                                       sliderInput(
                                           inputId = "mpea_logfc",
                                           label = "Log(FoldChange)",
                                           min = 0.00,
                                           max = 10.00,
                                           value = 0.58,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "mpea_padj",
                                           label = "Padjust Cutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "mpea_p_cutoff",
                                           label = "Pathway Pcutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "mpea_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "mpea_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "mpea_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "mpea_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "mpea_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "mpea_meta_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               textOutput("mpea_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("mpea_plot", width = "100%", height = "1000px")
                                           )
                                       ),
                                   )
                               ))
                }, #=== 1.5.1.2 bs4TabItem
                {
                    bs4TabItem(tabName = "gpea_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       style = "padding: 10%; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Setting",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "white",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("gear"),
                                       boxToolSize = "lg",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "gpea_gene_data_input",
                                           label = "Gene Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Gene Data (.txt format)"
                                       ),
                                       fileInput(
                                           inputId = "gpea_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Group Data (.txt format)"
                                       ),
                                       hr(),
                                       sliderInput(
                                           inputId = "gpea_logfc",
                                           label = "Log(FoldChange)",
                                           min = 0.00,
                                           max = 10.00,
                                           value = 0.58,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "gpea_padj",
                                           label = "Padjust Cutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "gpea_p_cutoff",
                                           label = "Pathway Pcutoff",
                                           min = 0.00,
                                           max = 1.00,
                                           value = 0.05,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       hr(),
                                       selectInput(
                                           inputId = "gpea_plot_format",
                                           label = "Figure Format",
                                           choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                           selected = "pdf",
                                           multiple = FALSE,
                                           width = NULL
                                       ),
                                       sliderInput(
                                           inputId = "gpea_plot_width",
                                           label = "Figure Width (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 6.18,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "gpea_plot_height",
                                           label = "Figure Height (inch)",
                                           min = 0.00,
                                           max = 30.00,
                                           value = 10.00,
                                           step = 0.01,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       sliderInput(
                                           inputId = "gpea_plot_dpi",
                                           label = "Figure DPI",
                                           min = 68,
                                           max = 1000,
                                           value = 300,
                                           step = 1,
                                           round = TRUE,
                                           ticks = TRUE,
                                           animate = TRUE,
                                           width = NULL,
                                           pre = NULL,
                                           post = NULL,
                                           timeFormat = FALSE,
                                           timezone = NULL,
                                           dragRange = TRUE
                                       ),
                                       downloadButton(
                                           outputId = "gpea_plot_download",
                                           label = "Figure Download",
                                           class = NULL,
                                           icon = icon("circle-down"),
                                           style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           style = "height: 850px; overflow-y: scroll; overflow-x: hidden",
                                           inputId = NULL,
                                           title = span("| Data && Figure Preview", ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "white",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = FALSE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "lg",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           class = "no-header",
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               DTOutput(
                                                   "gpea_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               )
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               textOutput("gpea_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "white",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("table-list"),
                                               boxToolSize = "lg",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("gpea_plot", width = "100%", height = "1000px")
                                           )
                                       ),
                                   )
                               ))
                }, {
                    bs4TabItem(tabName = "database", fluidRow(
                        bs4Card(
                            # 1
                            style = "padding: 10px 10%;",
                            inputId = NULL,
                            title = tags$b("Knowledgebase Update and Download"),
                            footer = NULL,
                            width = 12,
                            height = NULL,
                            status = "white",
                            elevation = 1,
                            solidHeader = FALSE,
                            headerBorder = FALSE,
                            gradient = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            maximizable = FALSE,
                            icon = icon("passport"),
                            boxToolSize = "lg",
                            label = NULL,
                            dropdownMenu = NULL,
                            sidebar = NULL,
                            markdown("
				## **1. Knowledgebase Introduction:**

			    "),
                            br(),
                            markdown(
                                "
                               	The knowledgebase **dbMNet** is a freely available knowledgebase that attempts to consolidate information
                                on all known genes and metabolites into a single resource. The knowledgebase includes two knowledgebases,
                                **dbNet** and **dbKEGG**.

                                Knowledgebase dbKEGG, designed for extended pathway analysis sourced from KEGG database,
                                encompasses **1,692 genes** and **3,097 metabolites** distributed across **84 metabolic pathways** and **11 metabolic categories**.

                                Knowledgebase dbNet, designed for metabolism-related subnetwork analysis sourced from KEGG,
                                BiGG, Reactome, SMPDB and WikiPathways, encompasses a total of **54,593 metabolite-gene pairs** and **51,719 metabolite-metabolite pairs** were documented.

                                These pairs involve **3,964 genes**, and **11,932 metabolites**.

                                The source code for compiling the knowledgebase dbMNet is available here:

                                [**_https://tuantuangui.github.io/MNet_manual/web-server-manual.html#construction-of-knowledgebase-dbmnet_**](https://tuantuangui.github.io/MNet_manual/web-server-manual.html#construction-of-knowledgebase-dbmnet)

                                <hr />

                                ## **2. Knowledgebase dbMNet V202411 can be downloaded here.**

                                <br />
                                "
                            ),
                            fluidRow(
                                column(
                                    width = 9,
                                    tags$a(
                                        href = "http://www.mnet4all.com/MNet/dbMNet/dbMNet-V202411.zip",
                                        "http://www.mnet4all.com/MNet/dbMNet/dbMNet-V202411.zip"
                                    )
                                ),
                                column(
                                    width = 3,
                                    downloadButton(
                                        outputId = "download_db202411",
                                        label = "Download",
                                        class = NULL,
                                        icon = icon("circle-down"),
                                        style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                    )
                                )
                            ),
                            hr(),
                            markdown(
                                "
				     #### **2.1 dbKEGG, designed for extended pathway analysis.**

				     <br />
				     "
                            ),
                            DTOutput(
                                "db_kegg",
                                width = "100%",
                                height = "auto",
                                fill = TRUE
                            ),
                            br(),
                            markdown(
                                "
                                #### **2.2 dbNet, designed for metabolism-related subnetwork analysis.**

                                <br />
                                "
                            ),
                            DTOutput(
                                "db_net",
                                width = "100%",
                                height = "auto",
                                fill = TRUE
                            ),
                            hr(),
                            markdown(
                                "
				## **3. Knowledgebase History**

				<br />

				#### **3.1 Knowledgebase dbMNet V202404 can be downloaded here.**

				<br />
				"
                            ),
                            fluidRow(
                                column(
                                    width = 9,
                                    tags$a(
                                        href = "http://www.mnet4all.com/MNet/dbMNet/dbMNet-V202404.zip",
                                        "http://www.mnet4all.com/MNet/dbMNet/dbMNet-V202404.zip"
                                    )
                                ),
                                column(
                                    width = 3,
                                    downloadButton(
                                        outputId = "download_db202404",
                                        label = "Download",
                                        class = NULL,
                                        icon = icon("circle-down"),
                                        style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                    )
                                )
                            ),
                            hr(),
                            markdown(
                                "
                                <hr />

                                #### **3.2 Knowledgebase dbMNet V202212 can be downloaded here.**

                                <br />
                               "
                            ),
                            fluidRow(
                                column(
                                    width = 9,
                                    tags$a(
                                        href = "http://www.mnet4all.com/MNet/dbMNet/dbMNet-V202212.zip",
                                        "http://www.mnet4all.com/MNet/dbMNet/dbMNet-V202212.zip"
                                    )
                                ),
                                column(
                                    width = 3,
                                    downloadButton(
                                        outputId = "download_db202212",
                                        label = "Download",
                                        class = NULL,
                                        icon = icon("circle-down"),
                                        style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                    )
                                )
                            ),
                            hr()
                        )
                    ))
                })
        )
    )
)

server <- shinyServer(function(session, input, output) {
    observe({
        # user_ip <- session$clientData$url_hostname
        # user_ip <- session$request$REMOTE_ADDR
        user_ip <- session$request$HTTP_X_FORWARDED_FOR
        if (is.null(user_ip) || user_ip == "") {
            user_ip <- session$request$REMOTE_ADDR
        }
        visit_time <- Sys.time()
        
        log_data <- data.frame(
            IP = user_ip,
            VisitTime = as.character(visit_time),
            stringsAsFactors = FALSE
        )
        
        # 追加记录到 TXT 文件
        write.table(
            log_data,
            log_file,
            append = TRUE,
            sep = "\t",
            row.names = FALSE,
            col.names = !file.exists(log_file)
        )
    })
    
    # 从日志文件中读取并统计数据
    get_stats <- reactive({
        req(file.exists(log_file))
        log_data <- read.table(log_file, header = TRUE, sep = "\t")
        
        # 转换访问时间为 POSIXct 格式
        log_data$VisitTime <- as.POSIXct(log_data$VisitTime)
        
        # 计算总访问量
        total_visits <- nrow(log_data)
        
        # 统计唯一用户数量
        unique_users <- n_distinct(log_data$IP)
        
        # 统计最近24小时的访问量
        last_24h <- Sys.time() - 24 * 60 * 60
        recent_visits <- log_data %>% filter(VisitTime >= last_24h) %>% nrow()
        
        # 返回统计数据
        list(
            total_visits = total_visits,
            unique_users = unique_users,
            recent_visits = recent_visits
        )
    })
    
    # 自动更新访问统计数据
    output$stats <- renderPrint({
        stats <- get_stats()
        cat("Total Visits:", stats$total_visits, "\n")
        # cat("Unique Visits:", stats$unique_users, "\n")
        cat("Recent 24h:", stats$recent_visits)
    })
    
    # 显示最近的访问记录
    output$log_table <- renderTable({
        req(file.exists(log_file))
        log_data <- read.table(log_file, header = TRUE, sep = "\t")
        log_data$VisitTime <- as.POSIXct(log_data$VisitTime)
        log_data <- log_data %>% arrange(desc(VisitTime)) %>% head(10)  # 显示最近10条记录
        log_data
    })
    
    # home_markdown
    output$home_markdown <- renderUI({
        file_content <- markdown::renderMarkdown(file = "./README.md")
        htmltools::tags$div(style = "padding: 1% 10%", HTML(file_content))
    })
    
    # pca_plot
    {
        output$pca_meta_data <- renderDT({
            if (is.null(input$pca_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$pca_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            return(meta_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
        
        output$pca_group_data <- renderText({
            if (is.null(input$pca_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$pca_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$pca_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$pca_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$pca_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$pca_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$pca_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "PCA analysis ...", detail = "PCA analysis ...")
            
            pca_plot <- pPCA(meta_data, group_data)
            pca_plot$p3
        })
        
        output$pca_plot_download <- downloadHandler(
            filename = function() {
                paste("PCAPlot", input$pca_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$pca_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$pca_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$pca_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$pca_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "PCA analysis ...", detail = "PCA analysis ...")
                    
                    pca_plot <- pPCA(meta_data, group_data)
                    pca_plot$p3
                })
                
                if (input$pca_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$pca_plot_width,
                        height = input$pca_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$pca_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$pca_plot_width,
                        height = input$pca_plot_height,
                        units = "in",
                        res = input$pca_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # volcano_plot
    {
        output$volcano_meta_data <- renderDT({
            if (is.null(input$volcano_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$volcano_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            return(meta_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
        
        output$volcano_group_data <- renderText({
            if (is.null(input$volcano_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$volcano_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$volcano_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$volcano_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$volcano_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$volcano_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$volcano_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
            if (input$volcano_diff_method == "LIMMA") {
                diff_res <- mlimma(meta_data, group_data)
            } else if (input$volcano_diff_method == "OPLS-DA") {
                diff_res <- DM(2 ** meta_data, group_data)
            }
            
            p_volcano <- pVolcano(diff_res,
                                  foldchange_threshold = input$volcano_fold_change)
            p_volcano
        })
        
        output$volcano_plot_download <- downloadHandler(
            filename = function() {
                paste("VolcanoPlot", input$volcano_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$volcano_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$volcano_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$volcano_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$volcano_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
                    if (input$volcano_diff_method == "LIMMA") {
                        diff_res <- mlimma(meta_data, group_data)
                    } else if (input$volcano_diff_method == "OPLS-DA") {
                        diff_res <- DM(2 ** meta_data, group_data)
                    }
                    
                    p_volcano <- pVolcano(diff_res,
                                          foldchange_threshold = input$volcano_fold_change)
                    p_volcano
                })
                
                if (input$volcano_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$volcano_plot_width,
                        height = input$volcano_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$volcano_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$volcano_plot_width,
                        height = input$volcano_plot_height,
                        units = "in",
                        res = input$volcano_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # heatmap_plot
    {
        output$heatmap_meta_data <- renderDT({
            if (is.null(input$heatmap_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$heatmap_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            return(meta_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
        
        output$heatmap_group_data <- renderText({
            if (is.null(input$heatmap_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$heatmap_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$heatmap_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$heatmap_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$heatmap_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$heatmap_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$heatmap_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "Heatmap visualizatioin ...", detail = "Heatmap visualizatioin ...")
            
            if (input$heatmap_diff_method == "LIMMA") {
                diff_res <- mlimma(meta_data, group_data)
            } else if (input$heatmap_diff_method == "OPLS-DA") {
                diff_res <- DM(2 ** meta_data, group_data)
            }
            
            diff_res_filter <- diff_res %>%
                filter(
                    Fold_change > input$heatmap_fold_change |
                        Fold_change < 1 / input$heatmap_fold_change
                ) %>%
                filter(Padj_wilcox < input$heatmap_padj_wilcox) %>%
                filter(VIP > input$heatmap_VIP)
            
            meta_data_diff <- meta_data[rownames(meta_data) %in% diff_res_filter$Name, ]
            p_heatmap <- pHeatmap(
                meta_data_diff,
                group_data,
                fontsize_row = 5,
                fontsize_col = 4,
                clustering_method = "ward.D",
                clustering_distance_cols = "correlation"
            )
            p_heatmap
        })
        
        output$heatmap_plot_download <- downloadHandler(
            filename = function() {
                paste("HeatmapPlot", input$heatmap_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$heatmap_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$heatmap_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$heatmap_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$heatmap_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Heatmap visualizatioin ...", detail = "Heatmap visualizatioin ...")
                    
                    if (input$heatmap_diff_method == "LIMMA") {
                        diff_res <- mlimma(meta_data, group_data)
                    } else if (input$heatmap_diff_method == "OPLS-DA") {
                        diff_res <- DM(2 ** meta_data, group_data)
                    }
                    
                    diff_res_filter <- diff_res %>%
                        filter(
                            Fold_change > input$heatmap_fold_change |
                                Fold_change < 1 / input$heatmap_fold_change
                        ) %>%
                        filter(Padj_wilcox < input$heatmap_padj_wilcox) %>%
                        filter(VIP > input$heatmap_VIP)
                    
                    meta_data_diff <- meta_data[rownames(meta_data) %in% diff_res_filter$Name, ]
                    p_heatmap <- pHeatmap(
                        meta_data_diff,
                        group_data,
                        fontsize_row = 5,
                        fontsize_col = 4,
                        clustering_method = "ward.D",
                        clustering_distance_cols = "correlation"
                    )
                    p_heatmap
                })
                
                if (input$heatmap_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$heatmap_plot_width,
                        height = input$heatmap_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$heatmap_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$heatmap_plot_width,
                        height = input$heatmap_plot_height,
                        units = "in",
                        res = input$heatmap_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # network_plot
    {
        temp_network <- file.path(tempdir(), "network")
        if (!dir.exists(temp_network)) {
            dir.create(temp_network, recursive = TRUE)
        }
        
        output$network_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/meta_dat.txt", to = file)
            }
        )
        
        output$network_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/gene_dat.txt", to = file)
            }
        )
        
        output$network_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/groups.txt", to = file)
            }
        )
        
        output$network_demo_nodes_data <- renderDT({
            nodes <- read.table(
                "www/demo/nodes.txt",
                header = TRUE,
                sep = "\t",
                stringsAsFactors = FALSE
            )
            
            datatable(
                head(nodes, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(nodes),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_demo_nodes_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_nodes_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/nodes.txt", to = file)
            }
        )
        
        output$network_demo_edges_data <- renderDT({
            edges <- read.table(
                "www/demo/edges.txt",
                header = TRUE,
                sep = "\t",
                stringsAsFactors = FALSE
            )
            
            datatable(
                head(edges, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(edges),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_demo_edges_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_edges_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/edges.txt", to = file)
            }
        )
        
        output$network_user_meta_data <- renderDT({
            req(input$network_user_meta_data_input)
            meta_data <- read.table(
                input$network_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_user_gene_data <- renderDT({
            req(input$network_user_gene_data_input)
            gene_data <- read.table(
                input$network_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$network_user_group_data <- renderDT({
            req(input$network_user_group_data_input)
            group_data <- read.table(
                input$network_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        observeEvent(input$network_demo, {
            output$network_user_meta_data <- renderDT({
                data("meta_dat")
                meta_data <- meta_dat
                
                return(head(meta_data, 30))
            }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
            
            output$network_user_gene_data <- renderDT({
                data("gene_dat")
                gene_data <- gene_dat
                
                return(head(gene_data, 30))
            }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
            
            output$network_user_group_data <- renderDT({
                data("group")
                group_data <- as.data.frame(group)
                
                return(head(group_data, 30))
            }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
            
            output$network_plot <- renderPlot({
                progress <- Progress$new(session, min = 1, max = 100)
                on.exit(progress$close())
                progress$set(value = 0)
                progress$set(message = "Starting program ...", detail = "Starting program ...")
                
                progress$set(value = 10)
                progress$set(message = "Reading data ...", detail = "Reading data ...")
                
                data("meta_dat")
                meta_data <- meta_dat
                
                data("gene_dat")
                gene_data <- gene_dat
                
                data("group")
                group_data <- group
                
                progress$set(value = 100)
                progress$set(message = "Metabolism-Gene related subnetwork ...", detail = "Metabolism-Gene related subnetwork ...")
                
                diff_meta <- mlimma(meta_data, group_data)
                diff_gene <- mlimma(gene_data, group_data)
                
                names(diff_meta)[4] <- "p_value"
                names(diff_gene)[4] <- "p_value"
                
                network_res <- pdnet(diff_meta, diff_gene, nsize = input$network_nsize)
                network_res
            })
        })
        
        observeEvent(input$network_submit, {
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            meta_data <- read.table(
                input$network_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            gene_data <- read.table(
                input$network_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            group_data <- read.table(
                input$network_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            group_data <- as.character(group_data[, 1])
            
            progress$set(value = 80)
            progress$set(message = "Running mlimma analysis ...", detail = "Running mlimma analysis ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            names(diff_meta)[4] <- "p_value"
            names(diff_gene)[4] <- "p_value"
            
            progress$set(value = 100)
            progress$set(message = "Running pdnet visualization ...", detail = "Running pdnet visualization ...")
            
            network_res <- pdnet(diff_meta, diff_gene, nsize = input$network_nsize)
            
            pdf(
                file = paste(temp_network, "/network_plot.pdf", sep = ""),
                width = input$network_plot_width,
                height = input$network_plot_height,
                onefile = FALSE
            )
            pdnet(diff_meta, diff_gene, nsize = input$network_nsize)
            dev.off()
            
            CairoJPEG(
                filename = paste(temp_network, "/network_plot.jpeg", sep = ""),
                width = input$network_plot_width,
                height = input$network_plot_height,
                units = "in",
                res = input$network_plot_dpi,
                quality = 100
            )
            pdnet(diff_meta, diff_gene, nsize = input$network_nsize)
            dev.off()
            
            write.table(
                network_res$node_result,
                file = paste(temp_network, "/node_result.txt", sep = ""),
                quote = F,
                sep = "\t",
                na = "NA",
                row.names = F
            )
            
            write.table(
                network_res$edge_result,
                file = paste(temp_network, "/edge_result.txt", sep = ""),
                quote = F,
                sep = "\t",
                na = "NA",
                row.names = F
            )
        })
        
        observe({
            # invalidateLater(1000, session)
            
            output$network_plot <- renderImage({
                list(
                    src = paste(temp_network, "/network_plot.jpeg", sep = ""),
                    contentType = "image/jpeg",
                    width = "100%",
                    height = "auto"
                )
            }, deleteFile = FALSE)
        })
        
        output$network_plot_download <- downloadHandler(
            filename = function() {
                paste("NetworkPlot", input$network_plot_format, sep = ".")
            },
            content = function(file) {
                file.copy(from = paste(temp_network, "/network_plot.", input$network_plot_format, sep = ""), to = file)
            }
        )
        
        observe({
            # invalidateLater(1000, session)
            
            output$network_user_nodes_data <- renderDT({
                req(file.exists(paste(temp_network, "/node_result.txt", sep = "")))
                
                nodes <- read.table(
                    paste(temp_network, "/node_result.txt", sep = ""),
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE
                )
                
                datatable(
                    head(nodes, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(nodes),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
        })
        
        output$network_user_nodes_data_download <- downloadHandler(
            filename = function() {
                paste("network_user_nodes_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = paste(temp_network, "/node_result.txt", sep = ""), to = file)
            }
        )
        
        observe({
            # invalidateLater(1000, session)
            
            output$network_user_edges_data <- renderDT({
                req(file.exists(paste(temp_network, "/edge_result.txt", sep = "")))
                
                edges <- read.table(
                    paste(temp_network, "/edge_result.txt", sep = ""),
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE
                )
                
                datatable(
                    head(edges, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(edges),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
        })
        
        output$network_user_edges_data_download <- downloadHandler(
            filename = function() {
                paste("network_user_edges_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = paste(temp_network, "/edge_result.txt", sep = ""), to = file)
            }
        )
    }
    
    # diff_network
    {
        output$diff_network_meta_data <- renderDT({
            if (is.null(input$diff_network_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$diff_network_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$diff_network_gene_data <- renderDT({
            if (is.null(input$diff_network_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$diff_network_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$diff_network_group_data <- renderText({
            if (is.null(input$diff_network_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$diff_network_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$diff_network_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$diff_network_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$diff_network_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$diff_network_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$diff_network_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$diff_network_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$diff_network_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "Metabolism related subnetwork ...", detail = "Metabolism related subnetwork ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            names(diff_meta)[4] <- "p_value"
            names(diff_gene)[4] <- "p_value"
            
            diff_metabolite <- diff_meta %>%
                filter(adj.P.Val < input$diff_network_padj) %>%
                filter(abs(logFC) > input$diff_network_logfc)
            diff_gene1 <- diff_gene %>%
                filter(adj.P.Val < input$diff_network_padj) %>%
                filter(abs(logFC) > input$diff_network_logfc)
            
            diff_network_res <- pdnet(diff_metabolite[, 8], diff_gene1[1:input$diff_network_gene_num, 8])
            diff_network_res
        })
        
        output$diff_network_plot_download <- downloadHandler(
            filename = function() {
                paste("DiffNetwork",
                      input$diff_network_plot_format,
                      sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$diff_network_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$diff_network_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$diff_network_gene_data_input)) {
                        data("gene_dat")
                        gene_data <- gene_dat
                    } else{
                        gene_data <- read.table(
                            input$diff_network_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$diff_network_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$diff_network_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Metabolism related subnetwork ...", detail = "Metabolism related subnetwork ...")
                    
                    diff_meta <- mlimma(meta_data, group_data)
                    diff_gene <- mlimma(gene_data, group_data)
                    
                    names(diff_meta)[4] <- "p_value"
                    names(diff_gene)[4] <- "p_value"
                    
                    diff_metabolite <- diff_meta %>%
                        filter(adj.P.Val < input$diff_network_padj) %>%
                        filter(abs(logFC) > input$diff_network_logfc)
                    diff_gene1 <- diff_gene %>%
                        filter(adj.P.Val < input$diff_network_padj) %>%
                        filter(abs(logFC) > input$diff_network_logfc)
                    
                    diff_network_res <- pdnet(diff_metabolite[, 8], diff_gene1[1:input$diff_network_gene_num, 8])
                    diff_network_res
                })
                
                if (input$diff_network_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$diff_network_plot_width,
                        height = input$diff_network_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$diff_network_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$diff_network_plot_width,
                        height = input$diff_network_plot_height,
                        units = "in",
                        res = input$diff_network_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # corr_network
    {
        output$corr_network_meta_data <- renderDT({
            if (is.null(input$corr_network_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$corr_network_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$corr_network_gene_data <- renderDT({
            if (is.null(input$corr_network_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$corr_network_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$corr_network_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$corr_network_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$corr_network_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$corr_network_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$corr_network_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            progress$set(value = 100)
            progress$set(message = "Correlation Network analysis ...", detail = "Correlation Network analysis ...")
            
            corr_network_res <- pNetCor(meta_data,
                                        gene_data,
                                        cor_threshold = input$corr_network_threshold)
            corr_network_res
        })
        
        output$corr_network_plot_download <- downloadHandler(
            filename = function() {
                paste("corr_networkPlot",
                      input$corr_network_plot_format,
                      sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$corr_network_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$corr_network_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$corr_network_gene_data_input)) {
                        data("gene_dat")
                        gene_data <- gene_dat
                    } else{
                        gene_data <- read.table(
                            input$corr_network_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Correlation Network analysis ...", detail = "Correlation Network analysis ...")
                    
                    corr_network_res <- pNetCor(meta_data,
                                                gene_data,
                                                cor_threshold = input$corr_network_threshold)
                    corr_network_res
                })
                
                if (input$corr_network_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$corr_network_plot_width,
                        height = input$corr_network_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$corr_network_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$corr_network_plot_width,
                        height = input$corr_network_plot_height,
                        units = "in",
                        res = input$corr_network_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # ePEA
    {
        temp_epea <- file.path(tempdir(), "epea")
        if (!dir.exists(temp_epea)) {
            dir.create(temp_epea, recursive = TRUE)
        }
        
        output$epea_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/meta_dat.txt", to = file)
            }
        )
        
        output$epea_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/gene_dat.txt", to = file)
            }
        )
        
        output$epea_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/groups.txt", to = file)
            }
        )
        
        output$epea_demo_up_data <- renderDT({
            epea_up <- data.table::fread(
                "www/demo/epea_up.txt",
                header = TRUE,
                sep = "\t",
                stringsAsFactors = FALSE
            )
            
            datatable(
                head(epea_up, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(epea_up),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_demo_up_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_up_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/epea_up.txt", to = file)
            }
        )
        
        output$epea_demo_down_data <- renderDT({
            epea_down <- data.table::fread(
                "www/demo/epea_down.txt",
                header = TRUE,
                sep = "\t",
                stringsAsFactors = FALSE
            )
            
            datatable(
                head(epea_down, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(epea_down),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_demo_down_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_down_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/epea_down.txt", to = file)
            }
        )
        
        output$epea_user_meta_data <- renderDT({
            req(input$epea_user_meta_data_input)
            meta_data <- read.table(
                input$epea_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_user_gene_data <- renderDT({
            req(input$epea_user_gene_data_input)
            gene_data <- read.table(
                input$epea_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epea_user_group_data <- renderDT({
            req(input$epea_user_group_data_input)
            group_data <- read.table(
                input$epea_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        observeEvent(input$epea_demo, {
            output$epea_user_meta_data <- renderDT({
                data("meta_dat")
                meta_data <- meta_dat
                
                return(head(meta_data, 30))
            }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
            
            output$epea_user_gene_data <- renderDT({
                data("gene_dat")
                gene_data <- gene_dat
                
                return(head(gene_data, 30))
            }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
            
            output$epea_user_group_data <- renderDT({
                data("group")
                group_data <- as.data.frame(group)
                
                return(head(group_data, 30))
            }, options = list(pageLength = 10, scrollX = TRUE), server = FALSE)
            
            output$epea_plot <- renderPlot({
                progress <- Progress$new(session, min = 1, max = 100)
                on.exit(progress$close())
                progress$set(value = 0)
                progress$set(message = "Starting program ...", detail = "Starting program ...")
                
                progress$set(value = 10)
                progress$set(message = "Reading data ...", detail = "Reading data ...")
                
                data("meta_dat")
                meta_data <- meta_dat
                
                data("gene_dat")
                gene_data <- gene_dat
                
                data("group")
                group_data <- group
                
                progress$set(value = 100)
                progress$set(message = "ePEA Pathway ...", detail = "ePEA Pathway ...")
                
                diff_meta <- mlimma(meta_data, group_data)
                diff_gene <- mlimma(gene_data, group_data)
                
                all_data <- rbind(diff_gene, diff_meta)
                
                all_data_up <- all_data %>%
                    filter(logFC > input$epea_logfc) %>%
                    filter(adj.P.Val < input$epea_padj)
                result_up <- PathwayAnalysis(
                    all_data_up$name,
                    out = "Extended",
                    p_cutoff = input$epea_p_cutoff
                )
                
                all_data_down <- all_data %>%
                    filter(logFC < -(input$epea_padj)) %>%
                    filter(adj.P.Val < input$epea_padj)
                result_down <- PathwayAnalysis(
                    all_data_down$name,
                    out = "Extended",
                    p_cutoff = input$epea_p_cutoff
                )
                
                plot <- cowplot::plot_grid(
                    plotlist = list(
                        result_up$p_barplot,
                        result_up$gp,
                        result_down$p_barplot,
                        result_down$gp
                    ),
                    labels = "AUTO",
                    ncol = 1
                )
                plot
            })
        })
        
        observeEvent(input$epea_submit, {
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            meta_data <- read.table(
                input$epea_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            gene_data <- read.table(
                input$epea_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            group_data <- read.table(
                input$epea_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            group_data <- as.character(group_data[, 1])
            
            progress$set(value = 100)
            progress$set(message = "ePEA Pathway ...", detail = "ePEA Pathway ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            all_data <- rbind(diff_gene, diff_meta)
            
            all_data_up <- all_data %>%
                filter(logFC > input$epea_logfc) %>%
                filter(adj.P.Val < input$epea_padj)
            result_up <- PathwayAnalysis(
                all_data_up$name,
                out = "Extended",
                p_cutoff = input$epea_p_cutoff
            )
            write.table(
                as.data.frame(result_up$output),
                file = paste(temp_epea, "/epea_up.txt", sep = ""),
                sep = "\t",
                quote = FALSE,
                row.names = FALSE
            )
            
            all_data_down <- all_data %>%
                filter(logFC < -(input$epea_padj)) %>%
                filter(adj.P.Val < input$epea_padj)
            result_down <- PathwayAnalysis(
                all_data_down$name,
                out = "Extended",
                p_cutoff = input$epea_p_cutoff
            )
            write.table(
                as.data.frame(result_down$output),
                file = paste(temp_epea, "/epea_down.txt", sep = ""),
                sep = "\t",
                quote = FALSE,
                row.names = FALSE
            )
            
            plot <- function() {
                cowplot::plot_grid(
                    plotlist = list(
                        result_up$p_barplot,
                        result_up$gp,
                        result_down$p_barplot,
                        result_down$gp
                    ),
                    labels = "AUTO",
                    ncol = 1
                )
            }
        
            pdf(
                file = paste(temp_epea, "/epea_plot.pdf", sep = ""),
                width = input$epea_plot_width,
                height = input$epea_plot_height,
                onefile = FALSE
            )
            print(plot())
            dev.off()
            
            CairoJPEG(
                filename = paste(temp_epea, "/epea_plot.jpeg", sep = ""),
                width = input$epea_plot_width,
                height = input$epea_plot_height,
                units = "in",
                res = input$epea_plot_dpi,
                quality = 100
            )
            print(plot())
            dev.off()
        })
        
        observe({
            # invalidateLater(1000, session)
            
            output$epea_user_up_data <- renderDT({
                req(file.exists(paste(temp_epea, "/epea_up.txt", sep = "")))
                
                epea_up <- data.table::fread(
                    paste(temp_epea, "/epea_up.txt", sep = ""),
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE
                )
                
                datatable(
                    head(epea_up, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(epea_up),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
        })
        
        output$epea_user_up_data_download <- downloadHandler(
            filename = function() {
                paste("epea_user_up_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = paste(temp_epea, "/epea_up.txt", sep = ""), to = file)
            }
        )
        
        observe({
            # invalidateLater(1000, session)
            
            output$epea_user_down_data <- renderDT({
                req(file.exists(paste(temp_epea, "/epea_down.txt", sep = "")))
                
                epea_down <- data.table::fread(
                    paste(temp_epea, "/epea_down.txt", sep = ""),
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE
                )
                
                datatable(
                    head(epea_down, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(epea_down),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
        })
        
        output$epea_user_down_data_download <- downloadHandler(
            filename = function() {
                paste("epea_user_down_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = paste(temp_epea, "/epea_down.txt", sep = ""), to = file)
            }
        )
        
        observe({
            # invalidateLater(1000, session)
            
            output$epea_plot <- renderImage({
                list(
                    src = paste(temp_epea, "/epea_plot.jpeg", sep = ""),
                    contentType = "image/jpeg",
                    width = "100%",
                    height = "auto"
                )
            }, deleteFile = FALSE)
        })
        
        output$epea_plot_download <- downloadHandler(
            filename = function() {
                paste("ePEAPlot", input$epea_plot_format, sep = ".")
            },
            content = function(file) {
                file.copy(from = paste(temp_epea, "/epea_plot.", input$epea_plot_format, sep = ""), to = file)
            }
        )
    }
    
    # mPEA
    {
        output$mpea_meta_data <- renderDT({
            if (is.null(input$mpea_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$mpea_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$mpea_group_data <- renderText({
            if (is.null(input$mpea_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$mpea_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$mpea_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$mpea_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$mpea_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$mpea_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$mpea_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "mPEA Pathway ...", detail = "mPEA Pathway ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            
            diff_meta_up <- diff_meta %>%
                filter(logFC > input$mpea_logfc) %>%
                filter(adj.P.Val < input$mpea_padj)
            result_up <- PathwayAnalysis(diff_meta_up$name,
                                         out = "metabolite",
                                         p_cutoff = input$mpea_p_cutoff)
            
            diff_meta_down <- diff_meta %>%
                filter(logFC < -(input$mpea_padj)) %>%
                filter(adj.P.Val < input$mpea_padj)
            result_down <- PathwayAnalysis(
                diff_meta_down$name,
                out = "metabolite",
                p_cutoff = input$mpea_p_cutoff
            )
            
            plot <- cowplot::plot_grid(
                plotlist = list(
                    result_up$p_barplot,
                    result_up$gp,
                    result_down$p_barplot,
                    result_down$gp
                ),
                ncol = 1,
                align = "v"
            )
            plot
        })
        
        output$mpea_plot_download <- downloadHandler(
            filename = function() {
                paste("mPEA", input$mpea_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$mpea_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$mpea_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$mpea_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$mpea_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "mPEA Pathway ...", detail = "mPEA Pathway ...")
                    
                    diff_meta <- mlimma(meta_data, group_data)
                    
                    diff_meta_up <- diff_meta %>%
                        filter(logFC > input$mpea_logfc) %>%
                        filter(adj.P.Val < input$mpea_padj)
                    result_up <- PathwayAnalysis(
                        diff_meta_up$name,
                        out = "metabolite",
                        p_cutoff = input$mpea_p_cutoff
                    )
                    
                    diff_meta_down <- diff_meta %>%
                        filter(logFC < -(input$mpea_padj)) %>%
                        filter(adj.P.Val < input$mpea_padj)
                    result_down <- PathwayAnalysis(
                        diff_meta_down$name,
                        out = "metabolite",
                        p_cutoff = input$mpea_p_cutoff
                    )
                    
                    plot <- cowplot::plot_grid(
                        plotlist = list(
                            result_up$p_barplot,
                            result_up$gp,
                            result_down$p_barplot,
                            result_down$gp
                        ),
                        ncol = 1,
                        align = "v"
                    )
                    plot
                })
                
                if (input$mpea_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$mpea_plot_width,
                        height = input$mpea_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$mpea_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$mpea_plot_width,
                        height = input$mpea_plot_height,
                        units = "in",
                        res = input$mpea_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # gPEA
    {
        output$gpea_gene_data <- renderDT({
            if (is.null(input$gpea_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$gpea_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$gpea_group_data <- renderText({
            if (is.null(input$gpea_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$gpea_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$gpea_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$gpea_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$gpea_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$gpea_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$gpea_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "gPEA Pathway ...", detail = "gPEA Pathway ...")
            
            diff_gene <- mlimma(gene_data, group_data)
            
            diff_gene_up <- diff_gene %>%
                filter(logFC > input$gpea_logfc) %>%
                filter(adj.P.Val < input$gpea_padj)
            result_up <- PathwayAnalysis(diff_gene_up$name,
                                         out = "gene",
                                         p_cutoff = input$gpea_p_cutoff)
            
            diff_gene_down <- diff_gene %>%
                filter(logFC < -(input$gpea_padj)) %>%
                filter(adj.P.Val < input$gpea_padj)
            result_down <- PathwayAnalysis(
                diff_gene_down$name,
                out = "gene",
                p_cutoff = input$gpea_p_cutoff
            )
            
            plot <- cowplot::plot_grid(
                plotlist = list(
                    result_up$p_barplot,
                    result_up$gp,
                    result_down$p_barplot,
                    result_down$gp
                ),
                ncol = 1,
                align = "v"
            )
            plot
        })
        
        output$gpea_plot_download <- downloadHandler(
            filename = function() {
                paste("gPEA", input$gpea_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    if (is.null(input$gpea_gene_data_input)) {
                        data("gene_dat")
                        gene_data <- gene_dat
                    } else{
                        gene_data <- read.table(
                            input$gpea_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$gpea_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$gpea_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "gPEA Pathway ...", detail = "gPEA Pathway ...")
                    
                    diff_gene <- mlimma(gene_data, group_data)
                    
                    diff_gene_up <- diff_gene %>%
                        filter(logFC > input$gpea_logfc) %>%
                        filter(adj.P.Val < input$gpea_padj)
                    result_up <- PathwayAnalysis(
                        diff_gene_up$name,
                        out = "gene",
                        p_cutoff = input$gpea_p_cutoff
                    )
                    
                    diff_gene_down <- diff_gene %>%
                        filter(logFC < -(input$gpea_padj)) %>%
                        filter(adj.P.Val < input$gpea_padj)
                    result_down <- PathwayAnalysis(
                        diff_gene_down$name,
                        out = "gene",
                        p_cutoff = input$gpea_p_cutoff
                    )
                    
                    plot <- cowplot::plot_grid(
                        plotlist = list(
                            result_up$p_barplot,
                            result_up$gp,
                            result_down$p_barplot,
                            result_down$gp
                        ),
                        ncol = 1,
                        align = "v"
                    )
                    plot
                })
                
                if (input$gpea_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$gpea_plot_width,
                        height = input$gpea_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$gpea_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$gpea_plot_width,
                        height = input$gpea_plot_height,
                        units = "in",
                        res = input$gpea_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # ePDA
    {
        temp_epda <- file.path(tempdir(), "epda")
        if (!dir.exists(temp_epda)) {
            dir.create(temp_epda, recursive = TRUE)
        }
        
        output$epda_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epda_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/meta_dat.txt", to = file)
            }
        )
        
        output$epda_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epda_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/gene_dat.txt", to = file)
            }
        )
        
        output$epda_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epda_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/groups.txt", to = file)
            }
        )
        
        output$epda_demo_result_data <- renderDT({
            epda_result <- read.table(
                "www/demo/epda_result.txt",
                header = TRUE,
                sep = "\t",
                stringsAsFactors = FALSE
            )
            
            datatable(
                head(epda_result, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(epda_result),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epda_demo_result_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_result_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/epda_result.txt", to = file)
            }
        )
        
        output$epda_user_meta_data <- renderDT({
            req(input$epda_user_meta_data_input)
            meta_data <- read.table(
                input$epda_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epda_user_gene_data <- renderDT({
            req(input$epda_user_gene_data_input)
            gene_data <- read.table(
                input$epda_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$epda_user_group_data <- renderDT({
            req(input$epda_user_group_data_input)
            group_data <- read.table(
                input$epda_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        observeEvent(input$epda_demo, {
            output$epda_user_meta_data <- renderDT({
                data("meta_dat")
                meta_data <- meta_dat
                
                datatable(
                    head(meta_data, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(meta_data),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
            
            output$epda_user_gene_data <- renderDT({
                data("gene_dat")
                gene_data <- gene_dat
                
                datatable(
                    head(gene_data, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(gene_data),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
            
            output$epda_user_group_data <- renderDT({
                data("group")
                group_data <- as.data.frame(group)
                
                datatable(
                    head(group_data, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(group_data),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
            
            output$epda_plot <- renderPlot({
                progress <- Progress$new(session, min = 1, max = 100)
                on.exit(progress$close())
                progress$set(value = 0)
                progress$set(message = "Starting program ...", detail = "Starting program ...")
                
                progress$set(value = 10)
                progress$set(message = "Reading data ...", detail = "Reading data ...")
                
                data("meta_dat")
                meta_data <- meta_dat
                
                data("gene_dat")
                gene_data <- gene_dat
                
                data("group")
                group_data <- group
                
                progress$set(value = 100)
                progress$set(message = "ePDA Pathway ...", detail = "ePDA Pathway ...")
                
                diff_meta <- mlimma(meta_data, group_data)
                diff_gene <- mlimma(gene_data, group_data)
                
                diff_gene_increase <-  diff_gene %>%
                    filter(logFC > input$epda_logfc) %>%
                    filter(adj.P.Val < input$epda_padj)
                diff_gene_decrease <- diff_gene %>%
                    filter(logFC < -(input$epda_logfc)) %>%
                    filter(adj.P.Val < input$epda_padj)
                
                diff_meta_increase <- diff_meta %>%
                    filter(logFC > input$epda_logfc) %>%
                    filter(adj.P.Val < input$epda_padj)
                
                diff_meta_decrease <- diff_meta %>%
                    filter(logFC < -(input$epda_logfc)) %>%
                    filter(adj.P.Val < input$epda_padj)
                
                epda_res <- DAscore(
                    c(
                        diff_gene_increase$name,
                        diff_meta_increase$name
                    ),
                    c(
                        diff_gene_decrease$name,
                        diff_meta_decrease$name
                    ),
                    c(diff_gene$name, diff_meta$name),
                    min_measured_num = 2,
                    out = "Extended"
                )
                epda_res
            })
        })
        
        observeEvent(input$epda_submit, {
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            meta_data <- read.table(
                input$epda_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            gene_data <- read.table(
                input$epda_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            group_data <- read.table(
                input$epda_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            group_data <- as.character(group_data[, 1])
            
            progress$set(value = 100)
            progress$set(message = "ePDA Pathway ...", detail = "ePDA Pathway ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            diff_gene_increase <-  diff_gene %>%
                filter(logFC > input$epda_logfc) %>%
                filter(adj.P.Val < input$epda_padj)
            diff_gene_decrease <- diff_gene %>%
                filter(logFC < -(input$epda_logfc)) %>%
                filter(adj.P.Val < input$epda_padj)
            
            diff_meta_increase <- diff_meta %>%
                filter(logFC > input$epda_logfc) %>%
                filter(adj.P.Val < input$epda_padj)
            
            diff_meta_decrease <- diff_meta %>%
                filter(logFC < -(input$epda_logfc)) %>%
                filter(adj.P.Val < input$epda_padj)
            
            epda_res <- DAscore(
                c(
                    diff_gene_increase$name,
                    diff_meta_increase$name
                ),
                c(
                    diff_gene_decrease$name,
                    diff_meta_decrease$name
                ),
                c(diff_gene$name, diff_meta$name),
                min_measured_num = 2,
                out = "Extended"
            )
            
            write.table(
                as.data.frame(epda_res$result),
                file = paste(temp_epda, "/epda_result.txt", sep = ""),
                sep = "\t",
                quote = FALSE,
                row.names = FALSE
            )
            
            pdf(
                file = paste(temp_epda, "/epda_plot.pdf", sep = ""),
                width = input$epda_plot_width,
                height = input$epda_plot_height,
                onefile = FALSE
            )
            print(epda_res$p)
            dev.off()
            
            CairoJPEG(
                filename = paste(temp_epda, "/epda_plot.jpeg", sep = ""),
                width = input$epda_plot_width,
                height = input$epda_plot_height,
                units = "in",
                res = input$epda_plot_dpi,
                quality = 100
            )
            print(epda_res$p)
            dev.off()
        })
        
        observe({
            # invalidateLater(1000, session)
            
            output$epda_user_result_data <- renderDT({
                req(file.exists(paste(temp_epda, "/epda_result.txt", sep = "")))
                
                epda_result <- read.table(
                    paste(temp_epda, "/epda_result.txt", sep = ""),
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE
                )
                
                datatable(
                    head(epda_result, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(epda_result),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
        })
        
        output$epda_user_result_data_download <- downloadHandler(
            filename = function() {
                paste("epda_user_result_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = paste(temp_epda, "/epda_result.txt", sep = ""), to = file)
            }
        )
        
        observe({
            # invalidateLater(1000, session)
            
            output$epda_plot <- renderImage({
                list(
                    src = paste(temp_epda, "/epda_plot.jpeg", sep = ""),
                    contentType = "image/jpeg",
                    width = "100%",
                    height = "auto"
                )
            }, deleteFile = FALSE)
        })
        
        output$epda_plot_download <- downloadHandler(
            filename = function() {
                paste("ePDAPlot", input$epda_plot_format, sep = ".")
            },
            content = function(file) {
                file.copy(from = paste(temp_epda, "/epda_plot.", input$epda_plot_format, sep = ""), to = file)
            }
        )
    }
    
    # eSEA
    {
        temp_esea <- file.path(tempdir(), "esea")
        if (!dir.exists(temp_esea)) {
            dir.create(temp_esea, recursive = TRUE)
        }
        
        output$esea_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$esea_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("esea_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/meta_dat.txt", to = file)
            }
        )
        
        output$esea_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$esea_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("esea_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/gene_dat.txt", to = file)
            }
        )
        
        output$esea_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$esea_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("esea_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/groups.txt", to = file)
            }
        )
        
        output$esea_demo_result_data <- renderDT({
            esea_result <- read.table(
                "www/demo/esea_result.txt",
                header = TRUE,
                sep = "\t",
                stringsAsFactors = FALSE
            )
            
            datatable(
                head(esea_result, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(esea_result),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$esea_demo_result_data_download <- downloadHandler(
            filename = function() {
                paste("esea_demo_result_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = "www/demo/esea_result.txt", to = file)
            }
        )
        
        output$esea_user_meta_data <- renderDT({
            req(input$esea_user_meta_data_input)
            meta_data <- read.table(
                input$esea_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(meta_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(meta_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$esea_user_gene_data <- renderDT({
            req(input$esea_user_gene_data_input)
            gene_data <- read.table(
                input$esea_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            datatable(
                head(gene_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(gene_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$esea_user_group_data <- renderDT({
            req(input$esea_user_group_data_input)
            group_data <- read.table(
                input$esea_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            datatable(
                head(group_data, 30),
                rownames = TRUE,
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(group_data),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        observeEvent(input$esea_submit, {
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            meta_data <- read.table(
                input$esea_user_meta_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            gene_data <- read.table(
                input$esea_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            group_data <- read.table(
                input$esea_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            group_data <- as.character(group_data[, 1])
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            meta.data <- diff_meta$logFC
            names(meta.data) <- diff_meta$name
            
            gene.data <- diff_gene$logFC
            names(gene.data) <- diff_gene$name
            
            data <- c(meta.data, gene.data)
            
            result <- ESEA(data, out = "Extended")
            result$leadingEdge <- sapply(result$leadingEdge, function(x) paste(x, collapse = ", "))
            
            write.table(
                result,
                # paste(temp_esea, "/esea_result.txt", sep = ""),
                sep = "\t",
                quote = F,
                row.names = F
            )
            
            progress$set(value = 100)
            progress$set(message = "eSEA Pathway ...", detail = "eSEA Pathway ...")
            
            plot <- function(){
                pESEA(input$esea_pathway, data, out = "Extended")
            }
            
            pdf(
                file = paste(temp_esea, "/esea_plot.pdf", sep = ""),
                width = input$esea_plot_width,
                height = input$esea_plot_height,
                onefile = FALSE
            )
            print(plot())
            dev.off()
            
            CairoJPEG(
                filename = paste(temp_esea, "/esea_plot.jpeg", sep = ""),
                width = input$esea_plot_width,
                height = input$esea_plot_height,
                units = "in",
                res = input$esea_plot_dpi,
                quality = 100
            )
            print(plot())
            dev.off()
        })
        
        observe({
            # invalidateLater(1000, session)
            
            output$esea_user_result_data <- renderDT({
                req(file.exists(paste(temp_esea, "/esea_result.txt", sep = "")))
                
                esea_result <- read.table(
                    paste(temp_esea, "/esea_result.txt", sep = ""),
                    header = TRUE,
                    sep = "\t",
                    stringsAsFactors = FALSE
                )
                
                datatable(
                    head(esea_result, 30),
                    rownames = TRUE,
                    options = list(
                        pageLength = 10,
                        scrollX = TRUE,
                        columnDefs = list(list(
                            targets = 1:ncol(esea_result),
                            render = JS(
                                "function(data, type, row, meta) {",
                                "  if (data === null || data === '') return 'NA';",
                                "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                                "}"
                            )
                        ))
                    )
                    # server = FALSE
                )
            })
        })
        
        output$esea_user_result_data_download <- downloadHandler(
            filename = function() {
                paste("esea_user_result_data", ".txt", sep = "")
            },
            content = function(file) {
                file.copy(from = paste(temp_esea, "/esea_result.txt", sep = ""), to = file)
            }
        )
        
        observe({
            # invalidateLater(1000, session)
            
            output$esea_plot <- renderImage({
                list(
                    src = paste(temp_esea, "/esea_plot.jpeg", sep = ""),
                    contentType = "image/jpeg",
                    width = "100%",
                    height = "auto"
                )
            }, deleteFile = FALSE)
        })
        
        output$esea_plot_download <- downloadHandler(
            filename = function() {
                paste("eSEAPlot", input$esea_plot_format, sep = ".")
            },
            content = function(file) {
                file.copy(from = paste(temp_esea, "/esea_plot.", input$esea_plot_format, sep = ""), to = file)
            }
        )
    }
    
    observeEvent(input$open_window, {
        session$sendCustomMessage(
            "openNewWindow",
            list(
                width = 1000,
                height = 800,
                url = "http://www.mnet4all.com/mnet_manual/"
            )
        )
    })
    
    # database
    {
        output$db_kegg <- renderDT({
            db_kegg <- read.table(
                "www/dbMNet/dbMNet-V202411/dbKEGG.txt",
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            datatable(
                head(db_kegg, 30),
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(db_kegg),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$db_net <- renderDT({
            db_net <- read.table(
                "www/dbMNet/dbMNet-V202411/dbNet2.txt",
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            datatable(
                head(db_net, 30),
                options = list(
                    pageLength = 10,
                    scrollX = TRUE,
                    columnDefs = list(list(
                        targets = 1:ncol(db_net),
                        render = JS(
                            "function(data, type, row, meta) {",
                            "  if (data === null || data === '') return 'NA';",
                            "  return isNaN(parseFloat(data)) ? data : parseFloat(data).toFixed(4);",
                            "}"
                        )
                    ))
                )
                # server = FALSE
            )
        })
        
        output$download_db202411 <- downloadHandler(
            filename = function() {
                "dbMNet-V202411.zip"
            },
            content = function(file) {
                file.copy(from = "www/dbMNet/dbMNet-V202411.zip", to = file)
            }
        )
        
        output$download_db202404 <- downloadHandler(
            filename = function() {
                "dbMNet-V202404.zip"
            },
            content = function(file) {
                file.copy(from = "www/dbMNet/dbMNet-V202404.zip", to = file)
            }
        )
        
        output$download_db202212 <- downloadHandler(
            filename = function() {
                "dbMNet-V202212.zip"
            },
            content = function(file) {
                file.copy(from = "www/dbMNet/dbMNet-V202212.zip", to = file)
            }
        )
    }
    
    session$onSessionEnded(function() {
        if (dir.exists(tempdir())) {
            tryCatch({
                unlink(tempdir(), recursive = TRUE)
            }, error = function(e) {
                cat(e$message)
            })
        }
    })
})

# runApp(list(ui = ui, server = server), host = "0.0.0.0", port = 3838)
shinyApp(ui = ui, server = server)
