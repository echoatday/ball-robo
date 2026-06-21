extends Node

var player: CharacterBody3D

var save_room: int
var rolled_state := false

var doors_rawmaterials := true

var unlock_roll := true
var unlock_jump := true
var unlock_walljump := true
var unlock_lateralboost := true
var unlock_downboost := true
var unlock_bounce := true
var unlock_grapple := true
var unlock_spin := true
