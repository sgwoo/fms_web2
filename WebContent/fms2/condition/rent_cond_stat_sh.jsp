<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size 	= branches.size();
	Vector users 	= c_db.getUserList("", "", "EMP"); 		//담당자 리스트
	int user_size 	= users.size();
	Vector users2 	= c_db.getUserList("9999", "", "", "N"); 	//퇴사자 리스트
	int user_size2 	= users2.size();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		fm.action = "rent_cond_stat_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function list(){
		var fm = document.form1;
		fm.action = "/fms2/condition/rent_cond_stat_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form method="POST" name="form1">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>    
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약현황</span></span></td>
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
        <table width="100%" border=0 cellspacing=1>
          <tr> 
            <td width=25%>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="gubun1">
                <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>계약일</option>
                <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>대여개시일</option>
				<option value="3" <%if(gubun1.equals("3"))%>selected<%%>>현재기준</option>
				<option value="4" <%if(gubun1.equals("4"))%>selected<%%>> 출고일</option>
              </select>
			  <select name="gubun2" >
                <% for(int i=2005; i<=AddUtil.getDate2(1); i++){%>
                <option value="<%=i%>" <%if(i == AddUtil.parseInt(gubun2)){%> selected <%}%>><%=i%>년도</option>
                <%}%>
              </select>
              <select name="gubun3">
                <option value="" <%if(gubun3.equals("")){%> selected <%}%>>전체</option>
                <% for(int i=1; i<=12; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(i == AddUtil.parseInt(gubun3)){%> selected <%}%>><%=AddUtil.addZero2(i)%>월</option>
                <%}%>
              </select></td>
            <td width=16%><img src="/acar/images/center/arrow_yuscd.gif" align=absmiddle title='영업소코드'>&nbsp; 			  
              <select name='gubun4'>
                <option value=''>전체</option>
                <%if(brch_size > 0){
    			for (int i = 0 ; i < brch_size ; i++){
    				Hashtable branch = (Hashtable)branches.elementAt(i);%>
                <option value='<%=branch.get("BR_ID")%>' <%if(gubun4.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                <%	}
    		}%>	
              </select>
            </td>
            <td width="24%"><img src=/acar/images/center/arrow_ddj.gif align=absmiddle>&nbsp;
              <select name="s_kd">
                <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>최초영업자</option>
                <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>영업담당자</option>
                <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>관리담당자</option>
              </select>
			  &nbsp;
              <select name='t_wd'>
            	<option value="">선택</option>
            	<%	if(user_size > 0){
            			for (int i = 0 ; i < user_size ; i++){
            				Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                <%		}
            		}%>
            	<option value="">=퇴사자=</option>
                <%	if(user_size2 > 0){
            			for (int i = 0 ; i < user_size2 ; i++){
            				Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
                <%		}
            		}%>
              </select>
            </td>					  
            <td width="8%"><a href="javascript:search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
            <td align="right"><a href="/fms2/condition/rent_cond_stat_frame.jsp" target='d_content'><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td>			
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>