<?php
	$conexao = "global";
	if ($conexao == "local") {
		$host = "127.0.0.1"; //computador onde o servidor de banco de dados esta instalado
		$user_host = "root"; //seu usuario para acessar o banco
		$pass_host = "admin"; //senha do usuario para acessar o banco
		$banco = "renault-salao"; //banco que deseja acessar  
	}
    if ($conexao == "global") {
		$host = "localhost"; //computador onde o servidor de banco de dados esta instalado
		$user_host = "tranz_renault"; //seu usuario para acessar o banco
		$pass_host = "NsQrN)1E+#T"; //senha do usuario para acessar o banco
		$banco = "tranz_renault-salao"; //banco que deseja acessar  
	}

	$conn = mysql_connect($host, $user_host, $pass_host) or die (mysql_error());
	mysql_select_db($banco, $conn);
?>