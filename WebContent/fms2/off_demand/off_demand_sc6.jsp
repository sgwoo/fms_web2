<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String gubun = "";
	
	//당기
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4)))+"0101"; //마감년도1월
	String ref_dt2 = save_dt; //마감기준일
	
	Vector vt1 = dm_db.getOffDemandStat6("1", ref_dt1, ref_dt2);		
	int vt1_size = vt1.size();
	
	Vector vt2 = dm_db.getOffDemandStat6("2", ref_dt1, ref_dt2);		
	int vt2_size = vt2.size();	
	
	//전기 
	String ref_dt3 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-1)+"0101"; //마감전년도1월
	String ref_dt4 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-1)+save_dt.substring(5); //마감전년도기준일
	
	Vector vt3 = dm_db.getOffDemandStat6("1", ref_dt3, ref_dt4);		
	int vt3_size = vt3.size();
	
	Vector vt4 = dm_db.getOffDemandStat6("2", ref_dt3, ref_dt4);		
	int vt4_size = vt4.size();
		
	//당기
	int h_cnt1[]	 		= new int[8];
	int h_amt1[]	 		= new int[8];
	float p_cnt1[]	 		= new float[8];
	float p_amt1[]	 		= new float[8];
	//전기
	int h_cnt2[]	 		= new int[8];
	int h_amt2[]	 		= new int[8];
	float p_cnt2[]	 		= new float[8];
	float p_amt2[]	 		= new float[8];
	//전기대비
	int h_cnt3[]	 		= new int[6];
	int h_amt3[]	 		= new int[6];
	int h_cnt4[]	 		= new int[6];
	int h_amt4[]	 		= new int[6];
	int h_cnt5[]	 		= new int[6];
	int h_amt5[]	 		= new int[6];
	float p_cnt5[]	 		= new float[6];
	float p_amt5[]	 		= new float[6];
		
	for(int i=0;i<vt1_size;i++){
		Hashtable ht = (Hashtable)vt1.elementAt(i);		
		for(int k = 1 ; k < 7 ; k++){
			h_cnt1[k] = h_cnt1[k] + AddUtil.parseInt((String)ht.get("CNT"+(k)));	
			h_amt1[k] = h_amt1[k] + AddUtil.parseInt((String)ht.get("AMT"+(k)));
		}
		int i_cnt7 = AddUtil.parseInt((String)ht.get("CNT1"))+AddUtil.parseInt((String)ht.get("CNT2"))+AddUtil.parseInt((String)ht.get("CNT3"))+AddUtil.parseInt((String)ht.get("CNT4"))+AddUtil.parseInt((String)ht.get("CNT5"))+AddUtil.parseInt((String)ht.get("CNT6"));
		int i_amt7 = AddUtil.parseInt((String)ht.get("AMT1"))+AddUtil.parseInt((String)ht.get("AMT2"))+AddUtil.parseInt((String)ht.get("AMT3"))+AddUtil.parseInt((String)ht.get("AMT4"))+AddUtil.parseInt((String)ht.get("AMT5"))+AddUtil.parseInt((String)ht.get("AMT6"));
		h_cnt1[7] = h_cnt1[7]+i_cnt7;
		h_amt1[7] = h_amt1[7]+i_amt7;
		//1,2,3 (신차,재리스,연장)
		//h_cnt3[i+1] = AddUtil.parseInt((String)ht.get("CNT7"));
		//h_amt3[i+1] = AddUtil.parseInt((String)ht.get("AMT7"));
		h_cnt3[i+1] = i_cnt7;
		h_amt3[i+1] = i_amt7;
		//5 (합계)
		//h_cnt3[5] = h_cnt3[5] + AddUtil.parseInt((String)ht.get("CNT7"));
		//h_amt3[5] = h_cnt3[5] + AddUtil.parseInt((String)ht.get("AMT7"));
		h_cnt3[5] = h_cnt3[5] + i_cnt7;
		h_amt3[5] = h_cnt3[5] + i_amt7;
	}	
	for(int i=0;i<vt2_size;i++){
		Hashtable ht = (Hashtable)vt2.elementAt(i);												
		h_cnt1[1] = h_cnt1[1] + AddUtil.parseInt((String)ht.get("CNT"));	
		h_amt1[1] = h_amt1[1] + AddUtil.parseInt((String)ht.get("AMT"));
		h_cnt1[7] = h_cnt1[7] + AddUtil.parseInt((String)ht.get("CNT"));	
		h_amt1[7] = h_amt1[7] + AddUtil.parseInt((String)ht.get("AMT"));
		//4 (월렌트)
		h_cnt3[vt1_size+1] = AddUtil.parseInt((String)ht.get("CNT"));
		h_amt3[vt1_size+1] = AddUtil.parseInt((String)ht.get("AMT"));
		//5 (합계)
		h_cnt3[5] = h_cnt3[5] + AddUtil.parseInt((String)ht.get("CNT"));
		h_amt3[5] = h_cnt3[5] + AddUtil.parseInt((String)ht.get("AMT"));
	}	
	
	for(int i=0;i<vt3_size;i++){
		Hashtable ht = (Hashtable)vt3.elementAt(i);		
		for(int k = 1 ; k < 7 ; k++){
			h_cnt2[k] = h_cnt2[k] + AddUtil.parseInt((String)ht.get("CNT"+(k)));	
			h_amt2[k] = h_amt2[k] + AddUtil.parseInt((String)ht.get("AMT"+(k)));
		}
		int i_cnt7 = AddUtil.parseInt((String)ht.get("CNT1"))+AddUtil.parseInt((String)ht.get("CNT2"))+AddUtil.parseInt((String)ht.get("CNT3"))+AddUtil.parseInt((String)ht.get("CNT4"))+AddUtil.parseInt((String)ht.get("CNT5"))+AddUtil.parseInt((String)ht.get("CNT6"));
		int i_amt7 = AddUtil.parseInt((String)ht.get("AMT1"))+AddUtil.parseInt((String)ht.get("AMT2"))+AddUtil.parseInt((String)ht.get("AMT3"))+AddUtil.parseInt((String)ht.get("AMT4"))+AddUtil.parseInt((String)ht.get("AMT5"))+AddUtil.parseInt((String)ht.get("AMT6"));
		h_cnt2[7] = h_cnt2[7]+i_cnt7;
		h_amt2[7] = h_amt2[7]+i_amt7;
		//1,2,3 (신차,재리스,연장)
		//h_cnt4[i+1] = AddUtil.parseInt((String)ht.get("CNT7"));
		//h_amt4[i+1] = AddUtil.parseInt((String)ht.get("AMT7"));
		h_cnt4[i+1] = i_cnt7;
		h_amt4[i+1] = i_amt7;
		//5 (합계)
		//h_cnt4[5] = h_cnt4[5] + AddUtil.parseInt((String)ht.get("CNT7"));
		//h_amt4[5] = h_cnt4[5] + AddUtil.parseInt((String)ht.get("AMT7"));
		h_cnt4[5] = h_cnt4[5] + i_cnt7;
		h_amt4[5] = h_cnt4[5] + i_amt7;
	}	
	for(int i=0;i<vt4_size;i++){
		Hashtable ht = (Hashtable)vt4.elementAt(i);												
		h_cnt2[1] = h_cnt2[1] + AddUtil.parseInt((String)ht.get("CNT"));	
		h_amt2[1] = h_amt2[1] + AddUtil.parseInt((String)ht.get("AMT"));
		h_cnt2[7] = h_cnt2[7] + AddUtil.parseInt((String)ht.get("CNT"));	
		h_amt2[7] = h_amt2[7] + AddUtil.parseInt((String)ht.get("AMT"));
		//4 (월렌트)
		h_cnt4[vt1_size+1] = AddUtil.parseInt((String)ht.get("CNT"));
		h_amt4[vt1_size+1] = AddUtil.parseInt((String)ht.get("AMT"));
		//5 (합계)
		h_cnt4[5] = h_cnt4[5] + AddUtil.parseInt((String)ht.get("CNT"));
		h_amt4[5] = h_cnt4[5] + AddUtil.parseInt((String)ht.get("AMT"));		
	}	
		
	//전기대비 대수,계약고 건수
	for(int k = 1 ; k < 5 ; k++){
		h_cnt5[k] =  h_cnt3[k] - h_cnt4[k];
		h_amt5[k] =  h_amt3[k] - h_amt4[k];
	}
	h_cnt5[5] =  h_cnt5[1] + h_cnt5[2] + h_cnt5[3] + h_cnt5[4];
	h_amt5[5] =  h_amt5[1] + h_amt5[2] + h_amt5[3] + h_amt5[4];
	//전기대비 대수,계약고 성장율
	for(int k = 1 ; k < 6 ; k++){
		p_cnt5[k] = (float)h_cnt3[k]/(float)h_cnt4[k]*100;
		p_amt5[k] = (float)h_amt3[k]/(float)h_amt4[k]*100;
	}	


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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약(대여개시)현황 (<%=AddUtil.ChangeDate2(ref_dt1) %>~<%=ref_dt2 %>)</span></td>
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
										<td class='title' colspan='3'>구분</td>
										<td class='title' width:100px;" style="height:35px;">6개월이내</td>
										<td class='title' width:100px;">7~12개월</td>
										<td class='title' width:100px;">13~24개월</td>		  
										<td class='title' width:100px;">25~36개월</td>
										<td class='title' width:100px;">37~48개월</td>
										<td class='title' width:100px;">48개월이상</td>										
										<td class='title' width:100px;">합계</td>
									</tr>
									<%for(int i=0;i<vt1_size;i++){
										Hashtable ht = (Hashtable)vt1.elementAt(i);		
										
										int i_cnt7 = AddUtil.parseInt((String)ht.get("CNT1"))+AddUtil.parseInt((String)ht.get("CNT2"))+AddUtil.parseInt((String)ht.get("CNT3"))+AddUtil.parseInt((String)ht.get("CNT4"))+AddUtil.parseInt((String)ht.get("CNT5"))+AddUtil.parseInt((String)ht.get("CNT6"));
										int i_amt7 = AddUtil.parseInt((String)ht.get("AMT1"))+AddUtil.parseInt((String)ht.get("AMT2"))+AddUtil.parseInt((String)ht.get("AMT3"))+AddUtil.parseInt((String)ht.get("AMT4"))+AddUtil.parseInt((String)ht.get("AMT5"))+AddUtil.parseInt((String)ht.get("AMT6"));
									%>
									<tr>
											<td class='title' rowspan='4' width:100px;><%=ht.get("CAR_GU")%></td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT1")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT2")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT3")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT4")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT5")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT6")+"")%></td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(i_cnt7)%><%//=AddUtil.parseDecimal(ht.get("CNT7")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P1")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P2")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P3")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P4")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P5")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P6")%>%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>		
									<tr>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT1")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT2")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT3")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT4")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT5")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT6")+"")%></td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(i_amt7)%><%//=AddUtil.parseDecimal(ht.get("AMT7")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P1")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P2")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P3")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P4")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P5")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P6")%>%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>								
									<%}%>
									<%for(int i=0;i<vt2_size;i++){
										Hashtable ht = (Hashtable)vt2.elementAt(i);												
									%>
									<tr>
											<td class='title' rowspan='4' width:100px;>월렌트</td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;">100%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>		
									<tr>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;">100%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>								
									<%}%>	
									
									<tr>
											<td class='title' rowspan='4' width:100px;>합계</td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<%for(int k = 1 ; k < 7 ; k++){%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_cnt1[k]+"")%></td>
											<%} %>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_cnt1[7]+"")%></td>
									</tr>		
									<tr>																						
											<%for(int k = 1 ; k < 7 ; k++){
												p_cnt1[k] = (float)h_cnt1[k]/(float)h_cnt1[7]*100;
											%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_cnt1[k]+"",1) %>%</td>
											<%} %>
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>		
									<tr>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<%for(int k = 1 ; k < 7 ; k++){%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_amt1[k]+"")%></td>
											<%} %>	
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_amt1[7]+"")%></td>
									</tr>		
									<tr>																						
											<%for(int k = 1 ; k < 7 ; k++){
												p_amt1[k] = (float)h_amt1[k]/(float)h_amt1[7]*100;
											%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_amt1[k]+"",1) %>%</td>
											<%} %>					
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>																		
								</table>
								</td>
							</tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전기(동기간) 대비현황</span></td>
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
										<td class='title' colspan='3'>구분</td>
										<td class='title' width:150px;" style="height:35px;">신차</td>
										<td class='title' width:150px;">재리스</td>
										<td class='title' width:150px;">연장</td>		  
										<td class='title' width:150px;">월렌트</td>
										<td class='title' width:100px;">합계</td>
									</tr>		
									<tr>
											<td class='title' rowspan='2' width:100px;>대수</td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수(성장)</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">성장율</div>
												</div>
											</td>
											<%for(int k = 1 ; k < 5 ; k++){%>
											<td style="height:35px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(h_cnt5[k]+"")%></td>
											<%} %>		
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_cnt5[5]+"")%></td>									
									</tr>		
									<tr>																						
											<%for(int k = 1 ; k < 5 ; k++){%>
											<td style="height:35px;width:150px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_cnt5[k]+"",1) %>%</td>
											<%} %>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_cnt5[5]+"",1) %>%</td>
									</tr>		
									<tr>
											<td class='title' rowspan='2' width:100px;>계약고</td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고()성장)</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">성장율</div>
												</div>
											</td>
											<%for(int k = 1 ; k < 5 ; k++){%>
											<td style="height:35px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(h_amt5[k]+"")%></td>
											<%} %>		
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_amt5[5]+"")%></td>										
									</tr>		
									<tr>																						
											<%for(int k = 1 ; k < 5 ; k++){%>
											<td style="height:35px;width:150px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_amt5[k]+"",1) %>%</td>
											<%} %>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_amt5[5]+"",1) %>%</td>
									</tr>	
																							
								</table>
								</td>
							</tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전기 계약현황 (<%=AddUtil.ChangeDate2(ref_dt3) %>~<%=AddUtil.ChangeDate2(ref_dt4) %>)</span></td>
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
										<td class='title' colspan='3'>구분</td>
										<td class='title' width:100px;" style="height:35px;">6개월이내</td>
										<td class='title' width:100px;">7~12개월</td>
										<td class='title' width:100px;">13~24개월</td>		  
										<td class='title' width:100px;">25~36개월</td>
										<td class='title' width:100px;">37~48개월</td>
										<td class='title' width:100px;">48개월이상</td>										
										<td class='title' width:100px;">합계</td>
									</tr>
									<%for(int i=0;i<vt3_size;i++){
										Hashtable ht = (Hashtable)vt3.elementAt(i);		
										
										int i_cnt7 = AddUtil.parseInt((String)ht.get("CNT1"))+AddUtil.parseInt((String)ht.get("CNT2"))+AddUtil.parseInt((String)ht.get("CNT3"))+AddUtil.parseInt((String)ht.get("CNT4"))+AddUtil.parseInt((String)ht.get("CNT5"))+AddUtil.parseInt((String)ht.get("CNT6"));
										int i_amt7 = AddUtil.parseInt((String)ht.get("AMT1"))+AddUtil.parseInt((String)ht.get("AMT2"))+AddUtil.parseInt((String)ht.get("AMT3"))+AddUtil.parseInt((String)ht.get("AMT4"))+AddUtil.parseInt((String)ht.get("AMT5"))+AddUtil.parseInt((String)ht.get("AMT6"));
									%>
									<tr>
											<td class='title' rowspan='4' width:100px;><%=ht.get("CAR_GU")%></td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT1")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT2")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT3")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT4")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT5")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT6")+"")%></td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(i_cnt7)%><%//=AddUtil.parseDecimal(ht.get("CNT7")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P1")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P2")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P3")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P4")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P5")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("CNT_P6")%>%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>		
									<tr>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT1")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT2")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT3")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT4")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT5")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT6")+"")%></td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(i_amt7)%><%//=AddUtil.parseDecimal(ht.get("AMT7")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P1")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P2")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P3")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P4")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P5")%>%</td>
											<td style="height:35px;width:100px;text-align:center;"><%=ht.get("AMT_P6")%>%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>								
									<%}%>
									<%for(int i=0;i<vt4_size;i++){
										Hashtable ht = (Hashtable)vt4.elementAt(i);												
									%>
									<tr>
											<td class='title' rowspan='4' width:100px;>월렌트</td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("CNT")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;">100%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>		
									<tr>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT")+"")%></td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>
											<td style="height:35px;width:100px;text-align:center;">0</td>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("AMT")+"")%></td>
									</tr>		
									<tr>																						
											<td style="height:35px;width:100px;text-align:center;">100%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>
											<td style="height:35px;width:100px;text-align:center;">0%</td>											
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>								
									<%}%>	
									
									<tr>
											<td class='title' rowspan='4' width:100px;>합계</td>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">건수</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<%for(int k = 1 ; k < 7 ; k++){%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_cnt2[k]+"")%></td>
											<%} %>											
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_cnt2[7]+"")%></td>
									</tr>		
									<tr>																						
											<%for(int k = 1 ; k < 7 ; k++){
												p_cnt2[k] = (float)h_cnt2[k]/(float)h_cnt2[7]*100;
											%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_cnt2[k]+"",1) %>%</td>
											<%} %>
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>		
									<tr>
											<td align='center' style='width:200px; height:35px;' rowspan="2" class="title" colspan='2'>
												<div style="height: 53px;">
													<div style="border-image: none; height: 21px; padding-top: 8px;">계약고</div>
													<div style="border-image: none; width: 100px; height: 22px; float: left;"></div>
													<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 100px; height: 22px; padding-top: 8px; float: right;">점유비</div>
												</div>
											</td>
											<%for(int k = 1 ; k < 7 ; k++){%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_amt2[k]+"")%></td>
											<%} %>	
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.parseDecimal(h_amt2[7]+"")%></td>
									</tr>		
									<tr>																						
											<%for(int k = 1 ; k < 7 ; k++){
												p_amt2[k] = (float)h_amt2[k]/(float)h_amt2[7]*100;
											%>
											<td style="height:35px;width:100px;text-align:center;"><%=AddUtil.calcMath("ROUND",p_amt2[k]+"",1) %>%</td>
											<%} %>					
											<td style="height:35px;width:100px;text-align:center;">100%</td>
									</tr>																		
								</table>
								</td>
							</tr>																				
							
  </table>
</form>
</body>
</html>
