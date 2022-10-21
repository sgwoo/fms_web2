<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");//자동차번호	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(){
		var fm = document.form1;	
		if(fm.rent_l_cd.value=="")		{	alert("변경하고자하는 계약번호를 선택해 주세요!");		return; }
		
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.action = "upd_l_cd_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	
	
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}


//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form name='form1' action='' method='post' >

<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mng_id' >
<input type="hidden" name="accid_id" value="<%=accid_id%>">
<!-- <input type="hidden" name="rent_l_cd" >
<input type="hidden" name="rent_mng_id" > -->

    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>계약변호변경</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width=25%>계약번호</td>
                    <td width=75%>                    
                      <input type= "text" name="rent_l_cd"  class="whitetext"  >
                      <input  type="hidden" name="rent_mng_id"  > 
                       <a href="javascript:MM_openBrWindow('/tax/pop_search/s_cont.jsp?go_url=/acar/accid_mng/upd_l_cd.jsp&s_kd=9&t_wd=<%=car_no%> ','popwin_serv_off','scrollbars=no,status=no,resizable=no,left=100,top=120,width=750,height=500')"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
                     </td>
                </tr>
            
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:save()"><img src="/acar/images/center/button_conf.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
