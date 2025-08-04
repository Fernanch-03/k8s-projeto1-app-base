<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

include 'conexao.php';

// Verificar se é uma requisição POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo "Method not allowed";
    exit;
}

// Verificar se os campos obrigatórios existem
if (!isset($_POST["nome"]) || !isset($_POST["email"]) || !isset($_POST["comentario"])) {
    http_response_code(400);
    echo "Missing required fields: nome, email, comentario";
    exit;
}

// Sanitizar os dados de entrada
$nome = trim($_POST["nome"]);
$email = trim($_POST["email"]);
$comentario = trim($_POST["comentario"]);

// Validar se os campos não estão vazios
if (empty($nome) || empty($email) || empty($comentario)) {
    http_response_code(400);
    echo "All fields are required and cannot be empty";
    exit;
}

// Usar prepared statement para evitar SQL injection
$stmt = $link->prepare("INSERT INTO mensagens(nome, email, comentario) VALUES (?, ?, ?)");
if (!$stmt) {
    echo "Error preparing statement: " . $link->error;
    exit;
}

$stmt->bind_param("sss", $nome, $email, $comentario);

if ($stmt->execute()) {
    echo "New record created successfully";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
?>