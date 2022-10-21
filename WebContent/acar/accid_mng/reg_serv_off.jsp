<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		
	
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
		if(fm.off_nm.value=="")		{	alert("정비업체를 선택해 주세요!");		return; }
		
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.action = "reg_serv_off_a.jsp";
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
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="accid_id" value="<%=accid_id%>">
<input type="hidden" name="serv_id" value="<%=serv_id%>">

    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>정비업체등록</span></span></td>
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
                    <td class=title width=25%>정비업체</td>
                    <td width=75%> 
                      <input type="hidden" name="off_id" size="9" class=text >
                      <input name="off_nm"  class="whitetext" size="22" >
                       <a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_off.jsp','popwin_serv_off','scrollbars=no,status=no,resizable=no,left=100,top=120,width=750,height=500')"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
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
