#![allow(dead_code)]

use std::mem;
use super::vec2::Vector2;

#[inline]
pub fn min(a: f32, b: f32) -> f32 {
  return if a < b { a } else { b };
}

#[inline]
pub fn max(a: f32, b: f32) -> f32 {
  return if a > b { a } else { b };
}

#[inline]
pub fn clamp(x: f32, low: f32, high: f32) -> f32 {
  return max(low, min(x, high));
}

#[inline]
pub fn dot(a: &Vector2, b: &Vector2) -> f32 {
  a.x * b.x + a.y * b.y
}

#[inline]
pub fn swap<T>(a: &mut T, b: &mut T) {
  mem::swap(a, b);
}

#[inline]
pub fn sign(x: f32) -> f32 {
  return if x < 0.0 { -1.0 } else { 1.0 };
}
