use std::ops;

pub struct Vector2 {
  pub x: f32,
  pub y: f32
}

impl Vector2 {
  pub fn new(x: f32, y: f32) -> Self {
    Self { x: x, y: y }
  }

  pub fn set(&mut self, x: f32, y: f32) {
    self.x = x;
    self.y = y;
  }

  pub fn len(&self) -> f64 {
    let dot = self.x * self.x + self.y * self.y;
    return (dot as f64).sqrt();
  }
}

// Operator Overloading:
impl ops::Neg for Vector2 {
  type Output = Self;

  fn neg(self) -> Self {
    Self {
      x: -self.x,
      y: -self.y
    }
  }
}

impl ops::AddAssign for Vector2 {
  fn add_assign(&mut self, other: Self) {
    self.x += other.x;
    self.y += other.y;
  }
}

impl ops::SubAssign for Vector2 {
  fn sub_assign(&mut self, other: Self) {
    self.x -= other.x;
    self.y -= other.y;
  }
}

impl ops::MulAssign<f32> for Vector2 {
  fn mul_assign(&mut self, amount: f32) {
    self.x *= amount;
    self.y *= amount;
  }
}
