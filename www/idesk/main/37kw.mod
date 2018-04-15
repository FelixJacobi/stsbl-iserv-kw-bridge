<?php
require_once "ctrl.inc";
require_once "db.inc";
require_once "format.inc";
require_once "quote.inc";

db_user("kw_bridge");

if (!secure_privilege("kw_exclude"))
{
  $course_selections = [];
  $res = db_query("SELECT k.id, k.name, EXTRACT(EPOCH FROM k.ends) AS date
      FROM kw k WHERE k.id IN (SELECT p.kw_id FROM kw_participants p WHERE 
      p.act IN (SELECT m.actgrp FROM members m WHERE m.actuser = $1))
      AND k.id NOT IN (SELECT u.kw_id FROM kw_user_choices u WHERE u.act = $2)
      AND k.begins < NOW() AND k.ends > NOW()", 
      $_SESSION["act"], $_SESSION["act"]); 
  while($row = pg_fetch_assoc($res)) $course_selections[$row['id']] = $row;

  if (count($course_selections) > 0) 
  {
    GroupBox(_("Outstanding course selections"), "dlg-info");
    echo "<p>".ngettext("You have to choose your course in the following selection:", "You have to choose your courses in the following selections:", count($course_selections))."</p>";
    echo "<ul>";
    foreach ($course_selections as $selection)
    {
      echo "<li>";
      echo icon("block").'<a target="_blank" href="'.q("/iserv/courseselection/".$selection["id"]).'">'.q($selection['name'])."</a> - ".sprintf(_("Selection is ending at %s"), DateTimeToStr($selection['date']));

      # 604800 seonds = 7 days
      if ($selection['date'] - time() < 604800) {
	echo "<br /><strong>".icon("dlg-warn")._("This selection is ending in less than seven days.")."</strong>";
      }
      echo "</li>";
    }
    _GroupBox('<a class="btn" target="_blank" href="/iserv/courseselection">'.icon("block")._('Open course selections in IServ 3').'</a>');
  }
}
