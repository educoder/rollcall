<?php

/**
 * This example requires the Pest REST client.
 * See https://github.com/educoder/pest
 **/

// This mkes things easier in my local dev environment... you can ignore this line
// or change it to something useful for yourself
set_include_path(get_include_path() . PATH_SEPARATOR . '../../../');

require 'Pest/PestXML.php';

// The base rollcall URL (don't include the trailing "/" slash)
$rollcall_site_url = "http://localhost:3000";
$pest = new PestXML($rollcall_site_url);



/** FETCH MULTIPLE RESOURCES IN A COLLECTION **/

// Fetch all Users
$users = $pest->get('/users.xml');

// Print the display name and login for each User returned.
foreach($users->user as $user) {
   echo $user->{'display-name'}." (".$user->login.")\n";
}


// Fetch all Groups
$groups = $pest->get('/groups.xml');

// Fetch all of the Groups that a specific user belongs to
$groups = $pest->get('/users/15/groups.xml');



/** FETCH A SPECIFIC RESOURCE **/

// Get the ID of the first User in the set returned above
$id = $users->user[0]->id;

// Fetch the User resource its ID
$user = $pest->get('/users/'.$id.'.xml');

echo $user->{'display-name'}." (".$user->login.")\n";

// You can also fetch a User by their login
$login = 'bobama';
try {
  $user2 = $pest->get('/users/'.$login.'.xml');
} catch (Pest_NotFound $e) {
  echo $e->getMessage();
}



/** CREATE A NEW RESOURCE **/

// Note that the data array must be nested under a 'user' key.
$data = array(
  'user' => array(
    'login' => "jdoe",
    'display_name' => "John Doe",
    'kind' => "Instructor",
    'metadata' => array(
      'hair colour' => 'Brown'
    )
  )
);

$user = $pest->post('/users.xml', $data);

echo $user->{'display-name'}." (".$user->login.")\n";

$id = $user->id;



/** UPDATE AN EXISTING RESOURCE **/

// Note that the 'metadata' part is arbitrary --
// you can use any key-value pair here.
$data = array(
  'user' => array(
    'display_name' => "John Doe Jr.",
    'kind' => "Student",
    'metadata' => array(
      'hair colour' => 'Green',
      'age' => 12
    )
  )
);

try {
  $pest->put('/users/'.$id.'.xml', $data);
  echo "User ".$id." updated.";
} catch (Pest_Exception $e) {
  echo "Couldn't update User ".$id." because: ".$e->getMessage();
}


/** DELETE A RESOURCE **/

try {
  $pest->delete('/users/'.$id.'.xml');
  echo "User ".$id." deleted.";
} catch (Pest_Exception $e) {
  echo "Couldn't delete User ".$id." because: ".$e->getMessage();
}

?>
