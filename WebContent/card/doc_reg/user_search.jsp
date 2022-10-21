<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String nm = request.getParameter("nm")==null?"":request.getParameter("nm");	
	dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	
	if(nm.equals("buy_user_id")){
		dept_id = "";		
	}
	
	Vector vt = new Vector();
	
	//카드종류 리스트 조회
	if (dept_id.equals("9999") ) {
		vt = CardDb.getUserSearchList("", dept_id, t_wd, "N");
	} else {
		if(t_wd.equals("")){
			vt = CardDb.getUserSearchList("", dept_id, t_wd, use_yn);
		}else{
			vt = CardDb.getUserSearchList("", dept_id, t_wd, "");
		}
	}	
	int vt_size = vt.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="user_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	function setCode(code, name){
		var fm = document.form1;	

		opener.form2.buy_user_id.value 			= code;		
		opener.form1.buy_user_id.value 			= code;
		opener.form2.user_nm.value 			= name;					

		
		
		window.close();
	}
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

</head>
<body>
<form action="./user_search.jsp" name="form1" method="POST">
  <input type='hidden' name='nm' value='<%=nm%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="use_yn" value="<%=use_yn%>"> 
  <input type="hidden" name="go_url" value="<%=go_url%>">
  <input type="hidden" name="dept_id" value="<%=dept_id%>">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_sm.gif align=absmiddle>&nbsp;
        <input name="t_wd" type="text" class="text" value="" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>연번</td>
            <td width='45%' class='title'>코드</td>
            <td width='45%' class='title'>이름</td>
          </tr>
          <%if(vt_size > 0){
				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>			
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center">
			<%=ht.get("USER_ID")%>
			</td>
            <td align="center"><a href="javascript:setCode('<%=ht.get("USER_ID")%>','<%=ht.get("USER_NM")%>')"><%=ht.get("USER_NM")%></a>
                <%if(String.valueOf(ht.get("USE_YN")).equals("N")){%>(퇴사자)<%}%>
            </td>
          </tr>
		  <%	}%>
		  <%}else{%>
          <tr>		  
            <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
          </tr>
		  <%}%>		  
        </table>
	</td>
  </tr>
   
    <tr>
      <td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

