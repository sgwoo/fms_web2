<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.user_mng.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String nm 	= request.getParameter("nm")==null?"":request.getParameter("nm");	
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");	
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String agent_user_id 	= request.getParameter("agent_user_id")==null?"":request.getParameter("agent_user_id");	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Vector vt = c_db.getAgentUserSearchList(agent_user_id, t_wd); 
	int vt_size = vt.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<!--<%@ include file="/acar/getNaviCookies.jsp" %>-->
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="search_agent_user.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	function setCode(code, name){
		var fm = document.form1;	
		var idx = toInt(fm.idx.value);	
		
		<%if(idx.equals("")){%>
		
		opener.form1.<%=nm%>.value 		= code;		

		<%if(nm.equals("agent_emp_id")){%>
		opener.form1.agent_emp_nm.value 		= name;
		<%}%>
		
		<%}else{%>

		opener.form1.<%=nm%>[<%=idx%>].value 		= code;		

		<%if(nm.equals("agent_emp_id")){%>
		opener.form1.agent_emp_nm[<%=idx%>].value 		= name;
		<%}%>
			
		<%}%>	
		
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
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>
<form action="./search_agent_user.jsp" name="form1" method="POST">
  <input type='hidden' name='mode' value='<%=mode%>'>
  <input type='hidden' name='nm' value='<%=nm%>'>
  <input type="hidden" name="idx" value="<%=idx%>">  
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">  
  <input type="hidden" name="agent_user_id" value="<%=agent_user_id%>">  
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > <span class=style5>에이전트 계약진행담당자(영업사원) 검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>  
    <tr> 
      <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_sm.gif align=absmiddle>&nbsp;
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
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
            <td width='30%' class='title'>소속</td>
            <td width='30%' class='title'>부서</td>
            <td width='30%' class='title'>이름</td>
          </tr>          
          <tr>
            <td align="center">-</td>
            <td align="center">-</td>
            <td align="center">-</td>
            <td align="center"><a href="javascript:setCode('','')">없음</a></td>
          </tr>                   
          <%if(vt_size > 0){%>
	  <%		for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>			
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("BR_NM")%></td>
            <td align="center"><%=ht.get("DEPT_NM")%></td>
            <td align="center"><a href="javascript:setCode('<%=ht.get("USER_ID")%>','<%=ht.get("USER_NM")%>')"><%=ht.get("USER_NM")%></a></td>
          </tr>
	  <%		}%>
	  <%}else{%>
          <tr>		  
            <td colspan="4" align="center">데이타가 없습니다.</td>
          </tr>
	  <%}%>		  
        </table>
	</td>
  </tr>
    <tr>
        <td class=h></td>
    </tr>  
   
    <tr>
      <td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

