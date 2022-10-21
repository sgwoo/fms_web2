<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String gubun = "";
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-4)+"0101"; //마감기준일-4년전
	String ref_dt2 = save_dt; //마감기준일
	
	Vector vt = dm_db.getOffDemandStat4("1", ref_dt1, ref_dt2);		
	int vt_size = vt.size();	
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
  <table border="0" cellspacing="0" cellpadding="0" width=1014>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각 형태별현황</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line' > 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td class='title' colspan='2'>구분</td>
										<td class='title' width:100px;" style="height:35px;">글로비스(시화)</td>
										<td class='title' width:100px;">글로비스(분당)</td>
										<td class='title' width:100px;">에이제이셀카</td>		  
										<td class='title' width:100px;">롯데경매장</td>
										<td class='title' width:100px;">KCAR</td>
										<td class='title' width:100px;">매입옵션</td>
										<td class='title' width:100px;">폐차(사고차매각포함)</td>
										<td class='title' width:100px;">합계</td>
									</tr>
									<%for(int i=0;i<vt_size;i++){
										Hashtable ht = (Hashtable)vt.elementAt(i);
										String years = AddUtil.subDataCut(ht.get("ASSCH_YEAR")+"",4);																				
									%>
									<tr>
											<td class='title' rowspan='2' width:150px;>
											<%	if(i==(vt_size-1) && !ref_dt2.substring(5,7).equals("12")){%>
												<%=years%>년(<%=AddUtil.ChangeDate(AddUtil.replace(ref_dt2,"-",""),"MM월DD일")%>)
											<%}else{%>
												<%=years%>년
											<%}%>											
											</td>
											<td class='title' style="height:35px;width:64px;text-align:center;">대수</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT1")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT2")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT3")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT4")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT5")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT6")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT7")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT8")+"")%></td>
									</tr>		
									<tr>											
											<td class='title' style="height:35px;width:64px;text-align:center;">비중</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER1")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER2")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER3")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER4")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER5")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER6")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("PER7")%>%</td>
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>								
									<%}%>
								</table>
								</td>
							</tr>
							
  </table>
</form>
</body>
</html>
