#! /usr/bin/php
<?php
error_reporting(E_ERROR | E_PARSE);
include('/var/www/html/lib/common.lib.php');
include('/var/www/html/classes/phpass/PasswordHash.php');
$adminpassword = getenv('ADMIN_PASS');
$hasher = new PasswordHash(8, false);
$password = md5($adminpassword);
$hash = $hasher->HashPassword($password);
$hash = (!get_magic_quotes_gpc()) ? addslashes($hash) : $hash;
print($hash);
?>

