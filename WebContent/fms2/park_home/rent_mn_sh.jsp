<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	String brch_id = request.getParameter("brch_id")==null?"S1":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"c.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
%>

<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;		
		fm.action = 'rent_mn_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
				
//-->
</script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='rent_mn_sc.jsp' target='c_foot'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > ���������� > <span class=style5>���(����)���� �߱�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td id='td_input' align='left' style="display:''" width='16%'><img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
            <select name='gubun2'>
              <option value='' <%if(gubun2.equals("")){%>selected<%}%>>��ü</option>
              <option value='20' <%if(gubun2.equals("20")){%>selected<%}%>>=�������=</option>
              <option value='1' <%if(gubun2.equals("1")){%>selected<%}%>>�ܱ�뿩</option>
              <option value='2' <%if(gubun2.equals("2")){%>selected<%}%>>�������</option>
              <option value='3' <%if(gubun2.equals("3")){%>selected<%}%>>������</option>
              <option value='9' <%if(gubun2.equals("9")){%>selected<%}%>>�������</option>
              <option value='10' <%if(gubun2.equals("10")){%>selected<%}%>>��������</option>
              <option value='4' <%if(gubun2.equals("4")){%>selected<%}%>>�����뿩</option>		  		  
    <!--      <option value='5' <%if(gubun2.equals("5")){%>selected<%}%>>��������</option>-->
              <option value='12' <%if(gubun2.equals("12")){%>selected<%}%>>����Ʈ</option>
              <option value='30' <%if(gubun2.equals("30")){%>selected<%}%>>=��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��=</option>		  
              <option value='6' <%if(gubun2.equals("6")){%>selected<%}%>>��������</option>
    <!--      <option value='7' <%if(gubun2.equals("7")){%>selected<%}%>>��������</option>-->
              <option value='8' <%if(gubun2.equals("8")){%>selected<%}%>>������</option>		  
            </select>
        </td>
        <td id='td_input' align='left' style="display:''" width='17%'><img src=/acar/images/center/arrow_yuscd.gif align=absmiddle>&nbsp;
            <select name='brch_id' onChange='javascript:search();'>
              <option value=''>��ü</option>
              <option value='S1' <%if(brch_id.equals("S1")){%>selected<%}%>>����+����</option>
              <option value='S2' <%if(brch_id.equals("S2")){%>selected<%}%>>��������</option>
              <option value='B1' <%if(brch_id.equals("B1")){%>selected<%}%>>�λ�+����</option>
              <option value='D1' <%if(brch_id.equals("D1")){%>selected<%}%>>����</option>
			  <option value='J1' <%if(brch_id.equals("J1")){%>selected<%}%>>����</option>
			  <option value='G1' <%if(brch_id.equals("G1")){%>selected<%}%>>�뱸</option>
            </select>
        </td>
        <td id='td_input' align='left' style="display:''" width=25%><img src=/acar/images/center/arrow_day_bc.gif align=absmiddle>&nbsp; 
            <input type='text' name='start_dt' size='11' class='text' value='<%=start_dt%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            ~ 
            <input type='text' name='end_dt' size='11' class='text' value='<%=end_dt%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td align='left' colspan="3"><img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='' <%if(s_kd.equals("")){%>selected<%}%>>��ü </option>
              <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>������ȣ</option>
              <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����</option>
              <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>��ȣ</option>
              <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>���ʿ�����</option>		
              <option value='6' <%if(s_kd.equals("6")){%> selected <%}%>>���������</option>
              <option value='7' <%if(s_kd.equals("7")){%> selected <%}%>>���ʿ�����|���������</option>
              <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>�����߻�������ȣ</option>
              <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>����ȣ</option>
            </select>
            <input type='text' name='t_wd' size='27' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
        </td>
        <td id='td_input' align='left' style="display:''"><img src=/acar/images/center/arrow_jrjg.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            <select name='sort_gubun' onChange='javascript:search()'>
              <option value='' 		<%if(sort_gubun.equals("")){%>selected<%}%>>���� </option>		
              <option value='a.rent_st' <%if(sort_gubun.equals("a.rent_st")){%> selected <%}%>>��౸��</option>
              <option value='c.car_no' 	<%if(sort_gubun.equals("c.car_no")){%> selected <%}%>>������ȣ</option>
              <option value='c.car_nm' 	<%if(sort_gubun.equals("c.car_nm")){%> selected <%}%>>����</option>
              <option value='a.deli_plan_dt' <%if(sort_gubun.equals("a.deli_plan_dt")){%> selected <%}%>>������������</option>
              <option value='a.deli_dt' <%if(sort_gubun.equals("a.deli_dt")){%> selected <%}%>>��������</option>		  
            </select>
            <select name='asc' onChange='javascript:search()'>
              <option value="asc">��������</option>
              <option value="desc">��������</option>
            </select>
        </td>
        <td>&nbsp;<a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
