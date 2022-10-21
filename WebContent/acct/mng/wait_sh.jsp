<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");


	String gubun1 	= request.getParameter("gubun1") ==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2") ==null?"":request.getParameter("gubun2");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//중메뉴
	Vector au_menu = umd.getAuthMaMeAll1(user_id, "19");
	int aumenu_size = au_menu.size();
	
	//마감자
	Vector users = at_db.getAcctRegIDList();
	int user_size = users.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//검색
	function Search()
	{
		var fm = document.form1;		
		fm.target = "c_foot";		
		fm.action = 'wait_sc.jsp';	
		fm.submit();
	}	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin=15>
<form name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>내부통제평가 > <span class=style5>평가예정관리</span></span></td>
            <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <!--비지니스사이클-->
                    	<!--<img src=/acct/images/center/arrow_gggs.gif align=absmiddle>&nbsp;-->
                    	비지니스사이클 : 
	    		<select name='gubun1'>
                    	  <option value="" >선택</option>
                    	  <%	for (int i = 0 ; i < aumenu_size ; i++){
                        		Hashtable aumenu = (Hashtable)au_menu.elementAt(i);
                        		if(String.valueOf(aumenu.get("M_NM")).equals("Master")) 	continue; %>
		    	  <option value="<%=aumenu.get("M_NM")%>" <%if(gubun1.equals(String.valueOf(aumenu.get("M_NM"))))%>selected<%%>><%=aumenu.get("M_NM")%></option>
		    	  <%	}%>
            		</select>	
            		&nbsp;&nbsp;
                    	<!--마감자-->
                    	<!--<img src=/acct/images/center/arrow_gggs.gif align=absmiddle>&nbsp;-->
                    	마감자 : 
	    		<select name='gubun2'>
                    	  <option value="" >선택</option>
                    	  <%	for (int i = 0 ; i < user_size ; i++){
                        		Hashtable user = (Hashtable)users.elementAt(i); %>
		    	  <option value="<%=user.get("USER_ID")%>" <%if(gubun2.equals(String.valueOf(user.get("USER_ID"))))%>selected<%%>><%=user.get("USER_NM")%></option>
		    	  <%	}%>
            		</select>	
            		&nbsp;&nbsp;
            		<a href="javascript:Search();"><img src=/acct/images/center/button_search.gif align=absmiddle border=0></a>
		    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>