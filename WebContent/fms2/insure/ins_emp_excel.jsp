<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=ins_emp_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");


	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	
	Vector vt = ie_db.getInsComempNotStatList3(s_kd, t_wd, gubun1, gubun2,st_dt,end_dt);
	int vt_size = vt.size();

%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='800'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>������ �����û��</b></td>
    </tr>
    <tr>
        <td align='right'>�ѰǼ� : <%=vt_size%>��</td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">�ͻ�� ü���� ��� �ڵ��� ���� û�༭�� ���ʼ���(���γ���)�� �Ͽ��� �ϳ� �ε����� ������ ���Ͽ� �ϱ�ǿ� ���ؼ��� ��Ȯ�μ��� ��ü�ϰ����մϴ�.</td>
    </tr>    
    <tr> 
      <td height="10" align='center'></td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">�ͻ�� ü���� �ڵ��� ���� û�༭ ���� ��� ������ �����ϸ� Ư�� �ϱ� ���ǿ� ���Ͽ� �ٽ��ѹ� Ȯ���ϸ� ��� ���ǵ� �������� ���� ���� Ȯ���մϴ�.</td>
    </tr>    
    <tr>
	<td>&nbsp;</td>
    </tr>           
    <tr>
	<td align='right' height="50" style="font-size : 15pt;">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
	        <tr>
	            <td width='860' >&nbsp;</td>
	            <td width='100' valign="top" >�ǰ����� : </td>
	            <td width='300' >����� �������� �ǻ���� 8,<br>
	                             802ȣ (���ǵ���, ����̾ؾ�����)<br><br>
	                             <span class=style6>(��)�Ƹ���ī ��ǥ�̻� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;��
	            </td>
	            <td width='80' ><img src="/acar/images/stamp.png" width="75" height="75"></td>
	        </tr>
	    </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>           
    <tr> 
        <td class=title> 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='100' class='title'>����</td>		
                    <td width='100' class='title'>������ȣ</td>				
                    <td width='100' class='title'>���ǹ�ȣ</td>
                    <td width='100' class='title'>��ȣ��</td>
                    <td width='100' class='title'>����</td>
                    <td width='100' class='title'>����ڹ�ȣ</td>
                    <td width='100' class='title'>���������</td>					
                    <td width='100' class='title'>���踸����</td>
                    <td width='100' class='title'>�輭�׸��</td>
                    <td width='100' class='title'>������</td>
                    <td width='100' class='title'>������</td>					
                </tr>			
           </table>
        </td>
    </tr>
    <%if(vt.size() > 0 ){%>
	            <tr>
                    <td width=530 class='' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <% for(int i=0; i< vt.size(); i++){
					Hashtable car = (Hashtable)vt.elementAt(i); %>
                            <tr> 			
                            	<td width='100' align='center'><%=i+1%></td>					
                        		<td width='100' align='center'><%=car.get("CAR_NO")%></td>
                        		<td width='100' align='center'><%=car.get("INS_CON_NO")%></td>
                        		<td width='100' align='left'>&nbsp;<%=car.get("FIRM_NM")%></td>
                        		<td width='100' align='center'><%=car.get("CAR_NM")%></td>                            
                           	<td width='100' align='left'>&nbsp;<%=car.get("ENP_NO")%></td>
                            <td width='100' align='center'><%=car.get("INS_START_DT")%></td>	
				              <td width='100' align='center'><%=car.get("INS_EXP_DT")%></td>
				              	 <td width='100' align='center'>������</td>
				               <td width='100' align='center'><%=car.get("INS_COM_EMP_YN")%></td>
				              <td width='100' align='center'><%=car.get("CONT_COM_EMP_YN")%></td>	
				                   
                           	
                            </tr>
                <%}%>
                            <tr> 
                                <td class='title' colspan='11'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                  	            </tr>
<%}else{%>
	            <tr>
	                <td width=200 class='line' id='td_con' style='position:relative;'> 
	                    <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=600> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ش� ������ �����ϴ�.</td>
                            </tr>          
                        </table>
		            </td>
	            </tr>
<%}%>		
            </table>
        </td>
    </tr>
</table>
</body>
</html>
