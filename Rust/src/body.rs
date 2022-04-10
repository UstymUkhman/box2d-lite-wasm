use crate::utils::vec2::Vector2;

pub struct Body {
  pub position: Vector2,
  pub rotation: f32,  
  pub velocity: Vector2,
  pub angular_velocity: f32,

  pub width: Vector2,
  pub friction: f32,
  pub mass: f32,
  pub inverse_mass: f32,
  pub inertia: f32,
  pub inverse_inertia: f32,

  pub torque: f32,
  pub force: Vector2
}

impl Body {
  pub fn new() -> Self {
    Self {
      position: Vector2::new(0.0, 0.0),
      rotation: 0.0,
      velocity: Vector2::new(0.0, 0.0),
      angular_velocity: 0.0,

      width: Vector2::new(1.0, 1.0),
      friction: 0.2,
      mass: f32::MAX,
      inverse_mass: 0.0,
      inertia: f32::MAX,
      inverse_inertia: 0.0,

      torque: 0.0,
      force: Vector2::new(0.0, 0.0),
    }
  }

  pub fn set(&mut self, width: &Vector2, mass: f32) {
    self.position.set(0.0, 0.0);
    self.rotation = 0.0;
    self.velocity.set(0.0, 0.0);
    self.angular_velocity = 0.0;

    self.width = *width;
    self.friction = 0.0;
    self.mass = mass;

    if mass < f32::MAX {
      self.inverse_mass = 1.0 / mass;

      self.inertia = mass * (
        width.x * width.x + width.y * width.y
      ) / 12.0;

      self.inverse_inertia = 1.0 / self.inertia;
    }

    else {
      self.inverse_mass = 0.0;
      self.inertia = f32::MAX;
      self.inverse_inertia = 0.0;
    }

    self.torque = 0.0;
    self.force.set(0.0, 0.0);
  }

  pub fn add_force(&mut self, force: &Vector2) {
    self.force += *force;
  }
}
