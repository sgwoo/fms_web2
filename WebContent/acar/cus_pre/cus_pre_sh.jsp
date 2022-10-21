<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//영업소 리스트 조회
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	

	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	String user_nm = "";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function search(arg){
	var fm = document.form1;
	if(arg=="sc"){
		fm.action = "cus_pre_sc.jsp";
	}else if(arg=="ct"){
		fm.action = "cus_pre_sc_ct.jsp";
	}else if(arg=="cng"){
		fm.action = "cus_pre_sc_cng.jsp";
	}else if(arg=="my"){
		fm.action = "cus_pre_sc_my.jsp";
	}else if(arg=="gs"){
		fm.action = "cus_pre_sc_gs.jsp";
	}else if(arg=="sg"){
		fm.action = "cus_pre_sc_sg.jsp";
	}else if(arg=="gt"){
		fm.action = "cus_pre_sc_gt.jsp";				
	}else if(arg=="rm"){
		fm.action = "cus_pre_sc_rm.jsp";
	}else{
		fm.action = "cus_pre_sc.jsp";
	}
	fm.target = "c_body";
	fm.submit();
}
-->
</script>

</head>

<body onload="javascript:search('gs');">
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 업무추진관리 > <span class=style5>담당자별업무추진현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td width=17%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp; 
            <select name='br_id'>
              <%	if(brch_size > 0 ){
    							for (int i = 0 ; i < brch_size ; i++){
    								Hashtable branch = (Hashtable)branches.elementAt(i);%>
              <option value="<%=branch.get("BR_ID")%>" <%if(br_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
              <% out.println(branch.get("BR_NM"));%>
              </option>
              <%			}
    					}		%>
            </select></td>
          <td width=15% valign="middle"><img src=/acar/images/center/arrow_ddj.gif align=absmiddle>&nbsp; 
             <%if(user_size > 0){
    			for(int i = 0 ; i < user_size ; i++){
    				Hashtable user = (Hashtable)users.elementAt(i); 
					if(user_id.equals(user.get("USER_ID"))){
						user_nm = String.valueOf(user.get("USER_NM"));
					}
    			%>
      				  
            <%	}
    		}		%>
    		
			<input type="text" name="user_nm" size="15" class=text value="<%= user_nm %>"  style='IME-MODE: active'>
			</td>    
    
        <td width=11%><img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp; 
            <select name='s_kd'>
              <option value=''> 선택</option>
    	      <option value='1' <% if(s_kd.equals("1")) out.print("selected");%>>상호</option>
              <option value='2' <% if(s_kd.equals("2")) out.print("selected");%>>차량번호</option>    	
            </select>
        </td>	
    	<td width=10% valign="middle"><input type="text" name="t_wd" size="25" class=text value="<%= t_wd %>"  style='IME-MODE: active'></td>	
        <td>&nbsp;<!--<a href='javascript:search('all')' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" aligh="absmiddle" border="0"></a>--></td>
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
        <td colspan="5" align="center">
                <a href="javascript:search('rm');"><img src="/acar/images/center/button_cus_mrent.gif" align="absmiddle" border="0"></a>
	  	&nbsp;&nbsp;<a href="javascript:search('gs');"><img src="/acar/images/center/button_cus_dicr.gif" align="absmiddle" border="0"></a>        		
		&nbsp;&nbsp;<a href="javascript:search('ct');"><img src="/acar/images/center/button_cus_gyml.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:search('cng');"><img src="/acar/images/center/button_p_ddj.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:search('my');"><img src="/acar/images/center/button_cus_ms.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:search('sc');"><img src="/acar/images/center/button_cus_gl.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:search('sg');"><img src="/acar/images/center/button_p_acc.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href="javascript:search('gt');"><img src="/acar/images/center/button_p_etc.gif" align="absmiddle" border="0"></a>
		
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
