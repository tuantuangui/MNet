# -> Author:
# Author: benben-miao
# Email: benben.miao@outlook.com
# Github: https://github.com/benben-miao
# Date: 2024-10-21
# <- Author

options = list(warn = -1)

library(shiny)
library(bs4Dash)
library(DT)
library(shinyWidgets)
library(colourpicker)
library(ggsci)
library(ggplot2)
library(MNet)
library(dplyr)

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
                skin = "light",
                status = "warning",
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
                        text = "Overview",
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
            tags$head(
                tags$link(rel = "icon", type = "image/png", href = "favicon.png")
            ),
            #=== 1.5.1 bs4DashPage -> bs4DashBody -> bs4TabItems
            bs4TabItems(
                #=== 1.5.1.1 bs4DashPage home
                {
                    bs4TabItem(tabName = "home", fluidRow(
                        bs4Card(
                            # 1
                            style = "padding: 10px;",
                            inputId = NULL,
                            title = tags$b(" | MNet Introduction:"),
                            footer = NULL,
                            width = 12,
                            height = NULL,
                            status = "danger",
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
                            htmlOutput("home_markdown")
                        )
                    ))
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           inputId = "network_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "network_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "network_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
                                       ),
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
                                       ),
                                       downloadButton(
                                           outputId = "network_plot_download",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                                   "network_meta_data",
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
                                               status = "danger",
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
                                                   "network_gene_data",
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
                                               status = "danger",
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
                                               textOutput("network_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
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
                                               plotOutput("network_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           inputId = "epea_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epea_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epea_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
                                       ),
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
                                           inputId = "epea_plot_height",
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
                                       ),
                                       downloadButton(
                                           outputId = "epea_plot_download",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                                   "epea_meta_data",
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
                                               status = "danger",
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
                                                   "epea_gene_data",
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
                                               status = "danger",
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
                                               textOutput("epea_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
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
                                               plotOutput("epea_plot", width = "100%", height = "1000px")
                                           )
                                       ),
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           inputId = "epda_meta_data_input",
                                           label = "Metabolite Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Metabolites (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epda_gene_data_input",
                                           label = "GeneExp Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "GeneExp (TXT)"
                                       ),
                                       fileInput(
                                           inputId = "epda_group_data_input",
                                           label = "Group Data",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Groups (TXT)"
                                       ),
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
                                       ),
                                       downloadButton(
                                           outputId = "epda_plot_download",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                                   "epda_meta_data",
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
                                               status = "danger",
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
                                                   "epda_gene_data",
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
                                               status = "danger",
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
                                               textOutput("epda_group_data")
                                           ),
                                           bs4Card(
                                               inputId = NULL,
                                               title = "| Data Table",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
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
                                               plotOutput("epda_plot", width = "100%", height = "1000px")
                                           )
                                       ),
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           inputId = "esea_comp_gene_data_input",
                                           label = "Compound Gene Stats",
                                           multiple = FALSE,
                                           accept = NULL,
                                           width = NULL,
                                           buttonLabel = "Browse",
                                           placeholder = "Compound Gene (TXT)"
                                       ),
                                       hr(),
                                       textInput(
                                           inputId = "esea_pathway",
                                           label = "Pathway Name",
                                           value = "Butanoate metabolism",
                                           placeholder = "Pathway Name",
                                           width = NULL
                                       ),
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
                                       ),
                                       downloadButton(
                                           outputId = "esea_plot_download",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                                   "esea_comp_gene_data",
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
                                               status = "danger",
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
                                               plotOutput("esea_plot", width = "100%", height = "640px")
                                           )
                                       ),
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem
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
                                       status = "danger",
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
                                           status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                                               status = "danger",
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
                },
                #=== 1.5.1.2 bs4TabItem umap_plot
                {
                    bs4TabItem(tabName = "umap_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 850px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "umap_plot_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "umap_plot_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "umap_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "umap_plot_width",
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
                                                   inputId = "umap_plot_height",
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
                                                   inputId = "umap_plot_dpi",
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
                                                   outputId = "umap_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "umap_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "seed_umap_plot",
                                                   label = "Seed TSNE",
                                                   min = 1,
                                                   max = 100,
                                                   value = 1,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "multi_shape_umap_plot",
                                                   label = "Multiple Shape",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "point_size_umap_plot",
                                                   label = "Point Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 5,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "point_alpha_umap_plot",
                                                   label = "Point Alpha",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "text_size_umap_plot",
                                                   label = "Text Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 5,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "fill_alpha_umap_plot",
                                                   label = "Ellipse Fill Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "border_alpha_umap_plot",
                                                   label = "Ellipse Border Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sci_fill_color_umap_plot",
                                                   label = "Sci Color",
                                                   choices = c(
                                                       "Sci_AAAS",
                                                       "Sci_NPG",
                                                       "Sci_Simpsons",
                                                       "Sci_JAMA",
                                                       "Sci_GSEA",
                                                       "Sci_Lancet",
                                                       "Sci_Futurama",
                                                       "Sci_JCO",
                                                       "Sci_NEJM",
                                                       "Sci_IGV",
                                                       "Sci_UCSC",
                                                       "Sci_D3",
                                                       "Sci_Material"
                                                   ),
                                                   selected = "Sci_AAAS",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "legend_pos_umap_plot",
                                                   label = "Legend Position",
                                                   choices = c("none", "left", "right", "bottom", "top"),
                                                   selected = "right",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "legend_dir_umap_plot",
                                                   label = "Legend Director",
                                                   choices = c("horizontal", "vertical"),
                                                   selected = "vertical",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_umap_plot",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "UMAP Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("umap_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "umap_plot_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "umap_plot_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem dendro_plot
                {
                    bs4TabItem(tabName = "dendro_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "dendro_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "dendro_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "dendro_plot_width",
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
                                                   inputId = "dendro_plot_height",
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
                                                   inputId = "dendro_plot_dpi",
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
                                                   outputId = "dendro_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "dendro_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "dist_method_dendro",
                                                   label = "Distance Method",
                                                   choices = c(
                                                       "euclidean",
                                                       "maximum",
                                                       "manhattan",
                                                       "canberra",
                                                       "binary",
                                                       "minkowski"
                                                   ),
                                                   selected = "euclidean",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "hc_method_dendro",
                                                   label = "HCluster Method",
                                                   choices = c(
                                                       "ward.D",
                                                       "ward.D2",
                                                       "single",
                                                       "complete",
                                                       "average",
                                                       "mcquitty",
                                                       "median",
                                                       "centroid"
                                                   ),
                                                   selected = "ward.D2",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "tree_type_dendro",
                                                   label = "Tree Type",
                                                   choices = c("rectangle", "circular", "phylogenic"),
                                                   selected = "rectangle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "k_num_dendro",
                                                   label = "K Number",
                                                   min = 1,
                                                   max = 30,
                                                   value = 5,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "palette_dendro",
                                                   label = "Color Palette",
                                                   choices = c(
                                                       "npg",
                                                       "aaas",
                                                       "lancet",
                                                       "jco",
                                                       "ucscgb",
                                                       "uchicago",
                                                       "simpsons",
                                                       "rickandmorty"
                                                   ),
                                                   selected = "npg",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "color_labels_by_k_dendro",
                                                   label = "Color Labels",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "horiz_dendro",
                                                   label = "Horizontal Dendro",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_dendro",
                                                   label = "Label Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 1.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "line_width_dendro",
                                                   label = "Line Width",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 1.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "rect_dendro",
                                                   label = "Rectangle Tree",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "rect_fill_dendro",
                                                   label = "Rectangle Fill",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_dendro",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Dendro Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("dendro_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "dendro_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem venn_plot
                {
                    bs4TabItem(tabName = "venn_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "venn_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "venn_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "venn_plot_width",
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
                                                   inputId = "venn_plot_height",
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
                                                   inputId = "venn_plot_dpi",
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
                                                   outputId = "venn_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "venn_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "title_size_venn",
                                                   label = "Title Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 1.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "label_show_venn",
                                                   label = "Show Label",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_venn",
                                                   label = "Label Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 0.80,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "border_show_venn",
                                                   label = "Show Border",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "line_type_venn",
                                                   label = "Line Type",
                                                   choices = c(
                                                       "blank",
                                                       "solid",
                                                       "dashed",
                                                       "dotted",
                                                       "dotdash",
                                                       "longdash",
                                                       "twodash"
                                                   ),
                                                   selected = "longdash",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ellipse_shape_venn",
                                                   label = "Ellipse Circle",
                                                   choices = c("circle", "ellipse"),
                                                   selected = "circle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "sci_fill_color_venn",
                                                   label = "Sci Color",
                                                   choices = c(
                                                       "Sci_AAAS",
                                                       "Sci_NPG",
                                                       "Sci_Simpsons",
                                                       "Sci_JAMA",
                                                       "Sci_GSEA",
                                                       "Sci_Lancet",
                                                       "Sci_Futurama",
                                                       "Sci_JCO",
                                                       "Sci_NEJM",
                                                       "Sci_IGV",
                                                       "Sci_UCSC",
                                                       "Sci_D3",
                                                       "Sci_Material"
                                                   ),
                                                   selected = "Sci_AAAS",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "sci_fill_alpha_venn",
                                                   label = "Color Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.65,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Venn Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("venn_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "venn_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem upsetr_plot
                {
                    bs4TabItem(tabName = "upsetr_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "upsetr_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "upsetr_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "upsetr_plot_width",
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
                                                   inputId = "upsetr_plot_height",
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
                                                   inputId = "upsetr_plot_dpi",
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
                                                   outputId = "upsetr_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "upsetr_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "sets_num_upsetr",
                                                   label = "Sets Number",
                                                   min = 2,
                                                   max = 100,
                                                   value = 4,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "keep_order_upsetr",
                                                   label = "Keep Order",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "order_by_upsetr",
                                                   label = "Ordery By",
                                                   choices = c("freq", "degree", "both"),
                                                   selected = "freq",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "decrease_upsetr",
                                                   label = "Decrease",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "mainbar_color_upsetr",
                                                   label = "Main Bar Color",
                                                   value = "#006600",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "number_angle_upsetr",
                                                   label = "Number Angle",
                                                   min = 0,
                                                   max = 360,
                                                   value = 45,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "matrix_color_upsetr",
                                                   label = "Matrix Color",
                                                   value = "#cc0000",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "point_size_upsetr",
                                                   label = "Point Size",
                                                   min = 1.00,
                                                   max = 30.00,
                                                   value = 4.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "point_alpha_upsetr",
                                                   label = "Point Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "line_size_upsetr",
                                                   label = "Line Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 0.80,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "shade_color_upsetr",
                                                   label = "Shade Color",
                                                   value = "#cdcdcd",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "setsbar_color_upsetr",
                                                   label = "Sets Bar Color",
                                                   value = "#000066",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "setsnum_size_upsetr",
                                                   label = "Sets Number Size",
                                                   min = 0.00,
                                                   max = 30.00,
                                                   value = 6.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "text_scale_upsetr",
                                                   label = "Text Scale Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 1.20,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Upsetr Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("upsetr_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "upsetr_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem flower_plot
                {
                    bs4TabItem(tabName = "flower_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "flower_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "flower_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "flower_plot_width",
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
                                                   inputId = "flower_plot_height",
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
                                                   inputId = "flower_plot_dpi",
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
                                                   outputId = "flower_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "flower_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "angle_flower",
                                                   label = "Rotate Angle",
                                                   min = 0,
                                                   max = 360,
                                                   value = 90,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "ellipse_col_pal_flower",
                                                   label = "Ellipse Color",
                                                   choices = c(
                                                       'Spectral',
                                                       'Set1',
                                                       'Set2',
                                                       'Set3',
                                                       'Accent',
                                                       'Dark2',
                                                       'Paired',
                                                       'Pastel1',
                                                       'Pastel2'
                                                   ),
                                                   selected = "Spectral",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "circle_col_flower",
                                                   label = "Circle Color",
                                                   value = "white",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "label_text_cex_flower",
                                                   label = "Label Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 1.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Flower Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("flower_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "flower_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem volcano_plot
                {
                    bs4TabItem(tabName = "volcano_plot2", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "volcano_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "volcano_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "volcano_plot_width2",
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
                                                   inputId = "volcano_plot_height2",
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
                                                   inputId = "volcano_plot_dpi2",
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
                                                   outputId = "volcano_plot_download2",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "volcano_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               textInput(
                                                   inputId = "title_volcano",
                                                   label = "Figure Title",
                                                   value = "CT-vs-LT12",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "log2fc_cutoff_volcano",
                                                   label = "Log2FC Cutoff",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "pq_value_volcano",
                                                   label = "P or Q value",
                                                   choices = c("pvalue", "padj"),
                                                   selected = "pvalue",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pq_cutoff_volcano",
                                                   label = "P or Q Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "cutoff_line_volcano",
                                                   label = "Cutoff Line",
                                                   choices = c(
                                                       "blank",
                                                       "solid",
                                                       "dashed",
                                                       "dotted",
                                                       "dotdash",
                                                       "longdash",
                                                       "twodash"
                                                   ),
                                                   selected = "longdash",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "point_shape_volcano",
                                                   label = "Point Shape",
                                                   choices = c(
                                                       "border_square",
                                                       "border_circle",
                                                       "border_triangle",
                                                       "plus",
                                                       "times",
                                                       "border_diamond",
                                                       "border_triangle_down",
                                                       "square_times",
                                                       "plus_times",
                                                       "diamond_plus",
                                                       "circle_plus",
                                                       "di_triangle",
                                                       "square_plus",
                                                       "circle_times",
                                                       "square_triangle",
                                                       "fill_square",
                                                       "fill_circle",
                                                       "fill_triangle",
                                                       "fill_diamond",
                                                       "large_circle",
                                                       "small_circle",
                                                       "fill_border_circle",
                                                       "fill_border_square",
                                                       "fill_border_diamond",
                                                       "fill_border_triangle"
                                                   ),
                                                   selected = "large_circle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "point_size_volcano",
                                                   label = "Point Size",
                                                   min = 0.00,
                                                   max = 30.00,
                                                   value = 2.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "point_alpha_volcano",
                                                   label = "Point Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "color_normal_volcano",
                                                   label = "Normal Color",
                                                   value = "#888888",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "color_log2fc_volcano",
                                                   label = "Log2FC Color",
                                                   value = "#008000",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "color_pvalue_volcano",
                                                   label = "Pvalue Color",
                                                   value = "#0088ee",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "color_Log2fc_p_volcano",
                                                   label = "Log2FC and Pvalue Color",
                                                   value = "#ff0000",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_volcano",
                                                   label = "Label Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 3,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "boxed_labels_volcano",
                                                   label = "Boxed Labels",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "draw_connectors_volcano",
                                                   label = "Draw Connectors",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "legend_pos_volcano",
                                                   label = "Legend Position",
                                                   choices = c("right", "left", "top", "bottom"),
                                                   selected = "right",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Volcano Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("volcano_plot_plot2", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "volcano_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem ma_plot
                {
                    bs4TabItem(tabName = "ma_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "ma_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "ma_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "ma_plot_width",
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
                                                   inputId = "ma_plot_height",
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
                                                   inputId = "ma_plot_dpi",
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
                                                   outputId = "ma_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "ma_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "foldchange_ma",
                                                   label = "Fold Change",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "fdr_value_ma",
                                                   label = "FDR Value",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "point_size_ma",
                                                   label = "Point Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 3,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "color_up_ma",
                                                   label = "UP Color",
                                                   value = "#FF0000",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "color_down_ma",
                                                   label = "Down Color",
                                                   value = "#008800",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "color_alpha_ma",
                                                   label = "Color Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "top_method_ma",
                                                   label = "Top Method",
                                                   choices = c("padj", "fc"),
                                                   selected = "fc",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "top_num_ma",
                                                   label = "Top Gene Number",
                                                   min = 0,
                                                   max = 100,
                                                   value = 20,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_ma",
                                                   label = "Label Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 8,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "label_box_ma",
                                                   label = "Label Box",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               textInput(
                                                   inputId = "title_ma",
                                                   label = "Figure Title",
                                                   value = "CT-vs-LT12",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_ma",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "MA Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("ma_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "ma_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem heatmap_group
                {
                    bs4TabItem(tabName = "heatmap_group", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "heatmap_group_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "heatmap_group_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "heatmap_group_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "heatmap_group_width",
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
                                                   inputId = "heatmap_group_height",
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
                                                   inputId = "heatmap_group_dpi",
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
                                                   outputId = "heatmap_group_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "heatmap_group_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "scale_data_hg",
                                                   label = "Scale Data",
                                                   choices = c("row", "column", "none"),
                                                   selected = "row",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "clust_method_hg",
                                                   label = "Image Format",
                                                   choices = c(
                                                       "ward.D",
                                                       "ward.D2",
                                                       "single",
                                                       "complete",
                                                       "average",
                                                       "mcquitty",
                                                       "median",
                                                       "centroid"
                                                   ),
                                                   selected = "complete",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "border_show_hg",
                                                   label = "Border Show",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "border_color_hg",
                                                   label = "Border Color",
                                                   value = "#ffffff",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "value_show_hg",
                                                   label = "Value Show",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "value_decimal_hg",
                                                   label = "Value Decimal",
                                                   min = 0,
                                                   max = 7,
                                                   value = 2,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "value_size_hg",
                                                   label = "Value Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 5,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "axis_size_hg",
                                                   label = "Axis Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 8,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "cell_height_hg",
                                                   label = "Cell Height",
                                                   min = 0,
                                                   max = 30,
                                                   value = 10,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "low_color_hg",
                                                   label = "Low Color",
                                                   value = "#00880055",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "mid_color_hg",
                                                   label = "Middle Color",
                                                   value = "#ffffff",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_hg",
                                                   label = "High Color",
                                                   value = "#ff000055",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "na_color_hg",
                                                   label = "NA Color",
                                                   value = "#ff8800",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "x_angle_hg",
                                                   label = "X Axis Angle",
                                                   min = 0,
                                                   max = 360,
                                                   value = 45,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Heatmap Group",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("heatmap_group_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "heatmap_group_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "heatmap_group_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem circos_heatmap
                {
                    bs4TabItem(tabName = "circos_heatmap", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "circos_heatmap_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "circos_heatmap_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "circos_heatmap_width",
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
                                                   inputId = "circos_heatmap_height",
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
                                                   inputId = "circos_heatmap_dpi",
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
                                                   outputId = "circos_heatmap_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "circos_heatmap_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               colourInput(
                                                   inputId = "low_color_ch",
                                                   label = "Low Color",
                                                   value = "#0000ff",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "mid_color_ch",
                                                   label = "Middle Color",
                                                   value = "#ffffff",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_ch",
                                                   label = "High Color",
                                                   value = "#ff0000",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "gap_size_ch",
                                                   label = "Gap Size",
                                                   min = 0,
                                                   max = 360,
                                                   value = 25,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "cluster_run_ch",
                                                   label = "Cluster Run",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "cluster_method_ch",
                                                   label = "Cluster Method",
                                                   choices = c(
                                                       "ward.D",
                                                       "ward.D2",
                                                       "single",
                                                       "complete",
                                                       "average",
                                                       "mcquitty",
                                                       "median",
                                                       "centroid"
                                                   ),
                                                   selected = "complete",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "distance_method_ch",
                                                   label = "Distance Method",
                                                   choices = c(
                                                       "euclidean",
                                                       "maximum",
                                                       "manhattan",
                                                       "canberra",
                                                       "binary",
                                                       "minkowski"
                                                   ),
                                                   selected = "euclidean",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "dend_show_ch",
                                                   label = "Distance Method",
                                                   choices = c("none", "outside", "inside"),
                                                   selected = "inside",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "dend_height_ch",
                                                   label = "Dend Height",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.20,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "track_height_ch",
                                                   label = "Track Height",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.30,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "rowname_show_ch",
                                                   label = "Rowname Show",
                                                   choices = c("none", "outside", "inside"),
                                                   selected = "outside",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "rowname_size_ch",
                                                   label = "Rowname Size",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 0.80,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Circos Heatmap",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("circos_heatmap_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "circos_heatmap_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem chord_plot
                {
                    bs4TabItem(tabName = "chord_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "chord_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "chord_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "chord_plot_width",
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
                                                   inputId = "chord_plot_height",
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
                                                   inputId = "chord_plot_dpi",
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
                                                   outputId = "chord_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "chord_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "multi_colors_chord",
                                                   label = "Multiple Colors",
                                                   choices = c("VividColors", "RainbowColors"),
                                                   selected = "VividColors",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "color_seed_chord",
                                                   label = "Color Seed",
                                                   min = 1,
                                                   max = 100,
                                                   value = 10,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "color_alpha_chord",
                                                   label = "Color Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.30,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "link_visible_chord",
                                                   label = "Link Visible",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "link_dir_chord",
                                                   label = "Alpha",
                                                   min = -1,
                                                   max = 2,
                                                   value = -1,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "link_type_chord",
                                                   label = "Link Type",
                                                   choices = c("diffHeight", "arrows"),
                                                   selected = "diffHeight",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "sector_scale_chord",
                                                   label = "Sector Scale",
                                                   choices = c("Origin", "Scale"),
                                                   selected = "Origin",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "width_circle_chord",
                                                   label = "Circle Width",
                                                   min = 1.00,
                                                   max = 10.00,
                                                   value = 3.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "dist_name_chord",
                                                   label = "Distance Name",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 3.00,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "label_dir_chord",
                                                   label = "Label Director",
                                                   choices = c("Horizontal", "Vertical"),
                                                   selected = "Vertical",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "dist_label_chord",
                                                   label = "Distance Label",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 0.30,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "label_scale_chord",
                                                   label = "Label Scale",
                                                   min = 0.00,
                                                   max = 10.00,
                                                   value = 0.80,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Chord Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("chord_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "chord_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem gene_rank_plot
                {
                    bs4TabItem(tabName = "gene_rank_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "gene_rank_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "gene_rank_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "gene_rank_plot_width",
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
                                                   inputId = "gene_rank_plot_height",
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
                                                   inputId = "gene_rank_plot_dpi",
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
                                                   outputId = "gene_rank_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "gene_rank_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "log2fc_rank",
                                                   label = "Log2FC Cutoff",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "palette_rank",
                                                   label = "Palette Color",
                                                   choices = c(
                                                       'Spectral',
                                                       'BrBG',
                                                       'PiYG',
                                                       'PRGn',
                                                       'PuOr',
                                                       'RdBu',
                                                       'RdGy',
                                                       'RdYlBu',
                                                       'RdYlGn'
                                                   ),
                                                   selected = "Spectral",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "top_n_rank",
                                                   label = "Top Gene Number",
                                                   min = 0,
                                                   max = 100,
                                                   value = 10,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_rank",
                                                   label = "Label Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 5,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "base_size_rank",
                                                   label = "Base Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 12,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Gene Rank Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("gene_rank_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "gene_rank_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem gene_cluster_trend
                {
                    bs4TabItem(tabName = "gene_cluster_trend", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "gene_cluster_trend_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "gene_cluster_trend_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "gene_cluster_trend_width",
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
                                                   inputId = "gene_cluster_trend_height",
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
                                                   inputId = "gene_cluster_trend_dpi",
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
                                                   outputId = "gene_cluster_trend_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "gene_cluster_trend_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               sliderInput(
                                                   inputId = "thres_gct",
                                                   label = "Threshold Excluding Genes",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.25,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "min_std_gct",
                                                   label = "Threshold Minimum Standard",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.20,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "palette_gct",
                                                   label = "Color Palette",
                                                   choices = c(
                                                       'Spectral',
                                                       'BrBG',
                                                       'PiYG',
                                                       'PRGn',
                                                       'PuOr',
                                                       'RdBu',
                                                       'RdGy',
                                                       'RdYlBu',
                                                       'RdYlGn'
                                                   ),
                                                   selected = "PiYG",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "cluster_num_gct",
                                                   label = "Cluster Number",
                                                   min = 1,
                                                   max = 30,
                                                   value = 4,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Gene Cluster Trend",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("gene_cluster_trend_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "gene_cluster_trend_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem trend_plot
                {
                    bs4TabItem(tabName = "trend_plot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "trend_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "trend_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "trend_plot_width",
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
                                                   inputId = "trend_plot_height",
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
                                                   inputId = "trend_plot_dpi",
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
                                                   outputId = "trend_plot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "trend_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "scale_method_trend",
                                                   label = "Scale Data",
                                                   choices = c(
                                                       "std",
                                                       "robust",
                                                       "uniminmax",
                                                       "globalminmax",
                                                       "center",
                                                       "centerObs"
                                                   ),
                                                   selected = "centerObs",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "miss_value_trend",
                                                   label = "Image Format",
                                                   choices = c("exclude", "mean", "median", "min10", "random"),
                                                   selected = "exclude",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "line_alpha_trend",
                                                   label = "Line Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "show_points_trend",
                                                   label = "Show Points",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "show_boxplot_trend",
                                                   label = "Show Boxplot",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "num_column_trend",
                                                   label = "Column Number",
                                                   min = 1,
                                                   max = 10,
                                                   value = 1,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sci_fill_color_trend",
                                                   label = "Sci Color",
                                                   choices = c(
                                                       "Sci_AAAS",
                                                       "Sci_NPG",
                                                       "Sci_Simpsons",
                                                       "Sci_JAMA",
                                                       "Sci_GSEA",
                                                       "Sci_Lancet",
                                                       "Sci_Futurama",
                                                       "Sci_JCO",
                                                       "Sci_NEJM",
                                                       "Sci_IGV",
                                                       "Sci_UCSC",
                                                       "Sci_D3",
                                                       "Sci_Material"
                                                   ),
                                                   selected = "Sci_AAAS",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "sci_color_alpha_trend",
                                                   label = "Color Alpha",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "legend_pos_trend",
                                                   label = "Legend Position",
                                                   choices = c("none", "left", "right", "bottom", "top"),
                                                   selected = "right",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "legend_dir_trend",
                                                   label = "Legend Director",
                                                   choices = c("horizontal", "vertical"),
                                                   selected = "vertical",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_trend",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Trend Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("trend_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "trend_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem network_plot
                {
                    bs4TabItem(tabName = "network_plot2", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "network_plot_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "network_plot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "network_plot_width2",
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
                                                   inputId = "network_plot_height2",
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
                                                   inputId = "network_plot_dpi2",
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
                                                   outputId = "network_plot_download2",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "network_plot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "calc_by_network",
                                                   label = "Calc By",
                                                   choices = c("degree", "node"),
                                                   selected = "degree",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "degree_value_network",
                                                   label = "Degree Value",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "normal_color_network",
                                                   label = "Normal Color",
                                                   value = "#008888cc",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "border_color_network",
                                                   label = "Border Color",
                                                   value = "#FFFFFF",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "from_color_network",
                                                   label = "From Color",
                                                   value = "#FF0000cc",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "to_color_network",
                                                   label = "To Color",
                                                   value = "#008800cc",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "normal_shape_network",
                                                   label = "Normal Shape",
                                                   choices = c(
                                                       "circle",
                                                       "crectangle",
                                                       "csquare",
                                                       "none",
                                                       "pie",
                                                       "raster",
                                                       "rectangle",
                                                       "sphere",
                                                       "square",
                                                       "vrectangle"
                                                   ),
                                                   selected = "circle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "spatial_shape_network",
                                                   label = "Spatial Shape",
                                                   choices = c(
                                                       "circle",
                                                       "crectangle",
                                                       "csquare",
                                                       "none",
                                                       "pie",
                                                       "raster",
                                                       "rectangle",
                                                       "sphere",
                                                       "square",
                                                       "vrectangle"
                                                   ),
                                                   selected = "circle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "node_size_network",
                                                   label = "Node Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 25,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "lable_color_network",
                                                   label = "Lable Color",
                                                   value = "#FFFFFF",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_network",
                                                   label = "Label Size",
                                                   min = 0.00,
                                                   max = 30.00,
                                                   value = 0.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "edge_color_network",
                                                   label = "Edge Color",
                                                   value = "#888888",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "edge_width_network",
                                                   label = "Edge Width",
                                                   min = 0.00,
                                                   max = 30.00,
                                                   value = 1.50,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "edge_curved_network",
                                                   label = "Edge Curved",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "net_layout_network",
                                                   label = "Network Layout",
                                                   choices = c(
                                                       "layout_as_bipartite",
                                                       "layout_as_star",
                                                       "layout_as_tree",
                                                       "layout_components",
                                                       "layout_in_circle",
                                                       "layout_nicely",
                                                       "layout_on_grid",
                                                       "layout_on_sphere",
                                                       "layout_randomly",
                                                       "layout_with_dh",
                                                       "layout_with_drl",
                                                       "layout_with_fr",
                                                       "layout_with_gem",
                                                       "layout_with_graphopt",
                                                       "layout_with_kk",
                                                       "layout_with_lgl",
                                                       "layout_with_mds",
                                                       "layout_with_sugiyama"
                                                   ),
                                                   selected = "layout_on_sphere",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Network Plot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("network_plot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "network_plot_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem heatmap_cluster
                {
                    bs4TabItem(tabName = "heatmap_cluster", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "heatmap_cluster_input",
                                                   label = "Survival Data",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "heatmap_cluster_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "heatmap_cluster_width",
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
                                                   inputId = "heatmap_cluster_height",
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
                                                   inputId = "heatmap_cluster_dpi",
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
                                                   outputId = "heatmap_cluster_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "heatmap_cluster_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "dist_method_hc",
                                                   label = "Distance Method",
                                                   choices = c(
                                                       "euclidean",
                                                       "maximum",
                                                       "manhattan",
                                                       "canberra",
                                                       "binary",
                                                       "minkowski"
                                                   ),
                                                   selected = "euclidean",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "hc_method_hc",
                                                   label = "HCluster Method",
                                                   choices = c(
                                                       "ward.D",
                                                       "ward.D2",
                                                       "single",
                                                       "complete",
                                                       "average",
                                                       "mcquitty",
                                                       "median",
                                                       "centroid"
                                                   ),
                                                   selected = "average",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "k_num_hc",
                                                   label = "K Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 5,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               materialSwitch(
                                                   inputId = "show_rownames_hc",
                                                   label = "Show Rowname",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "palette_hc",
                                                   label = "Color Palette",
                                                   choices = c(
                                                       'Spectral',
                                                       'BrBG',
                                                       'PiYG',
                                                       'PRGn',
                                                       'PuOr',
                                                       'RdBu',
                                                       'RdGy',
                                                       'RdYlBu',
                                                       'RdYlGn'
                                                   ),
                                                   selected = "RdBu",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "cluster_pal_hc",
                                                   label = "Cluster Palette",
                                                   choices = c(
                                                       'Set1',
                                                       'Set2',
                                                       'Set3',
                                                       'Accent',
                                                       'Dark2',
                                                       'Paired',
                                                       'Pastel1',
                                                       'Pastel2'
                                                   ),
                                                   selected = "Set1",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "border_color_hc",
                                                   label = "Border Color",
                                                   value = "#ffffff",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "angle_col_hc",
                                                   label = "Col Label Angle",
                                                   min = 0,
                                                   max = 360,
                                                   value = 45,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "label_size_hc",
                                                   label = "Label Size",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "base_size_hc",
                                                   label = "Base Size",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "line_color_hc",
                                                   label = "Line Color",
                                                   value = "#0000cd",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "line_alpha_hc",
                                                   label = "Line Alpha",
                                                   min = 0.00,
                                                   max = 1.00,
                                                   value = 0.20,
                                                   step = 0.01,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "summary_color_hc",
                                                   label = "Summary Color",
                                                   value = "#0000cd",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "summary_alpha_hc",
                                                   label = "Alpha",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "Heatmap Cluster",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("heatmap_cluster_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "heatmap_cluster_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem go_enrich
                {
                    bs4TabItem(tabName = "go_enrich", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "go_enrich_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "go_enrich_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_go_enrich",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_go_enrich",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_go_enrich",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               actionButton(
                                                   inputId = "go_enrich_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               hr(),
                                               downloadButton(
                                                   outputId = "go_enrich_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Table Results",
                                               span(
                                                   "GO Enrich",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_table",
                                               width = "100%",
                                               height = "600px",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem go_enrich_stat
                {
                    bs4TabItem(tabName = "go_enrich_stat", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "go_enrich_stat_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "go_enrich_stat_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "go_enrich_stat_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "go_enrich_stat_width",
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
                                                   inputId = "go_enrich_stat_height",
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
                                                   inputId = "go_enrich_stat_dpi",
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
                                                   outputId = "go_enrich_stat_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "go_enrich_stat_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_go_stat",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_go_stat",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_go_stat",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "max_go_item_go_stat",
                                                   label = "Max GO Item",
                                                   min = 1,
                                                   max = 50,
                                                   value = 15,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "xtext_angle_go_stat",
                                                   label = "X Axis Angle",
                                                   min = 0,
                                                   max = 360,
                                                   value = 45,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sci_fill_color_go_stat",
                                                   label = "Sci Color",
                                                   choices = c(
                                                       "Sci_AAAS",
                                                       "Sci_NPG",
                                                       "Sci_Simpsons",
                                                       "Sci_JAMA",
                                                       "Sci_GSEA",
                                                       "Sci_Lancet",
                                                       "Sci_Futurama",
                                                       "Sci_JCO",
                                                       "Sci_NEJM",
                                                       "Sci_IGV",
                                                       "Sci_UCSC",
                                                       "Sci_D3",
                                                       "Sci_Material"
                                                   ),
                                                   selected = "Sci_AAAS",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "sci_fill_alpha_go_stat",
                                                   label = "Color Alpha",
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
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_go_stat",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "GO Enrich Stat",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("go_enrich_stat_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_stat_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_stat_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem go_enrich_bar
                {
                    bs4TabItem(tabName = "go_enrich_bar", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "go_enrich_bar_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "go_enrich_bar_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "go_enrich_bar_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "go_enrich_bar_width",
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
                                                   inputId = "go_enrich_bar_height",
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
                                                   inputId = "go_enrich_bar_dpi",
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
                                                   outputId = "go_enrich_bar_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "go_enrich_bar_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_go_bar",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_go_bar",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_go_bar",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sign_by_go_bar",
                                                   label = "Sign By",
                                                   choices = c("pvalue", "p.adjust", "qvalue"),
                                                   selected = "p.adjust",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "category_num_go_bar",
                                                   label = "Category Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 30,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "font_size_go_bar",
                                                   label = "Font Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 12,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "low_color_go_bar",
                                                   label = "Low Color",
                                                   value = "#ff0000aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_go_bar",
                                                   label = "High Color",
                                                   value = "#008800aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_go_bar",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "GO Enrich Bar",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("go_enrich_bar_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_bar_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_bar_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem go_enrich_dot
                {
                    bs4TabItem(tabName = "go_enrich_dot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "go_enrich_dot_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "go_enrich_dot_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "go_enrich_dot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "go_enrich_dot_width",
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
                                                   inputId = "go_enrich_dot_height",
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
                                                   inputId = "go_enrich_dot_dpi",
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
                                                   outputId = "go_enrich_dot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "go_enrich_dot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_go_dot",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_go_dot",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_go_dot",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sign_by_go_dot",
                                                   label = "Sign By",
                                                   choices = c("pvalue", "p.adjust", "qvalue"),
                                                   selected = "p.adjust",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "category_num_go_dot",
                                                   label = "Category Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 30,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "font_size_go_dot",
                                                   label = "Font Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 12,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "low_color_go_dot",
                                                   label = "Low Color",
                                                   value = "#ff0000aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_go_dot",
                                                   label = "High Color",
                                                   value = "#008800aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_go_dot",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "GO Enrich Dot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("go_enrich_dot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_dot_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_dot_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem go_enrich_net
                {
                    bs4TabItem(tabName = "go_enrich_net", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "go_enrich_net_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "go_enrich_net_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "go_enrich_net_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "go_enrich_net_width",
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
                                                   inputId = "go_enrich_net_height",
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
                                                   inputId = "go_enrich_net_dpi",
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
                                                   outputId = "go_enrich_net_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "go_enrich_net_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_go_net",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_go_net",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_go_net",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "category_num_go_net",
                                                   label = "Category Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 20,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "net_layout_go_net",
                                                   label = "Net Layout",
                                                   choices = c(
                                                       'star',
                                                       'circle',
                                                       'gem',
                                                       'dh',
                                                       'graphopt',
                                                       'grid',
                                                       'mds',
                                                       'randomly',
                                                       'fr',
                                                       'kk',
                                                       'drl',
                                                       'lgl'
                                                   ),
                                                   selected = "circle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "net_circular_go_net",
                                                   label = "Net Circular",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "low_color_go_net",
                                                   label = "Low Color",
                                                   value = "#ff0000aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_go_net",
                                                   label = "High Color",
                                                   value = "#008800aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "GO Enrich Net",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("go_enrich_net_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_net_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "go_enrich_net_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem kegg_enrich
                {
                    bs4TabItem(tabName = "kegg_enrich", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "kegg_enrich_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "kegg_enrich_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_kegg_enrich",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_kegg_enrich",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_kegg_enrich",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               actionButton(
                                                   inputId = "kegg_enrich_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               hr(),
                                               downloadButton(
                                                   outputId = "kegg_enrich_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Table Results",
                                               span(
                                                   "KEGG Enrich",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_table",
                                               width = "100%",
                                               height = "600px",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem kegg_enrich_bar
                {
                    bs4TabItem(tabName = "kegg_enrich_bar", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "kegg_enrich_bar_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "kegg_enrich_bar_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "kegg_enrich_bar_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "kegg_enrich_bar_width",
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
                                                   inputId = "kegg_enrich_bar_height",
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
                                                   inputId = "kegg_enrich_bar_dpi",
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
                                                   outputId = "kegg_enrich_bar_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "kegg_enrich_bar_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_kegg_bar",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_kegg_bar",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_kegg_bar",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sign_by_kegg_bar",
                                                   label = "Sign By",
                                                   choices = c("pvalue", "p.adjust", "qvalue"),
                                                   selected = "p.adjust",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "category_num_kegg_bar",
                                                   label = "Category Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 30,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "font_size_kegg_bar",
                                                   label = "Font Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 12,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "low_color_kegg_bar",
                                                   label = "Low Color",
                                                   value = "#ff0000aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_kegg_bar",
                                                   label = "High Color",
                                                   value = "#008800aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_kegg_bar",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "KEGG Enrich Bar",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("kegg_enrich_bar_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_bar_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_bar_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem kegg_enrich_dot
                {
                    bs4TabItem(tabName = "kegg_enrich_dot", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "kegg_enrich_dot_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "kegg_enrich_dot_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "kegg_enrich_dot_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "kegg_enrich_dot_width",
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
                                                   inputId = "kegg_enrich_dot_height",
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
                                                   inputId = "kegg_enrich_dot_dpi",
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
                                                   outputId = "kegg_enrich_dot_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "kegg_enrich_dot_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_kegg_dot",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_kegg_dot",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_kegg_dot",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "sign_by_kegg_dot",
                                                   label = "Sign By",
                                                   choices = c("pvalue", "p.adjust", "qvalue"),
                                                   selected = "p.adjust",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "category_num_kegg_dot",
                                                   label = "Category Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 30,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "font_size_kegg_dot",
                                                   label = "Font Size",
                                                   min = 0,
                                                   max = 30,
                                                   value = 12,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               colourInput(
                                                   inputId = "low_color_kegg_dot",
                                                   label = "Low Color",
                                                   value = "#ff0000aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_kegg_dot",
                                                   label = "High Color",
                                                   value = "#008800aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               selectInput(
                                                   inputId = "ggTheme_kegg_dot",
                                                   label = "Themes",
                                                   choices = c(
                                                       "theme_default",
                                                       "theme_bw",
                                                       "theme_gray",
                                                       "theme_light",
                                                       "theme_linedraw",
                                                       "theme_dark",
                                                       "theme_minimal",
                                                       "theme_classic",
                                                       "theme_void"
                                                   ),
                                                   selected = "theme_light",
                                                   multiple = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "KEGG Enrich Dot",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("kegg_enrich_dot_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_dot_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_dot_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem kegg_enrich_net
                {
                    bs4TabItem(tabName = "kegg_enrich_net", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "kegg_enrich_net_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "kegg_enrich_net_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               selectInput(
                                                   inputId = "kegg_enrich_net_format",
                                                   label = "Figure Format",
                                                   choices = c("PDF" = "pdf", "JPEG" = "jpeg"),
                                                   selected = "pdf",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "kegg_enrich_net_width",
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
                                                   inputId = "kegg_enrich_net_height",
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
                                                   inputId = "kegg_enrich_net_dpi",
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
                                                   outputId = "kegg_enrich_net_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           ),
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 2. Parameters",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("brain"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               actionButton(
                                                   inputId = "kegg_enrich_net_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               selectInput(
                                                   inputId = "padjust_method_kegg_net",
                                                   label = "Padjust Method",
                                                   choices = c(
                                                       "holm",
                                                       "hochberg",
                                                       "hommel",
                                                       "bonferroni",
                                                       "BH",
                                                       "BY",
                                                       "fdr",
                                                       "none"
                                                   ),
                                                   selected = "fdr",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               sliderInput(
                                                   inputId = "pvalue_cutoff_kegg_net",
                                                   label = "Pvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "qvalue_cutoff_kegg_net",
                                                   label = "Qvalue Cutoff",
                                                   min = 0.000,
                                                   max = 1.000,
                                                   value = 0.050,
                                                   step = 0.001,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               sliderInput(
                                                   inputId = "category_num_kegg_net",
                                                   label = "Category Number",
                                                   min = 1,
                                                   max = 100,
                                                   value = 20,
                                                   step = 1,
                                                   round = TRUE,
                                                   ticks = TRUE,
                                                   animate = TRUE,
                                                   width = NULL,
                                                   pre = NULL,
                                                   post = NULL,
                                                   timeFormat = TRUE,
                                                   timezone = NULL,
                                                   dragRange = TRUE
                                               ),
                                               selectInput(
                                                   inputId = "net_layout_kegg_net",
                                                   label = "Net Layout",
                                                   choices = c(
                                                       'star',
                                                       'circle',
                                                       'gem',
                                                       'dh',
                                                       'graphopt',
                                                       'grid',
                                                       'mds',
                                                       'randomly',
                                                       'fr',
                                                       'kk',
                                                       'drl',
                                                       'lgl'
                                                   ),
                                                   selected = "circle",
                                                   multiple = FALSE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "net_circular_kegg_net",
                                                   label = "Net Circular",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "low_color_kegg_net",
                                                   label = "Low Color",
                                                   value = "#ff0000aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               ),
                                               colourInput(
                                                   inputId = "high_color_kegg_net",
                                                   label = "High Color",
                                                   value = "#008800aa",
                                                   showColour = "both",
                                                   palette = "square",
                                                   allowedCols = NULL,
                                                   allowTransparent = TRUE,
                                                   returnName = TRUE,
                                                   closeOnClick = FALSE,
                                                   width = NULL
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Figure Results",
                                               span(
                                                   "KEGG Enrich Net",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           plotOutput("kegg_enrich_net_plot", height = 700)
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_net_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "kegg_enrich_net_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem table_split
                {
                    bs4TabItem(tabName = "table_split", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "table_split_input",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               textInput(
                                                   inputId = "grouped_var_split",
                                                   label = "Grouped Variable",
                                                   value = "go_category",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               textInput(
                                                   inputId = "value_var_split",
                                                   label = "Value Variable",
                                                   value = "go_term",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "miss_drop_split",
                                                   label = "Missing Data Drop",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               actionButton(
                                                   inputId = "table_split_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               hr(),
                                               downloadButton(
                                                   outputId = "table_split_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Table Results",
                                               span(
                                                   "Table Split",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_split_table",
                                               width = "100%",
                                               height = "600px",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_split_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem table_merge
                {
                    bs4TabItem(tabName = "table_merge", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "table_merge_input",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               textInput(
                                                   inputId = "merge_vars_table_merge",
                                                   label = "Merge Variables: split by , ",
                                                   value = "biological_process,cellular_component,molecular_function",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               textInput(
                                                   inputId = "new_var_table_merge",
                                                   label = "New Variable",
                                                   value = "go_category",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               textInput(
                                                   inputId = "new_value_table_merge",
                                                   label = "New Value",
                                                   value = "go_term",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "na_remove_table_merge",
                                                   label = "NA Remove",
                                                   value = FALSE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               actionButton(
                                                   inputId = "table_merge_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               hr(),
                                               downloadButton(
                                                   outputId = "table_merge_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Table Results",
                                               span(
                                                   "Table Merge",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_merge_table",
                                               width = "100%",
                                               height = "600px",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_merge_data",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                },
                #=== 1.5.1.2 bs4TabItem table_cross
                {
                    bs4TabItem(tabName = "table_cross", #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                               fluidRow(
                                   bs4Card(
                                       # 1
                                       style = "padding: 5px; height: 800px; overflow-y: scroll; overflow-x: hidden",
                                       id = NULL,
                                       title = "| Options",
                                       footer = NULL,
                                       width = 3,
                                       height = NULL,
                                       status = "danger",
                                       elevation = 0,
                                       solidHeader = FALSE,
                                       headerBorder = TRUE,
                                       gradient = FALSE,
                                       collapsible = FALSE,
                                       collapsed = FALSE,
                                       closable = FALSE,
                                       maximizable = TRUE,
                                       icon = icon("palette"),
                                       boxToolSize = "sm",
                                       label = NULL,
                                       dropdownMenu = NULL,
                                       sidebar = NULL,
                                       #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                                       fluidRow(
                                           #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                           bs4Card(
                                               # 1
                                               style = "padding: 10px 20px;",
                                               inputId = NULL,
                                               title = "| 1. Upload/Download",
                                               footer = NULL,
                                               width = 12,
                                               height = NULL,
                                               status = "danger",
                                               elevation = 1,
                                               solidHeader = FALSE,
                                               headerBorder = TRUE,
                                               gradient = FALSE,
                                               collapsible = TRUE,
                                               collapsed = FALSE,
                                               closable = FALSE,
                                               maximizable = TRUE,
                                               icon = icon("file-arrow-up"),
                                               boxToolSize = "sm",
                                               label = NULL,
                                               dropdownMenu = NULL,
                                               sidebar = NULL,
                                               fileInput(
                                                   inputId = "table_cross_input1",
                                                   label = "Gene Expression",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               fileInput(
                                                   inputId = "table_cross_input2",
                                                   label = "Samples Groups",
                                                   multiple = FALSE,
                                                   accept = NULL,
                                                   width = NULL,
                                                   buttonLabel = "Browse",
                                                   placeholder = "Format: TXT"
                                               ),
                                               textInput(
                                                   inputId = "inter_var_cross",
                                                   label = "Internal Variable",
                                                   value = "Genes",
                                                   width = "100%",
                                                   placeholder = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "left_index_cross",
                                                   label = "Left Table as Index",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               materialSwitch(
                                                   inputId = "right_index_cross",
                                                   label = "Right Table as Index",
                                                   value = TRUE,
                                                   status = "success",
                                                   right = TRUE,
                                                   inline = TRUE,
                                                   width = NULL
                                               ),
                                               actionButton(
                                                   inputId = "table_cross_run",
                                                   label = "Start Running",
                                                   icon = icon('play-circle'),
                                                   width = NULL,
                                                   style = "width: 100%; background-color: #0000cc; color: #ffffff; border-radius: 50px;"
                                               ),
                                               hr(),
                                               downloadButton(
                                                   outputId = "table_cross_download",
                                                   label = "Result Download",
                                                   class = NULL,
                                                   icon = icon("circle-down"),
                                                   style = "width: 100%; background-color: #008888; color: #ffffff; border-radius: 50px;"
                                               )
                                           )
                                       )
                                   ),
                                   column(
                                       width = 9,
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = span(
                                               "| Table Results",
                                               span(
                                                   "Table Cross",
                                                   style = "margin-left: 100px;
                                                  font-size: 1em;
                                                  font-weight: bolder;
                                                  text-shadow: 0px 0px 10px #cdcdcd;
                                                  border: 2px solid #cdcdcd;
                                                  border-radius: 30px;
                                                  padding: 5px 10px;"
                                               )
                                           ),
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = FALSE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("compass-drafting"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_cross_table",
                                               width = "100%",
                                               height = "600px",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 1",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_cross_data1",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       ),
                                       bs4Card(
                                           # 1
                                           inputId = NULL,
                                           title = "| Data Table 2",
                                           footer = NULL,
                                           width = 12,
                                           height = NULL,
                                           status = "danger",
                                           elevation = 1,
                                           solidHeader = FALSE,
                                           headerBorder = TRUE,
                                           gradient = FALSE,
                                           collapsible = TRUE,
                                           collapsed = TRUE,
                                           closable = FALSE,
                                           maximizable = TRUE,
                                           icon = icon("table-list"),
                                           boxToolSize = "sm",
                                           label = NULL,
                                           dropdownMenu = NULL,
                                           sidebar = NULL,
                                           DTOutput(
                                               "table_cross_data2",
                                               width = "100%",
                                               height = "auto",
                                               fill = TRUE
                                           )
                                       )
                                   )
                               ))
                }
            )
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
        }, options = list(scrollX = TRUE))
        
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
        }, options = list(scrollX = TRUE))
        
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
        }, options = list(scrollX = TRUE))
        
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
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
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
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
        output$network_meta_data <- renderDT({
            if (is.null(input$network_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$network_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            return(meta_data)
        }, options = list(scrollX = TRUE))
        
        output$network_gene_data <- renderDT({
            if (is.null(input$network_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$network_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            return(gene_data)
        }, options = list(scrollX = TRUE))
        
        output$network_group_data <- renderText({
            if (is.null(input$network_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$network_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$network_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$network_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$network_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$network_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$network_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$network_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$network_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            names(diff_meta)[4] <- "p_value"
            names(diff_gene)[4] <- "p_value"
            
            network_res <- pdnet(diff_meta, diff_gene, nsize = input$network_nsize)
            network_res
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
                    
                    if (is.null(input$network_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$network_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$network_gene_data_input)) {
                        data("gene_dat")
                        gene_data <- gene_dat
                    } else{
                        gene_data <- read.table(
                            input$network_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$network_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$network_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
        }, options = list(scrollX = TRUE))
        
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
        }, options = list(scrollX = TRUE))
        
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
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
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
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
        }, options = list(scrollX = TRUE))
        
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
        }, options = list(scrollX = TRUE))
        
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
            progress$set(message = "Corr Network analysis ...", detail = "Corr Network analysis ...")
            
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
                    progress$set(message = "Corr Network analysis ...", detail = "Corr Network analysis ...")
                    
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
        output$epea_meta_data <- renderDT({
            if (is.null(input$epea_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$epea_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            return(meta_data)
        }, options = list(scrollX = TRUE))
        
        output$epea_gene_data <- renderDT({
            if (is.null(input$epea_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$epea_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            return(gene_data)
        }, options = list(scrollX = TRUE))
        
        output$epea_group_data <- renderText({
            if (is.null(input$epea_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$epea_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$epea_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$epea_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$epea_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$epea_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$epea_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$epea_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$epea_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
            diff_meta <- mlimma(meta_data, group_data)
            diff_gene <- mlimma(gene_data, group_data)
            
            all_data <- rbind(diff_gene, diff_meta)
            
            all_data_up <- all_data %>%
                filter(logFC > input$epea_logfc) %>%
                filter(adj.P.Val < input$epea_padj)
            result_up <- PathwayAnalysis(all_data_up$name,
                                         out = "Extended",
                                         p_cutoff = input$epea_p_cutoff)
            
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
                ncol = 1,
                align = "v"
            )
            plot
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
                    
                    if (is.null(input$epea_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$epea_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$epea_gene_data_input)) {
                        data("gene_dat")
                        gene_data <- gene_dat
                    } else{
                        gene_data <- read.table(
                            input$epea_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$epea_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$epea_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
                        ncol = 1,
                        align = "v"
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
        }, options = list(scrollX = TRUE))
        
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
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
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
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
        }, options = list(scrollX = TRUE))
        
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
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
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
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
        output$epda_meta_data <- renderDT({
            if (is.null(input$epda_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$epda_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            return(meta_data)
        }, options = list(scrollX = TRUE))
        
        output$epda_gene_data <- renderDT({
            if (is.null(input$epda_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$epda_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            return(gene_data)
        }, options = list(scrollX = TRUE))
        
        output$epda_group_data <- renderText({
            if (is.null(input$epda_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$epda_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            return(group_data)
        })
        
        output$epda_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$epda_meta_data_input)) {
                data("meta_dat")
                meta_data <- meta_dat
            } else{
                meta_data <- read.table(
                    input$epda_meta_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$epda_gene_data_input)) {
                data("gene_dat")
                gene_data <- gene_dat
            } else{
                gene_data <- read.table(
                    input$epda_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
            }
            
            if (is.null(input$epda_group_data_input)) {
                data("group")
                group_data <- group
            } else{
                group_data <- read.table(
                    input$epda_group_data_input$datapath,
                    header = T,
                    sep = "\t",
                    stringsAsFactors = F
                )
                group_data <- as.character(group_data[, 1])
            }
            
            progress$set(value = 100)
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
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
                c(diff_gene_increase$name, diff_meta_increase$name),
                c(diff_gene_decrease$name, diff_meta_decrease$name),
                c(diff_gene$name, diff_meta$name),
                min_measured_num = 2,
                out = "Extended"
                )
            epda_res
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
                    
                    if (is.null(input$epda_meta_data_input)) {
                        data("meta_dat")
                        meta_data <- meta_dat
                    } else{
                        meta_data <- read.table(
                            input$epda_meta_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$epda_gene_data_input)) {
                        data("gene_dat")
                        gene_data <- gene_dat
                    } else{
                        gene_data <- read.table(
                            input$epda_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                    }
                    
                    if (is.null(input$epda_group_data_input)) {
                        data("group")
                        group_data <- group
                    } else{
                        group_data <- read.table(
                            input$epda_group_data_input$datapath,
                            header = T,
                            sep = "\t",
                            stringsAsFactors = F
                        )
                        group_data <- as.character(group_data[, 1])
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
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
                        c(diff_gene_increase$name, diff_meta_increase$name),
                        c(diff_gene_decrease$name, diff_meta_decrease$name),
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
        output$esea_comp_gene_data <- renderDT({
            if (is.null(input$esea_comp_gene_data_input)) {
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
            } else{
                comp_gene_data_df <- read.table(
                    input$esea_comp_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
                comp_gene_data <- as.data.frame(comp_gene_data)
            }
            return(comp_gene_data)
        }, options = list(scrollX = TRUE))
        
        output$esea_plot <- renderPlot({
            progress <- Progress$new(session, min = 1, max = 100)
            on.exit(progress$close())
            progress$set(value = 0)
            progress$set(message = "Starting program ...", detail = "Starting program ...")
            
            progress$set(value = 10)
            progress$set(message = "Reading data ...", detail = "Reading data ...")
            
            if (is.null(input$esea_comp_gene_data_input)) {
                comp_gene_data_df <- read.table(
                    "data-tables/sim.cpd.data.txt",
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
            } else{
                comp_gene_data_df <- read.table(
                    input$esea_comp_gene_data_input$datapath,
                    header = T,
                    sep = "\t",
                    row.names = 1,
                    stringsAsFactors = F
                )
                comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                names(comp_gene_data) <- rownames(comp_gene_data_df)
            }
            
            progress$set(value = 100)
            progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
            
            plot <- MNet::pESEA(
                input$esea_pathway,
                comp_gene_data,
                out = "Extended"
                )
            plot
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
                    
                    if (is.null(input$esea_comp_gene_data_input)) {
                        comp_gene_data_df <- read.table(
                            "data-tables/sim.cpd.data.txt",
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                        comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                        names(comp_gene_data) <- rownames(comp_gene_data_df)
                    } else{
                        comp_gene_data_df <- read.table(
                            input$esea_comp_gene_data_input$datapath,
                            header = T,
                            sep = "\t",
                            row.names = 1,
                            stringsAsFactors = F
                        )
                        comp_gene_data <- as.numeric(as.matrix(comp_gene_data_df))
                        names(comp_gene_data) <- rownames(comp_gene_data_df)
                    }
                    
                    progress$set(value = 100)
                    progress$set(message = "Volcano analysis ...", detail = "Volcano analysis ...")
                    
                    plot <- MNet::pESEA(
                        input$esea_pathway,
                        comp_gene_data,
                        out = "Extended"
                    )
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
