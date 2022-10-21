<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(user_id);
	
	if(dept_id.equals("")){
		dept_id = user_bean.getDept_id();
		
		if(dept_id.equals("0003")) dept_id = "0002";
	}
	
	
	
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function tg(arg){
	var fm = document.form1;
	if(fm.dept_id.value==''){ alert('부서를 선택하십시오.'); return; }
	if(arg=="y"){
		fm.action = "cus_pre_tg_year.jsp";
		fm.cmd.value = '';
	}else if(arg=="m"||arg=="d"){
		fm.action = "cus_pre_tg_md.jsp";
		fm.cmd.value = arg;
	}
	fm.target = "c_body";
	fm.submit();
}
function st(arg){
	var fm = document.form1;
	if(arg=="y")			fm.action = "cus_pre_st_year.jsp";
	else if(arg=="m")		fm.action = "cus_pre_st_month.jsp";
	else if(arg=="d")		fm.action = "cus_pre_st_day.jsp";
	fm.target = "c_body";
	fm.submit();
}
//-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='cmd' value=''> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 업무추진관리 > <span class=style5>업무추진실적현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=12%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    <select name='dept_id'>
            
			<%for(int i = 0 ; i < dept_size ; i++){
				CodeBean dept = depts[i];
				%>
          <option value='<%=dept.getCode()%>' <%if(dept_id.equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
          <%	
				}%>
          </select>
			
                    </td>
                    <td></td>
                 </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=5 style='height:1; background-color:e7e7e8;'></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="center" colspan="2">
	    <a href="javascript:tg('d')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_cus_day.gif" align="absmiddle" border="0"></a> 
        &nbsp;&nbsp;<a href="javascript:tg('m')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_cus_month.gif" align="absmiddle" border="0"></a> 
		&nbsp;&nbsp;<a href="javascript:tg('y')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_cus_year.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td colspan=5 style='height:1; background-color:e7e7e8;'></td>
    </tr>
</table>
</form>
</body>
</html>
