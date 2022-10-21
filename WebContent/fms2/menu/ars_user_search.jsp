<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

	String reg_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String ars_group = request.getParameter("ars_group")==null?"":request.getParameter("ars_group");
	String u_dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String loan_st = request.getParameter("loan_st")==null?"":request.getParameter("loan_st");
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(reg_id);
	ars_group   = user_bean.getArs_group();
	
	
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
		<%if(user_bean.getLoan_st().equals("1")){%>
		if(fm.loan_st.value='1'){
			if(fm.ars_partner_id[0].value == ''){ alert('1순위 파트너를 입력하십시오.'); return; }
			if(fm.ars_partner_id[1].value == ''){ alert('2순위 파트너를 입력하십시오.'); return; }
			if(fm.ars_partner_id[0].value == fm.user_id.value){ alert('본인을 선택할 수 없습니다. 1순위 파트너를 입력하십시오.'); return; }
			if(fm.ars_partner_id[1].value == fm.user_id.value){ alert('본인을 선택할 수 없습니다. 2순위 파트너를 입력하십시오.'); return; }
			if(fm.ars_partner_id[0].value == fm.ars_partner_id[1].value){ alert('1순위와 2순위가 같을 수 없습니다. 2순위 파트너를 입력하십시오.'); return; }
		}
		<%}%>
		fm.target = "i_no";
		fm.action = "ars_user_search_a.jsp?";		
		fm.submit();
	}
	
//새로고침
function self_reload(){
	var fm = document.form1;
	fm.target = "_self";		
	fm.action = "ars_user_search.jsp";
	fm.submit();
}	
//-->
</script>


</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
  <input type="hidden" name="user_id" value="<%=reg_id%>">
  <input type="hidden" name="dept_id" value="<%=u_dept_id%>">
  <input type="hidden" name="loan_st" value="<%=loan_st%>">
  <input type="hidden" name="cmd" value="">
  <input type='hidden' name='go_url' value='<%=go_url%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<%if(user_bean.getLoan_st().equals("")){

	int s=0; 
	String app_value[] = new String[5];		
	if(ars_group.length() > 0){
		StringTokenizer st = new StringTokenizer(ars_group,"/");				
		while(st.hasMoreTokens()){
			app_value[s] = st.nextToken();
			s++;
		}		
	}	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "LOAN_ST0");
	int user_size = users.size();	
%>
    	<tr>
		<td >
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>재택근무파트너 관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
	<tr> 
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 재택근무파트너 리스트</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='20%' class='title'>구분</td>					
					<td width='40%' class='title'>이름</td>
					<td width='40%' class='title'>변경</td>					
			</tr>
			<%if(s>0){%>
			<%	for(int j=0 ; j < s ; j++){%>		
			<tr>
			<td align="center"><%=j+1%></td>
            <td align="center"><%=umd.getUserNm(app_value[j])%></td>
            <td align="center">
                <select name="ars_partner_id">
        			    <option value="">없음</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(app_value[j].equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>            
            </td>			
			</tr>
			<%	}%>
			<%}%>
			<%if(s<5){%>
			<%	for(int j=s ; j < 5 ; j++){%>		
			<tr>
			<td align="center"><%=j+1%></td>
            <td align="center">-</td>
            <td align="center">
                <select name="ars_partner_id">
        			    <option value="">없음</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>            
            </td>			
			</tr>			
			<%	}%>			
			<%}%>		  
			</table>
		</td>
	</tr>
<%}else{

	int s=0; 
	String app_value[] = new String[2];		
	if(ars_group.length() > 0){
		StringTokenizer st = new StringTokenizer(ars_group,"/");				
		while(st.hasMoreTokens()){
			app_value[s] = st.nextToken();
			s++;
		}		
	}	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "LOAN_ST1");
	int user_size = users.size();
%>
    	<tr>
		<td >
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>ARS파트너 관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
	<tr> 
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ARS파트너 리스트</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='20%' class='title'>구분</td>					
					<td width='40%' class='title'>이름</td>
					<td width='40%' class='title'>변경</td>					
			</tr>
			<%if(s>0){%>
			<%	for(int j=0 ; j < s ; j++){%>		
			<tr>
			<td align="center"><%=j+1%>순위</td>
            <td align="center"><%=umd.getUserNm(app_value[j])%></td>
            <td align="center">
                <select name="ars_partner_id">
        			    <option value="">없음</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(app_value[j].equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>            
            </td>			
			</tr>
			<%	}%>
			<%}else{%>
			<tr>
			<td align="center">1순위</td>
            <td align="center">-</td>
            <td align="center">
                <select name="ars_partner_id">
        			    <option value="">없음</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>            
            </td>			
			</tr>
			<tr>
			<td align="center">2순위</td>
            <td align="center">-</td>
            <td align="center">
                <select name="ars_partner_id">
        			    <option value="">없음</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>            
            </td>			
			</tr>			
			<%}%>		  
			</table>
		</td>
	</tr>
<%} %>

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

