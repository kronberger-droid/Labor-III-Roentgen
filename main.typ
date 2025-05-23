#import "lab-report.typ": lab-report
#import "@preview/lilaq:0.3.0" as lq
#import calc: exp, ln, round
#show: lab-report.with(
  title: "Röntgen",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Someone",
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

- Carefully align the guide rod while inserting the collimator into the collimator mount (a).
- Secure the goniometer onto the guide rods (d) before connecting the flat ribbon cable (c) for control.
- After removing the protective cap, install the window counter tube into the sensor mount (e) and plug its cable into the GM-tube socket in the experimental area.
- Remove the goniometer’s target holder (g) to lift off the target table.
- Slide the insertion edge of absorber set l (f) into the quarter-circle groove of the target holder until it clicks into place.
- Swap out the sensor holder with X-ray energy detector for the holder equipped with the window counter tube.
- Reinstall the target holder carrying absorber set l.
- Press the “Zero” button to set target and sensor to their null positions.
- Verify (and adjust if needed) the zero position of both the blank aperture in the absorber set and the sensor (see “Setting the measurement zero position” in the X-ray manual).
- Finally, slide the goniometer to position the collimator at ~5 cm from the blank aperture, then slide the sensor holder (b) to set ~5 cm between aperture and sensor slit. = Dependence of attenuation on absorber thickness

#pagebreak()

== Experiment 1: Attenuation of X-Ray Radiation

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

=== Setup
+ Mount the collimator and goniometer on the X-ray tube as shown in Fig. 1.
+ Insert the Geiger–Müller detector in the sensor arm and connect via “GM Tube”.
+ Align the target (absorber holder) and detector so that the slit-to-target and target-to-detector distances are each $approx 5$ cm.
+ Zero-position both arms with the “Zero” button.

=== Attenuation vs. Absorber Thickness

==== Without zirconium filter

#let d_mm = (0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0)
#let R_nofilter = (1618, 787.4, 403.5, 226.4, 49.1, 30.55, 16.11)

#align(left)[
  #grid(
    columns: (9cm, auto),
    column-gutter: 2cm,
    align: (left, right),
    [
      + Set tube voltage $U=21$ kV, emission current $I=0.05$ mA, measurement time $Delta t=100$ s.

      + Set absorber angles corresponding to the corresponding thicknesses, press *Scan*, wait $Delta t$, then read count rate $R$ via *Replay*.

      + Record in Table 1.
    ],
    figure(caption: [Some Caption], table(
      columns: (2cm, 2cm),
      align: (center, center),
      stroke: 0.8pt,
      table.header([d / mm], [R / s⁻¹]),
      ..for (.., d, R) in d_mm.zip(R_nofilter) { ([#d], [#R]) },
    )),
  )
]

==== With zirconium filter

#let R_filter = (775.1, 337, 149.8, 72.1, 33.85, 18.6, 7.85)

#align(left)[
  #grid(
    columns: (9cm, auto),
    column-gutter: 2cm,
    align: (left, right),
    [
      + Mount Zr filter, set $I=0.15$ mA, $Delta t=200$ s.

      + Repeat step 1.1 at the same angles.

      + Record in Table 2.
    ],
    figure(caption: [Some caption], table(
      columns: (2cm, 2cm),
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

=== Data Analysis
- Compute transmission: $T(d)=R(d)/R(0)$.
- Plot $T(d)$ vs $d$ and $ln T(d)$ vs $d$.
- Fit $ln T(d)=-mu d$ to extract $mu$ for both unfiltered and filtered cases.

#let linear_fit(xs, ys) = {
  assert(xs.len() == ys.len())
  let n = xs.len()
  let sx = xs.sum()
  let sy = ys.sum()
  let sxy = xs.zip(ys).map(p => p.product()).sum()
  let sx2 = xs.map(x => x * x).sum()

  let m = (n * sxy - sx * sy) / (n * sx2 - sx * sx)
  let c = (sy - m * sx) / n

  (m, c)
}

#let fit_through_origin(xs, ys) = {
  assert(xs.len() == ys.len())
  let sxy = xs.zip(ys).map(p => p.product()).sum()
  let sx2 = xs.map(x => x * x).sum()
  sxy / sx2
}

#let linear_fit_nofilter = fit_through_origin(d_mm, R_nofilter.map(R => ln(
  R / R_nofilter.first(),
)))

#let linear_fit_filter = fit_through_origin(d_mm, R_filter.map(R => ln(
  R / R_filter.first(),
)))

#align(center)[
  #grid(
    columns: (auto, auto),
    column-gutter: 0.5cm,
    align: center,
    figure(caption: [], lq.diagram(
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
    figure(caption: [], lq.diagram(
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





#pagebreak()

=== Dependence of attenuation on the absorber material

==== Without zirconium filter

#let d = 3e-3 // in mm
#let materials = ("leer", "C", "Al", "Fe", "Cu", "Zr", "Ag")
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
#let R_filter_mat = (
  738.3 * 50,
  694.6 * 50,
  390.9 * 50,
  51.7 * 50,
  5.7,
  107.3,
  12.05,
)

#let T_nofilter = R_nofilter_mat.map(v => v / R_nofilter_mat.first())
#let T_filter = R_filter_mat.map(v => v / R_filter_mat.first())
#let mu_nofilter = T_nofilter.map(v => -ln(v) / d)
#let mu_filter = T_filter.map(v => -ln(v) / d)

#align(center)[
  #figure(caption: [Some caption], table(
    columns: (3cm, 1cm, 1.5cm, 1.5cm, 3cm, 2cm, 2cm),
    align: (center, center, center, center, center),
    stroke: 0.8pt,
    table.header(
      [Absorber],
      [Z],
      [I / mA],
      [Δt / s],
      [R / s⁻¹],
      [T],
      [#sym.mu / $"cm"^(-1)$ ],
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
  ))
]

==== With a zirconium filter

#align(center)[
  #figure(caption: [Some caption], table(
    columns: (3cm, 1cm, 1.5cm, 1.5cm, 3cm, 2cm, 2cm),
    align: (center, center, center, center, center),
    stroke: 0.8pt,
    table.header(
      [Absorber],
      [Z],
      [I / mA],
      [Δt / s],
      [R / s⁻¹],
      [T],
      [#sym.mu / $"cm"^(-1)$ ],
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
  ))
]

#figure(caption: [Some caption], lq.diagram(
  width: 10cm,
  height: 6cm,
  lq.plot(stroke: none, Zvals, mu_filter),
  lq.plot(stroke: none, Zvals, mu_nofilter),
))

==== Measurement of the Zeroeffect




#pagebreak()

== Experiment 2: Bragg Reflection

=== Objectives
- Investigate the Bragg reflection of Mo K‑characteristic X‑rays on a NaCl single crystal.
- Determine the wavelengths of the Kα and Kβ lines up to third order diffraction.
- Confirm Bragg’s law and the wave nature of X‑radiation.

=== Theory
When X‑rays hit parallel crystal planes spaced by distance $d$, constructive interference occurs at angles $θ$ satisfying Bragg’s law:

$
  n sin θ = n λ / (2d)
$

where $n$ is the diffraction order and $λ$ is the wavelength.

=== Apparatus
- X‑ray tube with collimator mount and goniometer guide rods.
- Geiger–Müller detector in the sensor mount.
- NaCl single crystal fixed on the crystal stage.
- Distances: collimator–crystal ≈ 5 cm; crystal–detector ≈ 6 cm.
=== Procedure
+ Connect PC via USB, start the “X‑ray Device” software, select automatic scan mode.
+ Set parameters: tube voltage $U = 35$kV, current $I = 1.00$ mA, measurement time $Delta t = 10$ s, angle step $Delta β = 0.1°$; press COUPLED; set scan range $β_"min" = 2.5°$, $β_"max" = 30°$.
+ Start scan to record the spectrum; save data with F2.
+ Identify peak angles $θ$ for Kα and Kβ lines at orders $n=1,2,3$ and record in tables.
+ Calculate wavelengths via $λ = 2d sin θ$ using $d = 282.01$ pm.

=== Results

#figure(caption: [Some Caption], image(width: 12cm, "assets/NaCl.JPG"))

=== Conclusions
Measured wavelengths agree with literature and validate Bragg’s law and the wave character of X‑rays.

#pagebreak()

== Experiment 3: Duane–Hunt Law and Planck’s Constant

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
=== Apparatus
- Same goniometer and NaCl crystal setup as in Experiment 2.
- “X‑ray Device” software with Planck‑mode register.
- Geiger–Müller detector.

=== Procedure
+ For tube voltages $U=22,24,26,28,30,32,34,35$ kV at $I=1.00$ mA, set measurement time and angle range as in Table 1.
+ Perform automatic scans; save each spectrum.
+ In Planck mode, determine $λ_"min"$ for each $U$.
+ Plot $lambda_"min"$ vs. $1/U$ and fit a line through the origin; extract slope $A$.


=== Results
#figure(caption: [Some Caption], image(width: 9cm, "assets/NaCl_3.JPG"))

#figure(caption: [Some Caption], image(width: 9cm, "assets/NaCl_3_plank.JPG"))


$
  A = 1137 "pm kV"
$
=== Conclusions
The Duane–Hunt law is confirmed, and the measured Planck constant agrees closely with the literature value.


Planks konstant as a wavelenth-voltage factor is about $1240$ pm kV
