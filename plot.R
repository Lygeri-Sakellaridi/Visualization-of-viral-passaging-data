plot_chrono <- function(variants, plot_start, plot_end, line, passages, mut_types, mut_categories) {
  df <- variants[variants$line == line,]
  df <- df[df$start >= plot_start & df$start<= plot_end,]
  df <- df[(df$mut_type %in% mut_types),]
  df <- df[(df$mut_category %in% mut_categories),]
  circos.clear()
  circos.par(start.degree = 90, track.height = 0.1)
  circos.initialize(sectors = unique(variants$genome), xlim = c(plot_start, plot_end))
  for (i in 1:length(passages)) {
    passage <- passages[i]
    df2 <- df[df$passage == passage,]
    circos.track(ylim = c(0, 1), bg.col = "#FCF7DE")
    if(i == 1) {circos.xaxis()}
    circos.points(df2$start, df2$y, sector.index = unique(variants$genome),
                  col = "#9F2B68", pch = 16, cex = 0.5)
    
    #circos.xaxis()
  }
}

# Change back to "one passage at a time."
plot_interline <- function(variants, plot_start, plot_end, lines, passage, mut_types, mut_categories) {
  df <- variants[variants$passage == passage,]
  df <- df[df$start >= plot_start & df$start <= plot_end,]
  df <- df[(df$mut_type %in% mut_types),]
  df <- df[(df$mut_category %in% mut_categories),]
  circos.clear()
  circos.par(start.degree = 90, track.height = 0.1)
  circos.initialize(sectors = unique(variants$genome), xlim = c(plot_start, plot_end))
  for (i in 1:length(lines)) {
    line <- lines[i]
    df2 <- df[df$line == line,]
    circos.track(ylim = c(0, 1), bg.col = "#FCF7DE")
    if(i == 1) {circos.xaxis()}
    circos.points(df2$start, df2$y, sector.index = unique(variants$genome),
                  col = "#9F2B68", pch = 16, cex = 0.5)
  }
}
