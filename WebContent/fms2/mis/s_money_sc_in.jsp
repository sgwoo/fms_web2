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
	String minus		= request.getParameter("minus")==null?"":request.getParameter("minus");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"))-200;//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = ac_db.S_MoneyListM(dt, ref_dt1, ref_dt2, gubun1, minus);
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
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
//	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='800'>
    <tr>
        <td class=line2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'> 
		<td class='line' width='23%' id='td_title' style='position:relative;'>
			<table border=0 cellspacing=1 width=100%>
				<tr> 
					<td class='title' width='6%'>연번</td>
					<td class='title' width='6%'>사원번호</td>
					<td class='title' width='10%'>성명</td>
					<td class='title' width='13%'>
						<% if (gubun1.equals("9") ) { %>제안포상금 
						<% } else if (gubun1.equals("2") ) { %>영업캠페인포상
						<% } else if (gubun1.equals("1") ) { %>채권캠페인포상
						<% } else if (gubun1.equals("5") ) { %>비용캠페인포상
						<% } else if (gubun1.equals("6") ) { %>제안캠페인포상
						<% } else if (gubun1.equals("30") ) { %>1군비용캠페인포상
						<% } else if (gubun1.equals("29") ) { %>2군비용캠페인포상
						<% } else if (gubun1.equals("8") ) { %>통신비
						<% } %>
					</td>
					<td class='title' width='17%' >유류대정산<br>(포상금차감/복지비지급)</td>
					<td class='title' width='13%'>실지급액</td>
									
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=line2>
			<table border=0 cellspacing=1 width=100%>
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
            		<td width='6%' align="center"><%=i+1%></td>
            		<td width='6%' align="center"><%=ht.get("ID")%></td>
            		<td width='10%' align="center"><a href="javascript:parent.sub_list_pop('<%=ht.get("USER_ID")%>');"><%=ht.get("USER_NM")%></a></td>
               		<td width='13%' align="right"><%=AddUtil.parseDecimal(ht.get("AMT"))%></td>
               		<td width='17%' align="right"><%=AddUtil.parseDecimal(oil_m_amt)%><br>
               		                                                        <%=AddUtil.parseDecimal(oil_p_amt)%></td>
               		<td width='13%' align="right"><%=AddUtil.parseDecimal(pr_amt)%></td>
               		
            	</tr>
<% }	%>
			   <tr>
            		<td class=title  colspan=3 align="center">계</td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%><br>
            	 								<%=Util.parseDecimal(t_amt4[0])%></td>
            		<td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
            	
            	</tr>
<% }else{%>            	
	            <tr>
    	            <td colspan=7 align=center height=25>등록된 데이타가 없습니다.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
</table>
</body>
</html>
