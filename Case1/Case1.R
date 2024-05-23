require(astrochron)
require(admtools)

case1 <- read.csv2(file = "Case1/IODP_Site_U1514_splice_AlTi.csv",
                   sep = ",")
case1$Al.Ti <- as.numeric(case1$Al.Ti)
case1$Depth.CCSF.A..mcd. <- as.numeric(case1$Depth.CCSF.A..mcd.)

#### Eocene ####

Eocene <- case1[case1$Depth.CCSF.A..mcd. <= 285 & case1$Depth.CCSF.A..mcd. >= 140,]

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

par(mfcol=c(1,2))
plot(Eo_int$Al.Ti,Eo_int$Depth.CCSF.A..mcd., type="l")
abline(h=192.5084, col = "red")
abline(h=206.3406, col = "blue")
plot(Eo_model$y, Eo_model$x, type="l")


#Split into intervals visually

Eo1 <- Eo_int[Eo_int$Depth.CCSF.A..mcd.< 192.5084,]
Eo2 <- Eo_int[Eo_int$Depth.CCSF.A..mcd.>= 192.5084 & Eo_int$Depth.CCSF.A..mcd. <= 206.3406,]
Eo3 <- Eo_int[Eo_int$Depth.CCSF.A..mcd.> 206.3406,]

#### Interval 1 ####

Eo_eto1 <- eTimeOpt(dat = Eo1,
                    win=dt*100,
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

sedrate_adm1 <- get_data_from_eTimeOpt(Eo_eto1, index = 1)

t_tp1 = tp_height_det(heights = 43.32)
h_tp1 = function() {
  h = runif(n = 1, min = 183.04, max = 187.82)
  return(h)
}
sed1 <- sed_rate_from_matrix(height = sedrate_adm1$heights, 
                             sedrate = sedrate_adm1$sed_rate, 
                             matrix = sedrate_adm1$results, 
                             rate = 1)

Eo1_adm <- sedrate_to_multiadm(
  h_tp = h_tp1,
  t_tp = t_tp1,
  sed_rate_gen = sed1,
  h = 100,
  no_of_rep = 100L,
  subdivisions = 100L,
  stop.on.error = F,
  T_unit = "kyr",
  L_unit = "m"
)
