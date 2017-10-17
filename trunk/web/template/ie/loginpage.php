<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>Login</title>
    <?php include("template/$OJ_TEMPLATE/css.php");?>


    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="http://cdn.bootcss.com/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="http://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>
  <div class="container">
  <?php include("template/$OJ_TEMPLATE/nav.php");?>
    <!-- Main component for a primary marketing message or call to action -->
    <div class="jumbotron">
      <form id="login" action="login.php" method="post" role="form" class="form-horizontal" onSubmit="return jsMd5();"  >
        <br>
        <br>
        <center>
          <table>
            <tr>
              <td width=25%><?php echo $MSG_USER_ID?></td>
              <td width=75%><input name="user_id" class="form-control" placeholder="<?php echo $MSG_USER_ID?>" type="text"></td>
            </tr>
            <tr>
              <td width=25%><?php echo $MSG_PASSWORD?></td>
              <td width=75%><input name="password" class="form-control" placeholder="<?php echo $MSG_PASSWORD?>" type="password"></td>
            </tr>
            <tr>
              <?php if($OJ_VCODE){?>
              <div class="col-sm-4"><input name="vcode" class="form-control" type="text"></div>
              <div class="col-sm-4"><img alt="click to change" src="vcode.php" onclick="this.src='vcode.php?'+Math.random()" height="30px">*</div>						</div>
              <?php }?>
            </tr>
            <tr>
              <td></td>
              <td>
                <button name="submit" type="submit" class="btn btn-default btn-block" ><?php echo $MSG_LOGIN; ?></button>
              </td>
            </tr>
          </table>
        </center>
        <br>
        <br>
      </form>
      <center>
        <a href="lostpassword.php"><?php echo $MSG_LOST_PASSWORD; ?>?</a>
      </center>
  	  <script src="include/md5-min.js"></script>
  	  <script>
      	function jsMd5(){
      		if($("input[name=password]").val()=="") return false;
      		$("input[name=password]").val(hex_md5($("input[name=password]").val()));
      		return true;
      	}
    	</script>
  </div> <!-- /container -->
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->

  <?php include("template/$OJ_TEMPLATE/js.php");?>
  </body>
</html>
