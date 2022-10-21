<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function go_modify()
	{
		location='/acar/bank_mng/bank_mapping_u.jsp?lend_id='+document.form1.lend_id.value+'&car_mng_id='+document.form1.car_mng_id.value;
	}
	
	function go_list()
	{
		parent.location='/acar/bank_mng/bank_con_c.jsp?auth_rw='+document.form1.auth_rw.value+'&lend_id='+document.form1.lend_id.value;	
	}
//-->
</script>
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	
	BankMappingBean bm = new BankMappingBean();
%>
<body>
<form name="form1" method="POST">
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border=0 cellspacing=0 cellpadding=0 width=680>
    <tr>
    	<td ><font color="navy">재무관리 -> 은행대출관리 -> </font><font color="red">대출조회</font></td>
    </tr>
	<tr>
		<td align='right'>
<%
if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>	
		<a href='javascript:go_modify()';  onMouseOver="window.status=''; return true">수정화면</a>&nbsp;
<%	}
%>
		
		<a href='javascript:go_list()'; onMouseOver="window.status=''; return true">리스트로</a>
		</td>
	</tr>
   <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=680>
                
                <tr>
                    <td width='80' class=title>대출신청일</td>
                    <td width='90'>&nbsp;<%=bm.getLoan_st_dt()%></td>
                    <td width='70' class=title>공급가액</td>
                    <td width='100'>&nbsp;<%=Util.parseDecimal(bm.getSup_amt())%>원</td>
                    <td width='70' class=title>대출금액</td>
                    <td width='100'>&nbsp;<%=Util.parseDecimal(bm.getLoan_amt())%>원</td>
                    <td width='80' class=title>결제기준일</td>
                    <td width='90'>&nbsp;<%=bm.getRef_dt()%></td>
                </tr>
                <tr>
                    <td class=title>지급제시일</td>
                    <td>&nbsp;<%=bm.getSup_dt()%></td>
                    <td class=title>대출만기일</td>
                    <td>&nbsp;<%=bm.getLoan_end_dt()%></td>
                    <td class=title>선이자율</td>
                    <td>&nbsp;<%=bm.getF_rat()%>(%)</td>
                    <td class=title>선이자금액</td>
                    <td>&nbsp;<%=Util.parseDecimal(bm.getF_amt())%>원</td>
                </tr>
                <tr>
                    <td class=title>선이자기간</td>
                    <td>&nbsp;<%=bm.getF_term()%>개월</td>
                    <td class=title>일수</td>
                    <td>&nbsp;<%=bm.getDays()%>일</td>
                    <td class=title>차감입금액</td>
                    <td>&nbsp;<%=Util.parseDecimal(bm.getDif_amt())%>원</td>
                    <td class=title>대출승인일</td>
                    <td>&nbsp;<%=bm.getLoan_ack_dt()%></td>
                </tr>
                <tr>
                    <td rowspan='2' class=title>대출입금일</td>
                    <td rowspan='2' >&nbsp;<%=bm.getLoan_rec_dt()%></td>
                    <td rowspan='2'  class=title>기타</td>
                    <td rowspan='2'  align="center" colspan=5><%=Util.htmlBR(bm.getNote())%></td>
                    
                </tr>
                
            </table>
        </td>
    </tr>
    <tr>
    	<td></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=680>
            	<tr>
            		<td width='80' class=title>계약일자</td>
            		<td width='100' class=title>계약번호</td>
            		<td width='150' class=title>계약자</td>
            		<td width='200' class=title>차명</td>
            		<td width='150' class=title>차량번호</td>
            	</tr>
            	<tr>
            		<td align='center'><%=bm.getRent_dt()%></td>
            		<td align='center'><%=bm.getRent_l_cd()%></td>
            		<td align='center'><%=bm.getFirm_nm()%></td>
            		<td align='center'><%=bm.getCar_nm()%></td>
            		<td align='center'><%=bm.getCar_no()%></td>            		
            	</tr>
           </table>
		</td>
	</tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="300" height="80" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</iframe>
</html>