# R code for Cyclostratigraphy Intercomparison Project 2.0 - Case 1
# E. Jarochowska e.b.jarochowska@uu.nl

install.packages(setdiff(c("remotes", "astrochron"), rownames(installed.packages())))

require(astrochron)
remotes::install_github(repo = "MindTheGap-ERC/admtools",
                        ref = "dev",
                        force = TRUE,
                        build_vignettes = T)

case1 <- read.csv2(file = "Case1/IODP_Site_U1514_splice_AlTi.csv",
                   sep = ",")
case1$Al.Ti <- as.numeric(case1$Al.Ti)
case1$Depth.CCSF.A..mcd. <- as.numeric(case1$Depth.CCSF.A..mcd.)

#### Eocene ####
h_min = 285
h_max = 140
h_1 = 192.5084
h_2 = 206.3406

Eocene <- case1[case1$Depth.CCSF.A..mcd. <= h_min & case1$Depth.CCSF.A..mcd. >= h_max,]

duration = 50.5 - 41 # Ma

av_sed = (max(Eocene$Depth.CCSF.A..mcd.)-min(Eocene$Depth.CCSF.A..mcd.))/duration/10 #cm/ky
prec_period = 21*av_sed #cm
N_per_cycle = 6 #Martinez et al.
dh = prec_period/N_per_cycle
dt = dh/100

Eo_int <- astrochron::linterp(dat = Eocene,
                              dt = dh/100,
                              genplot = T,
                              check = T,
                              verbose = T)

##### Piecewise analysis #####

par(mfcol=c(1,1))
plot(Eo_int$Al.Ti,Eo_int$Depth.CCSF.A..mcd., type="l")
abline(h=h_1, col = "red")
abline(h=h_2, col = "blue")



#Split into intervals visually

Eo1 <- Eo_int[Eo_int$Depth.CCSF.A..mcd.< h_1,]
Eo2 <- Eo_int[Eo_int$Depth.CCSF.A..mcd.>= h_1 & Eo_int$Depth.CCSF.A..mcd. <= h_2,]
Eo3 <- Eo_int[Eo_int$Depth.CCSF.A..mcd.> h_2,]

#### Interval 1 ####

Eo_eto1 <- eTimeOpt(dat = Eo1,
                    win=dt*50,
                    step = dt*5,
                    sedmin = 0.01,
                    sedmax = 5,
                    fit = 2,
                    fitModPwr = T,
                    detrend = T,
                    output = 1,
                    genplot = T,
                    check = T,
                    verbose = 2)

sedrate_adm1 <- get_data_from_eTimeOpt(Eo_eto1, index = 1)
range(sedrate_adm1$heights)

t_tp1 = tp_height_det(heights = c(42640, 43320)) # tie points in time
h_tp1 = function() {
  h = c(
    runif(n = 1, min = 160.1, max = 169.97),
    runif(n = 1, min = 183.04, max = 187.82))
  return(h)
}
sed1 <- admtools::sed_rate_from_matrix(height = sedrate_adm1$heights,
                             sedrate = sedrate_adm1$sed_rate,
                             matrix = sedrate_adm1$results,
                             rate = 1)

Eo1_adm <- admtools::sedrate_to_multiadm(
  h_tp = h_tp1,
  t_tp = t_tp1,
  sed_rate_gen = sed1,
  h = seq(from = h_max + 2, to =  h_1 - 2, by = 1),
  no_of_rep = 100L,
  subdivisions = 100L,
  stop.on.error = F,
  T_unit = "kyr",
  L_unit = "m"
)
plot(Eo1_adm)
mean(unlist(get_time(Eo1_adm, 150.0)))
mean(unlist(get_time(Eo1_adm, 160.0)))
mean(unlist(get_time(Eo1_adm, 170.0)))
mean(unlist(get_time(Eo1_adm, 180.0)))
mean(unlist(get_time(Eo1_adm, 190.0)))

#### Interval 2 ####

Eo_eto2 <- eTimeOpt(dat = Eo2,
                    win=dt*40,
                    step = dt*10,
                    sedmin = 0.01,
                    sedmax = 5,
                    fit = 2,
                    fitModPwr = T,
                    detrend = T,
                    output = 1,
                    genplot = T,
                    check = T,
                    verbose = 2)

sedrate_adm2 <- get_data_from_eTimeOpt(Eo_eto2, index = 1)
range(sedrate_adm2$heights)

t_tp2 = tp_height_det(heights = 44120)
h_tp2 = function() {
  h = runif(n = 1, min = 193.63, max = 197.42)
  return(h)
}
sed2 <- admtools::sed_rate_from_matrix(height = sedrate_adm2$heights,
                                       sedrate = sedrate_adm2$sed_rate,
                                       matrix = sedrate_adm2$results,
                                       rate = 1)

Eo2_adm <- admtools::sedrate_to_multiadm(
  h_tp = h_tp2,
  t_tp = t_tp2,
  sed_rate_gen = sed2,
  h = seq( from = h_1 + 2, to = h_2 -2, by = 1),
  no_of_rep = 100L,
  subdivisions = 100L,
  stop.on.error = F,
  T_unit = "kyr",
  L_unit = "m"
)
plot(Eo2_adm)
mean(unlist(get_time(Eo2_adm, 200.0)))

#### Interval 3 ####

Eo_eto3 <- eTimeOpt(dat = Eo3,
                    win=dt*40,
                    step = dt*10,
                    sedmin = 0.01,
                    sedmax = 5,
                    fit = 2,
                    fitModPwr = T,
                    detrend = T,
                    output = 1,
                    genplot = T,
                    check = T,
                    verbose = 2)

sedrate_adm3 <- get_data_from_eTimeOpt(Eo_eto3, index = 1)
range(sedrate_adm3$heights)

t_tp3 = function() {
  t = c(45490,
        46210,
        runif(n = 1, min = 47840, max = 50500))
  return(t)
}

h_tp3 = function() {
  h = c(
    runif(n = 1, min = 207.59, max = 217.3),
    runif(n = 1, min = 217.3, max = 227.66),
    runif(n = 1, min = 227.66, max = 236.96))
  return(h)
}
sed3 <- admtools::sed_rate_from_matrix(height = sedrate_adm3$heights,
                                       sedrate = sedrate_adm3$sed_rate,
                                       matrix = sedrate_adm3$results,
                                       rate = 1)

Eo3_adm <- admtools::sedrate_to_multiadm(
  h_tp = h_tp3,
  t_tp = t_tp3,
  sed_rate_gen = sed3,
  h =  seq(from = h_2 + 2, to = h_min - 2, by = 1),
  no_of_rep = 100L,
  subdivisions = 100L,
  stop.on.error = F,
  T_unit = "kyr",
  L_unit = "m"
)
plot(Eo3_adm)
mean(unlist(get_time(Eo3_adm, 210.0)))
mean(unlist(get_time(Eo3_adm, 220.0)))
mean(unlist(get_time(Eo3_adm, 230.0)))
mean(unlist(get_time(Eo3_adm, 240.0)))
mean(unlist(get_time(Eo3_adm, 250.0)))
mean(unlist(get_time(Eo3_adm, 260.0)))
mean(unlist(get_time(Eo3_adm, 270.0)))
mean(unlist(get_time(Eo3_adm, 280.0)))

#### Combined adm ####

Eo_adm <- merge_multiadm(Eo1_adm, Eo2_adm, Eo3_adm)
par(mfcol=c(1,1))
plot(Eo_adm)

range(get_time(Eo_adm, 280.0))
get_time(Eo1_adm, 150.0)

#### Question 1 - Eccentricity ####

astrochron::timeOpt(dat = Eo1,
                    output = 1,
                    sedmin=0.01,
                    sedmax=3,
                    targetE=c(405.98, 100.21),
                    check = T,
                    verbose = T,
                    fit=2, # Test for eccentricity amplitude modulation
                    flow=1/24, # Low frequency cut-off for Taner bandpass (half power point; in cycles/ka)
                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                    genplot = T)


Eo3_sim <- astrochron::timeOptSim(dat = Eo3,
                                 sedmin = 0.05,
                                 sedmax = 3,
                                 numsim = 500,
                                 fit=2,
                                 targetE=c(405.98, 100.21),
                                 roll=NULL,
                                 output=2,
                                 genplot = T,
                                 verbose = T)

# (Envelope r^2) x (Spectral Power r^2) = 0.01831616
# (Envelope r^2) * (Spectral Power r^2) p-value = 0.02

astrochron::timeOpt(dat = Eo2,
                    output = 1,
                    sedmin=0.01,
                    sedmax=3,
                    targetE=c(405.98, 100.21),
                    check = T,
                    verbose = T,
                    fit=2, # Test for eccentricity amplitude modulation
                    flow=1/24, # Low frequency cut-off for Taner bandpass (half power point; in cycles/ka)
                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                    genplot = T)


Eo2_sim <- astrochron::timeOptSim(dat = Eo2,
                                  sedmin = 0.05,
                                  sedmax = 3,
                                  numsim = 500,
                                  fit=2,
                                  targetE=c(405.98, 100.21),
                                  roll=NULL,
                                  output=2,
                                  genplot = T,
                                  verbose = T)

# (Envelope r^2) x (Spectral Power r^2) = 0.1123426
# (Envelope r^2) * (Spectral Power r^2) p-value = 0.38

astrochron::timeOpt(dat = Eo2,
                    output = 1,
                    sedmin=0.01,
                    sedmax=3,
                    targetE=c(405.98, 100.21),
                    check = T,
                    verbose = T,
                    fit=2, # Test for eccentricity amplitude modulation
                    flow=1/24, # Low frequency cut-off for Taner bandpass (half power point; in cycles/ka)
                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                    genplot = T)


Eo1_sim <- astrochron::timeOptSim(dat = Eo1,
                                  sedmin = 0.05,
                                  sedmax = 3,
                                  numsim = 500,
                                  fit=2,
                                  targetE=c(405.98, 100.21),
                                  roll=NULL,
                                  output=2,
                                  genplot = T,
                                  verbose = T)

# (Envelope r^2) x (Spectral Power r^2) = 0133845
# (Envelope r^2) * (Spectral Power r^2) p-value = 0.27


#### Question 1 - Precession ####
# Precession targets 64 ky plus 74 ky https://doi-org.proxy.library.uu.nl/10.1002/2017GC007367

astrochron::timeOpt(dat = Eo1,
                    output = 1,
                    sedmin=0.01,
                    sedmax=3,
                    targetP=c(64, 74),
                    check = T,
                    verbose = T,
                    fit=1,
                    flow=1/24, # Low frequency cut-off for Taner bandpass (half power point; in cycles/ka)
                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                    genplot = T)


Eo3_sim <- astrochron::timeOptSim(dat = Eo3,
                                  sedmin = 0.05,
                                  sedmax = 3,
                                  numsim = 1000,
                                  fit=1,
                                  targetP=c(64, 74),
                                  roll=NULL,
                                  output=2,
                                  genplot = T,
                                  verbose = T)

# (Envelope r^2) x (Spectral Power r^2) = 0.01216367

# * (Envelope r^2) * (Spectral Power r^2) p-value = 0.737

astrochron::timeOpt(dat = Eo2,
                    output = 1,
                    sedmin=0.01,
                    sedmax=3,
                    targetE=c(405.98, 100.21),
                    check = T,
                    verbose = T,
                    fit=2, # Test for eccentricity amplitude modulation
                    flow=1/24, # Low frequency cut-off for Taner bandpass (half power point; in cycles/ka)
                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                    genplot = T)


Eo2_sim <- astrochron::timeOptSim(dat = Eo2,
                                  sedmin = 0.05,
                                  sedmax = 3,
                                  numsim = 500,
                                  fit=1,
                                  targetP=c(64, 74),
                                  roll=NULL,
                                  output=2,
                                  genplot = T,
                                  verbose = T)

# (Envelope r^2) x (Spectral Power r^2) = 0.213937

# (Envelope r^2) * (Spectral Power r^2) p-value = 0.562

astrochron::timeOpt(dat = Eo2,
                    output = 1,
                    sedmin=0.01,
                    sedmax=3,
                    targetE=c(405.98, 100.21),
                    check = T,
                    verbose = T,
                    fit=2, # Test for eccentricity amplitude modulation
                    flow=1/24, # Low frequency cut-off for Taner bandpass (half power point; in cycles/ka)
                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                    genplot = T)


Eo1_sim <- astrochron::timeOptSim(dat = Eo1,
                                  sedmin = 0.05,
                                  sedmax = 3,
                                  numsim = 500,
                                  fit=1,
                                  targetE=c(405.98, 100.21),
                                  roll=NULL,
                                  output=2,
                                  genplot = T,
                                  verbose = T)

# (Envelope r^2) x (Spectral Power r^2) = 0.01052402
# (Envelope r^2) * (Spectral Power r^2) p-value = 0.162

#### Question 3 ####
# What is your uncertainty on the duration estimate of magnetochron C23r in U1514?

mean(unlist(get_time(Eo3_adm, 250.61))) - mean(unlist(get_time(Eo3_adm, 245.87)))

range(unlist(get_time(Eo3_adm, 250.61)))
range(unlist(get_time(Eo3_adm, 245.87)))
