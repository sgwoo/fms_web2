<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(gubun1.equals("")){
		gubun1 = "1";
	}
	
	//ARS call 현황
	Vector vt = wc_db.ArsCallStatSDay(gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function display_pop(id){
	var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
	document.form1.id.value = id;
	document.form1.action="ars_call_stat_sday_list.jsp";
	document.form1.target="Stat";		
	document.form1.submit();
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='ars_call_stat_template_sc.jsp' method='post' target='t_content'>
  <table border="0" cellspacing="0" cellpadding="0" width=1100>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS안내문 </span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>	 	     
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title' width="10%">연번</td>
                    <td class='title' width="50%">구분</td>
                    <td class='title'>비고</td>                    
                </tr>
                <tr>
                    <td align=center>1</td>
                    <td align=center>긴급출동서비스 이용안내</td>
                    <td align=center><a href="/acar/ars/ars_info_sos.jsp" target="_blank">바로가기</a></td>
                </tr>
                <tr>
                    <td align=center>2</td>
                    <td align=center>사고처리 연락처 안내</td>
                    <td align=center><a href="/acar/ars/ars_info_accident.jsp" target="_blank">바로가기</a></td>
                </tr>
                <tr>
                    <td align=center>3</td>
                    <td align=center>자동차정비 안내</td>
                    <td align=center><a href="/acar/ars/ars_info_maint.jsp" target="_blank">바로가기</a></td>
                </tr>
            </table>
	    </td>
    </tr>    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
