mod math;
// use core::f64::consts::PI;

fn main() {
  let mut vec = math::Vector2::new(0.12, 0.25);

  println!("x: {} | y: {}", vec.x, vec.y);
  println!("Vector Length: {}", vec.length());

  vec.set(0.5, 0.75);

  println!("x: {} | y: {}", vec.x, vec.y);
  println!("Vector Length: {}", vec.length());
}
