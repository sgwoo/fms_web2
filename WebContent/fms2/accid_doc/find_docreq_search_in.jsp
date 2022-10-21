<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = "";
	
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String r_gov_id = request.getParameter("r_gov_id")==null?"":request.getParameter("r_gov_id");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String st_dt = request.getParameter("st_dt")==null?Util.getDate():request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?Util.getDate():request.getParameter("end_dt");
	
	Vector settles = s_db.getInsurHDocReqSearchList("", "", st_dt, end_dt, "1", "");
	int settle_size = settles.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='r_gov_id' value='<%=r_gov_id%>'>
<input type='hidden' name='settle_size' value='<%=settle_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	  <tr> 
            	    <td class='title' width=4%> 연번</td>
					<td class='title' width="5%">선택</td>
		            <td class='title' width="9%">차량번호</td>
		            <td class='title' width="15%">보험사</td>
		            <td class='title' width="8%">사고구분</td>
		            <td class='title' width="9%">사고일자</td>
		            <td class='title' width="12%">대차기간</td>					
		            <td class='title' width="10%">대차일수</td>
		            <td class='title' width="9%">청구일자</td>						
		            <td class='title' width="10%">청구액</td>									
		            <td class='title' width="9%">청구요청일</td>												
		          </tr>
          
                </tr>
        <%	for (int i = 0 ; i < settle_size ; i++){
				Hashtable settle = (Hashtable)settles.elementAt(i);%>
		  
                <tr align="center"> 
                    <td><%=i+1%></td>
					<td> 
                      <input type="checkbox" name="cho_id" value="<%=settle.get("ACCID_ID")%>^<%=settle.get("SEQ_NO")%>^<%=settle.get("CAR_MNG_ID")%>^<%=r_gov_id%>^<%=i%>^">
					  <input type='hidden' name='ins_com_id' 	value='<%=settle.get("INS_COM_ID")%>'>
					  <input type='hidden' name='ins_com' 		value='<%=settle.get("INS_COM")%>'>
					  <input type='hidden' name='ins_f_com' 	value='<%=settle.get("INS_F_COM")%>'>
					  <input type='hidden' name='ins_nm' 		value='<%=settle.get("INS_NM")%>'>
					  <input type='hidden' name='ins_addr' 		value='<%=settle.get("INS_ADDR")%>'>
					  <input type='hidden' name='ins_zip' 		value='<%=settle.get("ZIP")%>'>
					  <input type='hidden' name='ins_app_docs'	value='<%=settle.get("APP_DOCS")%>'>
					  <input type='hidden' name='ins_bus_id2'	value='<%=settle.get("BUS_ID2")%>'>
                    </td>
                    <td align='center'><%=settle.get("CAR_NO")%></td>
			        <td align='center'><a href="javascript:parent.search_dir_ok('<%=settle.get("ACCID_ID")%>^<%=settle.get("SEQ_NO")%>^<%=settle.get("CAR_MNG_ID")%>^<%=r_gov_id%>^<%=i%>^', '<%=settle.get("INS_COM_ID")%>','<%=settle.get("INS_COM")%>','<%=settle.get("INS_F_COM")%>','<%=settle.get("INS_NM")%>','<%=settle.get("INS_ADDR")%>','<%=settle.get("ZIP")%>','<%=settle.get("APP_DOCS")%>','<%=settle.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true"><%=settle.get("INS_COM")%></a></td>
			        <td align='center'><%=settle.get("ACCID_ST")%></td>
			        <td align='center'><%=settle.get("ACCID_DT")%></td>			
			        <td align='center'><%=settle.get("USE_ST")%>~<br><%=settle.get("USE_ET")%></td>								
			        <td align='center'><%=settle.get("USE_DAY")%>일<%if(!String.valueOf(settle.get("USE_HOUR")).equals("")){%><%=settle.get("USE_HOUR")%>시간<%}%></td>								
			        <td align='center'><%=settle.get("REQ_DT")%></td>						
			        <td align='right'><%=Util.parseDecimal(String.valueOf(settle.get("REQ_AMT")))%>원</td>									
			        <td align='center'><%=settle.get("DOC_REQ_DT")%></td>												
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
