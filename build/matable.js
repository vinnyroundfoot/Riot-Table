riot.tag('matable', '<div class="matable"> <yield></yield> <table class="table table-striped" id="{opts[\'data-id\']}"> <tr> <th onclick="{trier}" data-column="{this.colonnes[0].nomcol}" >{this.colonnes[0].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[0].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[1].nomcol}" >{this.colonnes[1].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[1].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[2].nomcol}" >{this.colonnes[2].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[2].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[3].nomcol}" >{this.colonnes[3].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[3].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[4].nomcol}" >{this.colonnes[4].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[4].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[5].nomcol}" >{this.colonnes[5].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[5].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[6].nomcol}" >{this.colonnes[6].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[6].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[7].nomcol}" >{this.colonnes[7].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[7].tri}"></th> <th onclick="{trier}" data-column="{this.colonnes[8].nomcol}" >{this.colonnes[8].nomcol} <span class="glyphicon glyphicon-arrow-{this.colonnes[8].tri}"></th> </tr> <tr each="{ elem, i in this.data }" class="{elem.ligneactive}" onmouseenter="{parent.activeligne }" > <td>{elem[this.parent.colonnes[0].nomcol]}</td> <td>{elem[this.parent.colonnes[1].nomcol]}</td> <td>{elem[this.parent.colonnes[2].nomcol]}</td> <td>{elem[this.parent.colonnes[3].nomcol]}</td> <td>{elem[this.parent.colonnes[4].nomcol]}</td> <td>{elem[this.parent.colonnes[5].nomcol]}</td> <td>{elem[this.parent.colonnes[6].nomcol]}</td> <td>{elem[this.parent.colonnes[7].nomcol]}</td> <td>{elem[this.parent.colonnes[8].nomcol]}</td> </tr> </table> </div>', 'matable table th {cursor:pointer} matable span.glyphicon { padding-left:10px}', function(opts) {
    this.data        = [];
    this.tri         = 'up';
    this.ligneactive = 'warning';
    this.colonnes    = [];
    this.col         = [];
    
    this.on('mount', function() {
       var elem = this.root.getElementsByTagName('th');
       for (var i=0,l=elem.length;i<l;i++) {
         elem[i].style.backgroundColor=opts.couleur;
       };
       
       if (opts.callback) { 
            opts.callback(this);
       }else{
           this.data = opts.data; 
       }
       
       this.ligneactive = opts['ligneactive'] || this.ligneactive;
       
       if (opts['excludecol']) {
            this.col = opts['excludecol'].split();
       }
       
       var keys = Object.keys(this.data[0]);
       
       for (var i=0, l=keys.length; i<l; i++) {
           this.colonnes.push({nomcol:keys[i], tri:''});
       }
       
       this.update();         
       this.tableau();

    });
   
    this.tableau = function() {
        var indice = -1;
        var col =this.col;
        var $lignes = $('#'+opts['data-id']).children('tbody').children('tr');

        $lignes.children('th').each(function() {
            var c = $(this).attr('data-column');  
            if (c === ''  || _.contains(col,c)){
              indice = $(this).index();

              $lignes.each(function() {
                 $(this).children("td:eq(" + indice + "), th:eq(" + indice+")").remove();
              });  
            }
        });

    };
    
    this.cacheRem = function(e) {
        return;
        var remarque = this.parent.remarque;
        remarque.style.display='none';
    };
     
    this.activeligne = function(e) {
        for (var i=0, l= this.parent.data.length;i<l;i++) {
            this.parent.data[i].select=false;
            this.parent.data[i].ligneactive='';
        }

        e.item.elem.select=true;
        e.item.elem.ligneactive = this.parent.ligneactive;

    };
    
    
    this.trier = function(e) {
        var colonne = e.target.getAttribute('data-column');
        
        if (colonne !== this.colonne) {
            this.tri = 'up';
            this.colonne = colonne;
        }
        
        this.data = _.sortBy(this.data, colonne);
        
        if (this.tri==="down") {
            this.tri = 'up';
            this.data.reverse();
        }else{
            this.tri = "down";
        };

        for (var i=0, l = this.colonnes.length; i < l; i++) {
            if (this.colonnes[i].nomcol === colonne) {
                this.colonnes[i].tri = this.tri;  
            }else{
                this.colonnes[i].tri = '';
            }
        }
        this.update();
    };
    
    
});