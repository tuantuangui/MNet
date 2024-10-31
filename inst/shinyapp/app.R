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
                    "| MNet App User Interface",
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
                br(),
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
                        text = "Documents",
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
                        text = "1. Metabolic Network",
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
                            text = "| Meta-Gene Network",
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
                            text = "| ePEA Pathway",
                            tabName = "epea_plot",
                            href = NULL,
                            newTab = TRUE,
                            icon = icon("r-project"),
                            selected = NULL
                        ),
                        bs4SidebarMenuSubItem(
                            text = "| DAscore ePDA",
                            tabName = "epda_plot",
                            href = NULL,
                            newTab = TRUE,
                            icon = icon("r-project"),
                            selected = NULL
                        ),
                        bs4SidebarMenuSubItem(
                            text = "| eSEA Pathway",
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
            #     left = span("Copyright: @MNet", style = "font-weight:bold"),
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
                            title = tags$b(" . MNet Documents"),
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
                            boxToolSize = "sm",
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
                                       boxToolSize = "sm",
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
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "pca_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                       boxToolSize = "sm",
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
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "volcano_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                       boxToolSize = "sm",
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
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "heatmap_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       hr(),
                                       fileInput(
                                           inputId = "network_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "network_user_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "network_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
                                       ),
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
                                       width = 9,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("Demo", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "network_demo_meta_data_download",
                                                       label = "Metabolic Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
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
                                                   **Gene Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to genes.

                                                   **Columns:** correspond to the samples.
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
                                               markdown(
                                                   "
                                                   **Group Data:** Group information.

                                                   **Format:** TXT with tab separated.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput("network_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Subnetwork",
                                               markdown(
                                                   "
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "https://tuantuangui.github.io/MNet/articles/data/Figure1.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(tags$b("FIGURE 1"), "ePEA Pathway."),
                                               icon = shiny::icon("image")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "|",
                                               icon = NULL
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Manual",
                                               tags$iframe(
                                                   src = "http://www.mnet4all.com/mnet_manual/",
                                                   width = "100%",
                                                   height = "720",
                                                   frameborder = 0
                                               ),
                                               icon = shiny::icon("book-open")
                                           )
                                       ),
                                       bs4TabCard(
                                           ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("User", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
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
                                                   **Gene Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to genes.

                                                   **Columns:** correspond to the samples.
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
                                               markdown(
                                                   "
                                                   **Group Data:** Group information.

                                                   **Format:** TXT with tab separated.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput("network_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: Subnetwork",
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
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               plotOutput("network_plot", width = "100%", height = "1000px"),
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
                                       boxToolSize = "sm",
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
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "diff_network_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "diff_network_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                       boxToolSize = "sm",
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
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "corr_network_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       hr(),
                                       fileInput(
                                           inputId = "epea_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epea_user_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epea_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                       width = 9,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("Demo", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epea_demo_meta_data_download",
                                                       label = "Metabolic Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
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
                                                   **Gene Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to genes.

                                                   **Columns:** correspond to the samples.
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
                                               markdown(
                                                   "
                                                   **Group Data:** Group information.

                                                   **Format:** TXT with tab separated.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput("epea_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePEA Pathway",
                                               markdown(
                                                   "
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "https://tuantuangui.github.io/MNet/articles/data/Figure1.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(tags$b("FIGURE 1"), "ePEA Pathway."),
                                               icon = shiny::icon("image")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "|",
                                               icon = NULL
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Manual",
                                               tags$iframe(
                                                   src = "http://www.mnet4all.com/mnet_manual/",
                                                   width = "100%",
                                                   height = "720",
                                                   frameborder = 0
                                               ),
                                               icon = shiny::icon("book-open")
                                           )
                                       ),
                                       bs4TabCard(
                                           ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("User", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
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
                                                   **Gene Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to genes.

                                                   **Columns:** correspond to the samples.
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
                                               markdown(
                                                   "
                                                   **Group Data:** Group information.

                                                   **Format:** TXT with tab separated.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput("epea_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePEA Pathway",
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
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               plotOutput("epea_plot", width = "100%", height = "1000px"),
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
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       hr(),
                                       fileInput(
                                           inputId = "epda_user_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epda_user_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epda_user_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                       width = 9,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("Demo", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "epda_demo_meta_data_download",
                                                       label = "Metabolic Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
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
                                                   **Gene Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to genes.

                                                   **Columns:** correspond to the samples.
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
                                               markdown(
                                                   "
                                                   **Group Data:** Group information.

                                                   **Format:** TXT with tab separated.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput("epda_demo_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePDA Pathway",
                                               markdown(
                                                   "
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "https://tuantuangui.github.io/MNet/articles/data/Figure1.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(tags$b("FIGURE 1"), "ePEA Pathway."),
                                               icon = shiny::icon("image")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "|",
                                               icon = NULL
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Manual",
                                               tags$iframe(
                                                   src = "http://www.mnet4all.com/mnet_manual/",
                                                   width = "100%",
                                                   height = "720",
                                                   frameborder = 0
                                               ),
                                               icon = shiny::icon("book-open")
                                           )
                                       ),
                                       bs4TabCard(
                                           ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("User", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
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
                                                   **Gene Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to genes.

                                                   **Columns:** correspond to the samples.
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
                                               markdown(
                                                   "
                                                   **Group Data:** Group information.

                                                   **Format:** TXT with tab separated.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput("epda_user_group_data"),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: ePDA Pathway",
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
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               plotOutput("epda_plot", width = "100%", height = "1000px"),
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
                                       maximizable = FALSE,
                                       icon = icon("gear"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       tags$b("1. DATA UPLOAD:"),
                                       hr(),
                                       fileInput(
                                           inputId = "esea_user_comp_gene_data_input",
                                           label = "Compound Gene Stats",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Compound Gene (TXT)"
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
                                           value = "Butanoate metabolism",
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
                                       width = 9,
                                       bs4TabCard(
                                           # ribbon(text = "Demo", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("Demo", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 3,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               fluidRow(column(width = 9), column(
                                                   width = 3,
                                                   downloadButton(
                                                       outputId = "esea_demo_comp_gene_data_download",
                                                       label = "Metabolic Data",
                                                       class = NULL,
                                                       icon = icon("circle-down"),
                                                       style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                                   )
                                               )),
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "esea_demo_comp_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: eSEA Pathway",
                                               markdown(
                                                   "
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               tags$img(
                                                   src = "https://tuantuangui.github.io/MNet/articles/data/Figure1.png",
                                                   width = "100%",
                                                   height = "auto"
                                               ),
                                               tags$p(tags$b("FIGURE 1"), "eSEA Pathway."),
                                               icon = shiny::icon("image")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "|",
                                               icon = NULL
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Manual",
                                               tags$iframe(
                                                   src = "http://www.mnet4all.com/mnet_manual/",
                                                   width = "100%",
                                                   height = "720",
                                                   frameborder = 0
                                               ),
                                               icon = shiny::icon("book-open")
                                           )
                                       ),
                                       bs4TabCard(
                                           ribbon(text = "User", color = "danger"),
                                           id = "examples_tabbox",
                                           selected = "Input: Metabolic Data",
                                           title = tags$b("User", style = "color: #888888;"),
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
                                           boxToolSize = "sm",
                                           elevation = 0,
                                           headerBorder = TRUE,
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           .list = NULL,
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Input: Metabolic Data",
                                               markdown(
                                                   "
                                                   **Metabolic Data:** [TXT] an interactive table for user-input metabolic data.

                                                   **Rows:** corresponding to metabolites.

                                                   **Columns:** corresponding to samples.
                                                   "
                                               ),
                                               hr(),
                                               DTOutput(
                                                   "esea_user_comp_gene_data",
                                                   width = "100%",
                                                   height = "auto",
                                                   fill = TRUE
                                               ),
                                               icon = shiny::icon("table-list")
                                           ),
                                           tabPanel(
                                               style = "height: 750px; overflow-y: auto; overflow-x: hidden",
                                               title = "Output: eSEA Pathway",
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
                                                   **Visualization:** analysis and visualization to figure.

                                                   **Format:** PDF or JPEG with width, height, dpi setting.
                                                   "
                                               ),
                                               hr(),
                                               plotOutput("esea_plot", width = "100%", height = "1000px"),
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
                                       boxToolSize = "sm",
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
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "mpea_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       fileInput(
                                           inputId = "gpea_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "gpea_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
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
                                           boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
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
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               plotOutput("gpea_plot", width = "100%", height = "1000px")
                                           )
                                       ),
                                   )
                               ))
                })
        )
    )
)

server <- shinyServer(function(session, input, output) {
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
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
        output$network_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            return(head(meta_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$network_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                data("meta_dat")
                meta_data <- meta_dat
                
                write.table(
                    meta_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$network_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            return(head(gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$network_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                data("gene_dat")
                gene_data <- gene_dat
                
                write.table(
                    gene_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$network_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            return(head(group_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$network_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("network_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                data("group")
                group_data <- as.data.frame(group)
                
                write.table(
                    group_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = FALSE,
                    quote = FALSE
                )
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
            
            return(head(meta_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$network_user_gene_data <- renderDT({
            req(input$network_user_gene_data_input)
            gene_data <- read.table(
                input$network_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            return(head(gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$network_user_group_data <- renderDT({
            req(input$network_user_group_data_input)
            group_data <- read.table(
                input$network_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            return(head(group_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        observeEvent(input$network_demo, {
            output$network_user_meta_data <- renderDT({
                data("meta_dat")
                meta_data <- meta_dat
                
                return(head(meta_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$network_user_gene_data <- renderDT({
                data("gene_dat")
                gene_data <- gene_dat
                
                return(head(gene_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$network_user_group_data <- renderDT({
                data("group")
                group_data <- as.data.frame(group)
                
                return(head(group_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
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
            output$network_plot <- renderPlot({
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
        
        output$network_plot_download <- downloadHandler(
            filename = function() {
                paste("NetworkPlot", input$network_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
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
                    
                    progress$set(value = 100)
                    progress$set(message = "Metabolism-Gene related subnetwork ...", detail = "Metabolism-Gene related subnetwork ...")
                    
                    diff_meta <- mlimma(meta_data, group_data)
                    diff_gene <- mlimma(gene_data, group_data)
                    
                    names(diff_meta)[4] <- "p_value"
                    names(diff_gene)[4] <- "p_value"
                    
                    network_res <- pdnet(diff_meta, diff_gene, nsize = input$network_nsize)
                    network_res
                })
                
                if (input$network_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$network_plot_width,
                        height = input$network_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$network_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$network_plot_width,
                        height = input$network_plot_height,
                        units = "in",
                        res = input$network_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
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
            return(meta_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
            return(gene_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
            return(meta_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
            return(gene_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
        output$epea_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            return(head(meta_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epea_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                data("meta_dat")
                meta_data <- meta_dat
                
                write.table(
                    meta_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$epea_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            return(head(gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epea_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                data("gene_dat")
                gene_data <- gene_dat
                
                write.table(
                    gene_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$epea_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            return(head(group_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epea_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("epea_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                data("group")
                group_data <- as.data.frame(group)
                
                write.table(
                    group_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = FALSE,
                    quote = FALSE
                )
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
            
            return(head(meta_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epea_user_gene_data <- renderDT({
            req(input$epea_user_gene_data_input)
            gene_data <- read.table(
                input$epea_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            return(head(gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epea_user_group_data <- renderDT({
            req(input$epea_user_group_data_input)
            group_data <- read.table(
                input$epea_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            return(head(group_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        observeEvent(input$epea_demo, {
            output$epea_user_meta_data <- renderDT({
                data("meta_dat")
                meta_data <- meta_dat
                
                return(head(meta_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$epea_user_gene_data <- renderDT({
                data("gene_dat")
                gene_data <- gene_dat
                
                return(head(gene_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$epea_user_group_data <- renderDT({
                data("group")
                group_data <- as.data.frame(group)
                
                return(head(group_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
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
            output$epea_plot <- renderPlot({
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
        
        output$epea_plot_download <- downloadHandler(
            filename = function() {
                paste("ePEA", input$epea_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
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
                
                if (input$epea_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$epea_plot_width,
                        height = input$epea_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$epea_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$epea_plot_width,
                        height = input$epea_plot_height,
                        units = "in",
                        res = input$epea_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
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
            return(meta_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
            return(gene_data)
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
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
        output$epda_demo_meta_data <- renderDT({
            data("meta_dat")
            meta_data <- meta_dat
            
            return(head(meta_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epda_demo_meta_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_meta_data", ".txt", sep = "")
            },
            content = function(file) {
                data("meta_dat")
                meta_data <- meta_dat
                
                write.table(
                    meta_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$epda_demo_gene_data <- renderDT({
            data("gene_dat")
            gene_data <- gene_dat
            
            return(head(gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epda_demo_gene_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                data("gene_dat")
                gene_data <- gene_dat
                
                write.table(
                    gene_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$epda_demo_group_data <- renderDT({
            data("group")
            group_data <- as.data.frame(group)
            
            return(head(group_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epda_demo_group_data_download <- downloadHandler(
            filename = function() {
                paste("epda_demo_group_data", ".txt", sep = "")
            },
            content = function(file) {
                data("group")
                group_data <- as.data.frame(group)
                
                write.table(
                    group_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = FALSE,
                    quote = FALSE
                )
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
            
            return(head(meta_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epda_user_gene_data <- renderDT({
            req(input$epda_user_gene_data_input)
            gene_data <- read.table(
                input$epda_user_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            
            return(head(gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$epda_user_group_data <- renderDT({
            req(input$epda_user_group_data_input)
            group_data <- read.table(
                input$epda_user_group_data_input$datapath,
                header = T,
                sep = "\t",
                stringsAsFactors = F
            )
            
            return(head(group_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        observeEvent(input$epda_demo, {
            output$epda_user_meta_data <- renderDT({
                data("meta_dat")
                meta_data <- meta_dat
                
                return(head(meta_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$epda_user_gene_data <- renderDT({
                data("gene_dat")
                gene_data <- gene_dat
                
                return(head(gene_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$epda_user_group_data <- renderDT({
                data("group")
                group_data <- as.data.frame(group)
                
                return(head(group_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
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
            output$epda_plot <- renderPlot({
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
                epda_res
            })
        })
        
        output$epda_plot_download <- downloadHandler(
            filename = function() {
                paste("ePDA", input$epda_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
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
                    epda_res
                })
                
                if (input$epda_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$epda_plot_width,
                        height = input$epda_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$epda_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$epda_plot_width,
                        height = input$epda_plot_height,
                        units = "in",
                        res = input$epda_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
    
    # eSEA
    {
        output$esea_demo_comp_gene_data <- renderDT({
            comp_gene_data_df <- read.table(
                "data-tables/sim.cpd.data.txt",
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
            names(comp_gene_data) <- rownames(comp_gene_data_df)
            comp_gene_data <- as.data.frame(comp_gene_data)
            
            return(head(comp_gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        output$esea_demo_comp_gene_data_download <- downloadHandler(
            filename = function() {
                paste("esea_demo_comp_gene_data", ".txt", sep = "")
            },
            content = function(file) {
                comp_gene_data_df <- read.table(
                    "data-tables/sim.cpd.data.txt",
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
                comp_gene_data <- as.data.frame(comp_gene_data)
                
                write.table(
                    comp_gene_data,
                    file,
                    sep = "\t",
                    col.names = TRUE,
                    row.names = TRUE,
                    quote = FALSE
                )
            }
        )
        
        output$esea_user_comp_gene_data <- renderDT({
            req(input$esea_user_comp_gene_data_input)
            comp_gene_data_df <- read.table(
                input$esea_user_comp_gene_data_input$datapath,
                header = T,
                sep = "\t",
                row.names = 1,
                stringsAsFactors = F
            )
            comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
            names(comp_gene_data) <- rownames(comp_gene_data_df)
            comp_gene_data <- as.data.frame(comp_gene_data)
            
            return(head(comp_gene_data, 100))
        }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
        
        observeEvent(input$esea_demo, {
            output$esea_user_comp_gene_data <- renderDT({
                comp_gene_data_df <- read.table(
                    "data-tables/sim.cpd.data.txt",
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
                comp_gene_data <- as.data.frame(comp_gene_data)
                
                return(head(comp_gene_data, 100))
            }, options = list(pageLength = 10, scrollX = TRUE), server = TRUE)
            
            output$esea_plot <- renderPlot({
                progress <- Progress$new(session, min = 1, max = 100)
                on.exit(progress$close())
                progress$set(value = 0)
                progress$set(message = "Starting program ...", detail = "Starting program ...")
                
                progress$set(value = 10)
                progress$set(message = "Reading data ...", detail = "Reading data ...")
                
                comp_gene_data_df <- read.table(
                    "data-tables/sim.cpd.data.txt",
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
                
                progress$set(value = 100)
                progress$set(message = "eSEA Pathway ...", detail = "eSEA Pathway ...")
                
                plot <- MNet::pESEA(input$esea_pathway, comp_gene_data, out = "Extended")
                plot
            })
        })
        
        observeEvent(input$esea_submit, {
            output$esea_plot <- renderPlot({
                progress <- Progress$new(session, min = 1, max = 100)
                on.exit(progress$close())
                progress$set(value = 0)
                progress$set(message = "Starting program ...", detail = "Starting program ...")
                
                progress$set(value = 10)
                progress$set(message = "Reading data ...", detail = "Reading data ...")
                
                comp_gene_data_df <- read.table(
                    input$esea_user_comp_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
                
                progress$set(value = 100)
                progress$set(message = "eSEA Pathway ...", detail = "eSEA Pathway ...")
                
                plot <- MNet::pESEA(input$esea_pathway, comp_gene_data, out = "Extended")
                plot
            })
        })
        
        output$esea_plot_download <- downloadHandler(
            filename = function() {
                paste("eSEA", input$esea_plot_format, sep = ".")
            },
            content = function(file) {
                plot <- reactive({
                    progress <- Progress$new(session, min = 1, max = 100)
                    on.exit(progress$close())
                    progress$set(value = 0)
                    progress$set(message = "Starting program ...", detail = "Starting program ...")
                    
                    progress$set(value = 10)
                    progress$set(message = "Reading data ...", detail = "Reading data ...")
                    
                    comp_gene_data_df <- read.table(
                        input$esea_user_comp_gene_data_input$datapath,
                        header = T,
                        sep = "\t",
                        row.names = 1,
                        stringsAsFactors = F
                    )
                    comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                    names(comp_gene_data) <- rownames(comp_gene_data_df)
                    
                    progress$set(value = 100)
                    progress$set(message = "eSEA Pathway ...", detail = "eSEA Pathway ...")
                    
                    plot <- MNet::pESEA(input$esea_pathway, comp_gene_data, out = "Extended")
                    plot
                })
                
                if (input$esea_plot_format == "pdf") {
                    pdf(
                        file = file,
                        width = input$esea_plot_width,
                        height = input$esea_plot_height,
                        onefile = FALSE
                    )
                    print(plot())
                    dev.off()
                } else if (input$esea_plot_format == "jpeg") {
                    jpeg(
                        filename = file,
                        width = input$esea_plot_width,
                        height = input$esea_plot_height,
                        units = "in",
                        res = input$esea_plot_dpi,
                        quality = 100
                    )
                    print(plot())
                    dev.off()
                }
            }
        )
    }
})

# runApp(list(ui = ui, server = server), host = "0.0.0.0", port = 3838)
shinyApp(ui = ui, server = server)
