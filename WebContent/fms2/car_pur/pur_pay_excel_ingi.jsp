<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=pur_pay_excel_ingi.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");

String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

//chrome ���� 
String height = request.getParameter("height")==null?"":request.getParameter("height");

Vector vt = d_db.getCarPurPayDocList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
int vt_size = vt.size();

int count = 0;

%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<% int col_cnt = 9;%>
<table border="0" cellspacing="0" cellpadding="0" width='870'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(��)�Ƹ���ī ����û�� ����Ʈ</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='870'>
            <tr> 
                    <td width='50' class='title'>����</td>
                    <td width='70' class='title'>����</td>
                    <td width='110' class='title'>�����ȣ</td>
                    <td width='170' class='title'>��</td>
                    <td width="70" class='title'>���ʿ���</td>                    
                    <td width="180" class='title'>����</td>
                    <td width='100' class='title'>�������</td>
                    <td width="70" class='title'>�뿩�Ⱓ</td>
                    <td width="50" class='title'>���</td>        	    
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				if(String.valueOf(ht.get("CAR_GU")).equals("�߰���")){ continue; }
    				
    				count++;
    		%>
            <tr> 
                    <td align='center'><%=count%></td>  
                    <td align='center'><%=ht.get("BIT")%></td>                             
                    <td align='center'><%=ht.get("RPT_NO")%></td>                    
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("USER_NM")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>                                            	   
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DLV_EST_DT")))%></td>
                    <td align='center'><%=ht.get("CON_MON")%></td>                
                    <td align='center'>&nbsp;</td>                
    		</tr>
    		<%	}%>
</table>
</form>
</body>
</html>
