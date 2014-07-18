<?php

require_once 'constants.php';
require_once(dirname(__FILE__).'/../config.inc.php');

class ManagerWaitingRoom{
    
    private $conn;
    
    private $_debug = false;
    
    public function __construct()
    {
        $this->conectar();
    }

    public function conectar()
    {
            $this->conn = mysql_connect(BD_HOST, BD_USERNAME, BD_PASSWORD);
            if (!$this->conn) {
                    die('No se pudo conectar: ' . mysql_error());
                    return false;
            }else{
                    mysql_select_db(BD_NAME, $this->conn);
                    return true;
            }
    }

    public function enableDebug () {
            $this->_debug = true;
    }

    public function disableDebug () {
            $this->_debug = false;
    }

    public function debugMessage($msg) {
            if ($this->_debug) {
                    echo "<p>DEBUG: ".$msg."</p>";
            }
    }

    public function desconectar()
    {
        mysql_close($this->conn);
    }

    public function escapeString($str)
    {
        return "'".mysql_real_escape_string($str, $this->conn)."'";
    }
           
    public function consulta($query)     
    {
        $this->debugMessage($query);
        $result = mysql_query($query, $this->conn);
        if (!$result) {
            error_log("Error BD ".mysql_error().$query);
        }
        return $result;
    }

    // Let's do it private -> public cmoyas
    public function obteObjecteComArray($result){
            return mysql_fetch_assoc($result);
    }

    public function numResultats($result) {
            return mysql_num_rows($result);
    }

    public function obteComArray($result) {
            $rows = array();
            while ($row = mysql_fetch_assoc($result)) {
            $rows[] = $row;
            }
            return $rows;
    }
    
    /**
    * Insert User in waiting room
    * @param type $language
    * @param type $idCourse
    * @param type $idExercise
    * @param type $idNumberUserWaiting
    * @return type
    */
    public function insertUserAndRoom($language,$idCourse,$idExercise,$idNumberUserWaiting,$idUser){
       $result = false;
       echo "<h1>gestorBD!!</h1>";
       echo $idNumberUserWaiting,$idCourse,$idExercise,$idNumberUserWaiting,gmdate('Y-m-d h:i:s \G\M\T');
       //DATETIME en formato 'YYYY-MM-DD HH:MM:SS' . El rango soportado es de '1000-01-01 00:00:00' a '9999-12-31 23:59:59'.
       $sql = 'INSERT INTO waiting_room (language, id_course, id_exercise,number_user_waiting,created) VALUES ('.$this->escapeString($language).','.$idCourse.','.$idExercise.','.$idNumberUserWaiting.',now())';

       $result = $this->consulta($sql);
       if ($result) {
           $waiting_room_id = mysql_insert_id();
           echo "Last it $waiting_room_id";
           //Insert into waiting_room_user
           $sql = 'INSERT INTO waiting_room_user (id_waiting_room, id_user,created) VALUES ('.$waiting_room_id.','.$idUser.',now())';
           $result = $this->consulta($sql);
           if ($result) {
               $result =  $this->addOrRemoveUserToWaitingRoom($waiting_room_id, +1);
           }
       } 
       return $result;
   }

   /**
    * Move the current user to history of waiting room
    * @param type $id_waiting_room
    * @param type $id_user
    * @param type $status
    * @return type
    */
   private function moveUserToHistory($id_waiting_room, $id_user, $status = 'assigned'){
       $ok = false;
       //1. Check in waiting room user
       $sql = 'Select *  FROM `waiting_room_user` WHERE `id_waiting_room` = '.$this->escapeString($id_waiting_room).' AND `id_user` = '.$this->escapeString($id_user);
       $result = $this->consulta($sql);
       if ($this->numResultats($result)>0) {
           $object = $this->obteObjecteComArray($result);
           $id_user_wating_room = $object['id'];
           $created = $object['created'];
           //2.Insert in history table
           $sqlInsert = 'INSERT INTO `waiting_room_user_history` (`id`, `id_waiting_room`, `id_user`, `status`, `created`, `created_history`) VALUES (NULL, '.$this->escapeString($id_waiting_room).', '.$this->escapeString($id_user).', '.$this->escapeString($status).', '.$this->escapeString($created).', NOW())';
           if ($this->consulta($sqlInsert)) {
               //3. Delete from waiting_room_user
               $sqlDelete = 'DELETE  FROM `waiting_room_user` WHERE `id` = '.$this->escapeString($id_user_wating_room);
               if ($this->consulta($sqlDelete)) {
                   $ok = $this->addOrRemoveUserToWaitingRoom($id_waiting_room, -1);
               }
           }
       }
       return $ok;
   }
   /**
    * Add or remove User to waiting room
    * @param type $id_waiting_room
    * @param type $number_user_to_add_or_remove
    * @return boolean
    */
    private function addOrRemoveUserToWaitingRoom($id_waiting_room,$number_user_to_add_or_remove){
       $ok = false;
       //1. Check in waiting room 
       $sql = 'Select *  FROM `waiting_room` WHERE `id` = '.$this->escapeString($id_waiting_room);
       $result = $this->consulta($sql);
       if ($this->numResultats($result)>0) {
           $object = $this->obteObjecteComArray($result);
           //$id_user_wating_room = $object['id'];
           $language = $object['language'];
           $id_course = $object['id_course'];
           $id_exercise = $object['id_exercise'];
           $number_user_waiting_old = $object['number_user_waiting'];
           $created = $object['created'];
           $number_user_waiting = $object['number_user_waiting'] + $number_user_to_add_or_remove;
           if ($number_user_waiting<=0) {
               //2.Insert in history table
               $sqlInsert = 'INSERT INTO `waiting_room_history` (`id`, `id_waiting_room`, `language`, `id_course`, `id_exercise`, `number_user_waiting`, `created`, `created_history`) '
                       . 'VALUES (NULL, '.$this->escapeString($id_waiting_room).', '.$this->escapeString($language).', '.$this->escapeString($id_course).', '
                       . ''.$this->escapeString($id_exercise).', '.$this->escapeString($number_user_waiting_old).', '.$this->escapeString($created).', NOW())';
               if ($this->consulta($sqlInsert)) {
                   //3. Delete from waiting_room_user
                   $sqlDelete = 'DELETE  FROM `waiting_room` WHERE `id` = '.$this->escapeString($id_waiting_room);
                   if ($this->consulta($sqlDelete)) {
                       $ok = true;
                   }


               }
           }
           else {
               $ok = true;
           }

       }
       return $ok;
   }
    /**
     * We selected the exercises that language is different from the user and select the same course.
     * @param string $language
     * @param integer $courseID
     * @return array
     */
    
    public function check_offered_exercises($language,$courseID)
    {
        $row = array();
        $result = $this->consulta("Select id_exercise,id FROM waiting_room WHERE language != ".$this->escapeString($language)." AND id_course = ".$this->escapeString($courseID));
        while($fila = mysql_fetch_assoc($result)){
            $row[] = $fila['id_exercise'].'-'.$fila['id']; 
        }
        return $row;
    }
    
    /**
     * We INSERT a user with a new exercise if don't exists or UPDATE the 
     * existing exercise increasing +1 in the comput global in the waiting_room table
     * @param type $language
     * @param type $courseID
     * @param type $exerciseID
     */
    
    public function offer_exercise($language,$courseID,$exerciseID)
    {
        $resultSelect= false;
        $resultUpdate= false;
        $resultInsert = false;
       
        $sqlSelect = 'select * from waiting_room where id_exercise = '.$exerciseID;
        $resultSelect = $this->consulta($sqlSelect);
        if ($this->numResultats($resultSelect)>0){
          $resultUpdate = $this->consulta("UPDATE waiting_room SET number_user_waiting = number_user_waiting+1 WHERE id_exercise = ".$exerciseID);
        }else{
          $sqlInsert = 'INSERT INTO waiting_room (language, id_course, id_exercise,number_user_waiting,created) VALUES ('.$this->escapeString($language).','.$courseID.','.$exerciseID.',1,now())';
          $resultInsert = $this->consulta($sqlInsert);
        }
        return $resultSelect.'-'.$resultUpdate.'-'.$resultInsert;
    }
    
    
    /**
     * 
     * @param type $language
     * @param type $courseID
     * @param type $exerciseID  
     */
    public function start_tandem($language,$courseID,$exerciseID)
    {
        $resultSelect= false;
         
        $sqlSelect = 'select number_user_waiting from waiting_room where id_exercise = '.$exerciseID.' and language = '.$this->escapeString($language).' and id_course = '.$courseID;
        $resultSelect = $this->consulta($sqlSelect);
        if ($this->numResultats($resultSelect)>0){
            //Si, aparellem fent FIFO
            //Descontem de la waiting Room -1
            //De la waiting room users eliminar registre i afegir-lo al històric
            //Sobre el waiting Room si el camp number_user_waiting = 0 eliminar la fila i passarla al històric.
            //REDIRECCIONAR AL TANDEM
        }else{
            //No podem aparellar
            //Passem parámetre ACTION() i pass1
            $this->check_offered_exercises();
        }
        
    }
}

