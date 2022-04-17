use crate::body::Body;
use crate::utils::cross::*;
use crate::utils::vec2::Vector2;
use crate::utils::mat4::Matrix4;

pub struct Joint {
  pub body1: Body,
  pub body2: Body,

  pub matrix: Matrix4,

  pub anchor1: Vector2,
  pub anchor2: Vector2,

  pub rotation1: Vector2,
  pub rotation2: Vector2,

  pub impulse: Vector2,
  pub bias: Vector2,

  pub bias_factor: f32,
  pub softness: f32,
}

impl Joint {
  pub fn new() -> Self {
    Self {
      body1: Body::new(),
      body2: Body::new(),

      matrix: Matrix4::new(),

      anchor1: Vector2::new(0.0, 0.0),
      anchor2: Vector2::new(0.0, 0.0),

      rotation1: Vector2::new(0.0, 0.0),
      rotation2: Vector2::new(0.0, 0.0),

      impulse: Vector2::new(0.0, 0.0),
      bias: Vector2::new(0.0, 0.0),

      bias_factor: 0.2,
      softness: 0.0,
    }
  }

  pub fn set(&mut self, body1: &Body, body2: &Body, anchor: &Vector2) {
    self.body1 = *body1;
    self.body2 = *body2;

    let rotation1 = Matrix4::from_angle(body1.rotation).transpose();
    let rotation2 = Matrix4::from_angle(body2.rotation).transpose();

    self.anchor1 = (*anchor - (*body1).position) * rotation1;
    self.anchor2 = (*anchor - (*body2).position) * rotation2;

    self.impulse.set(0.0, 0.0);
    self.bias_factor = 0.2;
    self.softness = 0.0;
  }

  /* pub fn pre_step(&mut self, inv_dt: f32) {

  } */

  pub fn apply_impulse(&mut self) {
    let ang_vel_x_rot1 = Cross::prod(self.body1.angular_velocity, &self.rotation1);
    let ang_vel_x_rot2 = Cross::prod(self.body2.angular_velocity, &self.rotation2);

    let dv = self.body2.velocity + ang_vel_x_rot2 - self.body1.velocity - ang_vel_x_rot1;
    let impulse = (self.bias - dv - self.impulse * self.softness) * self.matrix;

    let rot_x_imp1 = Cross::prod(&self.rotation1, &impulse);
    self.body1.velocity -= impulse * self.body1.inverse_mass;
    self.body1.angular_velocity -= self.body1.inverse_inertia * rot_x_imp1;

    let rot_x_imp2 = Cross::prod(&self.rotation2, &impulse);
    self.body2.velocity += impulse * self.body2.inverse_mass;
    self.body2.angular_velocity += self.body2.inverse_inertia * rot_x_imp2;

    self.impulse += impulse;
  }
}
