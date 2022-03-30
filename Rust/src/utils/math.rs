use super::vec2::Vector2;

#[inline]
pub fn dot(a: &Vector2, b: &Vector2) -> f32 {
  a.x * b.x + a.y * b.y
}

pub struct Cross;

trait Prod<Args> {
  type Output;
  fn prod(args: Args) -> Self::Output;
}

impl Prod<(&Vector2, &Vector2)> for Cross {
  type Output = f32;

  #[inline] // Cross::prod((&Vector2, &Vector2))
  fn prod(args: (&Vector2, &Vector2)) -> f32 {
    (*args.0).x * (*args.1).y - (*args.0).y * (*args.1).x
  }
}

impl Prod<(&Vector2, f32)> for Cross {
  type Output = Vector2;

  #[inline] // Cross::prod((&Vector2, f32))
  fn prod(args: (&Vector2, f32)) -> Vector2 {
    Vector2::new(args.1 * (*args.0).y, -args.1 * (*args.0).x)
  }
}

impl Prod<(f32, &Vector2)> for Cross {
  type Output = Vector2;

  #[inline] // Cross::prod((f32, &Vector2))
  fn prod(args: (f32, &Vector2)) -> Vector2 {
    Vector2::new(-args.0 * (*args.1).y, args.0 * (*args.1).x)
  }
}
