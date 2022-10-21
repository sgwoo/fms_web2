<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String white = "";
	String disabled = "";
	
	
	Vector vt1 = cs_db.getConsCostSearchList("1", "");
	int vt_size1 = vt1.size();
	
	Vector vt2 = cs_db.getConsCostSearchList("2", "");
	int vt_size2 = vt2.size();
	
	Vector vt3 = cs_db.getConsCostSearchList("3", "");
	int vt_size3 = vt3.size();
	
	Vector vt4 = cs_db.getConsCostSearchList("4", "");
	int vt_size4 = vt4.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		fm.action = 'cons_cost_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function reg_exp_all(){
		var fm = document.form1;
		fm.action = 'excel.jsp';
		fm.target = '_blank';
		fm.submit();
	}						

	function reg_exp_form(){
		var fm = document.form1;
		fm.action = 'excel_form.jsp';
		fm.target = '_blank';
		fm.submit();
	}						
	
	function reg_all(){
		var fm = document.form1;
		fm.action = 'cons_cost_i.jsp';
		fm.target = '_blank';
		fm.submit();
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body <%if(white.equals("")){%>onload="javascript:document.form1.t_wd.focus();"<%}%>>
<form name='form1' action='/fms2/cons_cost/cons_cost_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>출고탁송관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>		
  <tr>
    <td><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>조건검색</span></td>
    <td align="right">&nbsp;</td>
  </tr>
  <tr>
    <td class=line2 colspan=2></td>
  </tr>
  <tr>
    <td colspan="2" class=line>
	  <table border="0" cellspacing="1" cellpadding='0' width=100%>
        <tr>
          <td class=title width=10%>탁송업체</td>
          <td width=40%>&nbsp;
		    <select name='gubun1'>
              <option value=''>전체</option>
			  <%for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vt1.elementAt(i);%>
			  <option value='<%=ht.get("ID")%>' <%if(gubun1.equals(String.valueOf(ht.get("ID"))))%>selected<%%>><%=ht.get("NM")%></option>
			  <%}%>		
            </select>
		  </td>		
          <td class=title width=10%>기준일자</td>
          <td width=40%>&nbsp;
		    <select name='gubun2'>
              <option value=''>전체</option>
			  <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vt2.elementAt(i);%>
			  <option value='<%=ht.get("ID")%>' <%if(gubun2.equals(String.valueOf(ht.get("ID"))))%>selected<%%>><%=ht.get("NM")%></option>
			  <%}%>		
            </select>
            &nbsp; 사용여부 : 
            <select name='gubun5'>
              <option value=''>전체</option>
              <option value='Y' <%if(gubun5.equals("Y")){%>selected<%}%>>사용</option>
              <option value='N' <%if(gubun5.equals("N")){%>selected<%}%>>미사용</option>
            </select>
		  </td>
        </tr>		
        <tr>
          <td class=title width=10%>제조사</td>
          <td width=40%>&nbsp;
                    <input type='text' name='gubun3' size='25' class='<%=white%>text' value='<%=gubun3%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		  </td>		
          <td class=title width=10%>차종</td>
          <td width=40%>&nbsp;
                    <input type='text' name='gubun4' size='25' class='<%=white%>text' value='<%=gubun4%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		  </td>
        </tr>				
        <tr>
          <td class=title width=10%>검색조건</td>
          <td>&nbsp;
		    <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>출하장</option>
            </select>
			&nbsp;&nbsp;&nbsp;
			<input type='text' name='t_wd' size='25' class='<%=white%>text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		  </td>		
          <td class=title width=10%>정렬조건</td>
          <td>&nbsp;
		    <select name='sort'>
              <option value='1' <%if(sort.equals("1")){%>selected<%}%>>차종</option>
            </select>
			&nbsp;&nbsp;&nbsp;
			<!--<input type='text' name='t_wd' size='25' class='<%=white%>text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>-->
		  </td>
        </tr>
    </table>
	</td>
  </tr>  
  <tr align="right">
    <td colspan="2"><%if(white.equals("")){%>
		<a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a>
		<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		&nbsp;&nbsp;<a href='javascript:reg_exp_form()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_excel_ys.gif align=absmiddle border=0></a>
		&nbsp;&nbsp;<a href='javascript:reg_exp_all()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg_excel.gif align=absmiddle border=0></a>
		&nbsp;&nbsp;<a href='javascript:reg_all()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg_ilg.gif align=absmiddle border=0></a>
		<%}%>
    	<%}%></td>
  </tr>
</table>
</form>
</body>
</html>
