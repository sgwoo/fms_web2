<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.off_demand.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"4":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"20160101":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	String ref_dt1_2 = ref_dt1;
	String ref_dt2_2 = ref_dt2;
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	if(!ref_dt1.equals("")){
		ref_dt1 = ref_dt1.replace("-","");
	}
	if(!ref_dt2.equals("")){
		ref_dt2 = ref_dt2.replace("-","");
	}
	
	Vector dm_vt2 = dm_db.getDemandTermList2(ref_dt1,ref_dt2);		
	int dm_vt_size2 = dm_vt2.size();
	double[] month_c = new double[2];
	double all_count_month6=0;
	double all_count_month12=0;
	double all_count_month24=0;
	double all_count_month36=0;
	double all_count_month48=0;
	double all_count_month99=0;
	double all_count_month=0;
	
	double all_count_amt6=0;
	double all_count_amt12=0;
	double all_count_amt24=0;
	double all_count_amt36=0;
	double all_count_amt48=0;
	double all_count_amt99=0;
	double all_count_amt=0;
	
		for(int k=0;k<dm_vt_size2;k++){
    	Hashtable ht2 = (Hashtable)dm_vt2.elementAt(k);
    	if(ht2.get("CNT").equals("0")){
    		month_c[k] = 0;
    		month_c[k+1] = 0; 
    	}else{
    		month_c[k] = Double.parseDouble(ht2.get("CNT")+"");
    		month_c[k+1] = Double.parseDouble(AddUtil.million(ht2.get("AMT")+"")+""); 
    	}
    	
  	}  	
  	
  	Vector dm_vt = dm_db.getDemandTermList1(ref_dt1,ref_dt2);		
			int dm_vt_size = dm_vt.size();
			double[] month_6 = new double[3];
			double[] month_12 = new double[3];
			double[] month_24 = new double[3];
			double[] month_36 = new double[3];
			double[] month_48 = new double[3];
			double[] month_99 = new double[3];
			double[] all_count = new double[3];
			
			
			double[] amt_6 = new double[3];
			double[] amt_12 = new double[3];
			double[] amt_24 = new double[3];
			double[] amt_36 = new double[3];
			double[] amt_48 = new double[3];
			double[] amt_99 = new double[3];
			double[] all_count2 = new double[3];

			for(int k=0;k<dm_vt_size;k++){
    		Hashtable ht = (Hashtable)dm_vt.elementAt(k);
    		
    			month_6[k] = Double.parseDouble(ht.get("MON_D6")+"");
    			month_12[k] = Double.parseDouble(ht.get("MON_D12")+"");
    			month_24[k] = Double.parseDouble(ht.get("MON_D24")+"");
    			month_36[k] = Double.parseDouble(ht.get("MON_D36")+"");
    			month_48[k] = Double.parseDouble(ht.get("MON_D48")+"");
    			month_99[k] = Double.parseDouble(ht.get("MON_D99")+"");
    			all_count[k] = Integer.parseInt(ht.get("MON_D6")+"")+Integer.parseInt(ht.get("MON_D12")+"")+Integer.parseInt(ht.get("MON_D24")+"")+
    			Integer.parseInt(ht.get("MON_D36")+"")+Integer.parseInt(ht.get("MON_D48")+"")+Integer.parseInt(ht.get("MON_D99")+"");
    	
    			amt_6[k] = ht.get("AMT_D6")==""?0:Double.parseDouble(AddUtil.million(ht.get("AMT_D6")+""));
    			amt_12[k] = ht.get("AMT_D12")==""?0:Double.parseDouble(AddUtil.million(ht.get("AMT_D12")+""));
    			amt_24[k] = ht.get("AMT_D24")==""?0:Double.parseDouble(AddUtil.million(ht.get("AMT_D24")+""));
    			amt_36[k] = ht.get("AMT_D36")==""?0:Double.parseDouble(AddUtil.million(ht.get("AMT_D36")+""));
    			amt_48[k] = ht.get("AMT_D48")==""?0:Double.parseDouble(AddUtil.million(ht.get("AMT_D48")+""));
    			amt_99[k] = ht.get("AMT_D99")==""?0:Double.parseDouble(AddUtil.million(ht.get("AMT_D99")+""));
  		}  	

	  for(int j=0;j<all_count2.length;j++){
	  	all_count2[j] = amt_6[j]+ amt_12[j]+ amt_24[j]+ amt_36[j]+ amt_48[j]+ amt_99[j];
	  }
	  
	  for(int j=0;j<month_6.length;j++){
	   all_count_month6 += month_6[j];
	   all_count_month12 += month_12[j];
	   all_count_month24 += month_24[j];
	   all_count_month36 += month_36[j];
	   all_count_month48 += month_48[j];
	   all_count_month99 += month_99[j];
	  }
	  all_count_month6 += month_c[0];
    for(int j=0;j<month_6.length;j++){
	  	all_count_month  = all_count_month6 + all_count_month12 + all_count_month24 + all_count_month36 + all_count_month48 + all_count_month99;
	  }    					
	  
	  for(int j=0;j<amt_6.length;j++){
	   all_count_amt6 += amt_6[j];
	   all_count_amt12 += amt_12[j];
	   all_count_amt24 += amt_24[j];
	   all_count_amt36 += amt_36[j];
	   all_count_amt48 += amt_48[j];
	   all_count_amt99 += amt_99[j];
	  }
	  all_count_amt6 += month_c[1];
    for(int j=0;j<amt_6.length;j++){
	  	all_count_amt = all_count_amt6 + all_count_amt12 + all_count_amt24 + all_count_amt36 + all_count_amt48 + all_count_amt99;
	  }    					


%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>

</script>
</head>
<body onLoad="javascript:init()">
<form name="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">

<table border=0 cellspacing=0 cellpadding=0 width="1030">
	<tr>
		<td>○ 계약현황( <%=ref_dt1_2%> ~ <%=ref_dt2_2%> )<%
			for(int k=0;k<=83;k++){%>
				&nbsp;
			<%}%>	(단위:백만원, vat별도, 대여개시일 기준)
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td colspan=2 class=line2></td>

							</tr>
							
							<tr id='tr_title' style='position:relative;z-index:1'>		
								<td class='line' id='td_title' style='position:relative;' width=900> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td  class='title' style='height:45; width:130px;'>구분</td>
										<td  class='title' style='width:65px;'>6개월이내</td>
										<td  class='title' style='width:65px;'>7~12개월</td>
										<td  class='title' style='width:65px;'>13~24개월</td>	
										<td  class='title' style='width:65px;'>25~36개월</td>		 
										<td  class='title' style='width:65px;'>37~48개월</td>		 
										<td  class='title' style='width:67px;'>48개월이상</td>		 
										<td  class='title' style='width:70px;'>합계</td>		 	  
									</tr>
								</table>
								</td>		
							</tr>
							
							<tr>
								<td class='line' id='td_con' style='position:relative;' width=900> 
								<table border="0" cellspacing="1" cellpadding="0" width=100% >
									
									<tr> 
										<td align='center' class='title' rowspan="4" style='width:60px;'>신<br>차</td>
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>							
										<td align='center' style='width:112px; height:30px;'><%if(month_6[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_6[0])%><%}%></td>							  
										<td align='center' style='width:112px;'><%if(month_12[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_12[0])%><%}%></td>
										<td align='center' style='width:113px;'><%if(month_24[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_24[0])%><%}%></td>
										<td align='center' style='width:112px;'><%if(month_36[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_36[0])%><%}%></td>
										<td align='center' style='width:112px;'><%if(month_48[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_48[0])%><%}%></td>
										<td align='center' style='width:115px;'><%if(month_99[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_99[0])%><%}%></td>
										<td align='center' ><%if(all_count[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count[0])%><%}%></td>
									</tr>
									<tr> 
										<td align='center' style='height:30px;'><%if(month_6[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_6[0]/all_count[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(month_12[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_12[0]/all_count[0]*100+"",1)%>%<%}%></td>							
										<td align='center'><%if(month_24[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_24[0]/all_count[0]*100+"",1)%>%<%}%></td>							  
										<td align='center'><%if(month_36[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_36[0]/all_count[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(month_48[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_48[0]/all_count[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(month_99[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_99[0]/all_count[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count[0]==0){%>0.0%<%}else{%><%=all_count[0]/all_count[0]*100.0%>%<%}%></td>
									</tr>
									<tr> 
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>		
										<td align='center'><%if(amt_6[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_6[0])%><%}%></td>							
										<td align='center'><%if(amt_12[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_12[0])%><%}%></td>									  
										<td align='center'><%if(amt_24[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_24[0])%><%}%></td>		
										<td align='center'><%if(amt_36[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_36[0])%><%}%></td>		
										<td align='center'><%if(amt_48[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_48[0])%><%}%></td>		
										<td align='center'><%if(amt_99[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_99[0])%><%}%></td>		
										<td align='center'><%if(all_count2[0]==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count2[0])%><%}%></td>		
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(amt_6[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_6[0]/all_count2[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(amt_12[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_12[0]/all_count2[0]*100+"",1)%>%<%}%></td>			
										<td align='center'><%if(amt_24[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_24[0]/all_count2[0]*100+"",1)%>%<%}%></td>				  
										<td align='center'><%if(amt_36[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_36[0]/all_count2[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(amt_48[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_48[0]/all_count2[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(amt_99[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_99[0]/all_count2[0]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count2[0]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count2[0]/all_count2[0]*100+"",1)%>%<%}%></td>
									</tr>
									<tr> 
										<td align='center' class='title' rowspan="4" style='width:60px;'>재<br>리<br>스</td>
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>						
										<td align='center'><%if(month_6[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_6[1])%><%}%></td>							  
										<td align='center'><%if(month_12[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_12[1])%><%}%></td>					
										<td align='center'><%if(month_24[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_24[1])%><%}%></td>					
										<td align='center'><%if(month_36[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_36[1])%><%}%></td>					
										<td align='center'><%if(month_48[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_48[1])%><%}%></td>					
										<td align='center'><%if(month_99[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_99[1])%><%}%></td>					
										<td align='center'><%if(all_count[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count[1])%><%}%></td>					
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(month_6[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_6[1]/all_count[1]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_12[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_12[1]/all_count[1]*100+"",1)%>%<%}%></td>								
										<td align='center'><%if(month_24[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_24[1]/all_count[1]*100+"",1)%>%<%}%></td>								  
										<td align='center'><%if(month_36[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_36[1]/all_count[1]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_48[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_48[1]/all_count[1]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_99[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_99[1]/all_count[1]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(all_count[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count[1]/all_count[1]*100+"",1)%>%<%}%></td>	
									</tr>
									<tr> 
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>		
										<td align='center'><%if(amt_6[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_6[1])%><%}%></td>							
										<td align='center'><%if(amt_12[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_12[1])%><%}%></td>									  
										<td align='center'><%if(amt_24[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_24[1])%><%}%></td>		
										<td align='center'><%if(amt_36[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_36[1])%><%}%></td>		
										<td align='center'><%if(amt_48[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_48[1])%><%}%></td>		
										<td align='center'><%if(amt_99[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_99[1])%><%}%></td>		
										<td align='center'><%if(all_count2[1]==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count2[1])%><%}%></td>		
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(amt_6[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_6[1]/all_count2[1]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(amt_12[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_12[1]/all_count2[1]*100+"",1)%>%<%}%></td>					
										<td align='center'><%if(amt_24[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_24[1]/all_count2[1]*100+"",1)%>%<%}%></td>						  
										<td align='center'><%if(amt_36[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_36[1]/all_count2[1]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(amt_48[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_48[1]/all_count2[1]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(amt_99[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_99[1]/all_count2[1]*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count2[1]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count2[1]/all_count2[1]*100+"",1)%>%<%}%></td>
									</tr>
									<tr> 
										<td align='center' class='title' rowspan="4" style='width:60px;'>연<br>장</td>
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>									
										<td align='center'><%if(month_6[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_6[2])%><%}%></td>							  
										<td align='center'><%if(month_12[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_12[2])%><%}%></td>					
										<td align='center'><%if(month_24[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_24[2])%><%}%></td>					
										<td align='center'><%if(month_36[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_36[2])%><%}%></td>					
										<td align='center'><%if(month_48[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_48[2])%><%}%></td>					
										<td align='center'><%if(month_99[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(month_99[2])%><%}%></td>					
										<td align='center'><%if(all_count[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count[2])%><%}%></td>					
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(month_6[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_6[2]/all_count[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_12[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_12[2]/all_count[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_24[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_24[2]/all_count[2]*100+"",1)%>%<%}%></td>							  
										<td align='center'><%if(month_36[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_36[2]/all_count[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_48[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_48[2]/all_count[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(month_99[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",month_99[2]/all_count[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(all_count[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count[2]/all_count[2]*100+"",1)%>%<%}%></td>	
									</tr>
									<tr> 
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>		
										<td align='center'><%if(amt_6[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_6[2])%><%}%></td>							
										<td align='center'><%if(amt_12[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_12[2])%><%}%></td>									  
										<td align='center'><%if(amt_24[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_24[2])%><%}%></td>		
										<td align='center'><%if(amt_36[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_36[2])%><%}%></td>		
										<td align='center'><%if(amt_48[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_48[2])%><%}%></td>		
										<td align='center'><%if(amt_99[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(amt_99[2])%><%}%></td>		
										<td align='center'><%if(all_count2[2]==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count2[2])%><%}%></td>		
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(amt_6[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_6[2]/all_count2[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(amt_12[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_12[2]/all_count2[2]*100+"",1)%>%<%}%></td>					
										<td align='center'><%if(amt_24[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_24[2]/all_count2[2]*100+"",1)%>%<%}%></td>							  
										<td align='center'><%if(amt_36[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_36[2]/all_count2[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(amt_48[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_48[2]/all_count2[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(amt_99[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",amt_99[2]/all_count2[2]*100+"",1)%>%<%}%></td>	
										<td align='center'><%if(all_count2[2]==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count2[2]/all_count2[2]*100+"",1)%>%<%}%></td>	
									</tr>
									<tr> 
										<td align='center' class='title' rowspan="4" style='width:60px;'>월<br>렌<br>트</td>
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>								
										<td align='center'><%=AddUtil.parseDecimal(month_c[0])%></td>							  
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'><%=AddUtil.parseDecimal(month_c[0])%></td>
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(month_c[0]==0){%>0.0%<%}else{%><%=month_c[0]/month_c[0]*100.0%>%<%}%></td>
										<td align='center'>0.0%</td>							
										<td align='center'>0.0%</td>							  
										<td align='center'>0.0%</td>
										<td align='center'>0.0%</td>
										<td align='center'>0.0%</td>
										<td align='center'><%if(month_c[0]==0){%>0.0%<%}else{%><%=month_c[0]/month_c[0]*100.0%>%<%}%></td>
									</tr>
									<tr> 
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>		
										<td align='center'><%=AddUtil.parseDecimal(month_c[1])%></td>							
										<td align='center'>-</td>							  
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'>-</td>
										<td align='center'><%=AddUtil.parseDecimal(month_c[1])%></td>
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(month_c[1]==0){%>0.0%<%}else{%><%=month_c[1]/month_c[1]*100.0%>%<%}%></td>
										<td align='center'>0.0%</td>							
										<td align='center'>0.0%</td>							  
										<td align='center'>0.0%</td>
										<td align='center'>0.0%</td>
										<td align='center'>0.0%</td>
										<td align='center'><%if(month_c[1]==0){%>0.0%<%}else{%><%=month_c[1]/month_c[1]*100.0%>%<%}%></td>
									</tr>
									<tr> 
										<td align='center' class='title' rowspan="4" style='width:60px;'>합<br>계</td>
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>									
										<td align='center'><%if(all_count_month6==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month6)%><%}%></td>							  
										<td align='center'><%if(all_count_month12==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month12)%><%}%></td>							  
										<td align='center'><%if(all_count_month24==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month24)%><%}%></td>							  
										<td align='center'><%if(all_count_month36==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month36)%><%}%></td>							  
										<td align='center'><%if(all_count_month48==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month48)%><%}%></td>							  
										<td align='center'><%if(all_count_month99==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month99)%><%}%></td>							  
										<td align='center'><%if(all_count_month==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_month)%><%}%></td>						
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(all_count_month6==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month6/all_count_month*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_month12==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month12/all_count_month*100+"",1)%>%<%}%></td>						
										<td align='center'><%if(all_count_month24==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month24/all_count_month*100+"",1)%>%<%}%></td>						  
										<td align='center'><%if(all_count_month36==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month36/all_count_month*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_month48==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month48/all_count_month*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_month99==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month99/all_count_month*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_month==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_month/all_count_month*100+"",1)%>%<%}%></td>
									</tr>
									<tr> 
										<td align='center' style='width:163px; height:30px;' rowspan="2" class="title">
											<div style="height: 53px;">
												<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
												<div style="border-image: none; width: 30px; height: 22px; float: left;"></div>
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 110px; height: 22px; padding-top: 8px; float: right;">점유비</div>
											</div>
										</td>		
										<td align='center'><%if(all_count_amt6==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt6)%><%}%></td>							  
										<td align='center'><%if(all_count_amt12==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt12)%><%}%></td>							  
										<td align='center'><%if(all_count_amt24==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt24)%><%}%></td>							  
										<td align='center'><%if(all_count_amt36==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt36)%><%}%></td>							  
										<td align='center'><%if(all_count_amt48==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt48)%><%}%></td>							  
										<td align='center'><%if(all_count_amt99==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt99)%><%}%></td>							  
										<td align='center'><%if(all_count_amt==0){%>-<%}else{%><%=AddUtil.parseDecimal(all_count_amt)%><%}%></td>
									</tr>
									<tr> 
										<td align='center' style="height:23px;"><%if(all_count_amt6==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt6/all_count_amt*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_amt12==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt12/all_count_amt*100+"",1)%>%<%}%></td>						
										<td align='center'><%if(all_count_amt24==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt24/all_count_amt*100+"",1)%>%<%}%></td>						  
										<td align='center'><%if(all_count_amt36==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt36/all_count_amt*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_amt48==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt48/all_count_amt*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_amt99==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt99/all_count_amt*100+"",1)%>%<%}%></td>
										<td align='center'><%if(all_count_amt==0){%>0.0%<%}else{%><%=AddUtil.calcMath("ROUND",all_count_amt/all_count_amt*100+"",1)%>%<%}%></td>
									</tr>
								
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