<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1		= request.getParameter("gubun1")==null?"9":request.getParameter("gubun1");
	String s_user_id	= request.getParameter("s_user_id")==null?"":request.getParameter("s_user_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"))-200;//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = ac_db.S_MoneySubList(dt, ref_dt1, ref_dt2, gubun1, s_user_id);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
	long t_amt2[] = new long[1];
	long t_amt3[] = new long[1];
	long t_amt4[] = new long[1];
	
	long oil_m_amt = 0;
	long oil_p_amt = 0;

	long pr_amt = 0;
	
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
<table border="0" cellspacing="0" cellpadding="0" width='950'>
  <tr>
	  <td > 
	    <table border="0" cellspacing="0" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>특정수당내역
			:
			<% if (gubun1.equals("9") ) { %>제안포상금 
						<% } else if (gubun1.equals("2") ) { %>영업캠페인포상
						<% } else if (gubun1.equals("1") ) { %>채권캠페인포상
						<% } else if (gubun1.equals("5") ) { %>비용캠페인포상
						<% } else if (gubun1.equals("6") ) { %>제안캠페인포상
						<% } else if (gubun1.equals("30") ) { %>1군비용캠페인포상
						<% } else if (gubun1.equals("29") ) { %>2군비용캠페인포상
						<% } %>
			</span></td>
          </tr>
        </table></td>	
  </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr id='tr_title' > 
		<td class='line' width='23%' >
			<table border=0 cellspacing=1 width=100%>
				<tr> 
					<td class='title' width='5%'>연번</td>
					<td class='title' width='10%'>예정일자</td>					
					<td class='title' width='10%'>성명</td>
					<td class='title' width='35%'>내용</td>
					<td class='title' width='8%'>포상금</td>
					<td class='title' width='8%'>유류대정산</td>
					<td class='title' width='8%'>실지급액</td>
					<td class='title' width='8%'>실지급일자</td>	
					<td class='title' width='8%'>복지비추가액</td>										
				</tr>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			oil_m_amt = 0;					
			oil_p_amt = 0;					
			pr_amt = 0;		
			
			t_amt1[0] += AddUtil.parseLong(String.valueOf(ht.get("AMT")));
			
				
			if ( AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))) < 0) {
				oil_m_amt  = AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))); 
				pr_amt  = AddUtil.parseLong(String.valueOf(ht.get("PRIZE"))); 
				t_amt2[0] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
				t_amt3[0] +=   AddUtil.parseLong(String.valueOf(ht.get("PRIZE")));
					
			} else {
				oil_p_amt  =   AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))); 
				pr_amt  = AddUtil.parseLong(String.valueOf(ht.get("AMT"))); 
				t_amt4[0] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
				t_amt3[0] +=   AddUtil.parseLong(String.valueOf(ht.get("AMT")));
			}
								
%>             	
				<tr>
            		<td align="center"><%=i+1%></td>
            		<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DT")))%></td>					
            		<td align="center"><%=ht.get("USER_NM")%></td>
            		<td>&nbsp;<%=ht.get("P_CONT")%></td>					
               		<td align="right"><%=AddUtil.parseDecimal(ht.get("AMT"))%></td>
               		<td align="right"><%=AddUtil.parseDecimal(oil_m_amt)%></td>
               		<td align="right"><%=AddUtil.parseDecimal(pr_amt)%></td>
            		<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%></td>		
            		<td align="right"><%=AddUtil.parseDecimal(oil_p_amt)%></td>								
            	</tr>
<% }	%>
			   <tr>
            		<td class=title  colspan=4 align="center">계</td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%></td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>            		
            		<td class=title>&nbsp;</td>		
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt4[0])%></td>			
            	</tr>
<% }else{%>            	
	            <tr>
    	            <td colspan=9 align=center height=25>등록된 데이타가 없습니다.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
    <tr>
        <td>* FMS 출금관리에서 포상내역 연동되어 출금된 경우 실지급일자를 확인할 수 있으나, 은행사이트에서 인터넷뱅킹한 경우 실지급일자가 없습니다. <br>
                * 2014년부터 유류대정산금액이 + 인경우 복지비에 반영됩니다. </td>
    </tr>	
</table>
</body>
</html>
