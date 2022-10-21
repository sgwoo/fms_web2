<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = d_db.getCarPurReqCardList();
	int vt_size = vt.size();
	
	long total_amt1	= 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=950>
    <tr>
      <td>&lt; 계약금카드결재 당일요청리스트 &gt; </td>
    </tr>  
    <tr>
      <td></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width='50' class='title'>연번</td>
			<td width='120' class='title'>계약번호</td>
		    <td width="200" class='title'>고객</td>
		    <td width="140" class='title'>출고영업소</td>
		    <td width='120' class='title'>계출번호</td>		    					
       		<td width='70' class='title'>계약금</td>
			<td width='80' class='title'>지출예정일</td>
			<td width="100" class='title'>지출요청일</td>
			<td width="70" class='title'>최초영업자</td>			
		  </tr>		
		  <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
		  %>
		  <tr>
			<td align='center'><%=i+1%></td>
			<td align='center'><%=ht.get("RENT_L_CD")%></td>
			<td align='center'><%=ht.get("FIRM_NM")%></td>
			<td align='center'><%=ht.get("DLV_BRCH")%></td>
		    <td align='center'><%=ht.get("RPT_NO")%><%if(String.valueOf(ht.get("RPT_NO")).equals("")){ %><%=ht.get("COM_CON_NO")%><%} %></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%></td>
			<td align='center'><%=ht.get("CON_EST_DT")%></td>		
			<td align='center'><%=ht.get("CON_AMT_PAY_REQ")%></td>
			<td align='center'><%=ht.get("USER_NM")%></td>
		  </tr>
		  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CON_AMT")));
		 		}%>
		  <tr>
		    <td colspan="5" class=title>합계</td>		    		
			<td class='title_num'><%=Util.parseDecimal(total_amt1)%></td>
			<td colspan="3" class=title>&nbsp;</td>												
		  </tr>
		</table>
	  </td>
    </tr>
	<tr>
		<td align="right">
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true">닫기</a>
		</td>	
	</tr>				  
  </table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
