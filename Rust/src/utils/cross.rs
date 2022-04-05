pub struct Cross;

use super::vec2::Vector2;

pub trait Prod<A, B> {
  type Output;
  fn prod(a: A, b: B) -> Self::Output;
}

impl Prod<&Vector2, &Vector2> for Cross {
  type Output = f32;

  #[inline] // Cross::prod((&Vector2, &Vector2))
  fn prod(a: &Vector2, b: &Vector2) -> f32 {
    a.x * b.y - a.y * b.x
  }
}

impl Prod<&Vector2, f32> for Cross {
  type Output = Vector2;

  #[inline] // Cross::prod((&Vector2, f32))
  fn prod(a: &Vector2, b: f32) -> Vector2 {
    Vector2::new(b * a.y, -b * a.x)
  }
}

impl Prod<f32, &Vector2> for Cross {
  type Output = Vector2;

  #[inline] // Cross::prod((f32, &Vector2))
  fn prod(a: f32, b: &Vector2) -> Vector2 {
    Vector2::new(-a * b.y, a * b.x)
  }
}
