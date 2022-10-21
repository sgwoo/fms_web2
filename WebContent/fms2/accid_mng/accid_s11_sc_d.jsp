<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.accid.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector vt = as_db.getMyAccidInsComDtStat2(s_yy, s_mm);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	int total_cnt1	= 0;
	int total_cnt2 = 0;

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat(ins_com){
		window.open('accid_s11_stat_list.jsp?s_yy=<%=s_yy%>&s_mm=<%=s_mm%>&ins_com='+ins_com, "STAT_LIST", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
	}

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width=50 class=title>연번</td>
                    <td width=150 class=title>보험사</td>					
                    <td width=100 class=title>입금건수</td>
                    <td width=100 class=title>청구금액</td>
                    <td width=100 class=title>입금금액</td>
                    <td width=100 class=title>입금비율</td>
					
                </tr>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				//if(!ht.get("PAY_CNT").equals("0")){
				
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("REQ_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
				
			//	total_cnt1 	= total_cnt1 + AddUtil.parseInt(String.valueOf(ht.get("REQ_CNT")));
				total_cnt2 	= total_cnt2 + AddUtil.parseInt(String.valueOf(ht.get("PAY_CNT")));
		%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:view_stat('<%=ht.get("INS_COM")%>')"><%=ht.get("INS_COM")%>&nbsp;</a></td>			

                    <td align="center"><%=ht.get("PAY_CNT")%></td>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("REQ_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("PAY_AMT")))%></td>
                    <td align="center"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("PAY_AMT")))/AddUtil.parseFloat(String.valueOf(ht.get("REQ_AMT")))*100,2)%>%</td>
                </tr>		
		<%	}//}%>	
                <tr> 
                    <td class="title" colspan='2'>합계</td>
                    <td class="title"><%=Util.parseDecimal(total_cnt2)%></td>
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
                    <td class="title"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(total_amt2))/AddUtil.parseFloat(String.valueOf(total_amt1))*100,2)%>%</td>
                </tr>																				
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>