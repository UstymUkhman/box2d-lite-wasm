mod utils;

// use core::f64::consts::PI;
use crate::utils::vec2::Vector2;
use crate::utils::mat4::Matrix4;

fn main() {
  let mut vec = Vector2::new(0.12, 0.25);

  println!("x: {} | y: {}", vec.x, vec.y);
  println!("Vector Length: {}", vec.len());

  vec.set(0.5, 0.75);

  println!("x: {} | y: {}", vec.x, vec.y);
  println!("Vector Length: {}", vec.len());

  let mut mat = Matrix4::from_angle(0.5);

  println!("mat.col1.x: {} | mat.col1.y: {}", mat.col1.x, mat.col1.y);
  println!("mat.col2.x: {} | mat.col2.y: {}", mat.col2.x, mat.col2.y);

  mat = Matrix4::from_vectors(&Vector2::new(0.12, 0.25), &vec);

  println!("mat.col1.x: {} | mat.col1.y: {}", mat.col1.x, mat.col1.y);
  println!("mat.col2.x: {} | mat.col2.y: {}", mat.col2.x, mat.col2.y);

  println!("");
  println!("===== ===== =====");
  println!("");

  let mut neg = Vector2::new(0.2, 0.8);
  neg = -neg;
  println!("neg.x: {} | neg.y: {}", neg.x, neg.y);

  vec += Vector2::new(0.25, 0.5);
  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);

  vec -= Vector2::new(0.5, 0.25);
  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);

  vec *= 0.1;
  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);


  let vec1 = Vector2::new(0.1, 0.2);
  let vec2 = Vector2::new(0.2, 0.4);

  vec = vec1 + vec2;

  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);

  vec = vec * mat;

  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);
}
