<?php
// ** MySQL settings - You can get this info from your web host ** //
$db_data = false;
if ( file_exists('/opt/aws/cloud_formation.json') ) {
        $db_data = json_decode(file_get_contents('/opt/aws/cloud_formation.json'), true);
        if ( isset($db_data['rds']) ) {
                $db_data = $db_data['rds'];
                $db_data['host'] = $db_data['endpoint'] . ':' . $db_data['port'];
        }
}
if ( !$db_data ) {
        $db_data = array(
                'database' => '<%= @db_name %>',
                'username' => '<%= @user_name %>',
                'password' => '<%= @password %>',
                'host'     => 'localhost',
        );
}

/** The name of the database for WordPress */
define('DB_NAME', $db_data['database']);

/** MySQL database username */
define('DB_USER', $db_data['username']);

/** MySQL database password */
define('DB_PASSWORD', $db_data['password']);

/** MySQL hostname */
define('DB_HOST', $db_data['host']);

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

unset($db_data);
