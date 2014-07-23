<?php

/**************************************************************************************************************** */
/********** M A N A G E   W A I T I N G    R O O M    F O R     D B    I N S E R T I O N S ********************** */
/**************************************************************************************************************** */  
     
require_once dirname(__FILE__) . '/classes/gestorBD.php';  

if(isset($_POST['language'])){
    $language = $_POST['language'];
}

if(isset($_POST['tandem_language'])){
    $tandem_language = $_POST['tandem_language'];
}

if(isset($_POST['courseID'])){
    $courseID = $_POST['courseID'];
}

if(isset($_POST['exerciseID'])){
    $exerciseID = $_POST['exerciseID'];
}

if(isset($_POST['userID'])){
    $userID = $_POST['userID'];
}

$oWiewport = new GestorBD();


//waiting

$RESPONSE = array();

$RESPONSE = $oWiewport->updateWaitingDB($language, $tandem_language,$courseID, $exerciseID, $userID);

print_r($RESPONSE);

//tandem

//$aTandemDB=$oWiewport->updateTandemDB($language, $courseID);


//Anem a fer els métodes i ja veurem com passem els diferents paràmetres !!


//$mWT = array('waiting'=>$aWaitingDB,'tandem'=>$aTandemDB);



//$oJson=json_encode($mWT,JSON_FORCE_OBJECT);


//echo $oJson;



