 // Place all the behaviors and hooks related to the matching controller here.
 // All this logic will automatically be available in application.js.
 // You can use CoffeeScript in this file: http://coffeescript.org/

 var all_users =[];
 var array_of_users = new Array();
 var nIntervId;
 var count=0;
 var flag = 0;


$(document).ready(function(){
//it will run at the time of page loading...
 //alert("user");
    document.getElementById("user").value = " " ;
    $("#error").html('');
    document.charset = 'ISO-8859-1';
    all_users = [];
      $.ajax({
        type: "GET",
        url:"/get_user",
        success:function(result){
          $("#users_list>table").html(" ");
          $("#users_list>table").append('<tr><td><b>Users</b></td><td><b>Action</b></td></tr>')
          $.each(result,function(key,val){
            all_users.push(val.user);
            $("#users_list>table").append('<tr><td>'+val.user+'</td><td> <input type="button" value="Delete" id="delete_'+ val.id +'" class= "delete btn btn-xs btn-danger" onclick = "delete_data('+val.id+');"></td></tr>');
              array_of_users = all_users;
          });
        
        } , async:   false

      });

  // add new user.......
    $("#add_user").click(function(e){
      $("#error").html('');
      var val = document.getElementById("user").value;
      if (val.toString().trim().length == 0){
      	 $("#error").append('User should not be blank..!!!');
      	e.preventDefault();
      }
      else{
	      all_users = [];
	      
	      $.ajax({
	        type: "POST",
	        url:"/add_user?user="+val,
	        success:function(result){
	            document.getElementById("user").value = " " ;
	            $("#users_list>table").html(" ");
	            $("#users_list>table").append('<tr><td><b>Users</b></td><td><b>Action</b></td></tr>')
	            $.each(result,function(key,val){
	               all_users.push(val.user);
	               $("#users_list>table").append('<tr><td>'+val.user+'</td><td> <input type="button" value="Delete" id="delete_'+ val.id +'" class= "btn btn-xs btn-danger" onclick = "delete_data('+val.id+');"></td></tr>');
	                array_of_users = all_users;
	         });            
	       },  async:   false
	      }); 
	    }
    });

      // Import users user.......


  });

//for delete user.....
function delete_data(id){
  $("#error").html('');
  all_users = [];
  $.ajax({
    type: "GET",
    url:"/delete_user?id="+id,
    success:function(result){
      $("#users_list>table").html(" ");
      $("#users_list>table").append('<tr><td><b>Users</b></td><td><b>Action</b></td></tr>')
      $.each(result,function(key,val){
        all_users.push(val.user);
        $("#users_list>table").append('<tr><td>'+val.user+'</td><td> <input type="button" value="Delete" id="delete_'+ val.id +'" class= "btn btn-xs btn-danger" onclick = "delete_data('+val.id+');"></td></tr>');
        array_of_users = all_users; 
      });       
    },  async:   false
  });
}
     
