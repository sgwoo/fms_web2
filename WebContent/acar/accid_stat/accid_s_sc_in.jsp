<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getAccidS2List(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int accid_size = accids.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr id='tr_title' style='position:relative;z-index:1'> 
      <td class='line' width='440' id='td_title' style='position:relative;'> 
        <table border="0" cellspacing="1" cellpadding="0" width='450'>
        	<tr><td class=line2></td></tr>
          <tr> 
            <td rowspan="2" class='title' width='100'>월별</td>
            <td rowspan="2" class='title' width='100'>총건수</td>
            <td colspan="5" class='title'>사고구분</td>
          </tr>
          <tr> 
            <td width='50' class='title'>피해</td>
            <td width='50' class='title'>가해</td>
            <td width='50' class='title'>쌍방</td>
            <td width='50' class='title'>단독</td>
            <td width='50' class='title'>자차</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width='150'>
          <tr> 
            <td colspan="3" class='title'>피해구분</td>
          </tr>
          <tr> 
            <td width='60' class='title'>인사</td>
            <td width='60' class='title'>대물</td>
            <td width='60' class='title'>병합</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
      <td class='line' width='200'>
        <table border="0" cellspacing="1" cellpadding="0" width='200'>
          <tr> 
            <td colspan="4" class='title'>유형별</td>
          </tr>
          <tr> 
            <td width='50' class='title'>차대차</td>
            <td width='50' class='title'>차대사람</td>
            <td width='50' class='title'>차량단독</td>
            <td width='50' class='title'>차대열차</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
<script language='javascript'>
<!--
/*	var fm 		= document.form1;
	var p_fm	= parent.form1;
	var cnt 	= fm.fee_size.value;
	
	var i_amt = 0;
	
	if(cnt > 1){
		for(var i = 0 ; i < cnt ; i++){
			i_amt   += toInt(parseDigit(fm.amt[i].value));
		}
	}else if(cnt == 1){
		i_amt   += toInt(parseDigit(fm.amt.value));	
	}		*/
-->
</script>
</form>
</body>
</html>
