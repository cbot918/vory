module vory

import db.pg

struct Vory{
	mut:
	db pg.DB
}

pub fn new() Vory{
	return Vory{}
}

pub fn (v Vory) connect(c pg.Config) pg.DB{
	conn := pg.connect(c)	or {
		println("pg.connect failed")
		return pg.DB{}
	}
	return conn
}

pub fn (v Vory) hello(){
	println("hello in vory")
}
