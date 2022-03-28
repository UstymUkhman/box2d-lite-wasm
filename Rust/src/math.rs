pub struct Vector2 {
  pub x: f32,
  pub y: f32
}

impl Vector2 {
  pub fn new(x: f32, y: f32) -> Vector2 {
    Vector2 {
      x: x,
      y: y
    }
  }

  pub fn set(&mut self, x: f32, y: f32) {
    self.x = x;
    self.y = y;
  }

  pub fn length(&self) -> f64 {
    let dot = self.x * self.x + self.y * self.y;
    return (dot as f64).sqrt();
  }
}
