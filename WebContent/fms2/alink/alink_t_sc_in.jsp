<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.alink.*, acar.car_sche.*"%>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	
	ALinkDatabase alk_db = ALinkDatabase.getInstance();
	
	Vector vt = new Vector();

	long t_cnt1 = 0;
	long t_cnt2 = 0;
	long t_cnt3 = 0;
	long t_cnt4 = 0;
	long tot = 0;
	long tot2 = 0;
	
	vt = alk_db.Moncount(st_year, st_mon);
	int vt_size = vt.size();
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		t_cnt1 +=  AddUtil.parseLong(String.valueOf(ht.get("AC611")));			
		t_cnt2 +=  AddUtil.parseLong(String.valueOf(ht.get("AC111")));
		t_cnt3 +=  AddUtil.parseLong(String.valueOf(ht.get("AC711")));
		t_cnt4 +=  AddUtil.parseLong(String.valueOf(ht.get("AC811")));
		tot   += AddUtil.parseLong(String.valueOf(ht.get("ACTOT")));
		tot2 += AddUtil.parseLong(String.valueOf(ht.get("ACTOT2")));
	}

	//추가 변수VV(2017.11.06)
	long t_cnt1_over = t_cnt1 - 100;
	long t_cnt2_over = t_cnt2 - 900;
	long t_cnt3_over = t_cnt3 - 500;
	long t_cnt4_over = t_cnt4;
	long papylCnt = 0;
	
	Vector vt2 = new Vector();
	vt2 = alk_db.MoncountPapyl(st_year, st_mon);
	int vt2_size = vt2.size();
	for(int i = 0 ; i < vt2_size ; i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		papylCnt +=  AddUtil.parseLong(String.valueOf(ht2.get("PAPYLCNT")));
	}
	long papylCnt_over = papylCnt - 1000;
	if(papylCnt_over < 0){	papylCnt_over = 0;	}
	if(t_cnt3_over < 0){		t_cnt3_over = 0;		}
	
	//실제 사용건에 따라 따라 폼변경 용 변수세팅
	boolean papyl_fm = false;	//파피리스(장기대여)
	boolean acta1_fm = false;	//액타소프트(월렌트+인도인수증)
	boolean acta2_fm = false;	//액타소프트(장기대여)
	if(papylCnt > 0){				papyl_fm = true;		}
	if((t_cnt1+t_cnt2) > 0){	acta1_fm = true;		}
	if(t_cnt3 > 0){					acta2_fm = true;		}
	
	//액타소프트 전자계약서 계약구분별 카운팅(20190712) - 완료건
	Hashtable ht3 = alk_db.getLCRentLinkMCount(st_year, st_mon);
	//액타소프트 전자계약서 계약구분별 카운팅(20190712) - 등록건
	Hashtable ht4 = alk_db.getLCRentLinkMRCount(st_year, st_mon);

	int h3_cnt_tot = AddUtil.parseInt(String.valueOf(ht3.get("CNT1")))+AddUtil.parseInt(String.valueOf(ht3.get("CNT2")))+AddUtil.parseInt(String.valueOf(ht3.get("CNT3")));
	
	if(t_cnt3 > h3_cnt_tot){
		if(ck_acar_id.equals("000029")){
			out.println("장기대여 세부내역 합계가보다 실사용량이 크다. 실사용량 "+t_cnt3+"건");
		}
		t_cnt3 = h3_cnt_tot;
		t_cnt3_over = t_cnt3 - 500;
		if(t_cnt3_over < 0){		t_cnt3_over = 0;		}
	}
%>
<html>
<head><title>FMS</title>
<style type="text/css">
.td_style{	padding-right: 10px;}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:">

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<!-- 요청사항에 의해 표 새로 작성 (2017.11.06)-->
<table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<colgroup>
            		<col width="6%">
            		<col width="8%">
            		<col width="8%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">
            		<col width="13%">            		
            	</colgroup>
				<tbody>
					<tr>
						<td class="title" colspan="3" rowspan="2">구분</td>
						<%if(papyl_fm){%><td class="title">(주)파피리스</td><%}%>
						<%-- <%if(acta1_fm){%><td class="title" colspan="3">(주)액타소프트</td><%}%>
						<%if(acta2_fm){%><td class="title">(주)액타소프트</td><%}%> --%>
						<%if(acta1_fm){%><td class="title" colspan="4">모바일</td><%}%>
						<%if(acta2_fm){%><td class="title">인증서</td><%}%>
						<td class="title" rowspan="2">합계</td>
					</tr>
					<tr>
						<%if(papyl_fm){%><td class="title">계약서(장기대여)</td><%}%>
						<%if(acta1_fm){%><td class="title">계약서(월렌트)</td><%}%>
						<%if(acta1_fm){%><td class="title">인도인수증</td><%}%>
						<%if(acta1_fm){%><td class="title">계약서(장기대여)</td><%}%>
						<%if(acta1_fm){%><td class="title">소계</td><%}%>
						<%if(acta2_fm){%><td class="title">계약서(장기대여)</td><%}%>
					</tr>
					<tr>
						<td class="title" rowspan="3">기<br>본<br>료</td>
						<td class="title" colspan="2">단가(원)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,200</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">1,000</td><%}%>
						<td class="td_style" align="right"></td>
					</tr>
					<tr>
						<td class="title" colspan="2">수량(건)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,000 </td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">1,000</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">500</td><%}%> <!-- 2020-10 부터 기본 500건 300,000원 -->
						<td class="td_style" align="right"><!-- 2,300 -->
						<%	int tot_cnt = 0;
								if(papyl_fm){	tot_cnt += 1000;	}
								if(acta1_fm){	tot_cnt += 1000;	}
								if(acta2_fm){	tot_cnt += 500;	}
						%>
							<%=AddUtil.parseDecimal(tot_cnt) %>
						</td>
					</tr>
					<tr>
						<td class="title" colspan="2">기본요금(월,원)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,200,000</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">250,000</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">250,000</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">500,000</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">300,000</td><%}%>
						<td class="td_style" align="right"><!-- 2,000,000 -->
						<%	int tot_fee = 0;
								if(papyl_fm){	tot_fee += 1200000;	}
								if(acta1_fm){	tot_fee += 500000;	}
								if(acta2_fm){	tot_fee += 300000;	}
						%>
							<%=AddUtil.parseDecimal(tot_fee) %>
						</td>
					</tr>
					<tr>
						<td class="title" rowspan="4">실<br>사<br>용<br>료</td>
						<td class="title" colspan="2">단가(원)</td>
						<%if(papyl_fm){%><td class="td_style" align="right">1,200</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right">400</td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right">1,000</td><%}%>
						<td class="td_style" align="right"></td>
					</tr>
					<tr>
						<td class="title" colspan="2">실사용량</td>
						<%if(papyl_fm){%><td class="td_style" align="right"><%=papylCnt%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt1%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt2%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt4%></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%=t_cnt1 + t_cnt2 + t_cnt4%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%=t_cnt3%></td><%}%>
						<td class="td_style" align="right"><%=papylCnt + t_cnt1 + t_cnt2 + t_cnt3 + t_cnt4%></td>
					</tr>
					<tr>
						<td class="title" rowspan="2">초과사용</td>
						<td class="title">수량</td>
						<%if(papyl_fm){%><td class="td_style" align="right">-</td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt4_over > 0){%><%=t_cnt1_over + t_cnt2_over + t_cnt4_over%><%}else{%>0<%}%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%if(t_cnt3_over > 0){%><%=t_cnt3_over%><%}else{%>0<%}%></td><%}%>
						<td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt3_over + papylCnt_over + t_cnt4_over > 0){%><%=papylCnt_over + t_cnt1_over + t_cnt2_over + t_cnt3_over + t_cnt4_over%><%}else{%>0<%}%></td>
					</tr>
					<tr>
						<td class="title">요금</td>
						<%if(papyl_fm){%><td class="td_style" align="right">-</td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt4_over>0){%><%=AddUtil.parseDecimal(400*(t_cnt1_over + t_cnt2_over + t_cnt4_over))%><%}else{%>0<%}%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%if(t_cnt3_over>0){%><%=AddUtil.parseDecimal(1000*t_cnt3_over)%><%}else{%>0<%}%></td><%}%>
						<td class="td_style" align="right"><%if(papylCnt_over + t_cnt1_over + t_cnt2_over + t_cnt3_over + t_cnt4_over>0){%><%=AddUtil.parseDecimal((400*(papylCnt_over + t_cnt1_over + t_cnt2_over + t_cnt4_over))+(1000*t_cnt3_over))%><%}else{%>0<%}%></td>
					</tr>
					<tr>
						<td class="title" colspan="3">사용요금(VAT별도)</td>
						<%if(papyl_fm){%><td class="td_style" align="right"><%=AddUtil.parseDecimal(1200000 + (1200*papylCnt_over))%></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="title" align="right"></td><%}%>
						<%if(acta1_fm){%><td class="td_style" align="right"><%if(t_cnt1_over + t_cnt2_over + t_cnt4_over>0){%><%=AddUtil.parseDecimal(500000 + (400*(t_cnt1_over + t_cnt2_over + t_cnt4_over)))%><%}else{%>500,000<%}%></td><%}%>
						<%if(acta2_fm){%><td class="td_style" align="right"><%if(t_cnt3_over>0){%><%=AddUtil.parseDecimal(300000 + (1000*t_cnt3_over))%><%}else{%>300,000<%}%></td><%}%>
						<td class="td_style" align="right">
							<%-- <%if(t_cnt1_over + t_cnt2_over>0||t_cnt3_over>0){%><%=AddUtil.parseDecimal(1200000 + 500000 + (400*(t_cnt1_over + t_cnt2_over)) + (1200*papylCnt_over) + (1000*t_cnt3_over))%><%}else{%>2,000,000<%}%> --%>
						<%	int tot_amt = 0;		//합계구하기
						 		if(papylCnt > 0){								tot_amt += 1200000;											}
						 		if(papylCnt_over > 0){						tot_amt += (1200 * papylCnt_over);					}
						 		if(t_cnt1 + t_cnt2 > 0){					tot_amt += 500000;												}
								if(t_cnt1_over + t_cnt2_over + t_cnt4_over>0){		tot_amt += (400 * (t_cnt1_over + t_cnt2_over + t_cnt4_over));	}
								if(t_cnt3 > 0){									tot_amt += 300000;												}
								if(t_cnt3_over > 0){							tot_amt += 1000 * t_cnt3_over;							}
						%>
							<%=AddUtil.parseDecimal(tot_amt) %>	
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr> 
        <td class=h height="40px;" style="text-align: right; padding-top: 5px;">※ 청구 금액에는 위 금액에 SMS 이용료와 휴대폰 본인 인증료가 추가됩니다.</td>
    </tr>
</table>
<!-- <div style="margin-top: 10px;"><small>※ 초과사용량이 음수값일시 0으로 처리했기 때문에 월렌트, 인도인수증 요금은 오차처럼 보일수있습니다. (소계는 정확한 수치)</small></div> -->
<%if(acta2_fm){%>
<table border="0" cellspacing="0" cellpadding="0" width=30%>
    <tr> 
        <td class=h height="40px;">&nbsp;</td>
    </tr>
    <tr>
	    <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<colgroup>
            		<col width="20%">
            		<col width="30%">
            		<col width="30%">
            		<col width="30%">
            	</colgroup>
            	<tr>
            		<td colspan="4" class="title" style="padding: 5px 0;">(주)액타소프트 계약서<br>(장기대여) 세부내역</td>
            	</tr>	
            	<tr>
            		<td class="title">구분</td>
            		<!-- <td class="title">완료건수</td>
            		<td class="title">등록건수</td> -->
            		<td class="title">발송(건수)</td>
            		<td class="title">체결(건수)</td>
            		<td class="title">취소/진행(건수)</td>
            	</tr>
            	<tr>
            		<td class="title">신규</td>
            		<td align="center"><%=ht4.get("CNT1")%></td>
            		<td align="center"><%=ht3.get("CNT1")%></td>
            		<td align="center"><%=Integer.parseInt(String.valueOf(ht4.get("CNT1")))-Integer.parseInt(String.valueOf(ht3.get("CNT1")))%></td>
            	</tr>
            	<tr>
            		<td class="title">대차</td>
            		<td align="center"><%=ht4.get("CNT2")%></td>
            		<td align="center"><%=ht3.get("CNT2")%></td>
            		<td align="center"><%=Integer.parseInt(String.valueOf(ht4.get("CNT2")))-Integer.parseInt(String.valueOf(ht3.get("CNT2")))%></td>
            	</tr>
            	<tr>
            		<td class="title">증차</td>
            		<td align="center"><%=ht4.get("CNT3")%></td>
            		<td align="center"><%=ht3.get("CNT3")%></td>
            		<td align="center"><%=Integer.parseInt(String.valueOf(ht4.get("CNT3")))-Integer.parseInt(String.valueOf(ht3.get("CNT3")))%></td>
            	</tr>
            	<tr>
            		<td class="title">합계</td>
            		<td align="center">           		
            			<%=AddUtil.parseLong(String.valueOf(ht4.get("CNT1")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT2")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT3")))%>            	
            		</td>
            		<td align="center">
           		<%	
            		if(h3_cnt_tot == t_cnt3+t_cnt4){ %>	
            			<%=t_cnt3+t_cnt4%>
            	<%}else{%>
            			<%=h3_cnt_tot %><br>
<!--             			(총카운트량이 일치하지 않습니다. 구분범주에 따라 다르게 표시될수 있습니다. 전산팀에 확인요청 해주세요.<br> -->
<!--             			2019년 5월분 데이터는 테스트데이터 때문에 6건 차이납니다.) -->
            	<%} %>		
            		</td>
            		<td align="center">
            			<%=(AddUtil.parseLong(String.valueOf(ht4.get("CNT1")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT2")))+AddUtil.parseLong(String.valueOf(ht4.get("CNT3")))) - (t_cnt3+t_cnt4)%>
            		</td>
            	</tr>
           	</table>
    	</td>
   	</tr>
</table>	
<%}%>
</form>
</body>
</html>
