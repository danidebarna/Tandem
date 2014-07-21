<?php

/************************************************************************************************************** */
/********** M A N A G E   W A I T I N G    R O O M    F O R    A J A X     ***************** */
/************************************************************************************************************** */  
     
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


$aWaiting=$oWiewport->updateWaiting($language, $courseID);


$aTandem=$oWiewport->updateTandem($language, $courseID);


$mWT = array('waiting'=>$aWaiting,'tandem'=>$aTandem);


$oJson=json_encode($mWT,JSON_FORCE_OBJECT);


echo $oJson;



