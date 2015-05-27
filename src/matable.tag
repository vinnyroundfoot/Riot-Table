<matable>

    <div class="matable">
        <yield/>
        <table class="table table-striped" id="{opts['data-id']}"> 
            <tr class="{this.headerClass}"> 
                <th each={c in this.colonnes} data-column="{c.nomcol}" onclick="{this.parent.click_trier}">{c.nomcol} <span class="glyphicon glyphicon-arrow-{c.tri}"  </th>           
             </tr> 
            <tr each={ elem, i in this.donnees } class="{this.parent.ligneactive(i)}" onmouseover="{parent.activeligne }"  >
                <td each={ d in elem } >{elem[d]}</td>
            </tr>  
        </table>
   </div>
       
    <style>
        matable table th {cursor:pointer}
        matable span.glyphicon { padding-left:10px} 
    </style>
    
    <script>
    this.donnees     = [];
    this.donnees_bak = [];
    this.tri         = 'up';
    this.colonnes    = [];
    this.col         = [];
    this.selectionne = -1;
    this.headerClass = "";
    this.ligneactiveClass = '';
    this.filtreCol = 'gender';
    this.filtreVal = 'female';
    
    
    this.on('mount', function() {
       /*var elem = this.root.getElementsByTagName('th');
       for (var i=0,l=elem.length;i<l;i++) {
         elem[i].style.backgroundColor=opts.couleur;
       };*/
  
       this.headerClass = this.opts.styles.header || this.headerClass;
       this.ligneactiveClass = this.opts.styles.ligneactive || this.ligneaCtiveclass;
       
       if (opts['excludecol']) {
            this.col = opts['excludecol'].split(',');
       }
       
       if (this.ligneactiveClass ==='') {
           this.ligneactive = function() { return };
       }
        
    });

    this.lireFichier = function () {
        console.log('lecture'); 
             if (opts.callback) { 
            opts.callback(this);
       }else{
           this.donnees = opts.donnees; 
        } 
       this.donnees_bak = this.donnees;
       var keys = Object.keys(this.donnees[0]);
       
       this.colonnes = [];
       for (var i=0, l=keys.length; i<l; i++) {
           this.colonnes.push({nomcol:keys[i], tri:''});
       }       

       //this.filtrer();
       
       var colexclude = this.col;
       _.each(this.donnees, function(elem) {
         for (i=0, l=colexclude.length; i<l; i++) {
            delete elem[colexclude[i]] ;
         }
       });
       
        this.colonnes = _.filter(this.colonnes, function(elem){
            return !_.contains(colexclude,elem.nomcol);
        });       


        if (this.opts.triDefaut) {
            this.trier(this.opts.triDefaut); 
        }
        this.update();
    }
   
   
    this.filtrer = function() {
       var filtreCol = this.filtreCol;
       var filtreVal = this.filtreVal;        
        
        
       if (filtreCol === '') {
            this.donnees = this.donnees_bak;
       }else{
           var pos = filtreVal.indexOf("*");
           if (pos > -1 && pos === filtreVal.length-1)
           {    
               this.donnees = _.filter(this.donnees_bak, function(elem) {
                  var filval = filtreVal.replace('*',''); 
                  return (elem[filtreCol].startsWith(filval)) ;
               });
           }else{
               this.donnees = _.filter(this.donnees_bak, function(elem) {
                  var r =  (elem[filtreCol] == filtreVal) ;
                  console.log (elem[filtreCol] + ' - ' + filtreVal + ' - ' + filtreCol + ' - ' + r);
                  return r;
               });          
           }
       } 
       
       
       
       this.update();
    };
   
   
    this.tableau = function() {
        var indice = -1;
        var col =this.col;
        var $lignes = $('#'+opts['data-id']).children('tbody').children('tr');

        $lignes.children('th').each(function() {
            var c = $(this).attr('data-column');  
            if (c === ''  || _.contains(col,c)){
              indice = $(this).index();
              $(this).remove();
              //$lignes.each(function() {
              //   $(this).children("td:eq(" + indice + "), th:eq(" + indice+")").remove();
              //});  
            }
        });
    };
    
    this.cacheRem = function(e) {
        return;
        var remarque = this.parent.remarque;
        remarque.style.display='none';
    };
     
    this.activeligne = function(e) {
        this.parent.selectionne = e.item.i;
    }
    
    this.ligneactive = function(i) {
        if (i == this.selectionne)
        {
            return this.ligneactiveClass;
        }else{
            return '';
        }
    }
    
    this.click_trier = function(e) {
        var colonne = e.target.getAttribute('data-column');
        this.parent.trier(colonne); 
    }
    
    
    this.trier = function(colonne) {
        //var colonne = e.target.getAttribute('data-column');
        if (colonne !== this.colonne) {
            this.tri = 'up';
            this.colonne = colonne;
        }
        
        this.donnees = _.sortBy(this.donnees, colonne);
        
        if (this.tri==="down") {
            this.tri = 'up';
            this.donnees.reverse();
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
    };
    
    </script>
       
</matable>