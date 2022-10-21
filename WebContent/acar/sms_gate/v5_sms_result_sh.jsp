<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	

	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();	
	
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') ybSearch();
}
function Search()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}

function show_dt(arg){
	fm = document.form1;
	if(arg=='3'){
		td_blank.style.display = "none";	
		td_dt.style.display = "";
		fm.st_dt.focus();
	}else{
		td_blank.style.display = "";	
		td_dt.style.display = "none";	
	}
}

//수신목록가기
function cng_sh(){
	location.href = "./v5_sms_result_sh2.jsp";
	parent.c_foot.location.href = "./v5_sms_result_sc2.jsp";
}

//-->
</script>
</head>
<body>
<form name='form1' method='post' action='./v5_sms_result_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > <span class=style5>SMS문자전송결과(Biz5)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr>
      <td width="16%" align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_jhgb.gif"  border="0" align=absmiddle>&nbsp;
        <select name='gubun' onChange="javascript:cng_sh();">
          <option value='1' <%if(gubun.equals("1")){%>selected<%}%>>발신</option>
          <option value='2' <%if(gubun.equals("2")){%>selected<%}%>>수신</option>
        </select></td>
      <td width="16%"><img src="/acar/images/center/arrow_dsgb.gif"  border="0" align=absmiddle>&nbsp;
        <select name='dest_gubun'>
          <option value=''  <%if(dest_gubun.equals("")){%>selected<%}%>>전체</option>
          <option value='1' <%if(dest_gubun.equals("1")){%>selected<%}%>>영업사원</option>
          <option value='2' <%if(dest_gubun.equals("2")){%>selected<%}%>>계약자</option>
		  <option value='3' <%if(dest_gubun.equals("3")){%>selected<%}%>>당사직원</option>
        </select></td>
      <td width="12%"><img src="/acar/images/center/arrow_day_bs.gif"  border="0" align=absmiddle>&nbsp;
        <select name='send_dt' onChange="javascript:show_dt(this.value);">
          <option value=''  <%if(send_dt.equals("")){%>selected<%}%>>전체</option>
		  <option value='4' <%if(send_dt.equals("4")){%>selected<%}%>>당월</option>		  
		  <option value='1' <%if(send_dt.equals("1")){%>selected<%}%>>당일</option>
          <option value='2' <%if(send_dt.equals("2")){%>selected<%}%>>전일</option>
          <option value='3' <%if(send_dt.equals("3")){%>selected<%}%>>기간</option>
        </select></td>
      <td id="td_blank" style="display:''" width=17%>&nbsp;</td>
      <td id="td_dt" style="display:none;" width="176"><input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'> ~
				  <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
      <td width="179">&nbsp;</td>
    </tr>
    <tr>
      <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_bsj.gif"  border="0" align=absmiddle>&nbsp;&nbsp;&nbsp;
	            <select name='s_bus'>
                  <option value="">=전체=</option>
                  <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                  <option value='<%=user.get("USER_ID")%>' <%if(s_bus.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                  <%		}
					}		%>
                  
                </select></td>
      <td>&nbsp;        </td>
      <td><img src="/acar/images/center/arrow_jr.gif"  border="0" align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <select name='sort'>
          <option value='1' <%if(sort.equals("1")){%>selected<%}%>>발신자</option>
          <option value='2' <%if(sort.equals("2")){%>selected<%}%>>총건수</option>
          <option value='3' <%if(sort.equals("3")){%>selected<%}%>>유효건수</option>
          <option value='4' <%if(sort.equals("4")){%>selected<%}%>>발신일자</option>
        </select></td>
      <td><input type="radio" name="sort_gubun" value="asc" <%if(sort_gubun.equals("asc")){%>checked<%}%>>
오름차순
  <input type="radio" name="sort_gubun" value="desc" <%if(sort_gubun.equals("desc")){%>checked<%}%>>
내림차순</td>
      <td><a href="javascript:Search()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>