<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	String year = st_dt+end_dt;
	
	//�����۾�������
	Vector fee_scd = ScdMngDb.getFeeScdStopTax(s_br, year);
	int fee_scd_size = fee_scd.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//�̹���Ǽ� ����
	function issue(reg_yn, print_st, req_dt, rent_l_cd){
		var fm = document.form1;
  	fm.gubun1.value = "1";
  	fm.st_dt.value = req_dt;
  	fm.end_dt.value = req_dt;
  	fm.s_kd.value = "2";
  	fm.t_wd1.value = rent_l_cd;
		if(print_st == '���Ǻ�'){
	  	fm.action = '/tax/issue_1/issue_1_frame.jsp';
		}else{
	  	fm.action = '/tax/issue_2/issue_2_frame.jsp';
		}
 		fm.target = 'd_content';
 		fm.submit();
	}
	
	//��꼭�Ͻ���������
	function FeeScdStop(m_id, l_cd, seq){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.seq.value = seq;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=750, height=600, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='fee_scd_size' value='<%=fee_scd_size%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='mode' value='view'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='5%' class='title'>����</td>
            <td width='7%' class='title'>��������</td>
            <td width='13%' class='title'>��ȣ</td>
            <td width='10%' class='title'>������ȣ</td>
            <td width='5%' class='title'>ȸ��</td>
            <td width='8%' class='title'>�Աݿ�����</td>			
            <td width='8%' class='title'>���࿹����</td>
            <td width='9%' class='title'>���ް�</td>
            <td width='8%' class='title'>�ΰ���</td>
            <td width='9%' class='title'>�հ�</td>
            <td class='title'>��������</td>
          </tr>
<%		for(int i = 0 ; i < fee_scd_size ; i++){
			Hashtable ht = (Hashtable)fee_scd.elementAt(i);%>						  
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:FeeScdStop('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("STOP_SEQ")%>')"><%=ht.get("STOP_ST")%></td>
            <td align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
            <td align="center"><%=ht.get("CAR_NO")%></td>
            <td align="center"><%=ht.get("FEE_TM")%>ȸ</td>			
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
<!--            <td align="center"><a href="javascript:issue('N','<%=ht.get("PRINT_ST")%>','<%=ht.get("REQ_DT")%>','<%=ht.get("RENT_L_CD")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></a></td>-->
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>			
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>��&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;</td>
            <td align="center"><%=ht.get("STOP_CAU")%></td>
          </tr>
<%		}%>	
<% 		if(fee_scd_size == 0){%>
		<tr>
		  <td colspan="11" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
		</tr>
<% 		}%>					  
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>
