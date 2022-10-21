<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//납품관리 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(m_id, l_cd);	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		if(fm.dlv_est_dt.value != '' && fm.dlv_est_h.value == '') 		fm.dlv_est_h.value = '00';		
		if(fm.reg_est_dt.value != '' && fm.reg_est_h.value == '') 		fm.reg_est_h.value = '00';		
		if(fm.rent_est_dt.value != '' && fm.rent_est_h.value == '') 	fm.rent_est_h.value = '00';						
		fm.action='view_est_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
    <table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td> <font color="red">[ 납품관리 ]</font></td>
      </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
      <tr> 
        <td class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class='title' width='80'>계약번호</td>
              <td width='150'><%=l_cd%></td>
              <td class='title' width='80'>상호</td>
              <td width='260'><%=est.get("FIRM_NM")%></td>
            </tr>
            <tr> 
              <td class='title' width='80'>차량번호</td>
              <td width='150'><%=est.get("CAR_NO")%></td>
              <td class='title' width='80'>차명</td>
              <td width='260'><%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr> 
        <td>&nbsp; </td>
      </tr>
      <tr> 
        <td class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class='title' width='80'>구분</td>
              <td class='title' width='200'>예정일시</td>
              <td class='title' width='200'>실시일</td>
              <td class='title' width='90'>비고</td>
            </tr>
            <tr> 
              <td width='80' align="center">출고</td>
              <td width='200' align="center"> <input type='text' size='11' name='dlv_est_dt' class='text' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>'  <%if(!base.getDlv_dt().equals("")||!car.getCar_amt_dt().equals("")||!car.getCar_tax_dt().equals("")){%>readonly<%}%> onBlur='javascript:this.value=ChangeDate(this.value)'> 
                &nbsp; <input type='text' size='2' name='dlv_est_h' class='text' value='<%=String.valueOf(est.get("DLV_EST_H"))%>' <%if(!base.getDlv_dt().equals("")||!car.getCar_amt_dt().equals("")||!car.getCar_tax_dt().equals("")){%>readonly<%}%> >
                시 </td>
              <td width='200' align="center"><%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
              <td width='90' align="center">출고일자</td>
            </tr>
            <tr> 
              <td width='80' align="center">등록</td>
              <td width='200' align="center"> <input type='text' size='11' name='reg_est_dt' class='text' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                &nbsp; <input type='text' size='2' name='reg_est_h' class='text' value='<%=String.valueOf(est.get("REG_EST_H"))%>'>
                시 </td>
              <td width='200' align="center"><%=AddUtil.ChangeDate2(String.valueOf(est.get("INIT_REG_DT")))%></td>
              <td width='90' align="center">최초등록일</td>
            </tr>
            <tr> 
              <td width='80' align="center">납품</td>
              <td width='200' align="center"> <input type='text' size='11' name='rent_est_dt' class='text' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                &nbsp; <input type='text' size='2' name='rent_est_h' class='text' value='<%=String.valueOf(est.get("RENT_EST_H"))%>'>
                시 </td>
              <td width='200' align="center"><%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_START_DT")))%></td>
              <td width='90' align="center">대여개시일</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr> 
        <td align="right">&nbsp;</td>
      </tr>
      <tr>
        <td align="right">
		<a href='javascript:update()' onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      </tr>
    </table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
