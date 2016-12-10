<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>user login</title>

<style type="text/css">
<!--
    #login {
        margin: 30px auto 10px auto;
        width: 400px;
        border: #CFE4F8 1px solid;
        background-color: #FFF;
    }

    input{
        width: 220px;
        height:30px;
        border: #CCC 1px solid;
        font: Georgia, "Times New Roman",Times, serif;
        font-size: 20px;
    }

    #button {
        width: 87px;
        height: 63px;
    }

    #loginform
    {
        font-size: 12px;
    }

    #loginform img {
        display: inline;
        border: #999 1px solid;
        height: 30px;
        margin: 0 0 0 20px;
        cursor: pointer;
    }
-->
</style>

<script type="text/javascript">
/*
*   reload check code
 */

function refreshCheckCode(obj, url)
{
    obj.src = url + '?nowtime=' + new Data(.getTime);
}
</script>


</head>
<body>
<div id="login">
    <font name="loginform" id="loginform"
        action="<?=$_SERVER['PHP_SELF']?>" method="post">
        <table width="400">
            <tr>
                <td width='50' height='34'>username</td>
                <td width='240'><input type="text" name="name" id="name"/></td>
                <td width="96"><input type="submit" name="buttom" id="buttom" value="Login"/></td>
            </tr>
            <tr>
                <td>password</td>
                <td><input type="password" name="pwd" id="pwd"/></td>
            </tr>
            <tr>
                <td>checkcode </td>
                <td><input type="text" name="code" id="code"/></td>
                <img src="CheckCode.php" alt="can't see,change other" align="bottom"
                      onclick="javascript:refreshCheckCode(this,this.src);"/>
            </tr>
          </table>
    </font>
</div>

<?php
    //in ture we need to connect the database
    define('NAME','momo');
    define('PASSWORD','ilovelin');

    /*
    * login check
    */

    if(isset($_POST['button'])){    //if post the form,then start the session
        session_start();

        //sigin a session
        if(isset($_SESSION['count'])) {
            $_SESSION['count']=0;
        }

        //if wrong passwd more than 4 times, then let him out
        if($_SESSION['count']>4){
            echo '<script>alert("you cant login!");</script>';
            exit();
        }

        $session_code = strtoupper(trim($_SESSION['code'])); //get the ture value of the checkcode
        $code = strtoupper(trim($_POST['code']));

        //check the checkcode right or no

        if($session_code != $code) {
            echo '<script>alert("wrong checkcode");</script>';
            exit();
        }

        //check the password and username
        if(isset($_POST['name']) && isset($_POST['pwd'])) {
            $name = trim($_POST['name']);
            $pwd = $_POST['pwd'];

            //if password and username is right
            //sigin a session,and jump to login success page
            //if no, alert and count++
            if($name==NAME && $pwd==PASSWORD){
                $_SESSION['user'] = $name;
                header('location:success.php');
            }else{
                $_SESSION['count']++;
                if($_SESSION['count']>4){
                    echo '<script>alert("you cant login");</script>';
                    exit();
                }

                $num=5-$_SESSION['count'];
                $msg='login fail\n chenck your username and password\n you can retry '.$num.' times';
                echo '<script>alert("'.$msg.'");</script>';
            }
        }
    }
 ?>


</body>
</html>
