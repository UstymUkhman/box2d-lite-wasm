mod utils;
// #[allow(dead_code)]
// use core::f64::consts::PI;

use crate::utils::rand;
use crate::utils::math;
use crate::utils::cross::*;
use crate::utils::vec2::Vector2;
use crate::utils::mat4::Matrix4;

fn main() {
  let v1 = Vector2::new(0.9, 0.1);
  let v2 = Vector2::new(0.2, 0.8);

  let f = Cross::prod(&v1, &v2);
  println!("f: {}", f);

  let v3 = Cross::prod(&v1, f);
  println!("x: {}, y: {}", v3.x, v3.y);
  
  let v4 = Cross::prod(f, &v2);
  println!("x: {}, y: {}", v4.x, v4.y);

  let mut a = 1.2;
  let mut b = 2.1;

  math::swap(&mut a, &mut b);

  println!("a: {}, b: {}", a, b);

  let r1 = rand::random(());

  println!("r1: {}", r1);
  
  let r2 = rand::random((-25.0, 50.0));

  println!("r2: {}", r2);

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

  mat = mat.transpose();

  println!("mat.col1.x: {} | mat.col1.y: {}", mat.col1.x, mat.col1.y);
  println!("mat.col2.x: {} | mat.col2.y: {}", mat.col2.x, mat.col2.y);

  mat = mat.invert();

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


  let mut vec1 = Vector2::new(0.1, 0.2);
  let mut vec2 = Vector2::new(0.2, 0.4);

  vec = vec1 + vec2;

  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);

  vec = vec * mat;

  println!("vec.x: {} | vec.y: {}", vec.x, vec.y);

  println!("");
  println!("===== ===== =====");
  println!("");

  vec1 = Vector2::new(0.1, 0.2);
  vec2 = Vector2::new(0.2, 0.4);

  println!("dot: {}", math::dot(&vec1, &vec2));
}
