mod utils;
mod world;

mod body;
mod joint;
// #[allow(dead_code)]
use core::f32::consts::PI;

use crate::body::Body;
use crate::joint::Joint;
// use crate::utils::rand;
// use crate::utils::math;
// use crate::utils::cross::*;
use crate::utils::vec2::Vector2;
// use crate::utils::mat4::Matrix4;

fn print_body_data(body: &Body) {
  println!("body.position: [x: {}, y: {}]", &body.position.x, &body.position.y);
  println!("body.rotation: {}", &body.rotation);
  println!("body.velocity: [x: {}, y: {}]", &body.velocity.x, &body.velocity.y);
  println!("body.angular_velocity: {}", &body.angular_velocity);

  println!("body.width: [x: {}, y: {}]", &body.width.x, &body.width.y);
  println!("body.friction: {}", &body.friction);
  println!("body.mass: {}", &body.mass);
  println!("body.inverse_mass: {}", &body.inverse_mass);
  println!("body.inertia: {}", &body.inertia);
  println!("body.inverse_inertia: {}", &body.inverse_inertia);

  println!("body.torque: {}", &body.torque);
  println!("body.force: [x: {}, y: {}]", &body.force.x, &body.force.y);
}

fn main() {
  // Body
  let mut body = Body::new();
  let force = Vector2::new(12.0, 5.0);

  println!("");  
  println!("=========================");
  println!("");

  print_body_data(&body);

  println!("");  
  println!("=========================");
  println!("");

  body.set(&Vector2::new(5.0, 5.0), 5.0);

  print_body_data(&body);

  println!("");  
  println!("=========================");
  println!("");

  body.add_force(&force);

  print_body_data(&body);

  println!("");
  println!("=========================");
  println!("");

  // Joint
  let mut _body = Body::new();
  let mut joint = Joint::new();
  let anchor = Vector2::new(1.0, -1.0);

  _body.set(&Vector2::new(1.0, 1.0), 0.0001);

  _body.rotation = PI;
  body.rotation = -PI;

  joint.set(&body, &_body, &anchor);

  joint.pre_step(0.0);

  println!("Joint.impulse: [x: {}, y: {}]", joint.impulse.x, joint.impulse.y);
  
  println!("");
  println!("=========================");
  println!("");

  body.rotation = PI;
  joint.pre_step(0.06);
  joint.apply_impulse();

  println!("Joint.impulse: [x: {}, y: {}]", joint.impulse.x, joint.impulse.y);
  
  println!("");
  println!("=========================");
  println!("");
}
