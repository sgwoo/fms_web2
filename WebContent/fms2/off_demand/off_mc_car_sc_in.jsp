<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String dt		= request.getParameter("dt")==null?"4":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	Vector mc_vt = dm_db.getDemandMcList3(gubun, ref_dt1, ref_dt2);		
	int mc_vt_size = mc_vt.size();	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>

</script>
</head>
<body>
<form name="form1">
<table border=0 cellspacing=0 cellpadding=0 width="1200">
	<tr>
		<td>○ 매출형태
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td colspan=2 class=line2></td>
 
							</tr>
							
							<tr id='tr_title' style='position:relative;z-index:1'>		
								<td class='line' id='td_title' style='position:relative;' width=1200> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td  class='title' style="height:70px; width:164px;" rowspan='3'>구분</td>
										<td  class='title' style="height:35px;" colspan='4'>법인</td>
										<td class='title' colspan='4'>개인/개인사업자</td>
										<td  class='title' colspan='2'>합계</td>		  
									</tr>
									<tr>
										<td  class='title' style="height:35px;" colspan='2'>거래처</td>
										<td  class='title' style="height:35px;" colspan='2'>대여대수</td>
										<td class='title' colspan='2'>거래처</td>
										<td class='title' colspan='2'>대여대수</td>
										<td  class='title' rowspan='2'>거래처수</td>		  
										<td  class='title' rowspan='2'>대여대수</td>		  
									</tr>
									<tr>
										<td class='title' style="height:35px;width:100px;">거래처수</td>
										<td class='title' style="height:35px;width:100px;">비율</td>
										<td  class='title' style="height:35px;width:100px;">대수</td>
										<td  class='title' style="height:35px;width:100px;">비율</td>		  
										<td class='title' style="height:35px;width:100px;">거래처수</td>
										<td class='title' style="height:35px;width:100px;">비율</td>
										<td  class='title' style="height:35px;width:100px;">대수</td>
										<td  class='title' style="height:35px;width:100px;">비율</td>		  
									</tr>
								</table>
								</td>		
							</tr>
							
							<tr>
								<td class='line' id='td_con' style='position:relative;' width=900> 
								<table border="0" cellspacing="1" cellpadding="0" width=100% >
			
									<%for(int k=0;k<mc_vt_size;k++){
										Hashtable ht = (Hashtable)mc_vt.elementAt(k);
										String years = AddUtil.subDataCut(ht.get("SAVE_DT")+"",4);
										String tDate = ht.get("SAVE_DT")+"";
										String tMonth = tDate.substring(4,6);
										
										if(gubun.equals("")){
											//2017년~2020년 값 고정
											if(years.equals("2017")){
												ht.put("CO_COUNT", "6105");
												ht.put("CO_CAR",   "9835");
												ht.put("NO_COUNT", "7878");
												ht.put("NO_CAR",   "8786");
											}
											if(years.equals("2018")){
												ht.put("CO_COUNT", "6230");
												ht.put("CO_CAR",   "9984");
												ht.put("NO_COUNT", "8349");
												ht.put("NO_CAR",   "9308");
											}
											if(years.equals("2019")){
												ht.put("CO_COUNT", "6306");
												ht.put("CO_CAR",   "10154");
												ht.put("NO_COUNT", "9017");
												ht.put("NO_CAR",   "10006");
											}
											if(years.equals("2020")){
												ht.put("CO_COUNT", "6844");
												ht.put("CO_CAR",   "10948");
												ht.put("NO_COUNT", "10286");
												ht.put("NO_CAR",   "11331");
											}
										}	
										
										double co_hap = AddUtil.parseInt(ht.get("CO_COUNT")+"")+AddUtil.parseInt(ht.get("NO_COUNT")+"");
										double co_car = AddUtil.parseInt(ht.get("CO_CAR")+"")+AddUtil.parseInt(ht.get("NO_CAR")+"");;
									%>
									<tr>
											<td class='title' style="height:35px;width:164px;">
											<%if(k==(mc_vt_size-1)){%>
												<%=years%>년(<%=tMonth%>월 말일 기준)
											<%}else{%>
												<%=years%>년
												<%}%>
											</td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CO_COUNT")+"")%></td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("t",AddUtil.parseInt(ht.get("CO_COUNT")+"")/co_hap*100+"",1)%>%</td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CO_CAR")+"")%></td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("t",AddUtil.parseInt(ht.get("CO_CAR")+"")/co_car*100+"",1)%>%</td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("NO_COUNT")+"")%></td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("t",AddUtil.parseInt(ht.get("NO_COUNT")+"")/co_hap*100+"",1)%>%</td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("NO_CAR")+"")%></td>
											<td  style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("t",AddUtil.parseInt(ht.get("NO_CAR")+"")/co_car*100+"",1)%>%</td>
											<td style="text-align:center;"><%=AddUtil.parseDecimal(co_hap)%></td>
											<td style="text-align:center;"><%=AddUtil.parseDecimal(co_car)%></td>
									</tr>
									<%}%>									
								</table>
								</td>
							</tr>
							
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>