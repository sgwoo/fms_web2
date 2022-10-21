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

int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

//chrome 관련 
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
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 인지청구 리스트</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='870'>
            <tr> 
                    <td width='50' class='title'>연번</td>
                    <td width='70' class='title'>구분</td>
                    <td width='110' class='title'>계출번호</td>
                    <td width='170' class='title'>고객</td>
                    <td width="70" class='title'>최초영업</td>                    
                    <td width="180" class='title'>차명</td>
                    <td width='100' class='title'>출고예정일</td>
                    <td width="70" class='title'>대여기간</td>
                    <td width="50" class='title'>비고</td>        	    
        	</tr>
            <%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				if(String.valueOf(ht.get("CAR_GU")).equals("중고차")){ continue; }
    				
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
