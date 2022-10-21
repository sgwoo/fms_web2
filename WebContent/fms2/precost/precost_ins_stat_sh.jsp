<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="precost_ins_stat_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	function save(work_st, cnt)
	{
		var fm = document.form1;	
		if(cnt > 0){		
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
			fm.work_st.value = work_st;
			fm.target = 'i_no';
			fm.action = '/fms2/master/autowork_a.jsp';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}
	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//보험선급비용 미처리스트
	Vector vts2 = ai_db.getInsurPrecostNoRegList();
	int vt_size2 = vts2.size();
	
	//보험선급비용 미정산건리스트
	Vector vts4 = ai_db.getInsurPrecostNoSettleList_2009();
	int vt_size4 = vts4.size();
%>
<form action="./ins_s4_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>
<input type='hidden' name='work_st' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험현황 > <span class=style5>보험료현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
    <tr> 
      <td width="145">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_yd.gif align=absmiddle>
              &nbsp;<select name="gubun1">
                <!--<option value="" <%if(gubun1.equals("")){%>selected<%}%>>전체</option>-->
                <%for(int i=2006; i<=AddUtil.getDate2(1)+1; i++){%>
                <option value="<%=i%>" <%if(gubun1.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
                <%}%>
              </select>
      </td>
      <td width="80"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
      <td width="135">
        <!--
        <img src=/acar/images/center/arrow_yus.gif align=absmiddle>
        &nbsp;<select name='brch_id'>
          <option value=''>전체</option>
		  <option value='S1'  <%if(brch_id.equals("S1")){%>selected<%}%>>본사</option>
		  <option value='B1'  <%if(brch_id.equals("B1")){%>selected<%}%>>부산지점</option>
		  <option value='D1'  <%if(brch_id.equals("D1")){%>selected<%}%>>대전지점</option>		  		  
        </select>
        -->
      </td>
      <td align="right">
        &nbsp;&nbsp;&nbsp;
        <img src=/acar/images/center/arrow_reg_gg.gif align=absmiddle> : 미등록<%=vt_size2%>건 
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        <a id="submitLink" href="javascript:save('insur_period_costs', <%=vt_size2%>)"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;
        <%}%>
	    <!--<img src=/acar/images/center/arrow_ggjs.gif align=absmiddle> : 미정산<%=vt_size4%>건 <a href="javascript:save('insur_period_costs_settle', <%=vt_size4%>)"><img src=/acar/images/center/button_js.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;-->
	    <a href ="/acar/ins_excel/excel.jsp" target="_blank"><img src=/acar/images/center/button_reg_excel.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;
	  </td>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>