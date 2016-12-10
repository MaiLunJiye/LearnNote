<?php
/*
 * use cookie save the form
 */

if(!isset($_POST['submit'])){
    $username = '';
    $email = '';
    $tel = '';

    //if set cookie, get it
    if(isset($_COOKIE['username'])) $username = $_COOKIE['username'];
    if(isset($_COOKIE['email'])) $email = $_COOKIE['email'];
    if(isset($_COOKIE['tel'])) $tel = $_COOKIE['tel'];

    //out put form
    echo <<<FORM
    <form action="{$_SERVER['PHP_SELF']}" method = "post">
        <table>
        <tr>
            <td>username:</td>
            <td><input type="text" name="username" value="{$username}"/><td>
        </tr>
        <tr>
            <td>email:</td>
            <td><input type="text" name="email" value="{$email}"/></td>
        </tr>
        <tr>
            <td>tel:</td>
            <td><input type="text" name="tel" value="{$tel}"/><td>
        </tr>

        <tr>
            <td colspan=2><input type="submit" name="submit" value="submit"/></td>
        </tr>

        </table>
    </form>

FORM;
}else{
    //提交表单后: 先检查是否为空
    if(empty($_POST['username'])){
        echo 'alert: username cant empty!'; 
    }
    elseif(empty($_POST['email'])){  
        echo 'alert: email cant empty!'; 
    }
    elseif(empty($_POST['tel'])){  
        echo 'alert: tel cant empty!'; 
    }   //检查通过,输出用户信息
    else{
        echo 'you info<br>';
        echo 'username: '.$_POST['username'].'<br>';
        echo 'email: '.$_POST['email'].'<br>';
        echo 'tel: '.$_POST['tel'].'<br>';
    }

    //返回链接
    echo '<p><a href="'.$_SERVER['PHP_SELF'].'">back</a>';

    setcookie('username', $_POST['username'], time()+3600*24);
    setcookie('email', $_POST['email'], time()+3600*24);
    setcookie('tel', $_POST['tel'], time()+3600*24);
}

?>
