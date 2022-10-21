<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_brch_id = request.getParameter("s_brch_id")==null?"":request.getParameter("s_brch_id");
	String s_dept_id = request.getParameter("s_dept_id")==null?"":request.getParameter("s_dept_id");
	String s_user_id = request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):AddUtil.parseInt(request.getParameter("s_year"));
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):AddUtil.parseInt(request.getParameter("s_month"));
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):AddUtil.parseInt(request.getParameter("s_day"));	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
	CodeBean[] depts = c_db.getCodeAll2("0002", ""); /* 코드 구분:부서명-가산점적용 */
	int dept_size = depts.length;
	
	Vector users = c_db.getUserList("", "", "EMP"); //사원 리스트
	int user_size = users.size();	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.action = "busi_di_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
		
		fm.action = "busi_di_cont.jsp";
		fm.target = "c_cont";
		fm.submit();
		
	}

	//부서 선택시 차종코드 출력하기
	function GetUserId(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.s_user_id;
		te.options[0].value = '';
		te.options[0].text = '조회중';
		fm2.sel.value = "form1.s_user_id";
		fm2.s_brch_id.value = fm.s_brch_id.value;
		fm2.s_dept_id.value = fm.s_dept_id.value;		
		fm2.target="i_no";
		fm2.submit();
	}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="./busi_di_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="s_brch_id" value="">
  <input type="hidden" name="s_dept_id" value="">
  <input type="hidden" name="s_user_id" value="">
</form>
<form action="busi_di_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">  
<input type="hidden" name="user_id" value="<%=user_id%>">    
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 업무일지관리 > <span class=style5>업무일지조회</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td>	
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td width="200">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_yus.gif align=absmiddle>&nbsp;
                      <select name='s_brch_id'>
        			  <option value="">전체</option>
                        <%	if(brch_size > 0){
        							for (int i = 0 ; i < brch_size ; i++){
        								Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%= branch.get("BR_ID") %>' <%if(s_brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
                        <%= branch.get("BR_NM")%> </option>
                        <%							}
        						}		%>
                      </select>
                    </td>
                    <td width="150"><img src=../images/center/arrow_bs.gif align=absmiddle>&nbsp;
                      <select name='s_dept_id' onChange="javascript:GetUserId()">
                        <option value="">전체</option>
                        <%if(dept_size > 0){
        					for(int i = 0 ; i < dept_size ; i++){
        						CodeBean dept = depts[i];%>
                        <option value='<%=dept.getCode()%>' <%if(s_dept_id.equals(dept.getCode())){%>selected<%}%>> <%= dept.getNm()%> </option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td width="170"><img src=../images/center/arrow_sm.gif align=absmiddle>&nbsp;
                      <select name='s_user_id'>
                        <option value="">전체</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(s_user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                    <td width=250><img src=../images/center/arrow_gg.gif align=absmiddle>&nbsp; 
                      <select name="s_year">
                        <option value="" <%if(s_year == 0){%>selected<%}%>></option>
                        <%for(int i=2002; i<=s_year; i++){%>
                        <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                        <%}%>
                      </select>
                      <select name="s_month">
                        <option value="" <%if(s_month == 0){%>selected<%}%>></option>
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>월</option>
                        <%}%>
                      </select>
                      <select name="s_day" onChange="javascript:search()">
                        <option value="" <%if(s_day == 0){%>selected<%}%>></option>
                        <%for(int i=1; i<=31; i++){%>
                        <option value="<%=i%>" <%if(s_day == i){%>selected<%}%>><%=i%>일</option>
                        <%}%>
                      </select>
                    </td>
                    <td><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                </tr>
            </table>			
		</td>
	</tr>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>