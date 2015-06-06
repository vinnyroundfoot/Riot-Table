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
