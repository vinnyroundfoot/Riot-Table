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

Demo
-
See **&lt;rtable>** in [action](http://vinnyroundfoot.github.io/) 

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
            <script src="bower_components/riot/riot.min.js"></script>
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

Usage
-
Once you have included riot.js and undescore.js libraries. you need to :

1. include the javascript file rtable.js (after riot.js). In the example, rtable.js is located in the "build" folder.

	**&lt;script src="build/rtable.js" >&lt;/script>**
	
2. add the tag &lt;rtable>&lt;/rtable> where you want to place it. Add an ID to the tag to clearly identify it.

	**&lt;rtable id="tab">&lt;/rtable>**

3. "mount" the tag with a call to the riot.mount function. riot.mount returns a array containing a reference to the tag. Options can be passed to the tag by using a object as second argument. In this object, you pass your array containing your information by using the 'data' property.

	**var rtable = riot.mount('rtable#tab', {data:list});**


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

####**clonedata**
Let you specify if the source of data has to be "clone" to another array. it can be useful when multiples tables have the same source of data.

syntax : clonedata="yes/no"

example :

    <rtable id="tab" clonedata="no"></rtable>

> **remark:**
	- if omitted, this option is set to "no".


####Using options in the riot.mount call
Instead of incude the options inside the &lt;rtable> tag, you can include these options in the second arguments of the riot.mount function. 

Here is a example of this usage with all the options :

    var rtable = riot.mount("rtable#tab", {
                           data: liste1,                                
                           autoload: 'yes',
                           clonedata:'yes',
                           coltitle: {'name':'Nom'}, 
                           colexcluded : "email, card", 
                           sort: {column:'id',order:'Up'},
                           filter  : {column:'gender',value:'female'},
                           styles: { 
                               tableClass:"table-hover", 
                               colHeaderClass:"header", 
                               activeLineClass:"active",
                               sortUpClass:"glyphicon glyphicon-arrow-up white",
                               sortDownClass:"glyphicon glyphicon-arrow-down white",
                               activeSortClass : 'tri-actif'
                           }
                       });


###DOM Elements and CSS Classes

when mounted, the **&lt;rtable>**  tag is rendered with the following structure :

    <rtable id="?id?">
    <div class="rtable" id="rtable-?id?">
       <table id="table-?id?" class="?tableClass?">
          <thead>
             <tr class="?header?">
                <th class="header-?cold? header-sort-?sort?" data-column="?col?">
                   <raw r="?col?">?col?<span class="?sortClass?"></span></raw>
                </th> 
                ...
             </tr>
          </thead>
          <tbody>
             <tr class="?activeline?">
                <td class="col-?col? ?activeSort?">...</td>
                ...
            </tr>
            ...
         <tbody>
      </table>
      </div>
      </rtable>
                
  - **?id?** is replaced by the id value of the &lt;rtable> tag
  - **?tableClass?** is replace by the value of styles.tableClass
  - **?header**? is replaced by the value of styles.colHeaderClass
  - **?sort?** is replaced by "sortUp" or "sortDown" depending of the sort order
  - **?col?** is replaced by the name of the "data field" (example : age)
  - **?sortClass?** is replaced by the value of styles.sortUpClass or styles.sortDownClass depending on the sort order
  - **?activeline?** is replaced by the value of styles.activeLineClass
  - **?activeSort?** is replaced by the value of styles.activeSortClass