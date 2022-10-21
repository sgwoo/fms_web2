<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="bean" class="acar.ext.ScdExtPayBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--  
  //더이상 사용 안함 - 테이블 변경 
	function save(){
		
		var fm = document.form1;
		
	   if( toInt(parseDigit(fm.pay_amt.value)) < 1 ) { 	 alert('입금액을 입력하십시오'); 		fm.pay_amt.focus(); 		return;	}		
		if(confirm('등록하시겠습니까?')){			
			fm.target='i_no';
			fm.submit();
		}		
	
	}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.etc.focus();">
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
		
   String adate = AddUtil.getDate();
   		
	bean   =  ae_db.getExtPay(m_id, l_cd); 
	if ( !bean.getPay_dt().equals("") ) adate  = bean.getPay_dt();
	
%>
<form name='form1' action='scd_ext_pay_a.jsp' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<table border="0" cellspacing="0" cellpadding="0" width=400>
  <tr> 
    <td align='left'><<보증보험 >></td>
  </tr>
  <tr> 
    <td class='line' width='400'> 
      <table border="0" cellspacing="1" cellpadding="0" width=400>
      	<tr>
          <td width='200' class='title'>보증보험 입금일자</td>
          <td width="200">&nbsp;<input type="text" name="pay_dt" value="<%=adate%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>  </td>
        </tr>
        <tr> 
          <td width='200' class='title'>보증보험 입금금액</td>
          <td width="200">&nbsp;<input type="text" name="pay_amt" value="<%=Util.parseDecimal(bean.getPay_amt())%>"  size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'></td>
	</tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td align='right'>
    <% if ( bean.getRent_l_cd().equals("") ) { %>   <a href="javascript:save()">수정</a>&nbsp;&nbsp; <% } %><a href="javascript:window.close()">닫기</a></td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>