#import "lab-report.typ": lab-report
#import "@preview/lilaq:0.3.0" as lq
#import calc: ln, round

#show: lab-report.with(
  title: "Röntgen",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Someone",
  groupnumber: "301",
  date: datetime(day: 21, month: 5, year: 2025),
)

#set heading(numbering: "1.1")

= Measurement Setup and Preparations \
#text([*Setup*], size: 14pt)

#figure(
  image("assets/setup.png"),
  caption: [Measurement Setup with following compenents: (a) collimator mount, (b) sensor holder, (c) flat ribbon cable, (d) goniometer guide rods, (e) sensor mount, (f) insertion edge of absorber set l, and (g) goniometer target holder.],
)\
#text([*Preparations*], size: 14pt)

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

= Dependence of attenuation on absorber thickness

== Measurement without a zirconium filter

#let d_mm = (0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0)
#let R_nofilter = (1618, 787.4, 403.5, 226.4, 49.1, 30.55, 16.11)
#let R_0 = R_nofilter.first()

#align(center)[
  #figure(caption: [Some Caption], table(
    columns: (4cm, 4cm),
    align: (center, center),
    stroke: 0.8pt,
    table.header([d / mm], [R / s⁻¹]),
    ..for (.., d, R) in d_mm.zip(R_nofilter) {
      ([#d], [#R])
    },
  ))
]

== Measurement with a zirconium filter

#let R_filter = (969.4, 426.1, 197.3, 84.29, 40.51, 19.48, 9.52)

#align(center)[
  #figure(caption: [Some caption], table(
    columns: (4cm, 4cm),
    align: (center, center),
    stroke: 0.8pt,
    table.header([d / mm], [R / s⁻¹]),
    ..for (.., d, R) in d_mm.zip(R_filter) {
      ([#d], [#R])
    },
  ))
]

=== Measurement Results

#figure(caption: [Some Caption], lq.diagram(
  width: 10cm,
  height: 6cm,
  lq.plot(d_mm, R_nofilter.map(p => p / R_nofilter.first())),
  lq.plot(d_mm, R_filter.map(p => p / R_filter.first())),
))

#figure(caption: [Some Caption], lq.diagram(
  width: 10cm,
  height: 6cm,
  yscale: "log",
  lq.plot(d_mm, R_nofilter.map(p => p / R_nofilter.first())),
  lq.plot(d_mm, R_filter.map(p => p / R_filter.first())),
))

#pagebreak()

= Dependence of attenuation on the absorber material

== Measurement without zirconium filter

#let d = 3e-3 // in mm
#let materials = ("leer", "C", "Al", "Fe", "Cu", "Zr", "Ag")
#let Zvals = (0, 6, 13, 26, 29, 40, 47)
#let Ivals = (0.02, 0.02, 0.02, 1.00, 1.00, 1.00, 1.00)
#let tvals = (30, 30, 30, 300, 300, 300, 300)
#let R_nofilter_mat = (1841, 1801, 1164, 93.3, 16.63, 194.3, 106)
#let R_filter_mat = (718.3, 698.4, 406.1, 29.24, 6.016, 113.9, 24.52)
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

== Measurement with a zirconium filter

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

== Measurement of the Zeroeffect
