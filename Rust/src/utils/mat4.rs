use super::vec2::Vector2;

pub struct Matrix4 {
  pub col1: Vector2,
  pub col2: Vector2
}

impl Matrix4 {
  pub fn from_angle(angle: f32) -> Matrix4 {
    let angle_cos = angle.cos();
    let angle_sin = angle.sin();

    let col1 = Vector2::new( angle_cos, angle_sin);
    let col2 = Vector2::new(-angle_sin, angle_cos);

    Matrix4 {
      col1: col1,
      col2: col2
    }
  }

  pub fn from_vectors(col1: &Vector2, col2: &Vector2) -> Matrix4 {
    Matrix4 {
      col1: Vector2 { x: col1.x, y: col1.y },
      col2: Vector2 { x: col2.x, y: col2.y }
    }
  }
}
