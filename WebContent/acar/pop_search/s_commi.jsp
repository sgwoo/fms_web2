<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
%>

<html>
<head><title>자동차영업사원 조회</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchCarOffP();
	}
	function SearchCarOffP(){
		var fm = document.form1;
		fm.submit();
	}
	
	function car_emp_reg(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "./car_office_p_i.jsp";
		fm.submit();	
	}

	//영업소-사원명 셋팅
	function set_emp(car_comp_id, car_comp_nm, car_off_id, car_off_nm, pos, emp_id, emp_nm){
		var fm = document.form1;
	<%if(mode.equals("cng")){%>
		opener.document.form1.emp_id.value = emp_id;
		opener.document.form1.name.value = emp_nm;
	<%}else{%>
		if(fm.gubun2.value == 'BUS'){
			opener.form1.emp_car_comp_id.value = car_comp_id;
			opener.form1.emp_car_off_id.value = car_off_id;
			opener.form1.emp_id.value = emp_id;						
			opener.form1.emp_nm.value = car_comp_nm+ ' '+car_off_nm+' '+pos+' '+emp_nm;
		}else{
			opener.form1.dlv_car_comp_id.value = car_comp_id;
			opener.form1.dlv_car_off_id.value = car_off_id;
			opener.form1.dlv_id.value = emp_id;						
			opener.form1.dlv_nm.value = car_comp_nm+ ' '+car_off_nm+' '+pos+' '+emp_nm;
		}
	<%}%>		
		window.close();
	}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.gu_nm.focus();">
<form name='form1' action='./s_commi.jsp' method='post'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr> 
      <td align='left' colspan="2"><font color="#666600">- 자동차영업사원 조회 -</font></td>
    </tr>
    <tr> 
      <td align='left'> <select name="gubun" onChange="javascript:cng_input();">
          <option value="name" <% if(gubun.equals("name")||gubun.equals("")) out.print("selected"); %>>성명</option>
          <option value="car_comp" <% if(gubun.equals("car_comp")) out.print("selected"); %>>자동차회사</option>
          <option value="car_off" <% if(gubun.equals("car_off")) out.print("selected"); %>>지점</option>
          <option value="car_off_nm" <% if(gubun.equals("car_off_nm")) out.print("selected"); %>>대리점</option>
          <option value="emp_m_tel" <% if(gubun.equals("emp_m_tel")) out.print("selected"); %>>핸드폰</option>
        </select> <input type="text" class="text" name="gu_nm" size="15" value="<%= gu_nm %>"  onKeyDown='javascript:enter()' style='IME-MODE: active'> 
        <a href="javascript:SearchCarOffP()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="검색"></a> 
      </td>
      <td width="14%" align='right'><a href="javascript:car_emp_reg()" onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0" alt="등록"></a></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="10%">연번</td>
            <td class='title' width="25%">제조사</td>
            <td class='title' width="25%">지점/대리점명</td>
            <td class='title' width="20%">성명</td>
            <td class='title' width="20%">연락처</td>
          </tr>
        </table></td>
    </tr>
  </table>
<table width="520" border="0" cellspacing="0" cellpadding="0" >
  <tr> 
    <td><iframe src="./s_commi_in.jsp?gubun=<%=gubun%>&gu_nm=<%=gu_nm%>" name="inner" width="520" height="190" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
  </tr>
  <tr> 
    <td><table width="500" border="0" cellspacing="1" cellpadding="1">
        <tr> 
          <td><div align="right">
              <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt=""></a></div></td>
        </tr>
      </table></td>
  </tr>

</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>