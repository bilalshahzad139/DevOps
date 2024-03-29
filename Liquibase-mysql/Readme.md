## Prerequisite
### Step 1: Setup Liquibase
- https://www.liquibase.org/download
- **Option 1:** Download Liquibase Windows Installer
	- It includes everything you need to run Liquibase (including Java) to make getting started easier than ever.
- **Option 2:** Download only Liquiabase files
		- Install Java separately
			- https://www.oracle.com/java/technologies/javase-downloads.html
			- https://jdk.java.net/archive/ 
		- Download Liquiabase zip file, extract it somewhere and add liquibase.bat in Path enviornment variable so we can use it anywhere.
- You may also follow this tutorial to setup liquibase
	- https://docs.liquibase.com/concepts/installation/installation-windows.html

### Step 2: Setup MySQL Connector
- Download MySQL connector at some location e.g. c:/mysql-connector-java-8.0.23.jar
	- https://dev.mysql.com/downloads/connector/j/
- **Note:** We'll reference this jar file while executing liquibase command
	- ```--classpath=c:/mysql-connector-java-8.0.23.jar```

### Step 3: Create a basic MySQL Project
- Create a folder 
	- Create masterchangelog.xml (Check example1/masterchangelog.xml for sample)
	- Check examples
- Reference: https://docs.liquibase.com/workflows/database-setup-tutorials/mysql.html

## How to Run
- Go to specific liquibase project directory (e.g. example1)
- To migrate changes to database (we need to use **update** command)
	- ``` liquibase --classpath=c:/mysql-connector-java-8.0.23.jar  --changeLogFile=masterchangelog.xml --url="jdbc:mysql://localhost:3306/test?autoReconnect=true"  --username=root --password=  update```
- To generate differential or script to execute (without making changes to database), we need to use **updateSql** command
	- ```liquibase --classpath=c:/mysql-connector-java-8.0.23.jar  --changeLogFile=changelog.sql --url="jdbc:mysql://localhost:3306/test?autoReconnect=true"  --username=root --password=  --outputFile=updateSql.txt updateSql ``` 

## Example 1: Keep multiple changesets in one sql file
- In this example, we are maintaning our multiple changesets in a sql formatted file (e.g. example1/changelog.sql).
	- Each changeset contains author-name and an ID (or tag) e.g. 
		- --changeset bilalshahzad:1
	- For scripts (e.g. stored procedure) which comprises of multiple statements, we'll have to define endDelimiter and then we'll have to use at start & end of specific script. e.g.		
		``` 
		--changeset bilalshahzad:3 endDelimiter://
		//
		DROP  PROCEDURE  IF  EXISTS new_procedure1;
		//
		CREATE  PROCEDURE new_procedure1 ()
		BEGIN
			select * from teacher;
	    END// 
- masterchangelog.xml is referencing to our changelog.sql file.
	- ```<include  file="changelog.sql"/>```
- liquibase.properties contains default configuration (which can be overriden while executing liquibase cli command).

## Example 2: Keep every changeset in a separate sql file
- In this example, we are maintaning our multiple changesets in separate sql files e.g.
	- sql/create_teacher_table.sql
	- sql/my_stored_proc2.sql
- masterchangelog.xml is referencing to our changesets
	- ```<changeSet  id="create_teacher_table"  author="bilal"> <sqlFile path="/sql/create_teacher_table.sql"  stripComments="true"  relativeToChangelogFile="true"/> </changeSet>```			
	- ```<changeSet  id="create_my_stored_proc"  author="bilal"> <sqlFile endDelimiter="//"  path="/sql/my_stored_proc2.sql" stripComments="true" relativeToChangelogFile="true"/> </changeSet>```
		- If we are having a script of multiple statements, we'll have to use a different endDelimeter other than **;**. For example, we want to drop & create procedure so we'll have different statements (one for drop procedure and other to create procedure). In above example, we are using **//**

## Example 3: Maintaining changesets in different files
- In this example, we are maintaning our multiple changesets in separate XML files and xml files maintain details of changesets (sql files)
- masterchangelog.xml is referencing to our changesets XML files
	- ```<include  file="sql/sprint1.xml"/>```
	- ```<include  file="sql/sprint2.xml"/>```
- sprint1.xml files contain detail of changesets (as we've seen in example 2)
