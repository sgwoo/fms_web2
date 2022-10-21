<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	Vector vt = ad_db.getSelectStatEndContListDB(save_dt);
	int vt_size = vt.size();
	
	long sum_cnt = 0;
	long sum_amt = 0;
	long sum_cnt2 = 0;
	long sum_amt2 = 0;
	
	int best_cnt = 40;
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='off_demand_sc1.jsp' method='post' target='t_content'>
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>주요 거래처(계약기준)</span></td>
    </tr>
    <tr>
        <td align=right>(<%=AddUtil.ChangeDate2(save_dt) %> 현재, 단위:원)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line' > 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td width="100" class="title">연번</td>
	  								    <td width="400" class="title">거래처명</td>
	  								    <td width="200" class="title">대여대수</td>
	  								    <td width="200" class="title">월대여료</td>
	  								    <td width="100" class="title">비고</td>		  
									</tr>
									<%for(int i = 0 ; i < vt_size ; i++){
										Hashtable ht = (Hashtable)vt.elementAt(i);			
										
										sum_cnt  = sum_cnt  + Util.parseLong(String.valueOf(ht.get("대여대수")));
										sum_amt  = sum_amt  + Util.parseLong(String.valueOf(ht.get("월대여료")));
										
										if(i < best_cnt){
											sum_cnt2  = sum_cnt2  + Util.parseLong(String.valueOf(ht.get("대여대수")));
											sum_amt2  = sum_amt2  + Util.parseLong(String.valueOf(ht.get("월대여료")));											
									%>
									<tr>
										<td class="title"><%=i+1%></td>
	  								    <td align="center"><%=ht.get("거래처명")%></td>
	  								    <td align="center"><%=ht.get("대여대수")%></td>
	  								    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("월대여료")))%></td>
	  								    <td>&nbsp;</td>	  
									</tr>		
									<%	}
									}%>
									<tr>
	  									<td colspan="2" class="title">합계</td>	  
	  									<td align="right"><%=Util.parseDecimal(sum_cnt2)%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_amt2)%></td>
	  									<td>&nbsp;</td>	  
									</tr>
									
								</table>
								</td>
							</tr>
							
	<tr>
		<td>&nbsp;</td>
	</tr>								
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line' > 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td width="100" class="title">구분</td>	  								    
	  								    <td width="400" class="title">거래처수</td>
	  								    <td width="200" class="title">대여대수</td>
	  								    <td width="200" class="title">월대여료</td>
	  								    <td width="100" class="title"></td>		  
									</tr>
									<tr>
	  									<td class="title">주요거래처</td>	  
	  									<td align="right"><%=best_cnt%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_cnt2)%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_amt2)%></td>
	  									<td>&nbsp;</td>	  
									</tr>
									<tr>
	  									<td class="title">기타</td>	  
	  									<td align="right"><%=Util.parseDecimal(vt_size-best_cnt)%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_cnt-sum_cnt2)%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_amt-sum_amt2)%></td>
	  									<td>&nbsp;</td>	  
									</tr>
									<tr>
	  									<td class="title">합계</td>	  
	  									<td align="right"><%=Util.parseDecimal(vt_size)%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_cnt)%></td>
	  									<td align="right"><%=Util.parseDecimal(sum_amt)%></td>
	  									<td>&nbsp;</td>	  
									</tr>
									
								</table>
								</td>
							</tr>							

							
  </table>
</form>
</body>
</html>
