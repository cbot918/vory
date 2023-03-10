module dbv

import db.pg
import model
import json

type Yale = int | string

pub fn query(conn pg.DB, table_name string) ([]pg.Row,[]pg.Row) {

	query_column := "SELECT column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name = '${table_name}';"

	column_name := conn.exec(query_column) or { panic(err) }

	query := "select * from ${table_name};"
	rows := conn.exec(query) or { panic(err) }

	return rows, column_name
}

pub fn json_touser(user_json []map[string]Yale) []model.Users {

	mut users := []model.Users{}
	for user in user_json {
		users << json.decode(model.Users, json.encode(user)) or {
			println("json.decode error")
			return []model.Users{}
		}
	}

	return users
}

pub fn row_tojson(column_name []pg.Row, rows []pg.Row) []map[string]Yale{
	// get names
	mut names := []string{}
	for row in column_name { names << row.vals[0] }

	// bind row to users struct
	mut result := []map[string]Yale{}

	fields := get_fieldname[model.Users]()
	for row in rows {
		mut tmp := map[string]Yale{}
		for index, item in row.vals {
			tmp["${fields[index]}"] = item
		}

		result << tmp
	}
	return result
}

pub fn get_fieldname[T]()  []string{
	mut result := []string{}
	$for field in (T).fields{
		result << field.name
	}
	return result
}


// temp codebase to reference

// pub fn codec(){
// 	mut u := model.Users{
// 		id:"1"
// 		name:"hi"
// 		email:"amil"
// 	}
// 	str := json.encode(u)
//
// 	uu := json.decode(model.Users, str) or {
// 		println("decode failed")
// 		panic(err)
// 	}
// 	println(uu)
// }
//
// pub fn is_field_a_number[T]()  {
//	$for field in (T).fields{
//		if field.typ == 7 {
//			println("type: ${field.typ}, name: ${field.name}")
//		}
//	}
//}
//
//pub fn get_typ[T](field_name string){
//	$for field in (T).fields{
//		println(field.typ)
//	}
//}