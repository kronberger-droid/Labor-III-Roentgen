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
