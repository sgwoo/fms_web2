<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	
	
	Vector searchs = new Vector();
	int size = 0;
	
	if(!t_wd.equals("")){
		searchs = al_db.getClientSearch(t_wd);
		size = searchs.size();
	}
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function Search(){
		var fm = document.form1;
		if(fm.t_wd.value==""){	alert("검색단어를 입력해 주세요!"); fm.t_wd.focus();	return; }
		fm.action =  'client_search.jsp';		
		fm.target = "_self";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	function view_scd(gubun, m_id, l_cd, client_id){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;	
		fm.client_id.value = client_id;	
		
		if(gubun=='이력'){
			fm.action =  '/agent/client/client_c.jsp';	
			fm.target = "_blank";
		}else{
			fm.action =  '/agent/lc_rent/lc_c_frame.jsp';	
			fm.target = "d_content";
		}		
		fm.submit();
	}
	
	function open_smsgate(rent_l_cd, client_id, firm_nm, m_tel){
		var fm = document.form1;
		var values 	= '&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&rent_l_cd='+rent_l_cd+'&client_id='+client_id+'&firm_nm='+firm_nm+'&m_tel='+m_tel;			
		var SUBWIN="/acar/sms_gate/sms_gate.jsp?auth_rw=6"+values;	
		window.open(SUBWIN, "pop", "left=300, top=150, width=900, height=900, menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='from_page' value='/agent/client/client_search.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>고객조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_scontent.gif align=absmiddle>&nbsp;
		  <input name='t_wd' type='text' class='text' value="<%=t_wd%>" size='20' maxlength='20' onKeyDown="javascript:enter()" style='IME-MODE: active'> 
	    <a href="javascript:Search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> <span class="style1">(상호,계약자,담당자,관계자,통화자)</span></td>
	</tr>
	<tr>
	  <td>&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td align='right' class="line"><table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td width='3%' class='title'>연번</td>
          <td width="7%"class='title'>구분</td>
          <td width="12%"class='title'>계약번호</td>
          <td width="13%"class='title'>상호</td>
          <td width="10%"class='title'>계약자</td>
          <td width="10%" class='title'>성명</td>
          <td width="45%" class='title'>기타</td>
          </tr>
<%	if(size > 0){
		for(int i = 0 ; i < size ; i++){
			Hashtable search = (Hashtable)searchs.elementAt(i);%>		
        <tr>
          <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=i+1%></td>
          <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=search.get("GUBUN")%></td>		  
          <td <%if(i%2 != 0)%>class=is<%%> align="center"><a href="javascript:view_scd('<%=search.get("GUBUN")%>', '<%=search.get("RENT_MNG_ID")%>', '<%=search.get("RENT_L_CD")%>', '<%=search.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true" title=''><%=search.get("RENT_L_CD")%></a></td>
          <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=search.get("FIRM_NM")%></td>
          <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=search.get("CLIENT_NM")%></td>
          <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=search.get("AGNT_NM")%></td>
          <td <%if(i%2 != 0)%>class=is<%%>><%=search.get("ETC")%>
		    <%if(!String.valueOf(search.get("M_TEL")).equals("")){%>
		    <a href="javascript:open_smsgate('<%=search.get("RENT_L_CD")%>', '<%=search.get("CLIENT_ID")%>', '<%=search.get("FIRM_NM")%>', '<%=search.get("M_TEL")%>')" title='<%=search.get("FIRM_NM")%>:<%=search.get("M_TEL")%> SMS발송 페이지로 이동하기'><img src="/acar/images/center/icon_tel.gif"  width="11" height="16" align="absmiddle" border="0"></a>
			<%}%>
		  </td>
          </tr>
<%		}
	}else{%>
		<tr>
		  <td colspan="7" align="center">등록된 데이타가 없습니다.</td>
		</tr>
<%	}%>	
      </table></td>
    </tr>	
</table>
</form>
</body>
</html>
