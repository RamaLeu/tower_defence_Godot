extends Node

var tower_data = {
	"GunT1": {
		"damage": 20,
		"rof": 1,
		"range": 350,
		"category": "Projectile",
		"price": 50
	
	},
	"GunT2": {
		"damage": 25,
		"rof" : 0.5,
		"range" : 400,
		"category": "Projectile"
	},
	"MissileT1": {
		"damage": 100,
		"rof" : 3,
		"range" : 400,
		"category": "Missile",
		"price": 150
	},
	"MinigunT1": {
		"damage": 10,
		"rof" : 0.2,
		"range" : 200,
		"category": "Minigun",
		"price": 150
	}
}

var wave_data = {
	1:{
		"blue": 5,
		"path": 1,
		"enemy": true
	},
	2:{
		"blue": 5,
		"path": 2,
		"enemy": false
	},
	3:{
		"blue": 1,
		"path": 2,
		"enemy": false
	},
	4:{
		"blue": 1,
		"path": 1,
		"enemy": true
	},
	5:{
		"blue": 1,
		"path": 0,
		"enemy": false
	},
	6:{
		"blue": 1,
		"path": 0,
		"enemy": false
	}
}
