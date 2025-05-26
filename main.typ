#import "lab-report.typ": lab-report
#import "@preview/lilaq:0.3.0" as lq
#import calc: exp, ln, round, sin, pi, pow, sqrt, cos
#import "lib.typ": fit_through_origin

#show: lab-report.with(
  title: "X-Ray Physics",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Yan Xinlin",
  groupnumber: "301",
  date: datetime(day: 21, month: 5, year: 2025),
)

= Measurement Setup and Preparations
== Setup

#figure(
  image("assets/setup.png"),
  caption: [Measurement Setup with following compenents: (a) collimator mount, (b) sensor holder, (c) flat ribbon cable, (d) goniometer guide rods, (e) sensor mount, (f) insertion edge of absorber set l, and (g) goniometer target holder.],
)

== Preparations

/*- Carefully align the guide rod while inserting the collimator into the collimator mount (a).
- Secure the goniometer onto the guide rods (d) before connecting the flat ribbon cable (c) for control.
- Install the window counter tube into the sensor mount (e) and plug its cable into the GM-tube socket in the experimental area.*/
- Remove the goniometer’s target holder (g) to lift off the target table.
- Slide the insertion edge of absorber set 1 (f) into the quarter-circle groove of the target holder until it clicks into place.
/*- Swap out the sensor holder with X-ray energy detector for the holder equipped with the window counter tube.
- Reinstall the target holder carrying absorber set 1.*/
- Press the “Zero” button to set target and sensor to their zero positions.
- Verify (and adjust if needed) the zero position of both the blank aperture in the absorber set and the sensor 
- Finally, slide the goniometer to position the collimator at 5 cm from the blank aperture, then slide the sensor holder (b) to set 5 cm between aperture and sensor slit.

#pagebreak()

== Experiment 1: Attenuation of X-Ray Radiation

#line(stroke: 0.8pt, length: 100%)

=== Objectives
- Investigate the attenuation of X-ray intensity as a function of absorber thickness and material.
- Verify Lambert’s law of exponential attenuation.
- Demonstrate the wavelength dependence of the attenuation coefficient.

=== Theory
When a narrow beam of X-rays of initial count rate $R_0$ passes through an absorber of thickness $x$, the transmitted count rate $R$ satisfies
$
  T = R / R_0
  quad "where" quad
  T(x) = e^(-mu x)
  quad arrow quad
  ln T = -mu x
$
where $mu$ is the linear attenuation coefficient.

=== Procedure
/*+ Mount the collimator and goniometer on the X-ray tube as shown in Fig. 1.
+ Insert the Geiger–Müller detector in the sensor arm and connect via “GM Tube”.*/
+ Align the target (absorber holder) and detector so that the slit-to-target and target-to-detector distances are each $approx 5$ cm.
+ Zero-position both arms with the “Zero” button.

=== Attenuation vs. Absorber Thickness

#line(stroke: 0.8pt, length: 100%)

#let d_mm = (0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0)
#let R_nofilter = (1618, 787.4, 403.5, 226.4, 49.1, 30.55, 16.11)

#align(left)[
  #grid(
    columns: (1fr, 5cm),
    column-gutter: 1cm,
    align: (left, right),
    [
      *Without zirconium filter*
      + Set tube voltage $U=21$ kV, emission current $I=0.05$ mA, measurement time $Delta t=10$ s.

      + Set absorber angles corresponding to the corresponding thicknesses, press *Scan*, wait $Delta t$, then read count rate $R$ via *Replay*.

      + Record in Table 1.
    ],
    figure(caption: [Different thickness of Al, without Zr filter], table(
      columns: (2.5cm, 2.5cm),
      align: (center, center),
      stroke: 0.8pt,
      table.header([d / mm], [R / s⁻¹]),
      ..for (.., d, R) in d_mm.zip(R_nofilter) { ([#d], [#R]) },
    )),
  )
]

#let R_filter = (775.1, 337, 149.8, 72.1, 33.85, 18.6, 7.85)

#align(left)[
  #grid(
    columns: (1fr, 5cm),
    column-gutter: 1cm,
    align: (left, right),
    [
      *With zirconium filter*
      + Mount Zr filter, set $I=0.15$ mA, $Delta t=20$ s.

      + Repeat step 1.1 at the same angles.

      + Record in Table 2.
    ],
    figure(caption: [Different thickness of Al, with Zr filter], table(
      columns: (2.5cm, 2.5cm),
      align: (center, center),
      stroke: 0.8pt,
      table.header([d / mm], [R / s⁻¹]),
      ..for (.., d, R) in d_mm.zip(R_filter) {
        ([#d], [#R])
      },
    )),
  )
]

#pagebreak()

==== Data Analysis
- Compute transmission: $T(d)=R(d)/R(0)$.
- Plot $T(d)$ vs $d$ and $ln T(d)$ vs $d$.
- Fit $ln T(d)=-mu d$ to extract $mu$ for both unfiltered and filtered cases.


#let linear_fit_nofilter = fit_through_origin(d_mm, R_nofilter.map(R => ln(
  R / R_nofilter.first(),
)))

#let linear_fit_filter = fit_through_origin(d_mm, R_filter.map(R => ln(
  R / R_filter.first(),
)))

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    align: (left, right),
    figure(caption: [Transmission as a function of material thickness of Al], lq.diagram(
      title: [Transmission $T(d)$ over thickness $d$],
      width: 7cm,
      height: 6cm,
      lq.plot(stroke: blue + 1pt, mark: none, lq.linspace(0, 3, num: 1000), lq
        .linspace(0, 3, num: 1000)
        .map(x => (
          exp(x * linear_fit_nofilter)
        ))),
      lq.plot(stroke: orange + 1pt, mark: none, lq.linspace(0, 3, num: 1000), lq
        .linspace(0, 3, num: 1000)
        .map(x => (
          exp(x * linear_fit_filter)
        ))),
      lq.plot(
        stroke: none,
        mark-size: 6pt,
        color: blue,
        d_mm,
        R_nofilter.map(p => (
          p / R_nofilter.first()
        )),
      ),
      lq.plot(
        stroke: none,
        mark-size: 6pt,
        color: orange,
        d_mm,
        R_filter.map(p => (
          p / R_filter.first()
        )),
      ),
    )),
    figure(caption: [Semi-logarithmic graph of the transmission as a function of material thickness of Al], lq.diagram(
      title: [ln $T(d)$ over thickness $d$],
      width: 7cm,
      height: 6cm,
      yaxis: (position: right, mirror: true),
      lq.plot(
        stroke: blue + 1pt,
        mark: none,
        label: $mu_"nofilter" approx #round(-linear_fit_nofilter, digits: 2)$,
        lq.linspace(0, 3, num: 1000),
        lq
          .linspace(0, 3, num: 1000)
          .map(x => (
            x * linear_fit_nofilter
          )),
      ),
      lq.plot(
        stroke: orange + 1pt,
        mark: none,
        label: $mu_"filter" approx #round(-linear_fit_filter, digits: 2)$,
        lq.linspace(0, 3, num: 1000),
        lq
          .linspace(0, 3, num: 1000)
          .map(x => (
            x * linear_fit_filter
          )),
      ),
      lq.plot(
        stroke: none,
        mark-size: 6pt,
        color: blue,
        d_mm,
        R_nofilter.map(R => (
          ln(R / R_nofilter.first())
        )),
      ),
      lq.plot(
        stroke: none,
        mark-size: 6pt,
        color: orange,
        d_mm,
        R_filter.map(R => (
          ln(R / R_filter.first())
        )),
      ),
    )),
  )]





=== Dependence of attenuation on the absorber material

#line(stroke: 0.8pt, length: 100%)

#let d = 3e-3 // in mm
#let materials = ("empty (0°)", "C(10°)", "Al(20°)", "Fe(30°)", "Cu(40°)", "Zr(50°)", "Ag(60°)")
#let Zvals = (0, 6, 13, 26, 29, 40, 47)
#let Ivals = (0.02, 0.02, 0.02, 1.00, 1.00, 1.00, 1.00)
#let tvals = (30, 30, 30, 300, 300, 300, 300)
#let R_nofilter_mat = (
  1791 * 50,
  1701 * 50,
  1083 * 50,
  147.1 * 50,
  15.55,
  181.8,
  56.65,
)

#let T_nofilter = R_nofilter_mat.map(v => v / R_nofilter_mat.first())
#let mu_nofilter = T_nofilter.map(v => -ln(v) / d)

*Without zirconium filter*

+ Dismount the absorber set 1 in the target holder and mount the absorber set 2.

+ Detach Zr filter again, set tube voltage $U=30$ kV, emission current $I=0.02$ mA, measurement time $Delta t=10$ s for C, Al and no absorber.

+ Set tube voltage $U=30$ kV, emission current $I=1$ mA, measurement time $Delta t=20$ s for Fe, Cu, Zr and Ag.

+ Set absorber angles corresponding to the chosen absorber material, press *Scan*, wait $Delta t$, then read count rate $R$ via *Replay*.

+ Record in Table 3. Adjust the measurements of C, Al and no absorber by multiplying with 50, since the current in the measurements differed. 
    
#figure(caption: [Different materials with thickness of 0.5mm, without Zr filter], table(
      columns: (auto, auto, auto, auto, auto, auto, auto),

      align: (center, center, center, center, center),
      stroke: 0.8pt,
      table.header(
        [Absorber],
        [Z],
        $I / "mA"$,
        $(Delta t) / "s"$,
        $R / "hz"$,
        [T],
        $mu / "cm"^(-1)$,
      ),
      ..for (.., mat, Z, I, t, R, T, mu) in materials
        .zip(Zvals)
        .zip(Ivals)
        .zip(tvals)
        .zip(R_nofilter_mat)
        .zip(T_nofilter)
        .zip(mu_nofilter)
        .map(line => line.flatten()) {
        (
          [#mat],
          [#Z],
          [#I],
          [#t],
          [#R],
          [#round(T, digits: 3)],
          [#round(mu)],
        )
      },
    )),

    
#let R_filter_mat = (
  738.3 * 50,
  694.6 * 50,
  390.9 * 50,
  51.7 * 50,
  5.7,
  107.3,
  12.05,
)

#let T_filter = R_filter_mat.map(v => v / R_filter_mat.first())
#let mu_filter = T_filter.map(v => -ln(v) / d)

#align(center)[
  #grid(
    columns: (1fr, 9cm),
    align: (left, right),
    column-gutter: 1cm,
    [
      *With zirconium filter*
     
      + Mount Zr filter and repeat the previous measuring procedure.

      + Record in Table 4. Adjust the measurements of C, Al and no absorber by multiplying with 50, since the current in the measurements differed.

    ],
    figure(caption: [Different materials with thickness of 0.5mm, without Zr filter], table(
      columns: (auto, auto, auto, auto, auto, auto, auto),
      align: (center, center, center, center, center),
      stroke: 0.8pt,
      table.header(
        [Absorber],
        [Z],
        $I / "mA"$,
        $(Delta t) / "s"$,
        $R / "hz"$,
        [T],
        $mu / "cm"^(-1)$,
      ),
      ..for (.., mat, Z, I, t, R, T, mu) in materials
        .zip(Zvals)
        .zip(Ivals)
        .zip(tvals)
        .zip(R_filter_mat)
        .zip(T_filter)
        .zip(mu_filter)
        .map(line => line.flatten()) {
        (
          [#mat],
          [#Z],
          [#I],
          [#t],
          [#R],
          [#round(R / R_filter_mat.first(), digits: 3)],
          [#round(mu)],
        )
      },
    )),
  )
]

// #let growth_factor_nofilter = fit_through_origin(Zvals.slice(1, -2), mu_nofilter
//   .slice(1, -2)
//   .map(mu => ln(mu)))

// #let growth_factor_filter = fit_through_origin(Zvals.slice(1, -2), mu_filter
//   .slice(1, -2)
//   .map(mu => ln(mu)))
//
==== Measuring of the Zero Effect

+ Set tube voltage $U=0$ kV, emission current $I=0.0$ mA, measurement time $Delta t=300$.
+ Set all angles to the zero position and press *Scan*, wait $Delta t$, then read count rate $R$ via *Replay*.

#align(center)[
  Zero effect: \ $R_"zero" = 0.174 "hz"$
]

==== Data Analysis
#let border = 29

#figure(
  caption: [
    Linear attenuation coefficient $mu$ as a function of the absorber’s atomic number Z
  ],
  lq.diagram(
    width: 10cm,
    height: 6cm,
    ylabel: $mu(Z) "in" 1/"cm"$,
    xlabel: [Absorber atomic-number $Z$],
    lq.plot(stroke: none, mark-size: 6pt, color: blue, Zvals, mu_filter),
    lq.plot(stroke: none, mark-size: 6pt, color: orange, Zvals, mu_nofilter),
  ),
)

#v(1cm)

#pagebreak()

== Experiment 2: Bragg Reflection

#line(stroke: 0.8pt, length: 100%)

=== Objectives
- Investigate the Bragg reflection of Mo K‑characteristic X‑rays on a NaCl single crystal.
- Determine the wavelengths of the $K_α$ and $K_β$ lines up to third order diffraction.
- Confirm Bragg’s law and the wave nature of X‑radiation.

=== Theory
When X‑rays hit parallel crystal planes spaced by distance $d$, constructive interference occurs at angles $θ$ satisfying Bragg’s law:

$
   sin θ = n λ / (2d)
$

where $n$ is the diffraction order, $d$ is the distance between the parallel crystal planes and $λ$ is the wavelength.

=== Procedure
+ Connect PC via USB, start the “X‑ray Device” software, select automatic scan mode.
+ Detach Zr filter.
+ Mount the probe table on the target holder, put the NaCl crystal on the table and position table with the crystal at the horizontal groove of the target holder.
+ Set distance between collimator and crystal to 4cm and between crystal and detector to 9cm.
+ Set parameters: tube voltage $U = 35$kV, current $I = 1.00$ mA, measurement time $Delta t = 10$ s, angle step $Delta β = 0.1°$; press COUPLED; set scan range $β_"min" = 2.5°$, $β_"max" = 30°$.
+ Start scan to record the spectrum; save data with F2.
+ Identify peak angles $θ$ for $K_α$ and $K_β$ lines at orders $n=1,2,3$ and record in tables.
+ Calculate wavelengths via $λ = 2d sin θ$ using $d = 282.01$ pm.

=== Data Analysis

#figure(caption: [Diffraction spectrum of X-ray radiation in Bragg reflection up to the third order from a NaCl single crystal], image(width: 10cm, "assets/NaCl.JPG"))

#let lambda_error(beta, del_beta, num) = {
  round((2*282)/num * cos(beta/360 * 2 * pi) * del_beta, digits: 2)
}

#let nums = (1, 2, 3)
#let alpha_lambdas = (70.2, 70.66, 71.1)
#let alpha_betas = (7.15, 14.51, 22.22)
#let alpha_delta_betas = (0.09, 0.13, 0.09)

#let alpha_delta_lambdas = nums.zip(alpha_betas.zip(alpha_delta_betas)).map(x => x.flatten()).map(x => lambda_error(x.at(1), x.at(2), x.at(0)))


#let weighted_mean(lambdas, delta_lambdas) = {
  let enuma = lambdas.zip(delta_lambdas).map(x => x.first() / pow(x.last(),2) ).sum()
  
  let denom = delta_lambdas.map(x => 1/pow(x, 2)).sum()

  (round(enuma / denom, digits: 2), round(sqrt(1/denom), digits: 2))
}

#let alpha_lambda_mean = weighted_mean(alpha_lambdas, alpha_delta_lambdas)

#let beta_lambdas = (62.28, 63.25, 63.25)
#let beta_betas = (6.34, 12.96, 19.66)
#let beta_delta_betas = (0.09, 0.07, 0.05)

#let beta_delta_lambdas = nums.zip(beta_betas.zip(beta_delta_betas)).map(x => x.flatten()).map(x => lambda_error(x.at(1), x.at(2), x.at(0)))

#let beta_lambda_mean = weighted_mean(beta_lambdas, beta_delta_lambdas)

#grid(
    columns: (1fr, 1fr),
    column-gutter: 1cm,
  figure(
  caption: [Measured glancing angles of the Mo $K_alpha$ line and the wavelengths $lambda$ calculated therefrom for the first through third diffraction orders.],
  table(
    columns: (auto, auto, auto),
    rows: 0.8cm,
    align: horizon,
    table.header(
      $n$, $beta(K_alpha)/degree$, $lambda(K_alpha)/"pm"$,
    ),
    [1], $7.15 plus.minus 0.09$, $70.2 plus.minus #lambda_error(7.15, 0.09, 1)$,
    [2], $14.51 plus.minus 0.13$, $70.66 plus.minus #lambda_error(14.51, 0.13, 2)$,
    [3], $22.22 plus.minus 0.09$, $71.1 plus.minus #lambda_error(22.22, 0.09, 3)$,
  )),
  figure(
  caption: [Measured glancing angles of the Mo $K_beta$ line and the wavelengths $lambda$ calculated therefrom for the first through third diffraction orders.],
  table(
    columns: (auto, auto, auto),
    rows: 0.8cm,
    align: horizon,
    table.header(
      $n$, $beta(K_beta)/degree$, $lambda(K_beta)/"pm"$,
    ),
    [1], $6.34 plus.minus 0.09$, $62.28 plus.minus #lambda_error(6.34, 0.09, 1)$,
    [2], $12.96 plus.minus 0.07$, $63.25 plus.minus #lambda_error(12.96, 0.07, 2)$,
    [3], $19.66 plus.minus 0.05$, $63.25 plus.minus #lambda_error(19.66, 0.05, 3)$,
  )),
)

The following mean value and its error is calculated using a weighted mean:
$
  lambda plus.minus sigma_lambda= (sum_i x_i/sigma_i^2) /( sum_i 1/sigma_i^2)
  quad "where" quad
  sigma_lambda = ( sum_i 1/sigma_i^2)^(-1/2)
$

#figure(
  caption: [Mean value and literature value of the characteristic wavelength $lambda$.],
  table(
    columns: (auto, auto, auto),
    rows: 0.8cm,
    align: horizon,
    table.header(
      [],  $lambda(K_alpha)/"pm"$, $lambda(K_beta)/"pm"$,
    ),
    [Mean Value], $#alpha_lambda_mean.first() plus.minus #alpha_lambda_mean.last()$, $#beta_lambda_mean.first() plus.minus #beta_lambda_mean.last()$,
    [Literature Value], [71.08], [63.09],
  )
)

=== Conclusions
Measured wavelengths agree with literature and validate Bragg’s law and the wave character of X‑rays.

#pagebreak()

== Experiment 3: Duane–Hunt Law and Planck’s Constant

#line(stroke: 0.8pt, length: 100%)

=== Objectives
- Determine the cutoff wavelength $λ_"min"$ of the Bremsstrahlung continuum as a function of tube voltage $U$.
- Verify the Duane–Hunt relation $λ_"min" = (h c)/(e U)$.
- Extract Planck’s constant $h$ from the slope of $λ_"min"$ vs $1/U$.

=== Theory
Complete conversion of electron kinetic energy into photon energy gives:

$
  lambda_"min" = (h c)/(e U)
$

where $e$ is the elementary charge and $c$ the speed of light.

=== Procedure
+ Adjust the distance between crystal and detector to 7cm, to intensify the detected radiation.
+ Set parameters: For tube voltages $U=22,24,26,28,30,32,34,35$ kV at $I=1.00$ mA, set measurement time and angle range as in Table 8.
+ Perform automatic scans; save each spectrum.
+ In Planck mode, determine $λ_"min"$ for each $U$.
+ Plot $lambda_"min"$ vs. $1/U$ and fit a line through the origin; extract slope $A$.

#figure(
  caption: [Parameters used for experiment 3],
  grid(
    columns: (10cm),
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    rows: 0.7cm,
    align: horizon,
    table.header(
      $U/"kV"$, $I/"mA"$, $(Delta t)/"s"$, $beta_"min"/degree$, $beta_"max"/degree$, $(Delta beta)/degree$
    ),
    [22], [1.00], [30], [5.2], [6.2], [0.1],
    [24], [1.00], [30], [5.0], [6.2], [0.1],
    [26], [1.00], [20], [4.5], [6.2], [0.1],
    [28], [1.00], [20], [3.8], [6.0], [0.1],
    [30], [1.00], [10], [3.2], [6.0], [0.1],
    [32], [1.00], [10], [2.5], [6.0], [0.1],
    [34], [1.00], [10], [2.5], [6.0], [0.1],
    [35], [1.00], [10], [2.5], [6.0], [0.1],
  ),
)
)



=== Data Analysis

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1cm,
  figure(caption: [Sections of the X-ray diffraction spectra with fitted straight lines for determining the cutoff wavelength $lambda_"min"$], image("assets/NaCl_3.JPG")),
  figure(caption: [Analysis of the data $lambda_"min" = f(1/U)$ to confirm the Duane–Hunt displacement law and to determine Planck’s constant], image("assets/NaCl_3_plank.JPG"))
)

From the linear fit one obtains from which the corresponding planks constant can be calculated:
$
  A = 1137 plus.minus 112 "pm kV" quad arrow quad h = A dot e/c = 6.08 plus.minus 0.6 dot 10^(-24)"Js"
$

Literature value:
$
  h = 6.626 dot 10^(-24) "Js"
$

=== Conclusions
The Duane–Hunt law is confirmed, and the measured Planck constant agrees closely with the literature value.

=== Error Approximation

Measuring with a Geiger Müller Counter the counts follow the possion statistics. With a Zero effect of $R_"zero" = 0.174 "hz"$ the error of the counts in this experiment can be approximated with up to $plus.minus 12.74 " counts"/s$. The dead time is also causing an error to the measurement, but are negligible here since our measured rates are relatively small.
Further can the angles of the be determined with an error of $plus.minus$ 0,1°. 
