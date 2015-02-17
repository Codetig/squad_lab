$(document).ready(function(){
  $('#student-edit small').hide();

  var showSquadName = function(tag){
    var sId = parseInt(tag);
    console.log(typeof sId);
    $.ajax({
      type:"GET",
      datatype:"json",
      url: "/jsquads/" + tag,
      success:function(data){
        //var squad = JSON.parse(data); //return a JS object JSON.parse unecessary.
        //console.log(data);
        $('#student-edit small').text('Squad ID #' + tag +' '+ data.name);
        $('#student-edit small').show();
      }, //end of success function
      error: function(){
        $('#student-edit small').text('There is no squad with ID: ' + tag );
        $('#student-edit small').show();
        $('#student-edit small').fadeOut(4000);
        $('#squad_id').val('');
      } //end of error
    }); //ajax call for squad name end
  };

  var squadNames = function(){
    $.ajax({
      type:"GET",
      datatype:"json",
      url: "/jsquads",
      success:function(data){
        $('#student-edit ul li').remove();
        data.forEach(function(sq){
          $('#student-edit ul').append('<li><small>' +sq.squad_id+ ' => ' + sq.name +'</small></li>');
        });
        $('#student-edit ul li').fadeOut(6000);
      }, //end of success function
      
    }); //ajax call for squad name end
  };

$('body').on('focus', '#student-edit #squad_id',function(e){
  squadNames();
}); //input focus end
$('body').on('change', '#student-edit #squad_id',function(e){
  showSquadName($(this).val());
}); //input change end

$('body').on('click', '.del', function(e){
  e.preventDefault();
  $('.del').toggleClass('del');
  alert("This will delete the current record");

});


});