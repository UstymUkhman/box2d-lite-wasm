use super::vec2::Vector2;

// Matrix4 { col1: Vector2, col2: Vector2 }
pub struct Matrix4 {
  pub col1: Vector2,
  pub col2: Vector2
}

impl Matrix4 {
  // Matrix4::new()
  pub fn new() -> Self {
    Self {
      col1: Vector2 { x: 0.0, y: 0.0 },
      col2: Vector2 { x: 0.0, y: 0.0 }
    }
  }

  // Matrix4 = Matrix4::from_angle(f32)
  pub fn from_angle(angle: f32) -> Self {
    let angle_cos = angle.cos();
    let angle_sin = angle.sin();

    let col1 = Vector2::new( angle_cos, angle_sin);
    let col2 = Vector2::new(-angle_sin, angle_cos);

    Self {
      col1: col1,
      col2: col2
    }
  }

  // Matrix4 = Matrix4::from_vectors(&Vector2, &Vector2)
  pub fn from_vectors(col1: &Vector2, col2: &Vector2) -> Self {
    Self {
      col1: Vector2 { x: col1.x, y: col1.y },
      col2: Vector2 { x: col2.x, y: col2.y }
    }
  }

  // Matrix4 = Matrix4.transpose()
  pub fn transpose(self) -> Self {
    Self {
      col1: Vector2::new(self.col1.x, self.col2.x),
      col2: Vector2::new(self.col1.y, self.col2.y)
    }
  }

  // Matrix4 = Matrix4.invert()
  pub fn invert(self) -> Self {
    let x1 = self.col1.x;
    let x2 = self.col2.x;
    let y1 = self.col1.y;
    let y2 = self.col2.y;

    let mut inv = Matrix4::new();
    let mut det = x1 * y2 - x2 * y1;

    debug_assert!(det != 0.0,
      "Matrix4::invert - 'det' is 0.0!"
    );

    det = 1.0 / det;

    inv.col1.x =  det * y2;
    inv.col2.x = -det * x2;
    inv.col1.y = -det * y1;
    inv.col2.y =  det * x1;

    return inv;
  }
}
