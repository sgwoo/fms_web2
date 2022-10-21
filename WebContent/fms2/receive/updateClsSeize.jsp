<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.receive.*"%>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		//추심정보
	ClsBandBean cls_band = rc_db.getClsBandInfo(rent_mng_id, rent_l_cd);	
				
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	
			
	//등록
	function doc_reg(gubun){
		var fm = document.form1;
				
		if(fm.seize_dt.value == '')	{ alert('압류일자를 입력하십시오.'); 	return; }		
		 if( toInt(parseDigit(fm.seize_amt.value)) < 1 ) { 	 alert('압류비용을 입력하십시오'); 		fm.seize_amt.focus(); 		return;	}		
		 
		if(!confirm('수정하시겠습니까?')){	return;	}
		
		fm.action = "updateClsSeize_a.jsp?cmd="+gubun;
		fm.target = "i_no";
		fm.submit()
		
	}
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > 채권추심관리 > <span class=style5>압류 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	 
	 	  <tr> 
            <td class='title'>압류일</td>
            <td>&nbsp;&nbsp;<input type="text" name="seize_dt" value="<%=AddUtil.ChangeDate2(cls_band.getSeize_dt())%>" size="11" class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
          </tr>
          <tr> 
            <td class='title'>압류비용</td>
            <td>&nbsp;&nbsp;<input type="text" name="seize_amt" value="<%=AddUtil.parseDecimal(cls_band.getSeize_amt())%>" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value); '></td>
          </tr>

        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
		
    <tr>
      <td align="right">	
	  <a href='javascript:doc_reg(1)' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
	  &nbsp;&nbsp;&nbsp;<a href='javascript:doc_reg(2)' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
	   
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
