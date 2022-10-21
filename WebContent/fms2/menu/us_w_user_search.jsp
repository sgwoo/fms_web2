<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	String w_nm = request.getParameter("w_nm")==null?"":request.getParameter("w_nm");
	
	//단독 업무권한자 변경
	String w_user_id = nm_db.getWorkAuthUser(w_nm);
	
	user_bean 	= umd.getUsersBean(w_user_id);
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;		
		fm.target = "i_no";
		fm.action = "us_w_user_search_a.jsp";		
		fm.submit();
	}
	
	//새로고침
	function self_reload(){
		var fm = document.form1;
		fm.target = "_self";		
		fm.action = "us_w_user_search.jsp";
		fm.submit();
	}	
//-->
</script>


</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
  <input type="hidden" name="w_nm" value="<%=w_nm%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
   	<tr>
		<td >
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>업무권한자 변경</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
<%	//담당자 리스트
	Vector users = new Vector();

	if(w_nm.equals("과태료전자문서등록")){
		users = c_db.getUserList("", "", "FINE");	
	}	
	
	int user_size = users.size();
%>
    <tr><td class=line2></td></tr>
    <tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='40%' class='title'>구분</td>
					<td width='30%' class='title'>변경전</td>					
					<td width='30%' class='title'>변경후</td>								
			</tr>
			<tr>
			<td align="center"><%=w_nm%></td>
            <td align="center"><%=umd.getUserNm(w_user_id)%></td>
            <td align="center">
                <select name="s_user_id">
        			    <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(w_user_id.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>            
            </td>			
			</tr>	  
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr>
		<td align="center">
		    <a href="javascript:save()"><img src=/acar/images/pop/button_modify.gif border=0 align=absmiddle></a>
			<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
		</td>
	</tr>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>

