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

### Step 2: Setup MS SQL Server Driver
- Copy MSSQL Driver (from downloaded zip file) at some location e.g. c:/mssql-jdbc-9.2.1.jre11.jar
	- https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server?view=sql-server-ver15
- **Note:** We'll reference this jar file while executing liquibase command
	- ```--classpath=c:/mssql-jdbc-9.2.1.jre11.jar```

### Step 3: Create a basic MSSQL Project
- Create a folder 
	- Create masterchangelog.xml (Check example1/masterchangelog.xml for sample)
	- Check examples
- Reference: https://docs.liquibase.com/workflows/database-setup-tutorials/mssql.html

## How to Run
- Go to specific liquibase project directory (e.g. example1)
	 - Server Instance is **localhost\SQLEXPRESS2019**
	 - Database Name is **test**
- We've added following (as default) configuration in liquibase.properties file. If we don't provide these parameters with command, default value will be used from properties file.
	- url=jdbc:sqlserver://localhost\\SQLEXPRESS2019:1433;encrypt=false;database=test
	- username=sa
	- password=P@ssword1
	- liquibase.hub.mode=off
	- classpath=c:/mssql-jdbc-9.2.1.jre11.jar
	- changeLogFile=masterchangelog.xml
	- driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
- To migrate changes to database (we need to use **update** command)
	- ``` liquibase --changeLogFile=masterchangelog.xml update```
- To generate differential script to execute (without making changes to database), we need to use **updateSql** command
	- ```liquibase  --changeLogFile=masterchangelog.xml --outputFile=updateSql.txt updateSql ``` 
- To enable log, set logLevel. For example
	- ```liquibase  --changeLogFile=masterchangelog.xml --outputFile=updateSql.txt --logLevel=debug updateSql ``` 
- To override any parameter of liquibase.properties, pass it with command. For example
	- ```liquibase --changeLogFile=masterchangelog.xml --username=sa --password=P@ssword1 update```
	- ```liquibase --driver=com.microsoft.sqlserver.jdbc.SQLServerDriver --classpath=c:/mssql-jdbc-9.2.1.jre11.jar  --username=sa --password=P@ssword1 --changeLogFile=masterchangelog.xml  update```

## Example 1: Keep multiple changesets in one sql file
- In this example, we are maintaning our multiple changesets in a sql formatted file (e.g. example1/changelog.sql).
	- Each changeset contains author-name and an ID (or tag) e.g. 
		- --changeset bilalshahzad:1
	- For scripts (e.g. stored procedure) which comprises of multiple statements, we'll have to define endDelimiter  e.g.		
		``` 
		--changeset bilalshahzad:3 endDelimiter:GO
		
		CREATE  PROCEDURE new_procedure1
		AS
		BEGIN
			select * from teacher;
	    END

		GO;

		CREATE  PROCEDURE new_procedure2
		AS
		BEGIN
			select * from teacher;
	    END

- masterchangelog.xml is referencing to our changelog.sql file.
	- ```<include  file="changelog.sql"/>```
- liquibase.properties contains default configuration (which can be overriden while executing liquibase cli command).

## Example 2: Keep every changeset in a separate sql file
- In this example, we are maintaning our multiple changesets in separate sql files e.g.
	- sql/create_teacher_table.sql
	- sql/my_stored_proc2.sql
- masterchangelog.xml is referencing to our changesets
	- ```<changeSet  id="create_teacher_table"  author="bilal"> <sqlFile path="/sql/create_teacher_table.sql"  stripComments="true"  relativeToChangelogFile="true"/> </changeSet>```			
	- ```<changeSet  id="create_my_stored_proc"  author="bilal"> <sqlFile endDelimiter="GO"  path="/sql/my_stored_proc2.sql" stripComments="true" relativeToChangelogFile="true"/> </changeSet>```
		- If we are having a script of multiple statements, we'll have to use a different endDelimeter other than **;**. For example, we want to drop & create procedure so we'll have different statements (one for drop procedure and other to create procedure). In above example, we are using **GO**

## Example 3: Maintaining changesets in different files
- In this example, we are maintaning our multiple changesets in separate XML files and xml files maintain details of changesets (sql files)
- masterchangelog.xml is referencing to our changesets XML files
	- ```<include  file="sql/sprint1.xml"/>```
	- ```<include  file="sql/sprint2.xml"/>```
- sprint1.xml files contain detail of changesets (as we've seen in example 2)

## Example 4: Using runOnChange for procedures
- Use different folders in sql for different objects, for example
  - procedures: One file per SP (create or alter). runOnChange=true will be used for these changesets.
  - tables: One file per table
  - functions: One file per function
  - others: For any other changes (alter column, alter index etc.)
