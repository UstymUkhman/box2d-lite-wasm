use crate::utils::vec2::Vector2;

pub struct World {
  pub gravity: Vector2,
	pub iterations: i32,
}

impl World {
  // pub const ACCUMULATE_IMPULSES: bool = true;
  pub const POSITION_CORRECTION: bool = true;
  pub const WARM_STARTING: bool = true;
}
