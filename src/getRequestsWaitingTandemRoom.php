<?php

/**************************************************************************************************************** */
/********** M A N A G E   W A I T I N G    R O O M    F O R     D B    I N S E R T I O N S ********************** */
/**************************************************************************************************************** */  
     
require_once dirname(__FILE__) . '/classes/gestorBD.php';  

if(isset($_REQUEST['language'])){
    $language = $_REQUEST['language'];
}



if(isset($_REQUEST['tandem_language'])){
    $tandem_language = $_REQUEST['tandem_language'];
}

if(isset($_REQUEST['courseID'])){
    $courseID = $_REQUEST['courseID'];
}

if(isset($_REQUEST['exerciseID'])){
    $exerciseID = $_REQUEST['exerciseID'];
    
}

if(isset($_REQUEST['userID'])){
    $userID = $_REQUEST['userID'];
}

if(isset($_REQUEST['ltiID'])){
    $idRscLti = $_REQUEST['ltiID'];
}

if(isset($_REQUEST['onlyExID'])){
    $onlyExID = $_REQUEST['onlyExID'];
}

echo var_dump($language,$tandem_language,$courseID,$exerciseID,$userID,$idRscLti,$onlyExID);


$oWiewport = new GestorBD();


//waiting

$RESPONSE = array();

$RESPONSE = $oWiewport->updateWaitingDB($language, $tandem_language,$courseID, $exerciseID,$userID,$idRscLti,$onlyExID);

print_r($RESPONSE);

echo var_dump($RESPONSE);
//tandem

//$aTandemDB=$oWiewport->updateTandemDB($language, $courseID);


//Anem a fer els métodes i ja veurem com passem els diferents paràmetres !!


//$mWT = array('waiting'=>$aWaitingDB,'tandem'=>$aTandemDB);



//$oJson=json_encode($mWT,JSON_FORCE_OBJECT);


//echo $oJson;



