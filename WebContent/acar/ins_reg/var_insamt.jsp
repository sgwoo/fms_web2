<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String brch = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	
	//계산식 변수
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSikVarBean [] ea_r = e_db.getEstiSikVarList("ins_reg_amt");
	int size = ea_r.length;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function var_update(idx){
		var fm = document.form1;	
		if(fm.u_var_sik[idx].value == ''){ alert("변수값을 확인하십시오."); fm.u_var_sik[idx].focus(); return; }
		fm.var_cd.value = fm.u_var_cd[idx].value;				
		fm.var_sik.value = fm.u_var_sik[idx].value;						
		if(!confirm('수정하시겠습니까?'))	return;
		fm.target='i_no';
		fm.submit();		
	}			
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./var_insamt_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=brch%>'>
<input type="hidden" name="cmd" value="u">
<input type="hidden" name="size" value="<%=size%>">
<input type="hidden" name="a_a" value="1">
<input type="hidden" name="seq" value="01">
<input type="hidden" name="var_cd" value="">
<input type="hidden" name="var_sik" value="">
<table border=0 cellspacing=0 cellpadding=0 width="600">
  <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>보험등록 > <span class=style5>변수관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>                    
            <table border="0" cellspacing="1" cellpadding="0" width="600">
                <tr> 
                    <td width="110" class=title>변수코드</td>
                    <td width="220" class=title>변수명</td>
                    <td class=title width="160">변수값</td>
                    <td width="110" class=title>처리</td>
                </tr>
          <%
		  int cnt = -1;
		  for(int i=0; i<size; i++){
			bean = ea_r[i];
			String var_sik = AddUtil.parseDecimal(bean.getVar_sik());
			cnt++;
			%>
                <tr> 
                    <input type="hidden" name="u_var_cd" value="<%=bean.getVar_cd()%>">
                    <td align=center><%=bean.getVar_cd()%></td>
                    <td align=center><%=bean.getVar_nm()%></td>
                    <td align=center><input type="text" name="u_var_sik" size="10" class="num" value="<%=var_sik%>">
                      </td>
                    <td align="center"> 
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:var_update(<%=cnt%>);"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%	}%>
                    </td>
                </tr>
            <%}%>
            </table>
        </td>
    </tr>
    <tr>    	
        <td align="right"><a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>