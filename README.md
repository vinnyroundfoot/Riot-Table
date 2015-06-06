**&lt;rtable\> - component based on Riot.js**
======
Description 
-
**&lt;rtable\>** is a component based on the fantastic UI library **Riot.js** .
This component creates a table that displays contents of a simple array of objects (aka JSON file).

Features of **&lt;rtable\>**  are the following :

- possibility to customize the table with differents CSS classes 
- possibility to sort on columns
- possiblity to filter columns
- possibility  to remove column of the array 
- possiblity to change the label of column

Requirements
-
Obviously, **&lt;rtable\>** needs **Riot.js** to run.
It needs also the **underscore.js** library.

Basic Example
-

    <!DOCTYPE html>
    <html>
        <head>
            <title>Example table</title>
            <meta charset="UTF-8">
       </head>
        <body>
            <rtable id="tab"></rtable>
            
            <script src="bower_components/underscore/underscore-min.js"></script>
            <script src="bower_components/riot/riot.js"></script>
            <script src="build/rtable.js" ></script>
            <script>
             var list= 
             [
            { "id": 1,  "name": "Guzman Dean", "age": 47, "card": "verte", "gender": "male", "email": "guzmandean@furnafix.com", "solde": 1038.58 },
            { "id": 11, "name": "Trudy James", "age": 21, "card": "rouge", "gender": "female", "email": "trudyjames@furnafix.com", "solde": 3143.17},
            { "id": 21, "name": "Raquel Morrow", "age": 25, "card": "rouge","gender": "female",  "email": "raquelmorrow@furnafix.com","solde": 21.15},
            { "id": 31, "name": "John Calderon", "age": 35, "card": "bleue","gender": "female", "email": "johncalderon@furnafix.com","solde": 3666.0},
            { "id": 41, "name": "Roslyn Howard", "age": 24, "card": "verte", "gender": "female", "email": "roslynhoward@furnafix.com", "solde": 3086.59},
            { "id": 51, "name": "Joanna Mendez", "age": 48, "card": "bleue", "gender": "female", "email": "joannamendez@furnafix.com", "solde": 994.93 },
            { "id": 61, "name": "Kellie Gonzalez", "age": 60, "card": "verte", "gender": "female", "email": "kelliegonzalez@furnafix.com", "solde": -213.29 }
            ];
    
             var rtable = riot.mount('rtable#tab', {data:list});
            </script>
        </body>
    </html>


Options
-
You can configure **&lt;rtable\>** with the following options :

#### **colexcluded**
 let you omit displaying specified columns on the table. 

syntax : colexcluded="columnToHide1, columnToHide2"

example :

`<rtable id="tab" colexcluded="email, solde" ></rtable>`

the column "email" and "solde" are removed from the table display.

####**coltitle**
enable you to change the label of the columns.

syntax : coltitle="originalName1: newName1, orginalName2: newName2" 
example :
    <rtable id="tab" coltitle="name: fullName, id: ident. " ></rtable>

####**sort**
 let you specify a column to default sort on.

syntax: sort="column: colToSort, order: Up/Down"

example :

    <rtable id="tab" sort="column: name, order: Up" ></rtable>

> **remarks:**
- be sure to use "Up" or "Down" with first letter uppercase.
- You can only sort on only column at a time
	

####**filter** 
let you specify a filter on specified column

syntax : filter="column :  columnToFilter , value: filterValue"

example :

    <rtable id="tab" filter="column: gender, value: male" ></rtable>

> **remarks:**
- you can only filter on only one column at a time.
- ending the value with '*' let you filter on the beginning of the string

####**styles** 
let you add some CSS class to elements of the table.

syntax :
styles="tableClass: class1,  colHeaderClass: class2, activeLineClass: class3, sortUpClass: class4, sortDownClass: class5, activeSortClass: class6"

options available :
- tableClass : let you specify CSS classes to apply to the &lt;table> element
- colHeaderClass : let you specify CSS classes to apply to the table Header (&lt;th>)
- activeLineClass : let you specify CSS classes to apply to the active line of table
- sortUpClass : let you specify CSS classes to apply to the header of the column which is sort "up"
- sortDownClass : let you specify CSS classes to apply to the header of the column which is sort "down"
- activeSortClass : let you specify CSS classes to apply to the column (&lt;td>) which is sorted.

example :

    <rtable id="tab" styles="tableClass:table table-hover table-condensed, colHeaderClass:header, sortUpClass:glyphicon glyphicon-arrow-up white, sortDownClass:glyphicon glyphicon-arrow-down white" ></rtable>

> **remarks:**
	- you can specify the options in any order.
	- you can omit options you don't need
	- Be **careful** when typing the options names...

####**autoload**
Let you define If you want to load the data when the table is created or not

syntax : autoload="yes/no"

example :

    <rtable id="tab" autoload="no"></rtable>

> **remark:**
	- if omitted, this option is set to "yes".

####**clonedata
Let you specify if the source of data has to be "clone" to another array. it can be useful when multiples tables have the same source of data.

syntax : clonedata="yes/no"

example :

    <rtable id="tab" clonedata="no"></rtable>

> **remark:**
	- if omitted, this option is set to "no".
