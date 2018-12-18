default: emails.csv persons.csv

emails.csv: data-4.19.db
	printf ".headers on\n.mode csv\n.output emails.csv\nselect * from emails;\n" | sqlite3 data-4.19.db

persons.csv: data-4.19.db
	printf ".headers on\n.mode csv\n.output persons.csv\nselect * from persons;\n" | sqlite3 data-4.19.db

