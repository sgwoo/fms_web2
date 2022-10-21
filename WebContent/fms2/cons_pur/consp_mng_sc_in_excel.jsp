<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=consp_mng_sc_in_excel.xls");
%>

<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentPurMngList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<% int col_cnt = 14;%>
<table border="0" cellspacing="0" cellpadding="0" width='1480'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 배달탁송 의뢰 리스트 (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	 
<table border="1" cellspacing="0" cellpadding="0" width='1480'>
                <tr> 
                    <td width='30' align='center' style="font-size : 8pt;">연번</td>                    
                    <td width='100' align='center' style="font-size : 8pt;">제조사</td>
                    <td width='100' align='center' style="font-size : 8pt;">계출번호</td>
                    <td width='100' align='center' style="font-size : 8pt;">차종</td>
                    <td width="100" align='center' style="font-size : 8pt;">출고예정일자</td>        	    
                    <td width='100' align='center' style="font-size : 8pt;">출고사무소</td>
        	    <td width="100" align='center' style="font-size : 8pt;">탁송지점</td>
        	    <td width="150" align='center' style="font-size : 8pt;">배달지</td>
        	    <td width="100" align='center' style="font-size : 8pt;">탁송료(vat포함)</td>		  
        	    <td width="100" align='center' style="font-size : 8pt;">판매지점</td>
        	    <td width="100" align='center' style="font-size : 8pt;">담당자</td>		  
        	    <td width='100' align='center' style="font-size : 8pt;">연락처</td>
        	    <td width='100' align='center' style="font-size : 8pt;">확정여부</td>
        	    <td width='100' align='center' style="font-size : 8pt;">등록일시</td>
        	    <td width='100' align='center' style="font-size : 8pt;">출고대리인</td>
        	</tr>
            	<%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td align='center' style="font-size : 8pt;"><%=i+1%></td>                    
                    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_COMP_NM")%></td>
                    <td align='center' style="font-size : 8pt;"><%=ht.get("RPT_NO")%></td>
                    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%></td>
                    <td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DLV_EST_DT")))%></td>        	    
                    <td align='center' style="font-size : 8pt;"><%=ht.get("DLV_EXT")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("UDT_ST_NM")%></td>					
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("UDT_FIRM")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT1")))%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_OFF_NM")%></td>                    
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("EMP_NM")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("EMP_TEL")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("SETTLE_ST")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("REG_DT")%></td>
        	    <td align='center' style="font-size : 8pt;"><%=ht.get("DRIVER_NM")%></td>	        		            	    
                </tr>
		<%	}%>
</table>  
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
