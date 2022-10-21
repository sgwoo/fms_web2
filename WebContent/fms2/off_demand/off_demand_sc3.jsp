<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String dt = "4";
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-5)+"0101"; //마감기준일-4년전
	String ref_dt2 = save_dt; //마감기준일
	
	//구입
	Vector dm_vt = dm_db.getDemandCarList1(ref_dt1,ref_dt2,dt);		
	int dm_vt_size = dm_vt.size();	
	
	//매각
	Vector dm_vt2 = dm_db.getDemandCarList2(ref_dt1,ref_dt2,dt);		
	int dm_vt_size2 = dm_vt2.size();

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
<form name='form1' action='off_demand_sc3.jsp' method='post' target='t_content'>
  <table border="0" cellspacing="0" cellpadding="0" width=1164>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량구입 및 매각현황</span></td>
	  </tr>
    <tr>
        <td align=right>(단위:백만원, 차량수, vat별도)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line'> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td  class='title' style="height:70px;" width:164px;" rowspan='3'>구분</td>
										<td  class='title' style="height:35px;" colspan='4'>구입</td>
										<td class='title' colspan='4'>매각</td>
										<td  class='title' rowspan='3' width:316px;" >비고</td>		  
									</tr>
									<tr>
										<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">대수</div>
												<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">전년대비</div>
											</div>
										</td>	
										<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">금액</div>
												<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">전년대비</div>
											</div>
										</td>	
										<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">대수</div>
												<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">전년대비</div>
											</div>
										</td>	
										<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">금액</div>
												<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">전년대비</div>
											</div>
										</td>	
									</tr>	
									
									<tr>
		                                <td class=line2 colspan='10'></td>
	                                </tr>	
																		 				
									<%	
										//전년대비 계산용
										Hashtable b_ht = new Hashtable();									
    					  				Hashtable b_ht2 = new Hashtable();		
    					  				if(dm_vt_size > 0){
    					  					b_ht = (Hashtable)dm_vt.elementAt(0);
    					  					b_ht2 = (Hashtable)dm_vt2.elementAt(0);
    					  				}
    					  			%>
    					  			<%	
										for(int k=1;k<dm_vt_size;k++){
        					  				Hashtable ht = (Hashtable)dm_vt.elementAt(k);
        					  				Hashtable ht2 = (Hashtable)dm_vt2.elementAt(k);    
        					  				
        					  				double cnt1 = AddUtil.parseInt(b_ht.get("CNT")+"");
    										double cnt2 = AddUtil.parseInt(b_ht2.get("CNT")+"");
    										double amt1 = AddUtil.parseInt(AddUtil.million(b_ht.get("S_AMT")+""));
    										double amt2 = AddUtil.parseInt(AddUtil.million(b_ht2.get("S_AMT")+""));
        							%>
									<tr> 
										<td align='center' style="height:30px;width:164px;" class="title">
										<%	if(k==(dm_vt_size-1) && !ref_dt2.substring(5,7).equals("12")){%>
												<%=ht.get("YEAR")%>년(<%=AddUtil.ChangeDate(AddUtil.replace(ref_dt2,"-",""),"MM월DD일")%>)
										<%}else{%>
												<%=ht.get("YEAR")%>년
										<%}%>											
										</td>
										<td align='center' width='100px'><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
										<td align='center' width='100px'><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(ht.get("CNT")+"")/cnt1*100+"",1)))%>%</td>
										<td align='center' width='100px'><%=AddUtil.parseDecimal(AddUtil.million(ht.get("S_AMT")+""))%></td>
										<td align='center' width='100px'><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(AddUtil.million(ht.get("S_AMT")+""))/amt1*100+"",1)))%>%</td>							
										<td align='center' width='100px'><%=AddUtil.parseDecimal(ht2.get("CNT")+"")%></td>
										<td align='center' width='100px'><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(ht2.get("CNT")+"")/cnt2*100+"",1)))%>%</td>							  
										<td align='center' width='100px'><%=AddUtil.parseDecimal(AddUtil.million(ht2.get("S_AMT")+""))%></td>
										<td align='center' width='100px'><%=AddUtil.parseFloatNotDot(AddUtil.parseFloat(AddUtil.calcMath("t",AddUtil.parseInt(AddUtil.million(ht2.get("S_AMT")+""))/amt2*100+"",1)))%>%</td>
										<td align='center' width='200px'> </td>
									</tr>
									<%		b_ht = ht;
											b_ht2 = ht2; 
										}%>
										
								</table>
								</td>
							</tr>
							
  </table>
</form>
</body>
</html>
