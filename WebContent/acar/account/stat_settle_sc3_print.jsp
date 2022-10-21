<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.estimate_mng.*, acar.account.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate.js'></script>
<script language='javascript'>
<!--
	//수금 스케줄 리스트 이동
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '7';
		fm.gubun2.value = '2';
		fm.gubun3.value = '3';	
		fm.gubun4.value = '';			
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/acar/settle_acc/settle_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>

<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0001":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	float dly_per1 = 0;
	float dly_per2 = 0;
	float per_0405 = 0;
	float  per1 = 0;
	String per2 = "";
	float sum_tot_amt1 = 0, sum_tot_amt2 = 0 ;
	float a_per1 = 0;
	float a_avg_per = 0;
	float a_cmp_per = 0;
	int cnt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//계산식 변수
	String var1 = e_db.getEstiSikVarCase("1", "", "dly_bus1");
	String var2 = e_db.getEstiSikVarCase("1", "", "dly_bus2");
	
	
	String var3 = e_db.getEstiSikVarCase("1", "", "dly2_bus3");
	String var4 = e_db.getEstiSikVarCase("1", "", "dly2_bus4");
	String var5 = e_db.getEstiSikVarCase("1", "", "dly2_bus5");
	String var6 = e_db.getEstiSikVarCase("1", "", "dly2_bus6");
	String var7 = e_db.getEstiSikVarCase("1", "", "dly2_bus7");
	String var10 = e_db.getEstiSikVarCase("1", "", "dly2_bus10");
	String var11 = e_db.getEstiSikVarCase("1", "", "dly2_bus11");
	String var12 = e_db.getEstiSikVarCase("1", "", "dly2_bus12");
	
	//연체율 그래픽
	Vector feedps = st_db.getStatSettle("2", save_dt, var12, var7);
	int feedp_size = feedps.size();	
	
	int sum_tot_amt6 = 0, sum_tot_amt7 = 0 ;
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='dept_id' value='<%=dept_id%>'>
<input type='hidden' name='size' value='<%=feedp_size%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<input type='hidden' name='size2' value=''>
<input type='hidden' name='max_i' value=''>

<table width="900" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5>채권관리캠페인(2군)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

  <tr> 
    <td class="line">          
      <TABLE align=center border=0 width=100% cellspacing=1 cellpadding=0>
                <tr> 
                    <td colspan="2" class="title">담당자</TD>
                    <td class="title">당일연체율</TD>
                    <td class="title">평균연체율</TD>
                    <td class="title">적용연체율</TD>					
                    <td>
                      <table width=100% border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td class="title_p" style='text-align:right' width="100">1</td>
                          <td class="title_p" style='text-align:right' width="100">2</td>
                          <td class="title_p" style='text-align:right' width="100">3</td>
                          <td class="title_p" style='text-align:right' width="100">4</td>                          
                        </tr>
                      </table>
                    </TD>
                    <td colspan="2" class="title">담당자별 보너스</td>
                </tr>
	  
          <%if(feedp_size > 0){
			  	String tot_dly_amt = "0";
			  
				if(save_dt.equals("")){
					tot_dly_amt = st_db.getStatSettleAmt("d");//당일연체총액
				}
				
				for (int i = 0 ; i < feedp_size ; i++){
					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
					
					if(feedp.getTot_su6().equals("")) feedp.setTot_su7(feedp.getTot_su3());
					
					dly_per1 = Float.parseFloat(feedp.getTot_su7())*100;
					
					if(feedp.getTot_su4().equals("")){
						dly_per2 = Float.parseFloat(feedp.getTot_amt2())/Float.parseFloat(tot_dly_amt)*100;
						per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
					}else{
						per2 = feedp.getTot_su4();
					}
					
					if(dly_per1 > 400) dly_per1=400;
					
					if(feedp.getGubun().equals("000003") || feedp.getGubun().equals("000004") || feedp.getGubun().equals("000005")){
						cnt = cnt+1;
						continue;
					}
					
					//합계
					sum_tot_amt1 += Float.parseFloat(feedp.getTot_amt1());
					sum_tot_amt2 += Float.parseFloat(feedp.getTot_amt2());
					sum_tot_amt6 += AddUtil.parseInt(feedp.getTot_amt6());
					sum_tot_amt7 += AddUtil.parseInt(feedp.getTot_amt7());
					
					//평균
					a_per1 		+= Float.parseFloat(feedp.getTot_su3()==null?"0":feedp.getTot_su3());
					a_avg_per 	+= Float.parseFloat(feedp.getTot_su6()==null?"0":feedp.getTot_su6());
					a_cmp_per 	+= Float.parseFloat(feedp.getTot_su7()==null?"0":feedp.getTot_su7());
					
					%>
          <TR> 
            <TD style='background-color:e2fff8' align=center width="58"><a href="javascript:list_move('<%=feedp.getGubun()%>');"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a> 
              <input type='hidden' name='dept_id' value='<%=feedp.getDept_id()%>'>
			  <input type='hidden' name='brch_id' value='<%=feedp.getBr_id()%>'>
			  <input type='hidden' name='br_id' value='<%=feedp.getBr_id()%>'></TD>
            <TD style='background-color:e2fff8' align=center width="57"><%=feedp.getPartner_nm()%></TD>
            <TD align="center" width="75">
            <input type="text" name="per1" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su3(),3)%>" size="4" class="whitenum">
              %</TD>
            <TD align="center" width="75">
            <input type="text" name="avg_per" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su6(),3)%>" size="4" class="whitenum">
              %</TD>
            <TD align="center" width="75">
            <input type="text" name="cmp_per" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su7(),3)%>" size="4" class="whitenum">
              %</TD>
            <TD width="402">
           <!-- <img src=../../images/result1.gif width=<%=Float.toString(dly_per1).substring(0,Float.toString(dly_per1).indexOf("."))%> height=10> -->
            <img src=../../images/result1.gif width=<%=dly_per1*4%>% height=10>
            <%if(AddUtil.parseInt(feedp.getTot_su5())>100){%>&nbsp;&nbsp;내근직할증률:<%}%><input type="text" name="cont" value="<%=feedp.getTot_su5()%>" size="3" class="whitenum"><%if(AddUtil.parseInt(feedp.getTot_su5())>100){%>%<%}%></TD>
            <TD align="right" width="79"><input type="text" name="b_amt_out" value="<%= AddUtil.parseDecimal(feedp.getTot_amt4()) %>" size="8" class="whitenum">
              <%if(AddUtil.parseInt(feedp.getTot_amt6())>0){%><br><font color='red'><%= AddUtil.parseDecimal(feedp.getTot_amt6()) %></font><%}%>     
            </TD>	
            <TD align="right" width="79"><input type="text" name="b_amt_in" value="<%= AddUtil.parseDecimal(feedp.getTot_amt5()) %>" size="8" class="whitenum"></TD>			  
          </TR>
          <input type='hidden' name='tot_fee_amt' value='<%=feedp.getTot_amt1()%>'>
		  <input type='hidden' name='three_amt' value='<%=feedp.getTot_amt3()%>'>		  
		  <input type='hidden' name='bus_nm' value='<%=c_db.getNameById(feedp.getGubun(), "USER")%>'>
		  <input type='hidden' name='per_0405' value='<%=AddUtil.parseFloatCipher(feedp.getTot_su5(),2)%>'>
		  <input type='hidden' name='per_cha' value=''>
		  <input type='hidden' name='partner_id' value='<%=feedp.getPartner_id()%>'>
		  <input type='hidden' name='bus_id2' value='<%=feedp.getGubun()%>'>
          <%	}%>
          <TR> 
                    <TD colspan="2" class="title">평균</TD>
                    <TD class="title"><input type="text" name="a_per1" value="" size="4" class="whitenum">
%</TD>
                    <TD class="title"><input type="text" name="a_avg_per" value="" size="4" class="whitenum">
%</TD>
                    <TD class="title"><input type="text" name="a_cmp_per" value="" size="4" class="whitenum">
%</TD>		  
            <TD class="title" style='text-align:right'>합계 : 
              <input type="text" name="tot_amt" value="" size="10" class="whitenum">원 </TD>
            <TD class="title" style='text-align:right'><input type="text" name="tot_amt_out" value="" size="9" class="whitenum">원 </TD>
            <TD class="title" style='text-align:right'><input type="text" name="tot_amt_in" value="" size="9" class="whitenum">원 </TD>			  
          </TR>
          
          <%	}else{%>
          <TR class="title"> 
            <TD colspan="8">등록된 자료가 없습니다.</TD>
          </TR>
          <%}%>
        </TABLE>
    </td>
  </tr>
</table>
</form>

<script language='javascript'>
<!--


document.form1.a_per1.value 	 = '<%= AddUtil.parseFloatCipher2(a_per1/feedp_size, 3) %>';
document.form1.a_avg_per.value 	 = '<%= AddUtil.parseFloatCipher2(a_avg_per/feedp_size, 3) %>';
document.form1.a_cmp_per.value 	 = '<%= AddUtil.parseFloatCipher2(a_cmp_per/feedp_size, 3) %>';

//view_g2();
//view_max_cha();
view_sum_amt();

//영업팀채권캠페인	
function view_g2(){

	var fm = document.form1;	
	var size = toInt(fm.size.value)-<%=cnt%>;
//	var tot_dly_per=<%= AddUtil.parseFloatCipher2(sum_tot_amt2/sum_tot_amt1*100, 3) %>;
	var tot_dly_per = <%= AddUtil.parseFloatCipher2(a_cmp_per/feedp_size, 3) %>;		
	var amt;
	var est_amt;
	var b_amt=0, b_amt_out=0, b_amt_in=0;
	var tot_amt=0, tot_amt_out=0, tot_amt_in=0;	

	//계산값 구하기 ------------------------------------------------------------
//	var v_amt=0, s_amt=0;
	var v_amt=0, s_amt=0, s_tot_amt=<%= var7 %>;//s_tot_amt:받을어음 총액 제한
	
	//최대부서평균연체율-변수로 설정한다.
	max_tot_dly_per = <%= var1 %>;	
	if(max_tot_dly_per < tot_dly_per){
		tot_dly_per = max_tot_dly_per;
	}
		
	for(i=0; i<size ; i++){	
		//부서평균연체율 이상인 사원 연체금액 합계
		if(toFloat(tot_dly_per) >= toFloat(fm.cmp_per[i].value)){
			v_amt = v_amt + ((toFloat(tot_dly_per) - toFloat(fm.cmp_per[i].value)) * toFloat(fm.tot_fee_amt[i].value));
		}		
	}

	//포상금 계산 단가 구하기
	s_amt = v_amt / ((<%=var5%>-tot_dly_per)*<%=var4%>);	
	amt = toInt(s_amt);			
	//포상금 계산 단가 구하기
//	s_amt = <%= var2 %>;	
//	amt = toInt(s_amt);		
	
	//--------------------------------------------------------------------------

	
	//포상금 계산하기
	for(i=0; i<size ; i++){	
		
		if(amt > 0){
			//개인별총받을어음 기준
			//if(fm.br_id[i].value == 'S1'){
				est_amt = toFloat(fm.tot_fee_amt[i].value);
			//}else{
			//	est_amt = toFloat(fm.three_amt[i].value);			/*20080414 부산,대전지점 3개월받을어음으로 계산*/
			//}	
			
			//개인별 포상금 계산 =(부서평균연체율 - 본인연체율) * 개인별총대여료 / 2백만원;								
			//if(toFloat(fm.tot_fee_amt[i].value) >= s_tot_amt){
			//	b_amt = (toFloat(tot_dly_per) - toFloat(fm.cmp_per[i].value)) * est_amt / amt;
			//}else{ 
			//	b_amt = 0; 
			//}
			
			//개인별 포상금 계산
			b_amt = (toFloat(tot_dly_per) - toFloat(fm.cmp_per[i].value)) * toFloat(fm.tot_fee_amt[i].value) / amt;
		}

		var std_amt = 80000;
		var user_per1=<%=var10%>;
		var user_per2=<%=var11%>;

					
		if(fm.partner_id[i].value == ''){
			user_per2 	= 0;
		}
					
	
		if(b_amt <= 0){//포상금이 없으면
			fm.b_amt_out[i].value 		= 0; 
			fm.b_amt_in[i].value 		= 0; 				
		}else if(b_amt > 0 && b_amt < std_amt){//포상금이 8만원이하일때
			//if(fm.br_id[i].value == 'S1' || fm.br_id[i].value == 'B1'){
				//fm.b_amt_out[i].value 	= std_amt;
				//fm.b_amt_in[i].value 	= 0;
			//}else{
				fm.b_amt_out[i].value 	= th_rnd(std_amt*user_per1);
				fm.b_amt_in[i].value 	= th_rnd(std_amt*user_per2);
			//}
		}else if(b_amt > std_amt){
			b_amt = th_rnd(b_amt);
			if(b_amt < std_amt)		b_amt = std_amt;
			//if(fm.br_id[i].value == 'S1' || fm.br_id[i].value == 'B1'){
			//	fm.b_amt_out[i].value 	= b_amt;
			//	fm.b_amt_in[i].value 	= 0;
			//}else{
				fm.b_amt_out[i].value 	= th_rnd(b_amt*user_per1);
				fm.b_amt_in[i].value 	= th_rnd(b_amt*user_per2);
			//}								
		}
			
		tot_amt_out 	= tot_amt_out + toInt(fm.b_amt_out[i].value);
		tot_amt_in 		= tot_amt_in + toInt(fm.b_amt_in[i].value);
		tot_amt 		= tot_amt + (toInt(fm.b_amt_out[i].value)+toInt(fm.b_amt_in[i].value));			
		
		fm.b_amt_out[i].value 	= parseDecimal(fm.b_amt_out[i].value)+"원";
		fm.b_amt_in[i].value 	= parseDecimal(fm.b_amt_in[i].value)+"원";
	}		

	fm.size2.value = size;
	
	//미포상자중 노력상 계산하기-----------------------------------------------------------------------
	var max_cha = -99.00;
	var max_i = 0;	
	var min_i = 0;
	for(i=0; i<size ; i++){	
		fm.per_cha[i].value = parseFloatCipher3(toFloat(fm.per_0405[i].value)-toFloat(fm.cmp_per[i].value),3);
		//연체율 하락치 가장 높은 사람
		if(fm.b_amt_out[i].value == '0원'){
			if(max_cha < toFloat(fm.per_cha[i].value)){
			
				max_cha = fm.per_cha[i].value;		
				max_i = i;
			}
		//포상 대상중 마지막 사람
		}else{
			if(min_i < i){
				min_i = i;
			}		
		}
	}
	fm.max_i.value = max_i;
	fm.b_amt_out[max_i].value 	= parseDecimal(th_rnd(toInt(parseDigit(fm.b_amt_out[min_i].value)) * 0.8))+"원";
	
	if(fm.partner_id[max_i].value != ''){
		fm.b_amt_in[max_i].value 	= parseDecimal(th_rnd(toInt(parseDigit(fm.b_amt_out[max_i].value)) * 1))+"원";	
	}
	
	fm.cont[max_i].value 		= '-노력상-';
	//미포상자중 노력상 계산하기-----			
	
	
	//합계 출력
	fm.tot_amt_out.value 	= parseDecimal(th_rnd(tot_amt_out+toInt(parseDigit(fm.b_amt_out[max_i].value))));
	fm.tot_amt_in.value 	= parseDecimal(th_rnd(tot_amt_in+toInt(parseDigit(fm.b_amt_in[max_i].value))));
	fm.tot_amt.value 		= parseDecimal(th_rnd(toInt(parseDigit(fm.tot_amt_out.value))+toInt(parseDigit(fm.tot_amt_in.value))));	
}		

//노력상 표시
function view_max_cha(){

	var fm = document.form1;	
	var size = toInt(fm.size.value)-<%=cnt%>;
	var tot_amt=0, tot_amt_out=0, tot_amt_in=0;	
	
	fm.size2.value = size;
	
	//미포상자중 노력상 계산하기-----------------------------------------------------------------------
	var max_cha = -99.00;
	var max_i = 0;	
	var min_i = 0;
	for(i=0; i<size ; i++){	
		fm.per_cha[i].value = parseFloatCipher3(toFloat(fm.per_0405[i].value)-toFloat(fm.cmp_per[i].value),2);
		if(toFloat(fm.a_cmp_per.value) < toFloat(fm.cmp_per[i].value) && toInt(parseDigit(fm.b_amt_out[i].value))>0){
			fm.cont[i].value 		= '-노력상-';	
			max_i = i;
		}
		tot_amt_out += toInt(parseDigit(fm.b_amt_out[i].value));
		tot_amt_in 	+= toInt(parseDigit(fm.b_amt_in[i].value));
		tot_amt 	+= toInt(parseDigit(fm.b_amt_out[i].value))+toInt(parseDigit(fm.b_amt_in[i].value));		
	}
	fm.max_i.value = max_i;
	//합계 출력
	fm.tot_amt_out.value 	= parseDecimal(tot_amt_out);
	fm.tot_amt_in.value 	= parseDecimal(tot_amt_in);
	fm.tot_amt.value 		= parseDecimal(tot_amt);		
}	
//합계
function view_sum_amt(){

	var fm = document.form1;	
	var size = toInt(fm.size.value)-<%=cnt%>;
	var tot_amt=0, tot_amt_out=0, tot_amt_in=0;	
	
	fm.size2.value = size;
	
	for(i=0; i<size ; i++){	
		tot_amt_out += toInt(parseDigit(fm.b_amt_out[i].value));
		tot_amt_in 	+= toInt(parseDigit(fm.b_amt_in[i].value));
		tot_amt 	+= toInt(parseDigit(fm.b_amt_out[i].value))+toInt(parseDigit(fm.b_amt_in[i].value));		
	}
	//합계 출력
	fm.tot_amt_out.value 	= parseDecimal(tot_amt_out);
	fm.tot_amt_in.value 	= parseDecimal(tot_amt_in);
	fm.tot_amt.value 		= parseDecimal(tot_amt);		
}
//-->
</script>
</body>
</html>