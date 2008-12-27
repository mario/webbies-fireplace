<?php
/** Modified WordPress Installer for Firepalce Wordpress Stack */
define('WP_INSTALLING', true);

/** Load WordPress Bootstrap */
require_once('../wp-load.php');

/** Load WordPress Administration Upgrade API */
require_once('./includes/upgrade.php');

/** Display install header. */
function display_header() {
header( 'Content-Type: text/html; charset=utf-8' );
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" <?php language_attributes(); ?>>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<?php
}//end function display_header();

if ( !empty($wpdb->error) )	wp_die($wpdb->error->get_error_message());

display_header();

$wpdb->show_errors();
$result = wp_install('Blog', 'admin', 'USEREMAIL', '1');
extract($result, EXTR_SKIP);
?>

</body>
</html>
