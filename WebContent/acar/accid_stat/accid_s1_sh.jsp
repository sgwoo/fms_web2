<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="accid_s1_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	//다른현황으로 이동
	function cng_stat(){
		var fm = document.form1;
		if(fm.gubun1.value == "") 			fm.action="accid_s_frame.jsp";
		else if(fm.gubun1.value == "0") 	fm.action="accid_s1_frame.jsp";
		else if(fm.gubun1.value == "1") 	fm.action="accid_s2_frame.jsp";
		else if(fm.gubun1.value == "2") 	fm.action="accid_s3_frame.jsp";
		else if(fm.gubun1.value == "3") 	fm.action="accid_s4_frame.jsp";
		else if(fm.gubun1.value == "4") 	fm.action="accid_s5_frame.jsp";
		else if(fm.gubun1.value == "5") 	fm.action="accid_s6_frame.jsp";
		fm.target="d_content";		
		fm.submit();
	}		
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();		
%>
<form action="./accid_s1_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type="hidden" name="gubun2" value="">
<input type="hidden" name="gubun3" value="">
<input type="hidden" name="gubun4" value="">
<input type="hidden" name="gubun5" value="">
<input type="hidden" name="gubun6" value="">
<input type="hidden" name="end_dt" value="">
<input type="hidden" name="s_kd" value="">
<input type="hidden" name="t_wd" value="">
<input type="hidden" name="sort" value="">
<input type="hidden" name="asc" value="">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=6>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 사고현황 > <span class=style5>
						연간/월간현황</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>    	

    <tr> 
      <td width=15%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp;
        <select name="gubun1">
          <option value=""   <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
          <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>렌트</option>
          <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>리스</option>
        </select>
      </td>
      <td width=15%>
	  <%if(br_id.equals("S1")){%>	  
        <img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;          
        <select name='brch_id'>
          <option value=''>전체</option>
          <%if(brch_size > 0){
				for (int i = 0 ; i < brch_size ; i++){
					Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
          <%= branch.get("BR_NM")%> </option>
          <%	}
			}%>
        </select>
		<%}%>		
      </td>
      <td width=15%><img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;  
        <select name="st_dt">
          <option value="" >전체</option>		
          <%for(int i = 2000 ; i <= AddUtil.getDate2(1) ; i++){%>
          <option value="<%=i%>" <%if(st_dt.equals(Integer.toString(i))){%>selected<%}%>><%=i%></option>
          <%}%>
        </select>
        년도 </td>
      <td><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>