<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, acar.car_mst.*, tax.*, acar.user_mng.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="f_db" scope="page" class="acar.fee.FeeDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	//String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"002316":request.getParameter("rent_mng_id");
	//String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"S105YNCL00040":request.getParameter("rent_l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	String stamp_yn 	= request.getParameter("stamp_yn")==null?"N":request.getParameter("stamp_yn");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(rent_mng_id, rent_l_cd);
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//대여기본정보
	//ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, rent_st);
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(rent_mng_id, rent_l_cd);
	
	//최초대여정보
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	
	//건별 대여료 스케줄 리스트
	/* if (rent_st.equals("")) {
		fee_scd = af_db.getFeeScdMail(rent_l_cd);
		fee_scd_size = fee_scd.size();
	} else {
		//fee_scd = af_db.getFeeScdEmailRentst2(rent_l_cd, rent_st, f_fee.getPrv_mon_yn());
		fee_scd = af_db.getFeeScdNew2(rent_mng_id, rent_l_cd, b_dt, mode, bill_yn, false);	// 선납금 제거 2018.04.16
		fee_scd_size = fee_scd.size();
	} */
	
	if(cls.getCls_dt().equals("")){
		b_dt = Util.getDate();
	} else {
		b_dt = cls.getCls_dt();
	}
	
	fee_scd = af_db.getFeeScdNew2(rent_mng_id, rent_l_cd, b_dt, mode, bill_yn, false);	// 선납금 제거 2018.04.16
	fee_scd_size = fee_scd.size();
	
	int nc = 0;
	int ns = 0;
	int nv = 0;
	int rc = 0;
	int rs = 0;
	int rv = 0;
	int mc = 0;
	int ms = 0;
	int mv = 0;
	int dc = 0;
	int dt = 0;
	int dt2 = 0;	
	
	//건별 대여료 스케줄 통계
	//Hashtable fee_stat = af_db.getFeeScdStatNew(rent_mng_id, rent_l_cd, mode, bill_yn);
	Hashtable fee_stat = af_db.getFeeScdStatNew(rent_mng_id, rent_l_cd, "", "ALL", "");
	int fee_stat_size = fee_stat.size();
	
	//계좌번호 *로 가리기
	//System.out.println(cms.getCms_acc_no());
	int acc_len = cms.getCms_acc_no().length();
	String acc_no = "";
	String acc_no1 = "";
	String acc_no2 = "";	
	String acc_no3 = "";	
	String acc_no4 = "";	
	int escape_len = 0;
	if (acc_len > 0) {
		if (cms.getCms_acc_no().lastIndexOf("-") == -1) {
			/* acc_no1 = "*******";
			acc_no2 = cms.getCms_acc_no().substring(7,acc_len);
			acc_no = acc_no1+acc_no2; */			
			if (acc_len < 10) {				
				acc_no3 = cms.getCms_acc_no().substring(cms.getCms_acc_no().length() - 4, cms.getCms_acc_no().length());
				
				escape_len = cms.getCms_acc_no().length() - acc_no3.length();				
				for (int i = 0; i < escape_len; i ++) {
					acc_no4 += "*";
				}
				acc_no = acc_no4 + acc_no3;
			} else {				
				acc_no1 = cms.getCms_acc_no().substring(0,2);
				acc_no2 = cms.getCms_acc_no().replaceFirst(acc_no1, "");
				acc_no3 = cms.getCms_acc_no().substring(cms.getCms_acc_no().length() - 6, cms.getCms_acc_no().length());
				
				escape_len = acc_no2.length() - acc_no3.length();			
				for (int i = 0; i < escape_len; i ++) {
					acc_no4 += "*";
				}			
				acc_no = acc_no1 + acc_no4 + acc_no3;
			}
		}else{
			acc_no1 = cms.getCms_acc_no().substring(0,cms.getCms_acc_no().lastIndexOf("-"));
			acc_no2 = cms.getCms_acc_no().substring(cms.getCms_acc_no().lastIndexOf("-"));
    		for (int i = 0; i < acc_no1.length(); i++) {
	    		char c = (char) acc_no1.charAt(i);
    			if ( c == '-') {
    				acc_no += "-";
    			} else { 
	    			acc_no += "*";
    			}
    		}
			acc_no += acc_no+acc_no2;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><!-- 호환성 보기 추가시 화면이 깨지는 현상 수정 2018.04.04 -->
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.t_font td {
	font-size: 11px;
}
.button_style:hover {
    background-color: #525D60;
}
.button_style {
	background-color: #6d758c;
    font-size: 12px;
    cursor: pointer;
    border-radius: 2px;
    color: #fff;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
    margin-right: 30px;
}
</style>
<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 0mm 0mm 0mm 0mm;
    }    
    html {
        margin: 5px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 5mm 0mm 0mm 10mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 10mm; /*좌측*/
    }
    .button_style {
    	display: none;
    }
</style>
<script language="JavaScript" type="text/JavaScript">
function IE_Print() {
	factory.printing.header = ""; //폐이지상단 인쇄
	factory.printing.footer = ""; //폐이지하단 인쇄
	factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin = 15.0; //좌측여백   
	factory.printing.rightMargin = 0.0; //우측여백
	factory.printing.topMargin = 0.0; //상단여백    
	factory.printing.bottomMargin = 0.0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint() {
	var userAgent = navigator.userAgent.toLowerCase();
	
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}
</script>
</head>
<!-- <body topmargin=0 leftmargin=0 onLoad="javascript:onprint();"> -->
<body topmargin=0 leftmargin=0>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' method='post' >
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<div style="width: 100%; text-align: right;">
	<input class="button_style" type="button" value="프린트하기" onclick="onprint();">
</div>
<!-- 중간부분 -->
<table width=900 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td align="center">
            <table width=850 border=0 cellspacing=0 cellpadding=0 align="center" style="margin: 15px 0px 30px 0px;">                                        
                <tr>
				    <td height=25>&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color=57589f><b>대여정보</b></font></td>
				</tr>
                <tr>
                    <td>
              			<!-- 계약사항 -->
						<table width=800 border=0 cellpadding=0 cellspacing=1 bgcolor=a6b1d6>
						    <tr align="center">
							    <td width=15% class="title" height="20">상호</td>
								<td class="content" colspan="3"><%=base.get("FIRM_NM")%></td>
						        <td width=15% class="title">고객명</td>
						        <td align="center" class="content"><%=base.get("CLIENT_NM")%></td>
						    </tr>
						    <tr align="center">
						        <td width=15% class="title">대여차종</td>
						        <td align="center" class="content" colspan="3"><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
							    <td width=15% class="title" height="20">차량번호</td>
								<td class="content"><span style="font-weight: bold;"><%=base.get("CAR_NO")%></span></td>
						    </tr>
						    <tr align="center">
							    <td width=15% class="title">대여개시일</td>
								<td align="center" class="content"><%=f_fee.getRent_start_dt()%></td>
							    <td width=15% class="title">대여만료일</td>
								<td align="center" class="content"><%=f_fee.getRent_end_dt()%></td>
							    <td width=15% class="title" height="20">대여기간</td>
							    <td align="center" class="content"><%=f_fee.getCon_mon()%>개월</td>
							</tr>
							<tr align="center">
						        <td width=15% class="title" height="20">보증금</td>
								<td align="center" class="content"><%=AddUtil.parseDecimal(f_fee.getGrt_amt_s())%>원</td>
						        <td width=15% class="title">개시대여료</td>
								<td align="center" class="content"><%=AddUtil.parseDecimal(f_fee.getIfee_s_amt() + f_fee.getIfee_v_amt())%>원</td>
						        <td width=15% class="title">월대여료</td>
								<td align="center" class="content"><span style="font-weight: bold;"><%=AddUtil.parseDecimal(f_fee.getFee_s_amt() + f_fee.getFee_v_amt()) %>원</td>
							</tr>
        				</table>
    				</td>
				</tr>				
				
			<%	
			String rent_st2 = String.valueOf(fee.get("RENT_ST"));
	  		for (int i = 2; i <= AddUtil.parseInt(rent_st2); i++) {
				ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
			%>
				<%if (!ext_fee.getCon_mon().equals("")) {%>
				<tr style="height: 10px;">
					<td colspan="6"></td>
				</tr>				
                <tr> 
                	<td>
                		<table width=800 border=0 cellpadding=0 cellspacing=1 bgcolor=a6b1d6>
						    <tr align="center">
								<td width=15% class="title" height="20">연장계약일</td>
								<td align="center" class="content"><%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
								<td width=15% class="title" height="20">대여개시일</td>
								<td align="center" class="content"><%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
								<td width=15% class="title" height="20">대여만료일</td>
								<td align="center" class="content"><%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
								<td width=15% class="title" height="20">대여기간</td>
								<td align="center" class="content"><%=ext_fee.getCon_mon()%>개월</td>
						    </tr>
						    <tr align="center">
								<%-- <td width=15% class="title" height="20">선납금</td>
								<td align="center" class="content"><%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원</td> --%>
								<td width=15% class="title" height="20">보증금</td>
								<td align="center" class="content"><%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>원</td>                	
								<td width=15% class="title" height="20">개시대여료</td>
								<td align="center" class="content"><%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원</td>
								<td width=15% class="title" height="20">월대여료</td>
								<td align="center" class="content" colspan="3"><span style="font-weight: bold;"><%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원</span></td>								
						    </tr>
					    </table>
                	</td>
                </tr>
          		<%}%>
			<%}%>				
				
				<tr>
				    <td height=15></td>
				</tr>
				<tr>
				    <td height=25>&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color=57589f><b>대여료입금 스케줄</b></font></td>
				</tr>
				<tr>
    				<td>
						<!-- 대여료입금 스케줄 -->
						<table width="800" border=0 cellpadding=0 cellspacing=1 bgcolor="#a6b1d6">
						    <tr>
						        <td width="4%" height="24" class="title">No</td>
						        <td width="18%" align="center" class="title">사용기간</td>
						        <td width="10%" align="center" class="title">입금예정일자</td>
						        <td width="8%" align="center" class="title">공급가</td>
						        <td width="8%" align="center" class="title">부가세</td>
						        <td width="8%" align="center" class="title">월대여료</td>
						        
						        <td width="10%" align="center" class="title">입금일자</td>
						        <td width="10%" align="center" class="title">실입금액</td>
						        <td width="7%" align="center" class="title">연체일수</td>
						        <td width="8%" align="center" class="title">연체료</td>
						        
						        <td width="10%" align="center" class="title">세금계산서<br>발행일자</td>
						    </tr>
					<%if (fee_scd_size>0) {%>
						<%for (int i = 0 ; i < fee_scd_size ; i++) {%>
							<%
								FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);
								
								
								//대여료 통계
								if (scd.getRc_amt() > 0) { //수금
									rc++;
									rs += Math.round(scd.getRc_amt()/1.1);
									rv += scd.getRc_amt()-(Math.round(scd.getRc_amt()/1.1));
								} else {
									if (scd.getDly_fee() == 0) { //미도래
										mc++;
										ms += scd.getFee_s_amt();
										mv += scd.getFee_v_amt();
									} else {
										nc++;
										ns += scd.getFee_s_amt();
										nv += scd.getFee_v_amt();
									}
								}
								//연체료 통계
								if (scd.getDly_fee()>0) {
									dc++;
									dt += scd.getDly_fee();
								}
							%>
							<%if (scd.getBill_yn().equals("Y") || scd.getRc_amt() > 0) {%>
							<tr class="t_font" <%if(i%2 != 0){%>style="background-color: #f7fae5;"<%}else{%>style="background-color: #FFFFFF;"<%}%>>
								<td height="20" align="center"><%= i+1 %></td>
								<td align="center"><%=AddUtil.ChangeDate2(scd.getUse_s_dt())%> ~ <%=AddUtil.ChangeDate2(scd.getUse_e_dt())%></td>
								<td align="center"><span class="style8"><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
								<td align="center"><%=Util.parseDecimal(scd.getFee_s_amt())%></td>
								<td align="center"><%=Util.parseDecimal(scd.getFee_v_amt())%></td>
								<td align="center">
									<span class="style14"><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></span>
								</td>
								
								<td align="center">
									<span class="style8"><%=AddUtil.ChangeDate2(scd.getRc_dt())%></span>
								</td>								
								<td align="center"><%=Util.parseDecimal(scd.getRc_amt())%></td>
								<td align="center"><%=scd.getDly_days()%>일</td>
								<td align="center"><%=Util.parseDecimal(scd.getDly_fee())%></td>
								
								<td align="center">
									<span class="style8"><%=AddUtil.ChangeDate2(scd.getExt_dt())%></span>
								</td>
							</tr>
							<%} else {%>	
							<tr class="t_font" <%if(i%2 != 0){%>style="background-color: #f7fae5;"<%}else{%>style="background-color: #FFFFFF;"<%}%>>
								<td height="20" align="center"><%= i+1 %></td>
								<td align="center"><%=AddUtil.ChangeDate2(scd.getUse_s_dt())%> ~ <%=AddUtil.ChangeDate2(scd.getUse_e_dt())%></td>
								<td align="center"><span class="style8"><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
								<td align="center"><%=Util.parseDecimal(scd.getFee_s_amt())%></td>
								<td align="center"><%=Util.parseDecimal(scd.getFee_v_amt())%></td>
								<td align="center">
									<span class="style14"><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></span>
								</td>
								
								<td align="center">
									<span class="style8"><%if(cls_chk.equals("Y")){%><%}else{%><%=cls.getCls_dt()/* AddUtil.replace(cls.getCls_dt(),"-","") */%><%}%></span>
								</td>								
								<td align="center"><%if(cls_chk.equals("Y")){%>0원<%}else{%>중도해지정산<%}%></td>
								<td align="center"><%=scd.getDly_days()%>일</td>
								<td align="center"><%=Util.parseDecimal(scd.getDly_fee())%></td>
								
								<td align="center">
									<span class="style8"><%=AddUtil.ChangeDate2(scd.getExt_dt())%></span>
								</td>
							</tr>
							<%}%>	
						<%}%>	
					<%}%>	
						</table>
						<!-- 대여료입금 스케줄 -->
    				</td>
				</tr>
				<tr>
				    <td height=15></td>
				</tr>
				<tr>
				    <td height=25>&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color=57589f><b>대여료 통계</b></font></td>
				</tr>
				<tr>
					<td>
						<table width="400" border=0 cellpadding=0 cellspacing=1 bgcolor=a6b1d6 style="float: left;">
							<tr>
								<td height="20" class="title">구분</td>
								<td width="60" height="20" class="title">건수</td>
								<td height="20" class="title">공급가</td>
								<td height="20" class="title">부가세</td>
								<td height="20" class="title">합계</td>
							</tr>
							<tr>
								<td height="20" class="title">미수금</td>
								<td class="content" align="right"><%=Util.parseDecimal(nc)%>건&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(ns)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(nv)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(ns + nv)%>원&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="title">수금</td>
								<td class="content" align="right"><%=Util.parseDecimal(rc)%>건&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(rs)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(rv)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(rs + rv)%>원&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="title">미도래금</td>
								<td class="content" align="right"><%=Util.parseDecimal(mc)%>건&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(ms)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(mv)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(ms + mv)%>원&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="title">합계</td>
								<td class="content" align="right"><%=Util.parseDecimal(nc + rc + mc)%>건&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(ns + rs + ms)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal(nv + rv + mv)%>원&nbsp;</td>
								<td class="content" align="right"><%=Util.parseDecimal((ns + nv) + (rs + rv) + (ms + mv))%>원&nbsp;</td>
							</tr>
						</table>
						
						<table width=230 border=0 cellpadding=0 cellspacing=1 bgcolor=a6b1d6 style="float: right; margin-right: 50px;">
							<tr>
								<td height="20" class="title" width="100">연체건수</td>
								<td class="content" align="right"><%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%>건&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="title" width="100">미수 연체료</td>
								<td class="content" align="right"><%=Util.parseDecimal(String.valueOf(AddUtil.parseInt(String.valueOf(fee_stat.get("DT"))) - AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")))))%>원&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="title" width="100">수금 연체료</td>
								<td class="content" align="right"><%=Util.parseDecimal(String.valueOf(fee_stat.get("DT2")))%>원&nbsp;</td>
							</tr>
							<tr>
								<td height="20" class="title" width="100">총연체료</td>
								<td class="content" align="right"><%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%>원&nbsp;</td>
							</tr>
						</table>
						
						<%-- <img src="/acar/images/stamp.png" align="absmiddle" style="float: right; width: 90px; margin-right: 50px; <%if (stamp_yn.equals("N")) {%>display: none;<%}%>"> --%> 
					</td>
				</tr>
				<%if (stamp_yn.equals("Y")) {%>
				<tr>
				    <td height="30"></td>
				</tr>
				<tr>
					<td>
						<div style="position: relative; text-align: center;">
					  		<font face="바탕" style="z-index: 1; font-size : 25px; margin-left: -30px;"><b>주식회사 아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font>
					  		<img src="/acar/images/stamp.png" style="position:absolute; z-index: 2; left:620px; bottom: -23px; width: 80px;">
					  	</div>
					</td>
				</tr>
				<%}%>
            </table>
        </td>
    </tr>
</table>
</from>
</body>
</html>