<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pur_dlv_sc_in_excel.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.car_office.* "%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

	
	int count =0;
	
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
			
	Vector vt = umd.getPurComDlvList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="http://fms1.amazoncar.co.kr/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<% int col_cnt = 27;%>
<table border="0" cellspacing="0" cellpadding="0" width='2360'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(��)�Ƹ���ī �ڵ�����ǰ Ȯ����Ȳ ����Ʈ (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='2360'>
                <tr> 
                    <td width='30' class='title'>����</td>
                    <td width='30' class='title'>����</td>
                    <td width='100' class='title'>Ư�ǰ���ȣ</td>
                    <td width='75' class='title'>�������</td>        	    
                    <td width="75" class='title'>��������</td>       		
                    <td width="75" class='title'>�������</td>
                    <td width="75" class='title'>���������</td>
        	    <td width="100" class='title'>ī����</td>
        	    <td width="150" class='title'>ī���ȣ</td>		  
        	    <td width="80" class='title'>��ȿ�Ⱓ</td>		          	    
        	    <td width='100' class='title'>ī�����ݾ�</td>
        	    <td width="100" class='title'>������</td>
        	    <td width='100' class='title'>������</td> 
                    <td width='150' class='title'>����</td> 
        	    <td width="150" class='title'>���û��</td>
        	    <td width="100" class='title'>����</td>		  
        	    <td width='60' class='title'>�μ���</td>
        	    <td width="70" class='title'>��������</td>		
        	    <td width='80' class='title'>��������</td>
        	    <td width='80' class='title'>DC�ݾ�</td>        	    
        	    <td width='80' class='title'>Ź�۷�</td>        	    
        	    <td width='80' class='title'>�����ݾ�</td>        	            	            	            	    
        	    <td width='100' class='title'>�����</td>
        	    <td width='70' class='title'>���ʿ�����</td>
        	    <td width='50' class='title'>�����</td>
        	    <td width='200' class='title'>���븮��</td>
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    			Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='30' align='center'><%=i+1%></td>                    
                    <td width='30' align='center'><%=ht.get("USE_YN_ST")%></td>                    
                    <td width='100' align='center'><%=ht.get("COM_CON_NO")%></td>
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_REG_DT")))%></td>        	    
                    <td width='75' align='center'><%=ht.get("DLV_ST_NM")%></td>                
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>                	    	        		    	        		    
                    <td width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%></td>                
        	    <td width='100' align='center'><%=ht.get("CARD_KIND1")%><%if(!String.valueOf(ht.get("CARD_DT4")).equals("�� ��")){%><br><%=ht.get("CARD_KIND2")%><%}%></td>					
        	    <td width='150' align='center'> <%=ht.get("CARDNO1")%>   <%if(!String.valueOf(ht.get("CARD_DT4")).equals("�� ��")){%><br> <%=AddUtil.ChangeCard(String.valueOf(ht.get("CARDNO2")))%><%}%></td>
        	    <td width='80' align='center'><%=ht.get("CARD_DT2")%>   <%if(!String.valueOf(ht.get("CARD_DT4")).equals("�� ��")){%><br><%=ht.get("CARD_DT4")%><%}%></td>
        	    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%><%if(!String.valueOf(ht.get("CARD_DT4")).equals("�� ��")){%><br><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%><%}%></td>
        	    <td width='100' align='center'><%=ht.get("CAR_COMP_NM")%></td>
        	    <td align='center'><%=ht.get("CAR_OFF_NM")%></td>
                    <td width='150' align='center'><%=ht.get("R_CAR_NM")%></td>        	            	    
        	    <td width='150' align='center'><%=ht.get("R_OPT")%></td>					
        	    <td width='100' align='center'><%=ht.get("R_COLO")%></td>
        	    <td width='60' align='center'><%=ht.get("UDT_ST_NM")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("PURC_GU")%></td>
        	    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_CAR_F_AMT")))%></td>        	    
        	    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_DC_AMT")))%></td>        	    
        	    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>        	    
        	    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_CAR_G_AMT2")))%></td>        	                        
        	    <td width='100' align='center'><%=ht.get("PUR_COM_FIRM")%></td>				
        	    <td width='70' align='center'><%=ht.get("BUS_NM")%></td>
        	    <td width='50' align='center'><%=ht.get("DLV_EXT")%></td>
        	    <td width='200' align='center'><%=ht.get("OFF_NM")%><br>
        	        <%if(!String.valueOf(ht.get("DRIVER_NM")).equals("")){%>
        	        <%=ht.get("DRIVER_NM")%>(<%=ht.get("DRIVER_SSN")%>)<br><%=ht.get("DRIVER_M_TEL")%>
        	        <%}else{
        	        	//���븮��
				Hashtable cons_man = cs_db.getConsignmentPurMan(String.valueOf(ht.get("CAR_COMP_ID")), String.valueOf(ht.get("DLV_EXT")), String.valueOf(ht.get("OFF_ID")));
        	        %>
        	        <%=cons_man.get("MAN_NM")%>(<%=cons_man.get("MAN_SSN")%>)<br><%=cons_man.get("MAN_TEL")%> 
        	        <%}%>
        	    </td>
                </tr>
<%		}	%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

