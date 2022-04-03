extern crate rand;

// use rand::Rng;
use super::vec2::Vector2;

/* pub struct Cross;

trait Prod<Args> {
  type Output;
  fn prod(args: Args) -> Self::Output;
}

impl Prod<(&Vector2, &Vector2)> for Cross {
  type Output = f32;

  #[inline] // Cross::prod((&Vector2, &Vector2))
  fn prod(args: (&Vector2, &Vector2)) -> f32 {
    args.0.x * args.1.y - args.0.y * args.1.x
  }
}

impl Prod<(&Vector2, f32)> for Cross {
  type Output = Vector2;

  #[inline] // Cross::prod((&Vector2, f32))
  fn prod(args: (&Vector2, f32)) -> Vector2 {
    Vector2::new(args.1 * args.0.y, -args.1 * args.0.x)
  }
}

impl Prod<(f32, &Vector2)> for Cross {
  type Output = Vector2;

  #[inline] // Cross::prod((f32, &Vector2))
  fn prod(args: (f32, &Vector2)) -> Vector2 {
    Vector2::new(-args.0 * args.1.y, args.0 * args.1.x)
  }
}

#[inline]
pub fn random() -> f32 {
  let mut rng = rand::thread_rng();
  return rng.gen_range(-1.0..1.0);
}

#[inline]
pub fn random(low: f32, high: f32) -> f32 {
  let mut rng = rand::thread_rng();
  return rng.gen_range(low..high);
} */

#[inline]
pub fn min(a: f32, b: f32) -> f32 {
  return if a < b { a } else { b };
}

#[inline]
pub fn max(a: f32, b: f32) -> f32 {
  return if a > b { a } else { b };
}

#[inline]
pub fn clamp(x: f32, low: f32, high: f32) -> f32 {
  return max(low, min(x, high));
}

#[inline]
pub fn dot(a: &Vector2, b: &Vector2) -> f32 {
  a.x * b.x + a.y * b.y
}

#[inline]
pub fn swap<T>(a: &T, b: &T) {
  let (a, b) = (b, a);
}

#[inline]
pub fn sign(x: f32) -> f32 {
  return if x < 0.0 { -1.0 } else { 1.0 };
}
