<?php
// create_admin.php
require_once '/var/www/html/wp-load.php';

$username = getenv('WP_ADMIN_USER');      // Ex: pm_admin42
$password = getenv('WP_ADMIN_PASS');      // Ex: supersecurepassword
$email    = getenv('WP_ADMIN_EMAIL');     // Ex: pm42@example.com

if (!username_exists($username)) {
    $user_id = wp_create_user($username, $password, $email);
    if (!is_wp_error($user_id)) {
        $user = new WP_User($user_id);
        $user->set_role('administrator');
        echo "Admin user created: $username\n";
    } else {
        echo "Error creating user: ".$user_id->get_error_message()."\n";
    }
} else {
    echo "Admin user $username already exists\n";
}
