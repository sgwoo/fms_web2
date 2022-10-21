<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
		
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-5)+"0101"; //마감기준일-4년전
	String ref_dt2 = save_dt; //마감기준일
	
	//보유대수
	Vector vt1 = dm_db.getOffDemandStat2("1", ref_dt1, ref_dt2);		
	int vt1_size = vt1.size();	
	
	//계약고-상품별영업효율
	Vector vt2 = dm_db.getOffDemandStat2("2", ref_dt1, ref_dt2);		
	int vt2_size = vt2.size();	
	
	//매출액-영업현황변수
	Vector vt3 = dm_db.getOffDemandVarStat("demand_sc2.s_amt", ref_dt1, ref_dt2);		
	int vt3_size = vt3.size();	
	
	int cnt1[]	 		= new int[6];
	int cnt2[]	 		= new int[6];
	int cnt3[]	 		= new int[6];
	int cnt4[]	 		= new int[6];
	float cnt5[]	 	= new float[6];
	int cnt6[]	 		= new int[6];
	
	for(int i = 0 ; i < vt1_size ; i++){
		Hashtable ht = (Hashtable)vt1.elementAt(i);
		cnt1[i] = AddUtil.parseInt((String)ht.get("CNT"));
	}
	
	for(int i = 0 ; i < vt2_size ; i++){
		Hashtable ht = (Hashtable)vt2.elementAt(i);
		cnt6[i] = AddUtil.parseInt((String)ht.get("CNT"));
		if(i==(vt2_size-1) && !ref_dt2.substring(5,7).equals("12")){
			cnt6[i] = cnt6[i]/AddUtil.parseInt(ref_dt2.substring(5,7));
		}else{
			cnt6[i] = cnt6[i]/12;
		}
	}	
	
/*	
	int s_amt_2017 = 139048;
	int s_amt_2018 = 148753;
	int s_amt_2019 = 153100;
	int s_amt_2020 = 164905;
	int s_amt_2021 = 139938; //2021년9월
	
	if(save_dt.equals("2021-10-31")){
		s_amt_2021 = 139938;
	}
*/

	for(int k = 0 ; k < 6 ; k++){
		cnt4[k] = 0;
	}

	for(int i = 0 ; i < vt3_size ; i++){
		Hashtable ht = (Hashtable)vt3.elementAt(i);
		cnt4[i+1] = AddUtil.parseInt((String)ht.get("VAR_CD"));
	}
	
	//매출액
	/*
	cnt4[1] = s_amt_2017; 
	cnt4[2] = s_amt_2018;
	cnt4[3] = s_amt_2019;
	cnt4[4] = s_amt_2020;
	cnt4[5] = s_amt_2021;
	*/
	
	for(int k = 1 ; k < 6 ; k++){
		cnt2[k] = cnt1[k]-cnt1[k-1];
		cnt3[k] = (cnt1[k]+cnt1[k-1])/2;
		cnt5[k] = (float)cnt4[k]/(float)cnt3[k];
	}
		
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//변수관리
function pop_var(st){
	var fm = document.form1;
	fm.var_id.value = st;
	fm.action = 'off_demand_var.jsp';
	fm.target = '_blank';
	fm.submit();
}	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='off_demand_sc3.jsp' method='post' target='t_content'>
<input type="hidden" name="var_id" value="">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
  <table border="0" cellspacing="0" cellpadding="0" width=1014>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사업용자동차 보유현황</span></td>
	  </tr>
    <tr>
        <td align=right>(단위:대, 백만원)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line'> 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td  class='title' style="height:35px;" width:264px;">구분</td>
										<%for (int j = AddUtil.parseInt(save_dt.substring(0,4))-4 ; j <= AddUtil.parseInt(save_dt.substring(0,4)) ; j++){%>
										<td  class='title'  width:100px;">
											<%	if(j==AddUtil.parseInt(save_dt.substring(0,4)) && !save_dt.substring(5,7).equals("12")){%>
												<%=j%>년(<%=AddUtil.ChangeDate(AddUtil.replace(save_dt,"-",""),"MM월DD일")%>)
											<%}else{%>
												<%=j%>년
											<%}%>
										</td>
										<%} %>										
									</tr>
									<tr>
										<td class='title' style="height:75px;" width:164px;" rowspan='3'>
										    <div>
												<div style="border-image: none; height: 25px; padding-top: 8px;">보유대수</div>												
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 200px; height: 25px; padding-top: 8px; float: right;">전년대비증가대수</div>												
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 200px; height: 25px; padding-top: 8px; float: right;">당기평균보유대수</div>												
											</div>
										</td>	
										<%for(int k = 1 ; k < 6 ; k++){ %>									
										<td style="height:25px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(cnt1[k]) %></td>
										<%} %>																														
									</tr>
									<tr>
										<%for(int k = 1 ; k < 6 ; k++){ %>									
										<td style="height:25px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(cnt2[k]) %></td>
										<%} %>	
									</tr>									
									<tr>
										<%for(int k = 1 ; k < 6 ; k++){ %>									
										<td style="height:25px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(cnt3[k]) %></td>
										<%} %>
									</tr>	
									<tr>
										<td class='title' style="height:75px;" width:164px;" rowspan='3'>
										    <div>
												<div style="border-image: none; height: 25px; padding-top: 8px;">매출액</div>												
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 200px; height: 25px; padding-top: 8px; float: right;">보유대당 년간매출</div>												
												<div style="border-width: 1px 0px 0px 1px; border-style: solid; border-color: rgba(175, 185, 235, 1); border-image: none; width: 200px; height: 25px; padding-top: 8px; float: right;">월평균 계약고</div>												
											</div>
										</td>										
										<%for(int k = 1 ; k < 6 ; k++){ %>									
										<td style="height:25px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(cnt4[k]) %></td>
										<%} %>
									</tr>
									<tr>
										<%for(int k = 1 ; k < 6 ; k++){ %>									
										<td style="height:25px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(cnt5[k]) %></td>
										<%} %>
									</tr>									
									<tr>
										<%for(int k = 1 ; k < 6 ; k++){ %>									
										<td style="height:25px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(cnt6[k]) %>억원</td>
										<%} %>
									</tr>						
								</table>
								</td>
							</tr>

    <tr>
        <td align=right> </td>
    </tr>							
    <tr>
        <td align=right> </td>
    </tr>							
    <tr>
        <td align=right> </td>
    </tr>							
    <tr>
        <td align=right> </td>
    </tr>							
    <tr>
        <td align=right>※ 매출액은 더존프로그램 재무재표를 보고 입력하십시오. &nbsp;<input type="button" class="button" value="매출액관리" onclick="javascript:pop_var('demand_sc2.s_amt');"></td>
    </tr>							
  </table>
</form>
</body>
</html>
