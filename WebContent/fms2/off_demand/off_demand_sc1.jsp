<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String gubun = "";
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-4)+"1231"; //����������-4����
	String ref_dt2 = save_dt; //����������
	
	Vector mc_vt = dm_db.getDemandMcList3(gubun, ref_dt1, ref_dt2);		
	int mc_vt_size = mc_vt.size();	
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
  <table border="0" cellspacing="0" cellpadding="0" width=1164>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
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
										<td class='title' style="height:70px; width:164px;" rowspan='3'>����</td>
										<td class='title' style="height:35px;" colspan='4'>����</td>
										<td class='title' colspan='4'>����/���λ����</td>
										<td class='title' colspan='2'>�հ�</td>		  
									</tr>
									<tr>
										<td class='title' style="height:35px;" colspan='2'>�ŷ�ó</td>
										<td class='title' style="height:35px;" colspan='2'>�뿩���</td>
										<td class='title' colspan='2'>�ŷ�ó</td>
										<td class='title' colspan='2'>�뿩���</td>
										<td class='title' rowspan='2'>�ŷ�ó��</td>		  
										<td class='title' rowspan='2'>�뿩���</td>		  
									</tr>
									<tr>
										<td class='title' style="height:35px;width:100px;">�ŷ�ó��</td>
										<td class='title' style="height:35px;width:100px;">����</td>
										<td class='title' style="height:35px;width:100px;">���</td>
										<td class='title' style="height:35px;width:100px;">����</td>		  
										<td class='title' style="height:35px;width:100px;">�ŷ�ó��</td>
										<td class='title' style="height:35px;width:100px;">����</td>
										<td class='title' style="height:35px;width:100px;">���</td>
										<td class='title' style="height:35px;width:100px;">����</td>		  
									</tr>											
									<%for(int k=0;k<mc_vt_size;k++){
										Hashtable ht = (Hashtable)mc_vt.elementAt(k);
										String years = AddUtil.subDataCut(ht.get("SAVE_DT")+"",4);	
										
										//2017��~2020�� �� ����
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
										if(years.equals("2021") && ref_dt2.equals("2021-09-30")){
											ht.put("CO_COUNT", "7029");
											ht.put("CO_CAR",   "11346");
											ht.put("NO_COUNT", "10295");
											ht.put("NO_CAR",   "11335");
										}
										
										double co_hap = AddUtil.parseInt(ht.get("CO_COUNT")+"")+AddUtil.parseInt(ht.get("NO_COUNT")+"");
										double co_car = AddUtil.parseInt(ht.get("CO_CAR")+"")+AddUtil.parseInt(ht.get("NO_CAR")+"");
									%>
									<tr>
											<td class='title' style="height:35px;width:164px;">
											<%	if(k==(mc_vt_size-1) && !ref_dt2.substring(5,7).equals("12")){%>
												<%=years%>��(<%=AddUtil.ChangeDate(AddUtil.replace(ref_dt2,"-",""),"MM��DD��")%>)
											<%}else{%>
												<%=years%>��
											<%}%>											
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CO_COUNT")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(ht.get("CO_COUNT")+"")/co_hap*100+"",1)))%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CO_CAR")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(ht.get("CO_CAR")+"")/co_car*100+"",1)))%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("NO_COUNT")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(ht.get("NO_COUNT")+"")/co_hap*100+"",1)))%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("NO_CAR")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(ht.get("NO_CAR")+"")/co_car*100+"",1)))%>%</td>
											<td style="width:100px;text-align:center;"><%=AddUtil.parseDecimal(co_hap)%></td>
											<td style="width:100px;text-align:center;"><%=AddUtil.parseDecimal(co_car)%></td>
									</tr>
									<%}%>									
								</table>
								</td>
							</tr>
							
  </table>
</form>
</body>
</html>
