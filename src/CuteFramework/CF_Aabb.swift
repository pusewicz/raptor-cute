extension CF_Aabb {
  var width: Float { cf_width(self) }
  var height: Float { cf_height(self) }
  var halfWidth: Float { cf_half_width(self) }
  var halfHeight: Float { cf_half_height(self) }
  var halfExtents: CF_V2 { cf_half_extents(self) }
  var extents: CF_V2 { cf_extents(self) }

  var min: CF_V2 { cf_min_aabb(self) }
  var max: CF_V2 { cf_max_aabb(self) }
  var midpoint: CF_V2 { cf_midpoint(self) }
  var center: CF_V2 { cf_center(self) }
  var topLeft: CF_V2 { cf_top_left(self) }
  var topRight: CF_V2 { cf_top_right(self) }
  var bottomLeft: CF_V2 { cf_bottom_left(self) }
  var bottomRight: CF_V2 { cf_bottom_right(self) }
  var top: CF_V2 { cf_top(self) }
  var bottom: CF_V2 { cf_bottom(self) }
  var left: CF_V2 { cf_left(self) }
  var right: CF_V2 { cf_right(self) }
  var surfaceArea: Float { cf_surface_area_aabb(self) }
  var area: Float { cf_area_aabb(self) }

  func contains(_ point: CF_V2) -> Bool {
    cf_contains_point(self, point)
  }

  func contains(_ aabb: CF_Aabb) -> Bool {
    cf_contains_aabb(self, aabb)
  }

  func expand(by v2: CF_V2) -> CF_Aabb {
    cf_expand_aabb(self, v2)
  }

  func expand(by factor: Float) -> CF_Aabb {
    cf_expand_aabb_f(self, factor)
  }
}
