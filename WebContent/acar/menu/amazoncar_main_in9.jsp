<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.incom.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	a_bean = oad.getAncLastBean();
	
	Vector vt =  a_db.getIncomListChk("2", "Y", "1", "", "");
	int incom_size = vt.size();
	
	String value[] = new String[2];	
	
	//최대5개
	if(incom_size > 5) incom_size=5;
%>

<!--미입금확인-->

<html>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
a:link { text-decoration: none;}
</style>
<script language='javascript'>
<!--
//-->
</script>
</HEAD>
<BODY topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<center>
<table border=0 cellspacing=0 cellpadding=0 width=500>
<%	for(int i = 0 ; i < incom_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("BANK_NM")),":");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
%>

   	<tr>
    	<td><img src=/acar/images/main_dot.gif align=absmiddle>&nbsp;
		  <a  href="javascript:parent.MM_openBrWindow('/fms2/account/unconfirm_reply.jsp?auth_rw=<%=auth_rw%>&incom_dt=<%=ht.get("INCOM_DT")%>&incom_seq=<%=ht.get("INCOM_SEQ")%>&incom_amt=<%=ht.get("INCOM_AMT")%>','Reply','scrollbars=no,status=yes,resizable=yes,width=450,height=220,left=50, top=50')">
		  <!--거래일자--><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%>&nbsp;
		  <!--적요--><%=Util.subData(String.valueOf(ht.get("REMARK")), 15)%>&nbsp;
		  <!--금액--><%=Util.parseDecimal(String.valueOf(ht.get("INCOM_AMT")))%>
		  <!--오늘등록분 new-->
		  <%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>
		  &nbsp;
		  <font color="Fuchsia" size="1">
		  <b>New</b>
		  </font>
		  <%}%>
		</a>
		</td>
   	</tr>
<%	}%>
</table>
</center>
</body>
</html>


