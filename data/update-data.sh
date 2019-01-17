#!/bin/bash

source common.inc

ACTDB=$1
OUTDB=$2
USAGE="$0 <activityDB> <outputDB>"

if [ $# -ne 2 ] ; then
   Usage "Wrong parameters"
fi

Check_File $ACTDB "old activity persons db ${olddb} does not exist"

sqlite3 -bail $OUTDB <<EOF || Die "Unable to create schema"
begin;
CREATE TABLE topdomains(
   topdomain TEXT PRIMARY KEY,
   orgtype   TEXT,
   orgdomain TEXT,
   dateadded DATE,
   ncommitsaut  int,  -- computed
   ncommitscom  int,  -- computed
   ntokens   int, -- computed,  
   nlines    int, firstused DATE, lastused DATE, -- computed,  
   nfilesaut int,
   nfilescom int
 );
CREATE TABLE domains (
   domain text,
   reversedomain text, -- computed
   topdomain text,
   dateadded date,
   ncommitsaut  int,  -- computed
   ncommitscom  int,  -- computed
   ntokens   int,  
   nlines    int, firstused DATE, lastused DATE,  
   nfilesaut int,
   nfilescom int,
   primary key (domain),
   FOREIGN KEY (topdomain) REFERENCES  topdomains
     ON UPDATE RESTRICT
     ON DELETE RESTRICT
);
CREATE TABLE persons(
   personid text primary key,
   personname text UNIQUE, 
   gender text,
   notes  text,
   dateadded DATE, 
   ncommitsaut int, 
   ncommitscom int, 
   ntokens int, 
   nlines int, 
   nfilesaut int,
   nfilescom int,
   firstused DATE, 
   lastused DATE
);
CREATE TABLE emails(
  recordid int primary key,
  personid text,
  emailname text,
  emailaddr text,
  domain    text, 
  notes     text,
  dateadded DATE,
  ncommitsaut int, -- number of commits that this author created... must be updated at each release
  ncommitscom int, -- number of tokens tht this person has added... must be updated at each release
  ntokens   int,
  nlines    int,
   nfilesaut int,
   nfilescom int,
  firstused DATE,  -- computed from git repo, it should never change
  lastused DATE,   -- computed from git repo, updated as needed,
  UNIQUE (emailname,  emailaddr),  
  FOREIGN KEY (personid) REFERENCES persons ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (domain)   REFERENCES domains ON UPDATE RESTRICT ON DELETE RESTRICT
 );
commit;
EOF

sqlite3 -bail $OUTDB <<EOF || Die "copy data"
begin;
attach  '$ACTDB' as p;
insert into topdomains  select * from p.topdomains;
insert into domains     select * from p.domains;
insert into persons     select * from p.persons;
insert into emails      select * from p.emails;
commit;
EOF
