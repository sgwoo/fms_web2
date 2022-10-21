<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.commi_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_commi_agent_sc_in_excel.xls");
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"11":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector commis = ac_db.getCommiAgentList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int commi_size = commis.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<body>
<% int col_cnt = 12;%>
<table border="0" cellspacing="0" cellpadding="0" width='1100'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 에인전트수당 리스트</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='1100'>
                <tr> 
                    <td width='30' align='center' style="font-size : 8pt;">연번</td>                    
                    <td width='100' align='center' style="font-size : 8pt;">계약번호</td>
                    <td width='100' align='center' style="font-size : 8pt;">상호</td>
                    <td width="70" align='center' style="font-size : 8pt;">차량번호</td>        	    
                    <td width='100' align='center' style="font-size : 8pt;">차명</td>                    
                    <td width='100' align='center' style="font-size : 8pt;">대여개시일</td>
                    <td width='100' align='center' style="font-size : 8pt;">에이전트</td>                    
                    <td width='100' align='center' style="font-size : 8pt;">증빙구분</td>                    
        	    <td width="100" align='center' style="font-size : 8pt;">지급수수료</td>
        	    <td width="100" align='center' style="font-size : 8pt;">세금</td>		  
        	    <td width="100" align='center' style="font-size : 8pt;">실지급액</td>
        	    <td width="100" align='center' style="font-size : 8pt;">지급일자</td>		  
        	</tr>
            	<%	for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);%>
                <tr> 
                    <td align='center' style="font-size : 8pt;"><%=i+1%></td>                    
                    <td align='center' style="font-size : 8pt;"><%=commi.get("RENT_L_CD")%></td>
                    <td align='center' style="font-size : 8pt;"><%=commi.get("FIRM_NM")%></td>
                    <td align='center' style="font-size : 8pt;"><%=commi.get("CAR_NO")%></td>        	    
                    <td align='center' style="font-size : 8pt;"><%=commi.get("CAR_NM")%> <%=commi.get("CAR_NAME")%></td>
                    <td align='center' style="font-size : 8pt;"><%=commi.get("RENT_START_DT")%></td>
                    <td align='center' style="font-size : 8pt;"><%=commi.get("AGENT_OFF_NM")%></td>                    
        	    <td align='center' style="font-size : 8pt;"><%=commi.get("DOC_ST_NM")%></td>					
        	    <td align='right' style="font-size : 8pt;"><%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%></td>
        	    <td align='right' style="font-size : 8pt;"><%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%></td>                    
        	    <td align='right' style="font-size : 8pt;"><%=Util.parseDecimal(String.valueOf(commi.get("DIF_AMT")))%></td>
        	    <td align='center' style="font-size : 8pt;"><%=commi.get("SUP_DT")%></td>
                </tr>
		<%	}%>
</table>
</body>
</html>
