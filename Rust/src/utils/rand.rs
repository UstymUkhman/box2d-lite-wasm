extern crate rand;

use rand::Rng;

pub struct Rand {
  low: f32,
  high: f32
}

impl Default for Rand {
  #[inline]
  fn default() -> Self {
    Rand { low: -1.0, high: 1.0 }
  }
}

impl From<()> for Rand {
  #[inline] // rand::random(())
  fn from(_: ()) -> Self {
    Self::default()
  }
}

impl From<(f32, f32)> for Rand {
  #[inline] // rand::random((f32, f32))
  fn from((low, high): (f32, f32)) -> Self {
    Self { low, high }
  }
}

#[inline]
pub fn random<A>(range: A) -> f32 where A: Into<Rand> {
  let args = range.into();
  let mut rng = rand::thread_rng();
  return rng.gen_range(args.low..args.high);
}
