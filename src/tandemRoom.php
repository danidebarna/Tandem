<?php
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

require_once dirname(__FILE__) . '/classes/lang.php';
require_once dirname(__FILE__) . '/classes/constants.php';
require_once dirname(__FILE__) . '/classes/gestorBD.php';

require_once 'IMSBasicLTI/uoc-blti/lti_utils.php';

$user_obj = isset($_SESSION[CURRENT_USER]) ? $_SESSION[CURRENT_USER] : false;

$course_id = isset($_SESSION[COURSE_ID]) ? $_SESSION[COURSE_ID] : false;

$use_waiting_room = isset($_SESSION[USE_WAITING_ROOM]) ? $_SESSION[USE_WAITING_ROOM] : false;

require_once dirname(__FILE__) . '/classes/IntegrationTandemBLTI.php';



if (!$user_obj || !$course_id) {
//Tornem a l'index
    header('Location: index.php');
} else {
    require_once(dirname(__FILE__) . '/classes/constants.php');
    $path = '';
    if (isset($_SESSION[TANDEM_COURSE_FOLDER]))
        $path = $_SESSION[TANDEM_COURSE_FOLDER] . '/';

    $id_resource_lti = $_SESSION[ID_RESOURCE];

    $lti_context = unserialize($_SESSION[LTI_CONTEXT]);

    $gestorBD = new GestorBD();
    $users_course = $gestorBD->obte_llistat_usuaris($course_id, $user_obj->id);
    $is_reload = isset($_POST['reload']) ? $_POST['reload'] != null : false;

    if ($is_reload || !$users_course || count($users_course) == 0) {
        if ($lti_context->hasMembershipsService()) { //Carreguem per LTI
        //Convertir el llistat d'usuaris a un array de
        //person_name_given
        //person_name_family
        //person_name_full
        //person_contact_email_primary
        //roles: separats per comes
        //lis_result_sourcedid
            $users_course_lti = $lti_context->doMembershipsService(array()); //$users_course no ho passem per evitar problemes ja que el continguts son array i no un obj LTI
            $users_course = array();
            foreach ($users_course_lti as $user_lti) {
                $id_user_lti = $user_lti->getId();
                $firstname = mb_convert_encoding($user_lti->firstname, 'ISO-8859-1', 'UTF-8');
                $lastname = mb_convert_encoding($user_lti->lastname, 'ISO-8859-1', 'UTF-8');
                $fullname = mb_convert_encoding($user_lti->fullname, 'ISO-8859-1', 'UTF-8');
                $email = mb_convert_encoding($user_lti->email, 'ISO-8859-1', 'UTF-8');

                $gestorBD->afegeixUsuari($course_id, $id_user_lti, $firstname, $lastname, $fullname, $email, '');
//$users_course[$id_user_lti] = $gestorBD->get_user_by_username($id_user_lti);
            }
//Reorder
            $users_course = $gestorBD->obte_llistat_usuaris($course_id, $user_obj->id);
        } else { //Mirem de carregar per OKI
            $okibusPHP_components = $_SESSION[OKIBUSPHP_COMPONENTS];
            $okibusPHP_okibusClient = $_SESSION[OKIBUSPHP_OKIBUSCLIENT];
            putenv(OKIBUSPHP_COMPONENTS . '=' . $okibusPHP_components);
            putenv(OKIBUSPHP_OKIBUSCLIENT . '=' . $okibusPHP_okibusClient);
//Pel require d'autehtnication ja carrega les propietats
            require_once dirname(__FILE__) . '/classes/gestorOKI.php';
            $gestorOKI = new GestorOKI();
            $users_course = $gestorOKI->obte_llistat_usuaris($gestorBD, $course_id);
        }
    }
    $is_showTandem = isset($_POST['showTandem']) ? $_POST['showTandem'] != null : false;
    $user_tandems = null;
    $user_selected = isset($_POST['user_selected']) ? intval($_POST['user_selected']) : 0;
    if ($is_showTandem && $user_selected) {
        $exercise = isset($_POST['room']) ? intval($_POST['room'], 10) : false;
        $user_tandems = $gestorBD->obte_llistat_tandems($course_id, $user_selected, $exercise);
    }




//Permetem que seleccini l'exercici 20111110
    $is_host = $user_obj->is_host;

    $array_exercises = $gestorBD->get_tandem_exercises($course_id);
    $tandemBLTI = new IntegrationTandemBLTI();
    $selected_exercise = $tandemBLTI->checkXML2GetExercise($user_obj);
    $selected_exercise_select = isset($_POST['room']) ? $_POST['room'] : '';

    $pending_invitations = $gestorBD->get_invited_to_join($user_obj->id, $id_resource_lti, $course_id, true);
    $last_id = $gestorBD->get_lastid_invited_to_join($user_obj->id, $id_resource_lti, $course_id);

//Agafem les dades de l'usuari
    $name = mb_convert_encoding($user_obj->name, 'UTF-8', 'UTF-8');
    ?>
    <!DOCTYPE html>
    <html>
        <head>
            <title>Tandem</title>
            <meta charset="UTF-8" />
            <link rel="stylesheet" type="text/css" media="all" href="css/tandem.css" />
            <link rel="stylesheet" type="text/css" media="all" href="css/tandem-waiting-room.css" />
            <link rel="stylesheet" type="text/css" media="all" href="css/defaultInit.css" />
            <link rel="stylesheet" type="text/css" media="all" href="css/jquery-ui.css" />
            <!-- 10082012: nfinney> ADDED COLORBOX CSS LINK -->
            <link rel="stylesheet" type="text/css" media="all" href="css/colorbox.css" />
            <!-- END -->
            <script src="js/jquery-1.7.2.min.js"></script>
            <script src="js/jquery.ui.core.js"></script>
            <script src="js/jquery.ui.widget.js"></script>
            <script src="js/jquery.ui.button.js"></script>
            <script src="js/jquery.ui.position.js"></script>
            <script src="js/jquery.ui.autocomplete.js"></script>
            <script src="js/jquery.colorbox-min.js"></script>

            <script src="js/common.js"></script>
            
            <!-- Timer Start!! -->
            <script src="js/loadUserData.js"></script>
            <script type="text/javascript" src="js/jquery.animate-colors.min.js"></script>
            <script type="text/javascript" src="js/jquery.simplemodal.1.4.2.min.js"></script>
            <script type="text/javascript" src="js/jquery.iframe-auto-height.plugin.1.7.1.min.js"></script>
            <script type="text/javascript" src="js/jquery.infotip.min.js"></script>
            <script type="text/javascript" src="js/jquery.timeline-clock.min.js"></script>
            <script src="js/jquery.ui.progressbar.js"></script>
           
            <!-- Timer End -->
            
    <?php include_once dirname(__FILE__) . '/js/google_analytics.php' ?>
            
            
            
            <script>
                $(document).ready(function() {
                    StartTandemTimer();
                });
            </script>
            
            
            
    <?php if ($selected_exercise && strlen($selected_exercise) > 0) {
        echo 'getXML();';
    } ?>

            
            <script>
            //$language, $courseID, $idExercise, $idNumberUserWaiting, $idUser);
            // echo '<div>' . $lang = $_SESSION[LANG] . '</div>';
              //                          echo $course_id;
              //                          echo $user_obj->id;
            function getWaitingTandemRoom(exercise_id){
                
                $.ajax({
                    data:{ 
                            'language': "<?php echo $_SESSION[LANG]; ?>", 
                            'tandem_language' : "<?php echo $_GET['localLanguage']; ?>",
                            'courseID': "<?php echo $course_id; ?>", 
                            'exerciseID': exercise_id,
                            'userID':  "<?php echo $user_obj->id; ?>"
                        },
                    url: "getRequestsWaitingTandemRoom.php",
                    type: "POST",
                    dataType: "json",
                }).done(function(data){
                    console.log(data);
                }); 
            }
            
            
            
            var interval = null;
            $(document).on('ready',function(){
                interval = setInterval(updateDiv,2000);
            });
            
           
            function updateDiv(){
                console.time( "Peticion AJAX" );
                $.ajax({
                    data:{ 
                            language: "<?php echo $lang = $_SESSION[LANG]; ?>", 
                            courseID: "<?php echo $course_id; ?>" 
                        },
                    url: "updateWiewportWaitingTandemRoom.php",
                    type: "POST",
                    dataType: "json",
                }).done(function(data){
                    //http://stackoverflow.com/questions/2265167/why-is-forvar-item-in-list-with-arrays-considered-bad-practice-in-javascript
                    //http://stackoverflow.com/questions/11922383/access-process-nested-objects-arrays-or-json
                  
                    var data = data;
                    
                    var localLanguage = "<?php echo $_GET['localLanguage']; ?>"; 

                    sumatorioWaiting = '';
                    sumatorioWaiting += '<li class="lineWT title-waiting">WAITING</li>';
                    
                    sumatorioTandem = '';
                    sumatorioTandem += '<li class="lineWT title-tandem">TANDEM</li>';
                    
                    for (var i in data){
                        
                        var id_exercise = data[i]['id_exercise'];
                        
                        var name = data[i]['name'];
                       
                        var language = data[i]['language'];
                       
                        var number_user_waiting = data[i]['number_user_waiting'];
                        
                        if(localLanguage != language){
                            //waiting
                            //alert('primera opcio');
                            sumatorioWaiting += '<li class="lineWT"><input class="exButtonWaiting" type="button" name="exercise-'+id_exercise+'" data-id-exercise="'+id_exercise+'" id="exercise-'+id_exercise+'" value="'+name+'"><label class="common-waiting-tandem_users waiting-users-more-one">WaitUsers='+number_user_waiting+ ' IDExerc='+id_exercise+'</label></li>';
                            
                            //ajax 
                            //mostrarem dades en un jquery dialog
                        }else{
                            //tandem
                            //alert('segona opcio');
                            sumatorioTandem += '<li class="lineWT"><input class="exButtonTandem" type="button" name="exercise-'+id_exercise+'" id="exercise-'+id_exercise+'" data-id-exercise="'+id_exercise+'"  value="'+name+'"><label class="common-waiting-tandem_users tandem-users-more-one">WaitUsers='+number_user_waiting+ ' IDExerc='+id_exercise+'</label></li>';
                            
                        }
                        //alert(id_exercise+'-'+name+'-'+language+'-'+number_user_waiting);
                        
                    }
                    $('.tandem-room-left ul').html(sumatorioWaiting);
                    $('.tandem-room-right ul').html(sumatorioTandem);
                    
                    for (var i in data){
                        
                        var id_exercise = data[i]['id_exercise'];
                        
                        //si aquest boto es clickat passem id,language,id_user,num_usuaris_en_espera
                        
                        $(document).ready(function(){
                            $('#exercise-'+id_exercise).on("click",function(){
                                //alert('Hemos seleccionado el ejercicio: '+$(this).data("id-exercise"));
                                timeStop(); //Stopping the timebar
                                startTask(); //We show the connexion div with the charging image
                                getWaitingTandemRoom($(this).data("id-exercise")); //Passamos por ajax el id del ejercicio a la base de datos 
                            });
                        }); 
                        
                    }
                    
                    sumatorioWaiting='';
                    sumatorioTandem='';
                    
                });
            }
            </script>
            <script>
            
		var intTimerNow;
		var limitTimer = 500;
		var limitTimerConn = 1000;
		function setExpiredNow(itNow){
			intTimerNow = setTimeout("getTimeNow("+itNow+");", 10000);
		}
		function getTimeNow(itNow){
			var tNow;
			itNow--;
			if(itNow<10) tNow ="0"+itNow;
			else tNow = itNow;
			$("#startNowBtn").html("00:"+tNow);
			if(itNow<=1){ 
				clearInterval(intTimerNow);
				//desconn();
			}
			else setExpiredNow(itNow);
		}
                
                StartTandemTimer = function(){
                        /*$("#lnk-start-task").addClass("btnOff");
                        $("#lnk-start-task").html("Waiting...");
                        $("#lnk-start-task").removeAttr("href");
                        $("#lnk-start-task").removeAttr("onclick");*/
                        $("#timeline").show("fast");
                        var minutos = 1;
                        var segundos = 30;
                        timerOn(minutos,segundos);
                        timeline.start();
                       
                      
                        //intervalTimerAction = setInterval(timerChecker,1000);
                        
                        
                        
                }
                        
                        
                var totalUser = 0;
		$(document).ready(function(){
//colorbox js actionexample3
			notifyTimerDown = function(id){
				if($.trim(txtNews)!=$.trim(id)){
					$('#showNews').html(id);
					$('#showNews').fadeIn(1000).slideDown("fast");
					$("#showNews").delay(3000).fadeOut(1000).slideUp("fast");
					txtNews=id;
				}
			}
//colorbox
			$("a[rel='example1']").click(function(event){
				event.preventDefault();
			    $('a[rel="example1"]').colorbox({
			        maxWidth: '90%',
			        initialWidth: '200px',
			        initialHeight: '200px',
			        speed: 300,            
			        overlayClose: false
			    });
			    $.colorbox({href: $(this).attr('href')});
			});
                    });
               // Ajuste timeline (anchura máxima)
	var lwidth = $('#timeline').outerWidth() - ($('#timeline .lbl').outerWidth() + $('#timeline .clock').outerWidth()) + 5;
	var lmargin = $('#timeline .lbl').outerWidth() - 5;
	$('#timeline .linewrap').css({'width': lwidth + 'px', 'margin-left' : lmargin + 'px'});
	var timeline;
	timerOn = function(minutos,segundos){
		// Configuración timeline
               
		timeline = $('#timeline').timeLineClock({
			time: {hh:0,mm:parseInt(minutos),ss:parseInt(segundos)},
			onEnd: theEnd
		}); 
	}    
        
        // fin espera partner tarea con timer
	function partnerTimerTaskReady(){
		$.modal.close();
		stepReady($('#steps li .waiting'));
		timeline.start();
	}
        
	// ventana modal tiempo agotado
	function theEnd(){
		if ($("#modal-end-task").length > 0){
			$.modal($('#modal-end-task'));
			//accionTimer();
		}
	}
        
        function startTask(){
            if ($("#modal-start-task").length > 0){
                $('#modal-start-task').modal( {onClose: function () {
                   beginningOneMoreTime();
                    $.modal.close(); // must call this!
                }})
                
            }
        }
        
         
        function timeStop(){
		 timeline.stop();
	}
        
        function beginningOneMoreTime(){
                timeline.start();
        }
        
        
         
            </script>
           
           
            
        </head>
        <body>

            <!-- accessibility -->
            <div id="accessibility">
                <a href="#content" accesskey="s" title="Acceso directo al contenido"><?php echo $LanguageInstance->get('direct_access_to_content') ?></a> |
                <!--
                <a href="#" accesskey="n" title="Acceso directo al men de navegacin">Acceso directo al men de navegacin</a> |
                <a href="#" accesskey="m" title="Mapa del sitio">Mapa del sitio</a>
                -->
            </div>
            <!-- /accessibility -->
            <!-- /wrapper -->
            <div id="wrapper">

                <div id="head-containerS">
                    <div id="headerS">
                        <div id="logoS">
                            <div id="showNewsS"></div>
                        </div>
                    </div>
                </div>
                <!-- main-container -->
                <div id="main-container">
                    <!-- main -->
                    <div id="main">
                        <!-- content -->
                        <div id="content">
                            <span class="welcome"><?php echo $LanguageInstance->get('welcome') ?> <?php echo $name ?>!</span><br/>
                            <form action="#" method="post" id="main_form" class="login_form">
                             
                            <!-- *********************************** -->   
                            <!-- ****WAITING-TANDEM-ROOM-dynamic**** -->
                            <!-- *********************************** -->
                            
                             <div id="timeline" style="display:none;">
                                    <div class="lbl"><?php echo $LanguageInstance->get('waiting_remaining_time')?></div>
                                    <div class="clock" id="clock"><span class="mm">00</span>:<span class="ss">00</span></div>
                                    <div class="linewrap"><div class="line"></div></div>
                            </div>
                           
                            <!--
                            <p><a href='#' onclick="StartTandemTimer();return false;" id="lnk-start-task" class="btn">Empezamos con las pruebas del Timer</a></p>
                            -->
                            <div id="modal-start-task" class="modal">
                                <script>
                                         
                                </script>
                                <body id="home_" style="background-color:#FFFFFF;">
                                <div>
                                        <img id="home" src="images/final1.png" width="310" height="85" alt="" />
                                </div>
                                <div class="text">
                                        <!-- Falten introduir al PO -->
                                        <p><?php echo $LanguageInstance->get('Waiting for Tandem Connexion !!');?></p>
                                        <p><?php echo $LanguageInstance->get('Please Stand By !!');?></p>
                                </div>
                                <div class="waitingImagePosition">
                                  <img id="home" src="css/images/loading_1.gif" width="150" height="150" alt="" />
                                </div>
                            </body>
                            </div>
                            
                            
                            
                            <div id="modal-end-task" class="modal">
                                <p class="msg">Time up!</p>
                                <p><a href='#' id="lnk-end-task" class="btn simplemodal-close">Close</a></p>
                            </div>
                            
                            
                            
                            <div class="tandem-room-content">
                                <div class="tandem-room-left">
                                    <ul></ul>
                                </div>
                                <div class="tandem-room-right">
                                    <ul></ul>
                                </div>
                                
                            </div>
                            <div class="cleaner"></div> 
                            
                            <!--
                            <div id="simplemodal-container" class="modal">
                                Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32. 
                                <div class="positionCharge"><img src="css/images/loading_1.gif" alt=""/></div>
                            </div>
                            -->
                                <?php
                                echo '<div>Lenguaje de la sesion: ' . $lang = $_SESSION[LANG] . '</div>' . '<br>';
                                echo 'ID del Curso: ' . $course_id . '<br>';
                                echo 'ID Usuario: ' . $user_obj->id . '<br>';
                                //print_r($array_exercises);
                                echo '<br>';
                                ?>
                                <?php if ($array_exercises !== false && is_array($array_exercises) && count($array_exercises) > 0) { ?>
                                    <?php if (!$use_waiting_room) { ?>
                                        <fieldset>
                                        <?php
                                        if ($users_course && count($users_course) > 0) {
                                            ?>
                                                <label for="select_user" title="1. <?php echo $LanguageInstance->get('select_users') ?>"><img class="point" src="css/images/p1.png" alt="1. <?php echo $LanguageInstance->get('select_users') ?>" /></label>
                                                <br/><select name="user_selected" id="user_selected" tabindex="1" onchange="enable_exercise(this.value);">
                                                    <option value="-1"><?php echo $LanguageInstance->get('select_users') ?></option>
                                                    <?php foreach ($users_course as $user) {
                                                        if ($user['id'] != $user_obj->id) {
                                                            ?>
                                                            <option value="<?php echo $user['id'] ?>" <?php echo ($user_selected == $user['id'] ? 'selected' : '') ?>><?php echo $user['surname'] . ', ' . $user['firstname'] ?></option>
                                                    <?php }
                                                    }
                                                    ?>
                                                </select>
                                                <?php
                                            } else {
                                                $msg = $gestorOKI->getLastError() == null ? $LanguageInstance->get('no_users_in_course') : $gestorOKI->getLastError();
                                                ?>
                                                <label for="not_users" title="<?php echo $msg ?>"><?php echo $msg ?></label>
                                            <?php } ?>
                                        </fieldset>
                                    <?php
                                    } else {
                                        /* ******************************* */

                                        /*
                                        echo '<h1>DENTRO!!!!</h1>';

                                        echo '<div>' . $lang = $_SESSION[LANG] . '</div>';
                                        echo $course_id;
                                        echo $user_obj->id;


                                        $idExercise = isset($_GET['id_exercise']) ? $_GET['id_exercise'] : '';


                                        $insert = isset($_GET['insert']) ? $_GET['insert'] : '';
                                        if ($insert && $idExercise) {
                                            $insertParams = $gestorBD->insertUserAndRoom($_SESSION[LANG], $course_id, $idExercise, $use_waiting_room, $user_obj->id);
                                        }

                                        $something1 = $gestorBD->check_offered_exercises($_SESSION[LANG], $course_id);

                                        var_dump($something1);

                                        $something2 = $gestorBD->offer_exercise($_SESSION[LANG], $course_id, $idExercise);

                                        var_dump($something2);
                                         */
                                         
                                        /*
                                          $update = isset($_GET['update']) ? $_GET['update'] : '';
                                          if($update&&$idExercise){
                                          $gestorBD->updateUserAndRoom($_SESSION[LANG],$course_id);
                                          }

                                          $delete = isset($_GET['delete']) ? $_GET['delete'] : '';
                                          if($delete&&$idExercise){
                                          $gestorBD->deleteUserAndRoom($_SESSION[LANG],$course_id);
                                          }
                                         */
                                    }

                                    /*                                     * ************************** */
                                    ?>
                                    <fieldset>
                                        <?php
                                        if ($array_exercises !== false &&
                                                is_array($array_exercises) &&
                                                count($array_exercises) > 0) {
                                            ?>
                                            <label for="select_exercise" title="2. <?php echo $LanguageInstance->get('select_exercise') ?>"><img class="point" src="css/images/p2.png" alt="2. <?php echo $LanguageInstance->get('select_exercise') ?>" /></label>
                                            <br/><select id="room" name="room" tabindex="2" onchange="enable_button(this.value);">
                                                <option value="-1"><?php echo $LanguageInstance->get('select_exercise') ?></option>
                                                <?php
                                                foreach ($array_exercises as $exercise) {
                                                    $extra_exercise = isset($exercise['relative_path']) && strlen($exercise['relative_path']) > 0 ? str_replace("/", "", $exercise['relative_path']) . '/' : '';
                                                    ?>
                                                    <option value="<?php echo $extra_exercise . $exercise['name_xml_file'] ?>" <?php echo ($selected_exercise_select == $exercise['name_xml_file'] || $selected_exercise == $exercise['name_xml_file']) ? 'selected="selected"' : '' ?>><?php echo $exercise['name'] ?></option>
                                            <?php } ?>
                                            </select>
                                        <?php } else { ?>
                                            <input type="text" id="room" value="" size="10" onchange="putLink();"/>
                                 <?php } ?>
                                    </fieldset>
                                    <fieldset>
                                        <label for="start" title="3. <?php echo $LanguageInstance->get('start') ?>"><img class="point" src="css/images/p3.png" alt="3. <?php echo $LanguageInstance->get('start') ?>" /></label>
                                        <input type="button" onclick="Javascript:putLink();" id="start" name="start" disabled="disabled" value="<?php echo $LanguageInstance->get('start') ?>" class="tandem-btn" tabindex="3" />
                                    </fieldset>
                                <?php
                                } else {
                                    echo '<div id="alert-top" class="alert alert-warning"><div class="alert-inside"><i class="icon"></i><h3>' . Language::get('no_exercises_found') . '</h3></div></div>';
                                }
                                ?>
                                <div class="manage-area">
                                    <div class="clear">
                                        <div id="info-block" class="alert alert-info" style="display:none"></div>
                                        <!--<div class="info" style="display:none"></div>--> <!-- 10092012 nfinney> type error: changed to 'none' from 'hidden' -->
                                        <?php if (!$pending_invitations) { ?>
                                            <div class="title">
                                                <h2><?php echo $LanguageInstance->get('pending_tandems') ?></h2>
                                            </div>
                                            <div class="message">
                                                <p><strong><?php echo $LanguageInstance->get('no_pending_tandems') ?></strong></p>
                                            </div>
                                        <?php } else { ?>
                                            <div class="title">
                                                <h2><?php echo $LanguageInstance->get('pending_tandems') ?></h2>
                                                <a href="selectUserAndRoom.php" class="tandem-btn-secundary btn-reload"><i class="icon"></i><?php echo $LanguageInstance->get('reload_pending') ?></a>
                                            </div>
                                            <table id="statistics1" class="table">
                                                <thead>
                                                    <tr>
                                                        <th style="width:30%"><?php echo $LanguageInstance->get('user_guest') ?></th>
                                                        <th style="width:25%"><?php echo $LanguageInstance->get('exercise') ?></th>
                                                        <th style="width:25%"><?php echo $LanguageInstance->get('date') ?></th>
                                                        <th style="width:20%"><?php echo $LanguageInstance->get('state') ?></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php
                                                    $ai = 0;
                                                    foreach ($pending_invitations as $tandem) {
                                                        $ai++;
                                                        ?>
                                                        <tr>
                                                            <td><?php echo $tandem['surname'] . ', ' . $tandem['firstname'] ?></td>
                                                            <td><?php echo $tandem['name'] ?></td>
                                                            <td><?php echo $tandem['created'] ?></td>
                                                            <?php
                                                            $time2Expire = 60;
                                                            if ((time() - strtotime($tandem['created'])) >= $time2Expire) {
                                                                ?>
                                                                <td><a href="#" title="<?php echo $LanguageInstance->get('go') ?>" class="tandem-btnout"><?php echo $LanguageInstance->get('caducado') ?></a></td>
            <?php } else { ?>
                                                        <script>
                                                                            setExpired(<?php echo $time2Expire; ?>);
                                                                            var intTimer;
                                                                            function setExpired(i){
                                                                                intTimer = setTimeout("getTime(" + i + ");", 1000);
                                                                                    }
                                                                    function getTime(i){
                                                        //var t;
                                                        //i--;
                                                        //if(i<10) t ="0"+i;
                                                        //else t = i;
                                                                    for (var iT = 0; iT <=<?php echo $ai; ?>; iT++){
                                                        //$("#timer2expired"+iT).html("<?php echo $LanguageInstance->get('accept') ?> 00:"+t);
                                                        //if(i<=1 || isNowOn==1){
                                                                    $("#timer2expired" + iT).removeClass("tandem-btn").addClass("tandem-btnout");
                                                                            $("#timer2expired" + iT).html("<?php echo $LanguageInstance->get('caducado') ?>");
                                                                            $("#timer2expired" + iT).attr("href", "#")
                                                                            clearInterval(intTimer);
                                                        //}
                                                        //else setExpired(i);
                                                                            }
                                                                    }
                                                        </script>
                                                        <td><a id="timer2expired<?php echo $ai; ?>" href="accessTandem.php?id=<?php echo $tandem['id'] ?>" title="<?php echo $LanguageInstance->get('go') ?>" class="tandem-btn"><?php echo $LanguageInstance->get('accept') ?></a></td>
                                                        <?php
                                                    }
                                                    ?>
                                                    </tr>
                                        <?php } ?>
                                                </tbody>
                                            </table>
                                    <?php } ?>	
                                    </div>
                                    <?php /*
                                      <div class="clear">
                                      <p><a href="selectUserAndRoom.php"><?php echo $LanguageInstance->get('reload_pending')?></a></p>
                                      </div>
                                     */ ?>
                                    <?php if ($user_obj->instructor) { ?>
                                        <?php /*
                                          <div class="clear">
                                          if ($is_showTandem) {
                                          if ($user_selected==0) {?>
                                          <p class="error"><?php echo $LanguageInstance->get('select_user')?></p>
                                          <?php
                                          } else {
                                          if ($user_tandems==null || count($user_tandems)==0) {
                                          ?>
                                          <?php echo $LanguageInstance->get('no_tandems')?>
                                          <?php
                                          } else {
                                          ?>
                                          <div class="title"><?php echo $LanguageInstance->get('tandems')?></div>
                                          <table>
                                          <tr>
                                          <th><?php echo $LanguageInstance->get('date')?></th>
                                          <th><?php echo $LanguageInstance->get('total_time')?></th>
                                          <th><?php echo $LanguageInstance->get('user_guest')?></th>
                                          <th><?php echo $LanguageInstance->get('date_guest_user_logged')?></th>
                                          <th><?php echo $LanguageInstance->get('finalized')?></th>
                                          </tr>
                                          <?php
                                          foreach ($user_tandems as $tandem) {
                                          ?>
                                          <tr>
                                          <td><a href="statistics_tandem.php?id=<?php echo $tandem['id']?>" title="<?php echo $LanguageInstance->get('go')?>"><?php echo $tandem['created']?></a></td>
                                          <td><?php echo isset($tandem['total_time'])?$tandem['total_time']:0?></td>
                                          <td><?php echo $tandem['other_user']?></td>
                                          <td><?php echo $tandem['date_guest_user_logged']?></td>
                                          <td><?php echo $tandem['finalized']?></td>
                                          </tr>
                                          <?php }?>
                                          </table>
                                          <div class="clear" >&nbsp;</div>
                                          <?php }
                                          }
                                          }
                                          </div>
                                         */ ?>
                                        <div class="clear">
                                            <input type="submit" name="reload" onclick="Javascript:canviaAction('');" value="<?php echo $LanguageInstance->get('refresh') ?>" />
                                            <input type="submit" name="showTandem" onclick="Javascript:canviaAction('show');" value="<?php echo $LanguageInstance->get('activity_log') ?>" />
                                            <input type="submit" name="showTandem" onclick="Javascript:canviaAction('exercises');" value="<?php echo $LanguageInstance->get('mange_exercises_tandem') ?>" />
                                        </div>
                                        <?php } //is instructor ?>

                                    <div class="clear">
    <?php /* <p>echo Language::getTag('tandem_description_1','<strong>'.$name.'</strong>') <!--10082012: nfinney> finney> replaced with popup on IE detection--><br/>
      <?php echo $LanguageInstance->get('tandem_description_2');</p> */ ?>
                                        <p id="roomStatus"></p>
                                    </div>
                                </div> <!-- /manage-area -->
                            </form>
                            <div id="logo">
                                <a href="#" title="<?php echo $LanguageInstance->get('tandem_logo') ?>"><img src="css/images/logo_Tandem.png" alt="<?php echo $LanguageInstance->get('tandem_logo') ?>" /></a>
                            </div>
                        </div>
                        <!-- /content -->
                    </div>
                    <!-- /main -->
                </div>
                <!-- /main-container -->
            </div>
            <!-- /wrapper -->
            <!-- footer -->
            <div id="footer-container">
                <div id="footer">
                    <div class="footer-tandem" title="<?php echo $LanguageInstance->get('tandem') ?>"></div>
                    <div class="footer-logos">
                        <img src="css/images/logo_LLP.png" alt="Lifelong Learning Programme" />
                        <img src="css/images/logo_EAC.png" alt="Education, Audiovisual &amp; Culture" />
                        <img src="css/images/logo_speakapps.png" alt="Speakapps" />
                    </div>
                </div>
            </div>
            <!-- /footer -->
            <iframe src="" width="0" frameborder="0" height="0" id="idfrm" name="idfrm"></iframe>
        </body>
    </html>
<?php } ?>