from typing import List
from yage.models.capability import Capability
from yage.models.collisions import Collision
from yage.utils.geometry import Point


class Rotating(Capability):
    def __init__(self, subject):
        super().__init__(subject)
        self.is_enabled = False
        self.z_angle = 0
        self.is_flipped_vertically = False
        self.is_flipped_horizontally = False
        self.subject.rotation = self
