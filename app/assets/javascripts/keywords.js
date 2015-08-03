 // Place all the behaviors and hooks related to the matching controller here.
 // All this logic will automatically be available in application.js.
 // You can use CoffeeScript in this file: http://coffeescript.org/

 var all_keyword =[];
 var array_of_keywords = new Array();
 var nIntervId;
 var count=0;
 var flag = 0;


$(document).ready(function(){
//it will run at the time of page loading...
//alert("keyword");
    document.getElementById("keyword").value = " " ;
    $("#error").html('');
    document.charset = 'ISO-8859-1';
    all_keyword = [];
      $.ajax({
        type: "GET",
        url:"/get_data",
        success:function(result){
          $("#keywords_list>table").html(" ");
          $("#keywords_list>table").append('<tr><td><b>keywords</b></td><td><b>Action</b></td></tr>')
          $.each(result,function(key,val){
            all_keyword.push(val.keyword);
            $("#keywords_list>table").append('<tr><td>'+val.keyword+'</td><td> <input type="button" value="Delete" id="delete_'+ val.id +'" class= "delete btn btn-xs btn-danger" onclick = "delete_data('+val.id+');"></td></tr>');
              array_of_keywords = all_keyword;
          });
        
        } , async:   false

      });

  // add new keyword.......
    $("#add_keyword").click(function(e){
      $("#error").html('');
      var val = document.getElementById("keyword").value;
      if (val.toString().trim().length == 0){
      	 $("#error").append('Keyword should not be blank..!!!');
      	e.preventDefault();
      }
      else{
	      all_keyword = [];
	      
	      $.ajax({
	        type: "POST",
	        url:"/add?keyword="+val,
	        success:function(result){
	            document.getElementById("keyword").value = " " ;
	            $("#keywords_list>table").html(" ");
	            $("#keywords_list>table").append('<tr><td><b>keywords</b></td><td><b>Action</b></td></tr>')
	            $.each(result,function(key,val){
	               all_keyword.push(val.keyword);
	               $("#keywords_list>table").append('<tr><td>'+val.keyword+'</td><td> <input type="button" value="Delete" id="delete_'+ val.id +'" class= "btn btn-xs btn-danger" onclick = "delete_data('+val.id+');"></td></tr>');
	                array_of_keywords = all_keyword;
	         });            
	       },  async:   false
	      }); 
	    }
    });

      // Import keywords keyword.......


  });

//for delete keyword.....
function delete_data(id){
  $("#error").html('');
  all_keyword = [];
  $.ajax({
    type: "GET",
    url:"/delete?id="+id,
    success:function(result){
      $("#keywords_list>table").html(" ");
      $("#keywords_list>table").append('<tr><td><b>keywords</b></td><td><b>Action</b></td></tr>')
      $.each(result,function(key,val){
        all_keyword.push(val.keyword);
        $("#keywords_list>table").append('<tr><td>'+val.keyword+'</td><td> <input type="button" value="Delete" id="delete_'+ val.id +'" class= "btn btn-xs btn-danger" onclick = "delete_data('+val.id+');"></td></tr>');
        array_of_keywords = all_keyword; 
      });       
    },  async:   false
  });
}
     
