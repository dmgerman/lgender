default: emails.csv persons.csv 

emails.csv: data.db
	printf ".headers on\n.mode csv\n.output emails.csv\nselect * from emails;\n" | sqlite3 data.db

persons.csv: data.db
	printf ".headers on\n.mode csv\n.output persons.csv\nselect * from persons;\n" | sqlite3 data.db

