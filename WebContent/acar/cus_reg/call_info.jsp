<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cus_reg.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	CusReg_Database cr_db = CusReg_Database.getInstance();

	
	ServInfoBean siBn = cr_db.getServInfo(c_id, serv_id);
				
	//차량정보
	Hashtable res = rs_db.getCarInfo(c_id);	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.call_t_nm.value == '' || fm.call_t_tel.value == ''){ alert('call대상자 정보를 확인하세요.'); return; }
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'call_info_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
	
		//차량이용자조회
	function CarMgr_search(){
		var fm = document.form1;	
		var t_wd;
		window.open("s_man.jsp?s_kd=3&t_wd="+fm.l_cd.value, "CarMgr_search", "left=10, top=10, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.call_t_nm.focus()">
<form action="" name="form1" method="post" >
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type="hidden" name="accid_id" value="<%=accid_id%>">
<input type="hidden" name="serv_id" value="<%=serv_id%>">

<table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=res.get("CAR_NO")%> call 대상자 정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               	<tr>
		          <td width="13%" class='title'>차량이용자</td>
		          <td width="27%">&nbsp;
		       		   <input type='text' size='30' class='text' name='call_t_nm' value="<%=siBn.getCall_t_nm()%>" >		                
		          </td>
		         <td width="13%" class='title'>연락처</td>
		         <td width="47%">&nbsp;
		         	<input type='text' size='30' class='text'  name='call_t_tel' value="<%=siBn.getCall_t_tel()%>" >
		         	<a href="javascript:CarMgr_search();"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
		          </td>
		        </tr>
            </table>
        </td>
    </tr>
 
    <tr> 
        <td align="right"><a href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
