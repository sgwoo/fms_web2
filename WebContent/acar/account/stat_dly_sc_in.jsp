<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<%
	String gubun1		= request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String im_dt 		= request.getParameter("im_dt")==null?"":request.getParameter("im_dt");
	int fee_size=0;
	Vector fees=new Vector();
	
	if(gubun1.equals("6")) { //현황
		if(gubun2.equals("2"))		fees = af_db.getDfeeList(im_dt);
		else if(gubun2.equals("0"))	fees = af_db.getMDfeeList();
		else if(gubun2.equals("1"))	fees = af_db.getMYfeeList();
		fee_size = fees.size();
	}
	else {
		fees = af_db.getFeeList(gubun1, gubun2, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
		fee_size = fees.size();
	}
	long tot1=0;
	long tot2=0;
	long tot3=0;
	long tot4=0;
	long tot5=0;
	long tot6=0;
	long tot7=0;
		String query = "";
	
/*		query = " select"+
				" decode(rc_yn, '0', '미수', '1', '수금', '') gubun_st,"+
				" RENT_MNG_ID, RENT_L_CD, FIRM_NM, CAR_NO, CAR_NM, FEE_TM,"+
				" decode(tm_st1, '0', fee_tm||'회', fee_tm||'회(잔)') FEE_TM_NM,"+
				" substr(FEE_EST_DT, 1, 4) || '-' || substr(FEE_EST_DT, 5, 2) || '-'||substr(FEE_EST_DT, 7, 2) FEE_EST_DT,"+
				" FEE_S_AMT, FEE_V_AMT, FEE_AMT, BRCH_ID, R_FEE_EST_DT, RENT_ST, TM_ST1,"+
				" RC_YN, decode(sign(DLY_DAY), -1, (DLY_DAY*-1), DLY_DAY) DLY_DAY, R_SITE, client_nm, bus_id2,"+
				" decode(RC_DT, '', '', substr(RC_DT, 1, 4)||'-'||substr(RC_DT, 5, 2) ||'-'||substr(RC_DT, 7, 2)) RC_DT, D, "+
				" use_yn "+				
				" from"+
				" ("+
					" select"+
					" decode(sign(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE), 0, '1', 1, '2', -1, decode(sign(TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD') - SYSDATE+1), 1, '1', '0')) E,"+ 							
					" DECODE(F.RC_DT, '', '', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD') - SYSDATE)), -1, '0', 0, '1', '2')) R,"+
					" DECODE(F.RC_YN, '0', DECODE(SIGN(TRUNC(SYSDATE-TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), 1, 1, 0), '1', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD')-TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), 1, 1, 0), 0) D,"+
					" DECODE(F.RC_YN, '1', DECODE(SIGN(TRUNC(TO_DATE(F.RC_DT, 'YYYYMMDD') - TO_DATE(F.R_FEE_EST_DT, 'YYYYMMDD'))), -1, '1', '0'), 0) F,"+
			 	    " F.rent_mng_id, F.rent_l_cd, nvl(L.firm_nm, L.client_nm) FIRM_NM, R.car_no,"+
			 	    " R.car_nm, F.fee_tm, F.fee_est_dt, F.fee_s_amt, F.rent_st,"+
			 	    " F.fee_v_amt, decode(F.RC_YN, '0', F.fee_s_amt+F.fee_v_amt, F.rc_amt) FEE_AMT, F.r_fee_est_dt,"+
			 	    " C.brch_id, F.tm_st1, F.rc_dt, F.rc_yn, C.R_SITE, L.client_nm, \n"+
					//" F.dly_days dly_day, \n"+
					" TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD')) dly_day, "+ 
					" C.bus_id2, "+
					" C.use_yn use_yn "+
					" from scd_fee F, cont C, client L, car_reg R"+
					" where"+
				   	" C.rent_mng_id = F.rent_mng_id and"+
				 	" C.rent_l_cd =  F.rent_l_cd and"+
				 	" C.client_id = L.client_id and"+
				 	" C.car_mng_id = R.car_mng_id(+)"+
					" and SIGN(TRUNC(NVL(TO_DATE(rc_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(r_fee_est_dt, 'YYYYMMDD'))) > -9999 "+
				" )"+
				" where ";*/
		query="select * from fee_view where ";

		//전체-당일((E:1 && F:0)|| (D:1 && R:1) || (D:1 && N))	입금예정일이 당일이고 선수가 아닌 데이터) & 연체된 데이타(연체수금:당일, 연체미수))	
		if(gubun1.equals("0") && gubun2.equals("0")) 
			query += " ((E = 1 AND F = 0) OR (D = 1 AND R = 1) OR (D = 1 AND RC_YN = '0'))";
		//전체-기간
		else if(gubun1.equals("0") && gubun2.equals("2"))		
			query += " fee_est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
		//선수-당일(F:1, R:1, Y)
		else if(gubun1.equals("1") && gubun2.equals("0")) 		
			query += " F = 1 AND R = 1";
		// 수금-당일(E:1, 2, R:1, Y)	수금일이 당일이고 입금예정일이 당일이거나 예정인것
		else if(gubun1.equals("2") && gubun2.equals("0"))
			query += " (E = 1 OR E = 2) AND R = 1";
		// 수금-연체(D:1, R:1, Y)	수금일이 당일이고 연체된것
		else if(gubun1.equals("2") && gubun2.equals("1"))
			query += " D = 1 AND R = 1";
		//수금-기간
		else if(gubun1.equals("2") && gubun2.equals("2"))
			query += " RC_YN='1' AND RC_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
		//수금-당일+연체((D:1, E:1, 2,  R:1, Y)
		else if(gubun1.equals("2") && gubun2.equals("3"))
			query += " ((E = 1 OR E = 2) OR D = 1) AND R = 1";
		//미수-당일(E:1, N)
		else if(gubun1.equals("3") && gubun2.equals("0"))
			query += " E = 1 AND RC_YN = '0'";
		//미수-연체(D:1, N)
		else if(gubun1.equals("3") && gubun2.equals("1"))
			query += " D = 1 AND RC_YN = '0'";
		//미수-기간
		else if(gubun1.equals("3") && gubun2.equals("2"))
			query += " RC_YN='0' AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	
		//미수-당일+연체(E:0, 1,  N)
		else if(gubun1.equals("3") && gubun2.equals("3"))
			query += " (E = 1 OR D = 1) AND RC_YN = '0'";
		//연체-당일(E : 1)
		else if(gubun1.equals("4") && gubun2.equals("0"))
			query += " E = 0 AND RC_YN = '0' ";		
		//연체-기간
		else if(gubun1.equals("4") && gubun2.equals("2"))
			query += " E = 0 AND FEE_EST_DT BETWEEN '"+st_dt+"' AND '"+end_dt+"' AND RC_YN = '0' ";	
		//검색
		else
//			query += " FEE_TM = '1' ";
			query += " FEE_TM = min_fee_tm ";
			
		if(s_kd.equals("2"))		query += " and nvl(client_nm, ' ') like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')";
		else if(s_kd.equals("4"))	query += " and nvl(car_no, ' ') like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and fee_s_amt = "+t_wd;
		else if(s_kd.equals("6"))	query += " and upper(brch_id) like upper('%"+t_wd+"%')";
		else if(s_kd.equals("7"))	query += " and nvl(R_SITE, ' ') like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and nvl(BUS_ID2, ' ') like '%"+t_wd+"%'";
		else					query += " and nvl(firm_nm, ' ') like '%"+t_wd+"%'";

//		if(!gubun1.equals("5"))	query+= " and use_yn='Y' ";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		if(gubun1.equals("5") && gubun2.equals("0")){
			if(sort_gubun.equals("0"))		query += " order by use_yn desc, fee_est_dt "+sort+", rc_dt, firm_nm";
			else if(sort_gubun.equals("1"))	query += " order by use_yn desc, firm_nm "+sort+", rc_dt, fee_est_dt";
			else if(sort_gubun.equals("2"))	query += " order by use_yn desc, rc_dt "+sort+", firm_nm, fee_est_dt";
			else if(sort_gubun.equals("3"))	query += " order by use_yn desc, fee_amt "+sort+", rc_dt, firm_nm, fee_est_dt";
			else if(sort_gubun.equals("4"))	query += " order by use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		}else{
			if(sort_gubun.equals("0"))		query += " order by fee_est_dt "+sort+", rc_dt, firm_nm";
			else if(sort_gubun.equals("1"))	query += " order by firm_nm "+sort+", rc_dt, fee_est_dt";
			else if(sort_gubun.equals("2"))	query += " order by rc_dt "+sort+", firm_nm, fee_est_dt";
			else if(sort_gubun.equals("3"))	query += " order by fee_amt "+sort+", rc_dt, firm_nm, fee_est_dt";
			else if(sort_gubun.equals("4"))	query += " order by dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		}
//out.println(query);
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fee_size%>'>


<!-- 대여료 현황 -->

<% if(gubun1.equals("6") && gubun2.equals("2")) { %>

<table border="0" cellspacing="0" cellpadding="0" width='1090'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='355' id='td_title' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='355'>
          <tr>
					<td width='105' rowspan=2 class='title'>구분</td>
					
            <td width='240' colspan=3 class='title'>금일</td>
				</tr>
				<tr>
					
            <td width='100' class='title'>계획</td>
					
            <td width='90' class='title'>수금</td>
					
            <td width='60' class='title'>비율</td>
				</tr>
			</table>
		</td>
		<td class='line' width='770'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='770'>
          <tr> 
            <td width='140' colspan=2 class='title'>전일</td>
            <td width='140' colspan=2 class='title'>전월동일</td>
            <td width='140' colspan=2 class='title'>전전월동일</td>
            <td width='140' colspan=2 class='title'>전년도동일</td>
            <td width='140' colspan=2 class='title'>임의일자</td>
          </tr>
          <tr> 
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
          </tr>
        </table>
		</td>
	</tr>
<%	if(fee_size > 0){%>
	<tr>
		<td class='line' width='345' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='355'>
          <%		for (int i = 0 ; i < 3 ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
			tot1+=fee.getTot1();
			tot2+=fee.getTot2();
			tot3+=fee.getTot3();
			tot4+=fee.getTot4();
			tot5+=fee.getTot5();
			tot6+=fee.getTot6();
			tot7+=fee.getTot7();
%>
          <tr > 
            <td width='105' align='center'><%=fee.getUser_nm()%></td>
            <td width='100' align='right'><%=Util.parseDecimalLong(String.valueOf(fee.getTot1()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot2()))%></td>
            <td width='60' align='right'><%=fee.getFTot2_rate()%>%&nbsp;</td>
          </tr>
          <%		}
	float f_tot2=Float.parseFloat(Long.toString(tot2))/Float.parseFloat(Long.toString(tot1));
	String s_tot2=Float.toString(f_tot2*100);
%>
          <tr > 
            <td width='105' align='center'><b><font color="#006699">합계</font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot1)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot2)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%=(tot2==0)?"0.0":s_tot2.substring(0,s_tot2.indexOf(".")+3)%>%&nbsp;</font></b></td>
          </tr>
          <%		for (int i = 3 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);		  %>
          <tr > 
            <td width='105' align='center'><%=fee.getUser_nm()%></td>
            <td width='100' align='right'><%=Util.parseDecimalLong(String.valueOf(fee.getTot1()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot2()))%></td>
            <td width='60' align='right'><%=fee.getFTot2_rate()%>%&nbsp;</td>
          </tr>
          <%		}%>
        </table>
		</td>
		<td class='line' width='720'>			
        <table border="0" cellspacing="1" cellpadding="0" width='770'>
          <%		for (int i = 0 ; i < 3 ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
%>
          <tr> 
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot3()))%></td>
            <td width='60' align='right'><%=fee.getFTot3_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot4()))%></td>
            <td width='60' align='right'><%=fee.getFTot4_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot5()))%></td>
            <td width='60' align='right'><%=fee.getFTot5_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot6()))%></td>
            <td width='60' align='right'><%=fee.getFTot6_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot7()))%></td>
            <td width='60' align='right'><%=fee.getFTot7_rate()%>%&nbsp;</td>
          </tr>
          <%		}
	float f_tot3=Float.parseFloat(Long.toString(tot2))/Float.parseFloat(Long.toString(tot3));
	float f_tot4=Float.parseFloat(Long.toString(tot2))/Float.parseFloat(Long.toString(tot4));
	float f_tot5=Float.parseFloat(Long.toString(tot2))/Float.parseFloat(Long.toString(tot5));
	float f_tot6=Float.parseFloat(Long.toString(tot2))/Float.parseFloat(Long.toString(tot6));
	float f_tot7=Float.parseFloat(Long.toString(tot2))/Float.parseFloat(Long.toString(tot7));
	String s_tot3=Float.toString(f_tot3*100);
	String s_tot4=Float.toString(f_tot4*100);
	String s_tot5=Float.toString(f_tot5*100);
	String s_tot6=Float.toString(f_tot6*100);
	String s_tot7=Float.toString(f_tot7*100);
%>
          <tr> 
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot3)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%if(tot3==0 || tot2==0) out.println("0.0"); else out.println(s_tot3.substring(0,s_tot3.indexOf(".")));%>%&nbsp;</font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot4)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%if(tot4==0 || tot2==0) out.println("0.0"); else out.println(s_tot4.substring(0,s_tot4.indexOf(".")));%>%&nbsp;</font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot5)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%if(tot5==0 || tot2==0) out.println("0.0"); else out.println(s_tot5.substring(0,s_tot5.indexOf(".")));%>%&nbsp;</font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot6)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%if(tot6==0 || tot2==0) out.println("0.0"); else out.println(s_tot6.substring(0,s_tot6.indexOf(".")));%>%&nbsp;</font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot7)%></font></b></td>
            <td width='60' align='right'><font color="#006699"><b><%if(tot7==0 || tot2==0) out.println("0.0"); else out.println(s_tot7.substring(0,s_tot7.indexOf(".")));%>%&nbsp;</b></font></td>
          </tr>
          <%		for (int i = 3 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
%>
          <tr> 
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot3()))%></td>
            <td width='60' align='right'><%=fee.getFTot3_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot4()))%></td>
            <td width='60' align='right'><%=fee.getFTot4_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot5()))%></td>
            <td width='60' align='right'><%=fee.getFTot5_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot6()))%></td>
            <td width='60' align='right'><%=fee.getFTot6_rate()%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot7()))%></td>
            <td width='60' align='right'><%=fee.getFTot7_rate()%>%&nbsp;</td>
          </tr>
          <%		} %>
        </table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='345' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='355'>
          <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='720'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='770'>
          <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>

<!-- 담당자별 수금 현황 -->

<% }else if(gubun1.equals("6") && gubun2.equals("0")) { %>

<table border="0" cellspacing="0" cellpadding="0" width='1030'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='405' id='td_title' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='405'>
          <tr>
					<td width='105' rowspan=2 class='title'>구분</td>
					<td width='240' colspan=3 class='title'>수금계획</td>
				</tr>
				<tr>
					
            <td width='100' class='title'>당일</td>
					
            <td width='100' class='title'>연체</td>
					
            <td width='100' class='title'>합계</td>
				</tr>
			</table>
		</td>
		<td class='line' width='660'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='660'>
          <tr>
					<td width='320' colspan=4 class='title'>수금현황</td>
					<td width='140' colspan=2 class='title'>전일</td>
					<td width='140' colspan=2 class='title'>전월동일</td>
				</tr>
				<tr>
					
            <td width='90' class='title'>선입금</td>
					
            <td width='90' class='title'>당일</td>
					
            <td width='90' class='title'>연체</td>
					
            <td width='90' class='title'>합계</td>
					
            <td width='90' class='title'>수금액</td>
					<td width='60' class='title'>변동비</td>
					
            <td width='90' class='title'>수금액</td>
					<td width='60' class='title'>변동비</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(fee_size > 0){%>
	<tr>
		<td class='line' width='405' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='405'>
          <%		for (int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
			tot1+=fee.getTot1();
			tot2+=fee.getTot2();
			tot3+=fee.getTot3();
			tot4+=fee.getTot4();
			tot5+=fee.getTot5();
			tot6+=fee.getTot6();
			tot7+=fee.getTot7();
%>
          <tr > 
            <td width='105' align='center'><%=fee.getUser_nm()%></td>
            <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot1()))%></td>
            <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot2()))%></td>
            <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot1()+fee.getTot2()))%></td>
          </tr>
          <%		}%>
          <tr > 
            <td width='105' align='center'><b><font color="#006699">합계</font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot1)%></font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot2)%></font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot1+tot2)%></font></b></td>
          </tr>
        </table>
		</td>
		<td class='line' width='660'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='660'>
          <%		for (int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
%>
          <tr> 
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot3()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot4()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot5()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot5()+fee.getTot4()+fee.getTot3()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot6()))%></td>
            <td width='60' align='right'><%=fee.getTot6_rate()/10%>%&nbsp;</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot7()))%></td>
            <td width='60' align='right'><%=fee.getTot7_rate()/10%>%&nbsp;</td>
          </tr>
          <%		}
	float f_tot6=Float.parseFloat(Long.toString(tot3+tot4+tot5))/Float.parseFloat(Long.toString(tot6));
	float f_tot7=Float.parseFloat(Long.toString(tot3+tot4+tot5))/Float.parseFloat(Long.toString(tot7));
%>
          <tr> 
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot3)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot4)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot5)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot3+tot4+tot5)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot6)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%=Math.round(f_tot6*100)%>%&nbsp;</font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot7)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%=Math.round(f_tot7*100)%>%&nbsp;</font></b></td>
          </tr>
        </table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='405' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='405'>
          <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='660'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='660'>
          <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>

  <!-- 담당자별 연체현황 -->
  <% }else if(gubun1.equals("6") && gubun2.equals("1")) { %>
  <table border="0" cellspacing="0" cellpadding="0" width='1030'>
    <tr id='tr_title' style='position:relative;z-index:1'> 
      <td class='line' width='405' id='td_title' style='position:relative;'> 
        <table border="0" cellspacing="1" cellpadding="0" width='405'>
          <tr> 
            <td width='105' rowspan=2 class='title'>구분</td>
            <td width='240' colspan=3 class='title'>수금계획</td>
          </tr>
          <tr> 
            <td width='100' class='title'>당일</td>
            <td width='100' class='title'>연체</td>
            <td width='100' class='title'>합계</td>
          </tr>
        </table>
      </td>
      <td class='line' width='660'> 
        <table border="0" cellspacing="1" cellpadding="0" width='660'>
          <tr> 
            <td width='320' colspan=4 class='title'>수금현황</td>
            <td width='140' colspan=2 class='title'>전일</td>
            <td width='140' colspan=2 class='title'>전월동일</td>
          </tr>
          <tr> 
            <td width='90' class='title'>선입금</td>
            <td width='90' class='title'>당일</td>
            <td width='90' class='title'>연체</td>
            <td width='90' class='title'>합계</td>
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
            <td width='90' class='title'>수금액</td>
            <td width='60' class='title'>변동비</td>
          </tr>
        </table>
      </td>
    </tr>
    <%	if(fee_size > 0){%>
    <tr> 
      <td class='line' width='405' id='td_con' style='position:relative;'> 
        <table border="0" cellspacing="1" cellpadding="0" width='405'>
          <%		for (int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
			tot1+=fee.getTot1();
			tot2+=fee.getTot2();
			tot3+=fee.getTot3();
			tot4+=fee.getTot4();
			tot5+=fee.getTot5();
			tot6+=fee.getTot6();
			tot7+=fee.getTot7();
%>
          <tr > 
            <td width='105' align='center'><%=fee.getUser_nm()%></td>
            <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot1()))%></td>
            <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot2()))%></td>
            <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot1()+fee.getTot2()))%></td>
          </tr>
          <%		}%>
          <tr > 
            <td width='105' align='center'><b><font color="#006699">합계</font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot1)%></font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot2)%></font></b></td>
            <td width='100' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot1+tot2)%></font></b></td>
          </tr>
        </table>
      </td>
      <td class='line' width='660'> 
        <table border="0" cellspacing="1" cellpadding="0" width='660'>
          <%		for (int i = 0 ; i < fee_size ; i++){
			FeeScdBean fee = (FeeScdBean)fees.elementAt(i);
%>
          <tr> 
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot3()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot4()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot5()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot5()+fee.getTot4()+fee.getTot3()))%></td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot6()))%></td>
            <td width='60' align='right'><%=fee.getTot6_rate()/10%>%</td>
            <td width='90' align='right'><%=Util.parseDecimal(String.valueOf(fee.getTot7()))%></td>
            <td width='60' align='right'><%=fee.getTot7_rate()/10%>%</td>
          </tr>
          <%		}
	float f_tot6=Float.parseFloat(Long.toString(tot3+tot4+tot5))/Float.parseFloat(Long.toString(tot6));
	float f_tot7=Float.parseFloat(Long.toString(tot3+tot4+tot5))/Float.parseFloat(Long.toString(tot7));
%>
          <tr> 
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot3)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot4)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot5)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot3+tot4+tot5)%></font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot6)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%=Math.round(f_tot6*100)%>%</font></b></td>
            <td width='90' align='right'><b><font color="#006699"><%=Util.parseDecimal(tot7)%></font></b></td>
            <td width='60' align='right'><b><font color="#006699"><%=Math.round(f_tot7*100)%>%</font></b></td>
          </tr>
        </table>
      </td>
    </tr>
    <%	}else{%>
    <tr> 
      <td class='line' width='405' id='td_con' style='position:relative;'> 
        <table border="0" cellspacing="1" cellpadding="0" width='405'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table>
      </td>
      <td class='line' width='660'> 
        <table border="0" cellspacing="1" cellpadding="0" width='660'>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <%	}%>
  </table>
  <!-- 현황이 아닌자료 -->

<% }else{ %>

<table border="0" cellspacing="0" cellpadding="0" width='930'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='430' id='td_title' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='430'>
          <tr>
					
            <td width='70' class='title'>연번</td>
					<td width='55' class='title'>구분</td>
					<td width='95' class='title'>계약코드</td>
					<td width='110' class='title'>상호</td>
					<td width='100' class='title'>차량번호</td>
				</tr>
			</table>
		</td>
		<td class='line' width='500'>
			<table border="0" cellspacing="1" cellpadding="0" width='500'>
				<tr>
					<td width='125' class='title'>차명</td>
					<td width='50' class='title'>회차</td>
					<td width='75' class='title'>입금예정일</td>
					<td width='85' class='title'>월대여료	</td>
					<td width='70' class='title'>수금일</td>
					<td width='55' class='title'>연체일수</td>
					<td width='40' class='title'>영업소</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(fee_size > 0){%>
	<tr>
		<td class='line' width='410' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='430'>
          <%		String rent="";
		for (int i = 0 ; i < fee_size ; i++){
			Hashtable fee = (Hashtable)fees.elementAt(i);
			if(rent != (String)fee.get("RENT_L_CD")) {
%>
				<tr >
					
            <td  <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=i+1%><%if(fee.get("USE_YN").equals("Y")){%> <%}else{%>
              (해약)
<%}%></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='55' align='center'><a href="javascript:parent.view_memo('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>', '<%=fee.get("RENT_ST")%>', '<%=fee.get("FEE_TM")%>', '<%=fee.get("TM_ST1")%>')" onMouseOver="window.status=''; return true"><%if(String.valueOf(fee.get("GUBUN")).equals("0")){%><font color='red'><%=fee.get("GUBUN_ST")%></font><%}else{%><%=fee.get("GUBUN_ST")%><%}%></a></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='95' align='center'><a href="javascript:parent.view_fee('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=fee.get("RENT_L_CD")%></a></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='110' align='center'><span title='<%=fee.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=fee.get("RENT_MNG_ID")%>', '<%=fee.get("RENT_L_CD")%>', '<%=fee.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(fee.get("FIRM_NM")), 7)%></a></span></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><span title='<%=fee.get("CAR_NO")%>'><%=Util.subData(String.valueOf(fee.get("CAR_NO")), 15)%></span></td>
				</tr>
<%
			rent = (String)fee.get("RENT_L_CD");
			}
			
		}
%>
			</table>
		</td>
		<td class='line' width='500'>
			<table border="0" cellspacing="1" cellpadding="0" width='500'>
<%		
		rent="";
		for (int i = 0 ; i < fee_size ; i++)
		{
			Hashtable fee = (Hashtable)fees.elementAt(i);
			if(rent != (String)fee.get("RENT_L_CD")) {
%>				<tr>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='125' align='center'><span title='<%=fee.get("CAR_NM")%>'><%=Util.subData(String.valueOf(fee.get("CAR_NM")), 9)%></span></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='50' align='right'><%=fee.get("FEE_TM_NM")%></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='75' align='center'><%=fee.get("FEE_EST_DT")%></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='85' align='right'><%=Util.parseDecimal(String.valueOf(fee.get("FEE_AMT")))%><input type='hidden' name='amt' value='<%=Util.parseDecimal(String.valueOf(fee.get("FEE_AMT")))%>' size='10' class='whitenum' readonly></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=fee.get("RC_DT")%></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='55' align='center'><%if(!fee.get("DLY_DAY").equals("")){%><%=fee.get("DLY_DAY")%>일 <%}else{%>- <%}%></td>
					<td <%if(fee.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='center'><%=fee.get("BRCH_ID")%></td>
				</tr>
<%
			rent = (String)fee.get("RENT_L_CD");
			}
			
		}
%>
			</table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='410' id='td_con' style='position:relative;'>
			
        <table border="0" cellspacing="1" cellpadding="0" width='430'>
          <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='500'>
			<table border="0" cellspacing="1" cellpadding="0" width='500'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<% 	}%>
</table>
<script language='javascript'>
<!--
	var fm 		= document.form1;
	var p_fm	= parent.form1;
	var cnt 	= fm.fee_size.value;
	
	var i_amt = 0;
	
	if(cnt > 1){
		for(var i = 0 ; i < cnt ; i++){
			i_amt   += toInt(parseDigit(fm.amt[i].value));
		}
	}else if(cnt == 1){
		i_amt   += toInt(parseDigit(fm.amt.value));	
	}		
-->
</script>
<%} %>

</form>
</body>
</html>
