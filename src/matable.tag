<matable>

    <div class="matable">
        <yield/>
        <table class="table table-striped" id="{opts['data-id']}"> 
            <tr class="{this.colHeaderClass}"> 
                <th each={c in this.colHeader} data-column="{c.nomcol}" onclick="{this.parent.click_trier}">{c.nomcol} <span class="glyphicon glyphicon-arrow-{c.tri}"></span>  </th>           
             </tr> 
            <tr each={ elem, i in this.data } class="{this.parent.activeLine(i)}" onmouseover="{parent.lineOver }"  >
                <td each={ d in elem } >{elem[d]}</td>
            </tr>  
        </table>
   </div>
       
    <style>
        matable table th {cursor:pointer}
        matable span.glyphicon { padding-left:10px} 
    </style>
    
    <script>
    this.data         = [];
    this.data_bak     = [];
    this.tri          = 'up';
    this.colHeader    = [];
    this.colExcluded  = [];
    this.selectionne  = -1;
    this.colHeaderClass  = "";
    this.activeLineClass = '';
    this.filtreCol    = '';
    this.filtreVal    = '';
    
    this.on('mount', function() {
      this.init(); 
    });
    
    this.init = function() {
       this.colHeaderClass = this.opts.styles.colHeaderClass || this.colHeaderClass;
       this.activeLineClass = this.opts.styles.activeLineClass || this.activeLineClass;
       
       if (this.opts['colexcluded']) {
            this.colExcluded = this.opts['colexcluded'].replace(/ /g,'').split(',');
       }
       
       if (this.activeLineClass ==='') {
           this.activeLine = function() { return };
       }  
       
       if (this.opts.colFilter) {
           this.filtreCol = opts.colFilter;
       };
       
       if (this.opts.valueFilter) {
           this.filtreVal = opts.valueFilter;
       };       
       
       
    };
    
    
    this.formatTable = function () {
       var keys = Object.keys(this.data[0]);
       
       this.colHeader = [];
       for (var i=0, l=keys.length; i<l; i++) {
           this.colHeader.push({nomcol:keys[i], tri:''});
       }       
       
       var colexclude = this.colExcluded;
       _.each(this.data, function(elem) {
         for (i=0, l=colexclude.length; i<l; i++) {
            delete elem[colexclude[i]] ;
         }
       });
       
        this.colHeader = _.filter(this.colHeader, function(elem){
            return !_.contains(colexclude,elem.nomcol);
        });       

        if (this.opts.triDefaut) {
            this.trier(this.opts.triDefaut); 
        }
        this.update();        
    };
    

    this.start = function (data) {
        if (!data) {
           this.data = this.opts.data; 
        }else{
            this.data = data;
        }
       this.data_bak = this.data;
       this.filtrer();
       this.formatTable();
    };
   
    this.filtrer = function() {
       var filtreCol = this.filtreCol;
       var filtreVal = this.filtreVal;        
        
       if (filtreCol === '') {
            this.data = this.data_bak;
       }else{
           var pos = filtreVal.indexOf("*");
           if (pos > -1 && pos === filtreVal.length-1)
           {    
               this.data = _.filter(this.data_bak, function(elem) {
                  var filval = filtreVal.replace('*',''); 
                  return (elem[filtreCol].startsWith(filval)) ;
               });
           }else{
               this.data = _.filter(this.data_bak, function(elem) {
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
        var colExcluded =this.colExcluded;
        var $lignes = $('#'+opts['data-id']).children('tbody').children('tr');

        $lignes.children('th').each(function() {
            var c = $(this).attr('data-column');  
            if (c === ''  || _.contains(colExcluded,c)){
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
     
    this.lineOver = function(e) {
        this.parent.selectionne = e.item.i;
    };
    
    this.activeLine = function(i) {
        if (i == this.selectionne)
        {
            return this.activeLineClass;
        }else{
            return '';
        }
    };
    
    this.click_trier = function(e) {
        var colonne = e.target.getAttribute('data-column');
        this.parent.trier(colonne); 
    };
    
    
    this.trier = function(colonne) {
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

        for (var i=0, l = this.colHeader.length; i < l; i++) {
            if (this.colHeader[i].nomcol === colonne) {
                this.colHeader[i].tri = this.tri;  
            }else{
                this.colHeader[i].tri = '';
            }
        }
    };
    
    </script>
       
</matable>