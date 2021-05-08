spvs_read_lcm_coord <- function (coord_f) 
{
  line_reader <- readLines(coord_f)
  n <- 0
  for (line in line_reader) {
    n <- n + 1
    if (endsWith(line, "lines in following concentration table = NCONC+1")) {
      signals <- as.integer(strsplit(trimws(line), " ")[[1]][1]) - 
        1
    }
    else if (endsWith(line, "lines in following misc. output table")) {
      misc <- as.integer(strsplit(trimws(line), " ")[[1]][1])
    }
    else if (endsWith(line, "points on ppm-axis = NY")) {
      data_start = n
      points <- as.integer(strsplit(trimws(line), " ")[[1]][1])
    }
  }
  FWHM <- as.double(strsplit(trimws(line_reader[signals + 
                                                  6]), "  *")[[1]][3])
  SNR <- as.double(strsplit(trimws(line_reader[signals + 6]), 
                            "  *")[[1]][7])
  ph1 <- as.double(strsplit(trimws(line_reader[signals + 8]), 
                             "  *")[[1]][4])
  ph0 <- as.double(strsplit(trimws(line_reader[signals + 8]), 
                            "  *")[[1]][2])
  diags <- data.frame(FWHM = FWHM, SNR = SNR, ph0 = ph0, ph1 = ph1)
  metab_table <- utils::read.fwf(coord_f, widths = c(9, 5, 
                                                     8, -1, 40), skip = 4, n = signals, header = FALSE, col.names = c("amp", 
                                                                                                                      "SD", "TCr_ratio", "Metab"), row.names = "Metab")
  row.names(metab_table) <- trimws(row.names(metab_table))
  metab_table$SD <- as.double(sub("%", "", metab_table$SD))
  metab_table <- t(metab_table)
  amps <- as.data.frame(t(as.data.frame(metab_table[1, ])))
  row.names(amps) <- "1"
  amps <- as.matrix(amps)
  amps <- as.numeric(as.character(amps))
  crlbs <- as.data.frame(t(as.data.frame(metab_table[2, ])))
  row.names(crlbs) <- "1"
  crlbs <- as.matrix(crlbs)
  crlbs <- as.numeric(as.character(crlbs))
  max_crlbs <- crlbs == 999
  # crlbs <- amps * crlbs/100
  # crlbs[max_crlbs] = Inf
  amps <- as.data.frame(amps)
  row.names(amps) <- colnames(metab_table)
  amps <- t(amps)
  crlbs <- as.data.frame(crlbs)
  row.names(crlbs) <- colnames(metab_table)
  crlbs <- t(crlbs)
  res_tab <- list(amps = amps, crlbs = crlbs, diags = diags)
  data_lines <- ceiling(points/10)
  n <- 0
  colnames <- vector()
  fit_tab_list <- list()
  repeat {
    header_line <- line_reader[data_start + n * (data_lines + 
                                                   1)]
    if (endsWith(header_line, "lines in following diagnostic table:")) {
      break
    }
    name <- strsplit(trimws(header_line), "  *")[[1]][1]
    skip_pt <- data_start + (n * (data_lines + 1))
    data <- as.vector(t(as.matrix(utils::read.table(coord_f, 
                                                    skip = skip_pt, nrows = data_lines, fill = T))))
    fit_tab_list <- c(fit_tab_list, list(data))
    colnames <- c(colnames, name)
    n = n + 1
  }
  colnames[1] = "PPMScale"
  colnames[2] = "Data"
  colnames[3] = "Fit"
  colnames[4] = "Baseline"
  names(fit_tab_list) <- colnames
  fit_tab <- stats::na.omit(as.data.frame(fit_tab_list))
  fit_tab$Fit <- fit_tab$Fit - fit_tab$Baseline
  fit_tab[5:ncol(fit_tab)] <- fit_tab[5:ncol(fit_tab)] - fit_tab$Baseline
  class(fit_tab) <- c("fit_table", "data.frame")
  return(list(fit = fit_tab, res_tab = res_tab))
}