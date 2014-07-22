<?php

/**************************************************************************************************************** */
/********** M A N A G E   W A I T I N G    R O O M    F O R     D B    I N S E R T I O N S ********************** */
/**************************************************************************************************************** */  
     
require_once dirname(__FILE__) . '/classes/gestorBD.php';  

if(isset($_POST['language'])){
    $language = $_POST['language'];
}else{
    $language = 'en_US';
}

if(isset($_POST['courseID'])){
    $courseID = $_POST['courseID'];
}else{
    $courseID = 2;
}

$oWiewport = new GestorBD();


//waiting

$RESONSE = $oWiewport->insertUserAndRoom($language, $courseID, $idExercise, $idNumberUserWaiting, $idUser);



//tandem

$aTandemDB=$oWiewport->updateTandemDB($language, $courseID);


//Anem a fer els métodes i ja veurem com passem els diferents paràmetres !!


$mWT = array('waiting'=>$aWaitingDB,'tandem'=>$aTandemDB);



$oJson=json_encode($mWT,JSON_FORCE_OBJECT);


echo $oJson;



