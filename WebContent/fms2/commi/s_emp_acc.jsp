<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bill_mng.*, card.*, acar.cont.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String emp_id 		= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	Vector vt = d_db.getCommiEmpAccList(emp_id);
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Disp(emp_acc_nm, rel, rec_incom_yn, rec_incom_st, emp_bank, emp_acc_no, rec_ssn, rec_zip, rec_addr, file_name1, file_name2, file_gubun1, file_gubun2){
		var fm = document.form1;
		opener.form1.emp_acc_nm.value 		= emp_acc_nm;
		opener.form1.rel.value 				= rel;
		opener.form1.rec_incom_yn.value 	= rec_incom_yn;	
		opener.form1.rec_incom_st.value 	= rec_incom_st;
		opener.form1.emp_bank.value 		= emp_bank;
		opener.form1.emp_acc_no.value 		= emp_acc_no;	
		opener.form1.rec_ssn.value 			= rec_ssn;	
		opener.form1.t_zip.value 			= rec_zip;
		opener.form1.t_addr.value 			= rec_addr;
		opener.form1.s_file_name1.value 	= file_name1;	
		opener.form1.s_file_name2.value 	= file_name2;	
		opener.form1.s_file_gubun1.value 	= file_gubun1;	
		opener.form1.s_file_gubun2.value 	= file_gubun2;									
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="5%">연번</td>
                    <td class=title width="10%">지급일자</td>					
                    <td class=title width="10%">실수령인</td>										
                    <td class=title width="20%">생년월일</td>
                    <td class=title width="20%">계좌번호</td>
                    <td class=title width="35%">주소</td>		  
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("SUP_DT")%></td>		  		  					
                    <td><a href="javascript:Disp('<%=ht.get("EMP_ACC_NM")%>','<%=ht.get("REL")%>','<%=ht.get("REC_INCOM_YN")%>','<%=ht.get("REC_INCOM_ST")%>','<%=ht.get("EMP_BANK")%>','<%=ht.get("EMP_ACC_NO")%>','<%=ht.get("REC_SSN")%>','<%=ht.get("REC_ZIP")%>','<%=ht.get("REC_ADDR")%>','<%=ht.get("FILE_NAME1")%>','<%=ht.get("FILE_NAME2")%>','<%=ht.get("FILE_GUBUN1")%>','<%=ht.get("FILE_GUBUN2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("EMP_ACC_NM")%></a></td>		  		  										
                    <td><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("REC_SSN")))%></td>		  		  
                    <td><%=ht.get("EMP_BANK")%> <%=ht.get("EMP_ACC_NO")%></td>
                    <td><%=ht.get("REC_ADDR")%></td>
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr> 
        <td align="center"><a href="javascript:window.close();" class="btn"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>