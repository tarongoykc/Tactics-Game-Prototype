# Overview

Initial tactics game bare bones prototype for learning Godot. Currently only moving units around and a rudimentary "turn" system are in place, where units become deactivated after making a movement. The Recon and Armored Car units have movement penalties on the plains and dirt path tiles; only the paved road tiles allow them their full movement. The Light Tank and Rifles units all have full movement on every tile available at the moment.

Unit pathing was done via Godot's basic A-star pathing, using weights as per-tile movement cost.
