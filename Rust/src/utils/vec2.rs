use std::ops;

// Vector2 { x: f32, y: f32 }
#[derive(Copy, Clone)]
pub struct Vector2 {
  pub x: f32,
  pub y: f32
}

impl Vector2 {
  // Vector2::new(f32, f32)
  pub fn new(x: f32, y: f32) -> Self {
    Self { x: x, y: y }
  }

  // Vector2.set(f32, f32)
  pub fn set(&mut self, x: f32, y: f32) {
    self.x = x;
    self.y = y;
  }

  // Vector2 = Vector2.abs()
  pub fn abs(&mut self) -> Self {
    Self {
      x: self.x.abs(),
      y: self.y.abs()
    }
  }

  // f32 = Vector2.len()
  pub fn len(&self) -> f32 {
    (self.x * self.x + self.y * self.y).sqrt()
  }
}

/**
 * Operator Overloading
 */

// Vector2 = -Vector2
impl ops::Neg for Vector2 {
  type Output = Self;

  fn neg(self) -> Self {
    Self {
      x: -self.x,
      y: -self.y
    }
  }
}

// Vector2 = Vector2 + Vector2
impl ops::Add for Vector2 {
  type Output = Self;

  fn add(self, other: Self) -> Self {
    Self {
      x: self.x + other.x,
      y: self.y + other.y
    }
  }
}

// Vector2 += Vector2
impl ops::AddAssign for Vector2 {
  fn add_assign(&mut self, other: Self) {
    self.x += other.x;
    self.y += other.y;
  }
}

// Vector2 = Vector2 - Vector2
impl ops::Sub for Vector2 {
  type Output = Self;

  fn sub(self, other: Self) -> Self {
    Self {
      x: self.x - other.x,
      y: self.y - other.y
    }
  }
}

// Vector2 -= Vector2
impl ops::SubAssign for Vector2 {
  fn sub_assign(&mut self, other: Self) {
    self.x -= other.x;
    self.y -= other.y;
  }
}

// Vector2 = Vector2 * f32
impl ops::Mul<f32> for Vector2 {
  type Output = Self;

  fn mul(self, other: f32) -> Self {
    Self {
      x: self.x * other,
      y: self.y * other
    }
  }
}

// Vector2 *= f32
impl ops::MulAssign<f32> for Vector2 {
  fn mul_assign(&mut self, amount: f32) {
    self.x *= amount;
    self.y *= amount;
  }
}
