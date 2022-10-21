<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_card_tax_excel.xls");
%>

<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="ic_db" scope="page" class="acar.incom.IncomDatabase" />
<%@ include file="/acar/cookies.jsp" %>

<%  String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun0 	= request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	
	int count =0;
	
	long gtotal_amt = 0;	
	long grtotal_amt = 0;	
	long gitotal_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector vt = ic_db.getCardPayList( gubun0,  gubun2, gubun3, st_mon);		
	int vt_size = vt.size();
	
	long total_amt =0;
	long tax_amt =0;
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
</head>

<body>

<table border="1" cellspacing="0" cellpadding="0" width=1200>
  <tr> 
    <td colspan="25" align="left"><font face="����" size="4" > 
      <b>�ſ�ī����⳻�� : <%=gubun0%>��  <%=gubun2%> �б�</b> </font></td>
  </tr>
  
  <tr align="center"> 
   
   		 <td width="4%" class='title'>����</td>   
        <td width="10%" class='title'>�ŷ�����</td>   
        <td width='15%' class='title'>ī���</td>
        <td width="10%" class='title'>�Աݾ�</td>   
 		  <td width="12%" class='title'>�����/�ֹι�ȣ</td>	
		  <td width="19%" class='title'>��</td>	
		  <td width="22%" class='title'>����</td>
		  <td width="8%" class='title'>���������</td>   	
   </tr>
  <%
  
   		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);	
		
		%>		
			
 	 <tr> 
   			<td width='14%' align='center'><%=i+1%></td>
              <td width='20%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
              <td width='25%' align='center'><%=ht.get("CARD_NM")%></td> 
              <td width='17%' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></td>
              <td width='18%' align='center'><%=String.valueOf(ht.get("REGNO"))%>&nbsp;</td>		        		
      		  <td width='30%' align='center'><%=ht.get("FIRM_NM")%></td>		
      		  <td width='34%' align='left'><span title='<%=ht.get("CARD_DOC_CONT")%>'><%=Util.subData(String.valueOf(ht.get("CARD_DOC_CONT")), 34)%></span></td>			
      		  <td width='18%' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TAX_AMT")))%></td>   
      
 	 </tr>
 <%		
                total_amt  = total_amt  + Long.parseLong(String.valueOf(ht.get("INCOM_AMT")));    
            	tax_amt  = tax_amt  + Long.parseLong(String.valueOf(ht.get("TAX_AMT")));
        
       			 }	%>
  
     <tr>
              <td class="title" align='center' colspan=3>�հ�</td>
              <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
              <td class="title" align='center' colspan=3></td>
              <td class="title" style='text-align:right'><%=Util.parseDecimal(tax_amt)%></td>                  
      </tr>			

</table>
</body>
</html>
