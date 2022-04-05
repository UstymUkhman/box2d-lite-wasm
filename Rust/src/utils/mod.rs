use std::ops;

pub mod vec2;
pub mod mat4;
pub mod math;
pub mod rand;
pub mod cross;

use vec2::Vector2;
use mat4::Matrix4;

// Vector2 = Vector2 * Matrix4
impl ops::Mul<Matrix4> for Vector2 {
  type Output = Self;

  fn mul(self, mat: Matrix4) -> Self {
    Self {
      x: mat.col1.x * self.x + mat.col2.x * self.y,
      y: mat.col1.y * self.x + mat.col2.y * self.y
    }
  }
}
