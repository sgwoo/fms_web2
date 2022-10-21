<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"scd":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_yn 	= request.getParameter("reg_yn")==null?"":request.getParameter("reg_yn");
	String gubun	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여갯수 카운터
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	//건별 대여료 스케줄 리스트
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScd(l_cd);
		fee_scd_size = fee_scd.size();
	}else{
		fee_scd = af_db.getFeeScdRentst(l_cd, rent_st, "");//fee.getPrv_mon_yn()
		fee_scd_size = fee_scd.size();
		if(!rent_st.equals("1")) tae_sum=0;
	}
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean h_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	
	UsersBean a_user = u_db.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function pagesetPrint(){
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
	
	function IE_Print(){
		factory1.printing.header='';
		factory1.printing.footer='';
		factory1.printing.leftMargin=15;
		factory1.printing.rightMargin=15;
		<%if(fee_scd_size > 34){%>
		factory1.printing.topMargin=15;
		factory1.printing.bottomMargin=10;
		<%}else{%>
		factory1.printing.topMargin=20;
		factory1.printing.bottomMargin=15;
		<%}%>
		factory1.printing.Print(true, window);
	}
//-->
//-->
</script>
</head>
<body leftmargin="15" topmargin="10" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name="form1" method='post'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
  <table border='1' cellspacing='0' cellpadding='0' width='620'>
    <tr> 
      <td align="center" valign="middle" style="border-top: #99CC66 2px solid; border-left: #99CC66 2px solid; border-bottom: #99CC66 2px solid; border-right: #99CC66 2px solid;">
        <table width="600" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td colspan="14" height="15"></td>
          </tr>
          <tr align="center"> 
            <td colspan="14" style="font-size:14pt" height="30" bgcolor="#DFEFCF"><b>아마존카 
              장기대여 이용 안내문</b></td>
          </tr>
          <tr valign="bottom"> 
            <td colspan="7" height="30"  style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid; font-size=11pt"><b><%=base.get("FIRM_NM")%> 님</b></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3" align="right">작성일 : <%= AddUtil.getDate() %></td>
          </tr>
          <tr> 
            <td width="19">&nbsp;</td>
            <td width="19">&nbsp;</td>
            <td width="35">&nbsp;</td>
            <td width="35">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="70">&nbsp;</td>
            <td width="4">&nbsp;</td>
            <td width="19">&nbsp;</td>
            <td width="19">&nbsp;</td>
            <td width="70">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="60">&nbsp;</td>
            <td width="70">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="14" height="18"> <p>최상의 서비스를 제공하는 장기렌트전문 회사 (주)아마존카를 
                이용해 주셔서 감사합니다.</p></td>
          </tr>
          <tr> 
            <td colspan="14" height="18">앞으로 고객께서 이용하실 저희 (주)아마존카와의 차량계약 및 대여요금 
              내역입니다. </td>
          </tr>
          <tr> 
            <td colspan="14" height="18">업무에 참고하시기 바랍니다.</td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td colspan="5" height="23" style="font-size:10pt">▶ 계약사항</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">대여차종</td>
            <td colspan="3"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">월대여료(VAT별도)</td>
            <td colspan="4"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">장기대여보증금</td>
            <td colspan="2"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">개시대여료(VAT별도)</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="25"  style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=7pt" ><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;"><%= Util.parseDecimal(fee.getFee_s_amt()) %>원</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;"><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;"><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>원</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">대여기간</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">대여개시일</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">대여만료일</td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid;" bgcolor="#EAF4DF">비고</td>
          </tr>
          <tr align="center"> 
            <td colspan="5" height="25" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=fee.getCon_mon()%>개월</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=fee.getRent_start_dt()%></td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=fee.getRent_end_dt()%></td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid;"><%=base.get("CAR_NO")%></td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td colspan="5" height="23" style="font-size:10pt">▶ 대여료 입금 안내</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="14" height="18">고객님의 대여료 납부일은 매월 <span style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid; font-size=11pt">&nbsp;<b><%if(fee.getFee_est_day().equals("99")){%>말일<%}else{%><%= fee.getFee_est_day() %><%}%></b>&nbsp;</span> 일입니다.</td>
          </tr>
          <tr> 
            <td colspan="14" height="18">※ 결제일 변경을 원하시는 경우 (주)아마존카 총무팀 (Tel.02-392-4243)으로 
              요청 해 주시기 바랍니다.</td>
          </tr>
          <tr> 
            <td colspan="14" style="font-size:7pt" height="18">(결제일 조정 등으로 대여료 
              일자 계산 청구가 발생 될 수 있습니다. 입금일자가 공휴일/주말인 경우 익일이 입금일자입니다.)</td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td colspan="5" height="23" style="font-size:10pt">▶ 대여료 입금 스케줄</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2" align="center" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">회차</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF" colspan="2">입금일자</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">공급가</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">부가세</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">월대여료</td>
            <td>&nbsp;</td>
            <td colspan="2" align="center" height="20" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">회차</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">입금일자</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">공급가</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">부가세</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">월대여료</td>
          </tr>
        <% 	if(fee_scd_size>0){
				int h_size = Math.round(fee_scd_size/2);
				if(fee_scd_size%2 != 0){
					h_size = h_size+1;
				}
				for(int i = 0 ; i < h_size ; i++){
					FeeScdBean fee1 = (FeeScdBean)fee_scd.elementAt(i);
					FeeScdBean fee2 = new FeeScdBean();
					if(i+h_size < fee_scd_size){
						fee2 = (FeeScdBean)fee_scd.elementAt(i+h_size);
					}
			%>
          <tr> 
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt" <%if(fee_scd_size > 34){%>height="13"<%}else{%>height="17"<%}%>><%if(fee1.getTm_st2().equals("2")){%>b<%}%><%//= i+1 %><%=fee1.getFee_tm()%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%if(!fee1.getRc_yn().equals("1")){ out.print("V"); }else{ out.print("&nbsp;"); }%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt" colspan="2">&nbsp;<%=AddUtil.ChangeDate2(fee1.getFee_est_dt())%>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%=Util.parseDecimal(fee1.getFee_s_amt())%>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%=Util.parseDecimal(fee1.getFee_v_amt())%>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%=Util.parseDecimal(fee1.getFee_s_amt()+fee1.getFee_v_amt())%>&nbsp;</td>
            <td>&nbsp;</td>
			<%if(fee_scd_size%2 != 0 && i+h_size+1 > fee_scd_size){%>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">-</td>
			<%}else{%>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%//= i+h_size+1 %><%=fee2.getFee_tm()%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><% if(!fee2.getRc_yn().equals("1")){ out.print("V"); }else{ out.print("&nbsp;"); }%></td>
            <td align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt">&nbsp;<%= AddUtil.ChangeDate2(fee2.getFee_est_dt()) %>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%= Util.parseDecimal(fee2.getFee_s_amt()) %>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%= Util.parseDecimal(fee2.getFee_v_amt()) %>&nbsp;</td>
            <td align="right"  style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 <%if(i == h_size-1){%>1px<%}else{%>0px<%}%> solid; border-right: #99CC66 1px solid; font-size=7pt"><%= Util.parseDecimal(fee2.getFee_s_amt()+fee2.getFee_v_amt()) %>&nbsp;</td>
			<%}%>
          </tr>
          <% }
		  	}else{  %>
          <tr> 
            <td height="17" colspan="7" align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">-</td>
            <td>&nbsp;</td>
            <td colspan="6" align="center" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">-</td>
          </tr>
          <% } %>
		  <%if(tae_sum>0){%>
          <tr> 
            <td colspan="14" style="font-size:7pt" height="18">(회차에 b가 표시된 것은 <%if(String.valueOf(base.get("CAR_NO")).equals(taecha.getCar_no())){%>만기매칭대차<%}else{%>출고전대차<%}%> 스케줄입니다.)</td>
          </tr>
		  <%}%>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
		  <%if(cms.getRent_l_cd().equals("")){%>
          <tr> 
            <td colspan="10" height="23" style="font-size:10pt">▶ 입금방법 : 온라인 계좌이체 
              (★ 자동이체 미신청 시)
			</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2" align="right">예금주 : (주)아마존카</td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">은행명</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">계좌번호</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">은행명</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">계좌번호</td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="17" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">하나은행</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">140-910014-53104</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">국민은행</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt">385-01-0026-124</td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="17" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">신한은행</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">140-004-023871</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">시티은행</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">163-01374-242</td>
          </tr>
          <tr> 
            <td colspan="14" style="font-size:7pt" height="18">※ 상기은행 중 원하시는 곳으로 
              납부를 부탁드리며, 자동이체 신청을 원하시는 경우 저희 아마존카로 문의 해 주시기 바랍니다.</td>
          </tr>
		  <%}else{%>
          <tr> 
            <td colspan="10" height="23" style="font-size:10pt">▶ 입금방법 : 자동이체</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2" align="right"></td>
          </tr>
          <tr align="center"> 
            <td colspan="4" height="18" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">은행명</td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">계좌번호</td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">최초인출일</td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">마지막인출일</td>
            <td style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 0px solid; border-right: #99CC66 1px solid; font-size=8pt" bgcolor="#EAF4DF">이체일</td>			
          </tr>
          <tr align="center"> 
            <td colspan="4" height="17" style="border-top: #99CC66 1px solid; border-left: #99CC66 1px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt"><%=cms.getCms_bank()%></td>
            <td colspan="3" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt"><%=cms.getCms_acc_no()%></td>
            <td colspan="4" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">&nbsp;<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%></td>
            <td colspan="2" style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">&nbsp;<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%></td>
            <td style="border-top: #99CC66 1px solid; border-left: #99CC66 0px solid; border-bottom: #99CC66 1px solid; border-right: #99CC66 1px solid; font-size=8pt">매월 <%=cms.getCms_day()%>일</td>			
          </tr>
		  <%}%>
          <tr> 
            <td height="15" colspan="14">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="14" height="18">저희 (주)아마존카는 고객의 안전운행을 위하여 세심한 차량관리 서비스로 
              최선을 다하고 있습니다.</td>
          </tr>
          <tr> 
            <td height="8" colspan="14"></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="4" height="20" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid;">영업담당 
              : <%=h_user.getUser_nm()%> (HP. <%=h_user.getUser_m_tel()%>)</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="4" height="20" style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 1px solid; border-right: #000000 0px solid;">회계담당 
              : <%=a_user.getUser_nm()%> (Tel. <%=a_user.getHot_tel()%>)</td>
          </tr>
          <tr> 
            <td colspan="14" height="8"></td>
          </tr>
          <tr> 
            <td colspan="4"><font color="#FF0000"><img src="/acar/images/logo_1.png" width="75" height="20" border="0"></font></td>
            <td colspan="10" style="font-size:7pt" valign="bottom">(주)아마존카 : Tel.02)757-0802 
              Fax.02)757-0803 / 서울 영등포구 여의도동 17-3 / http://www.amazoncar.co.kr</td>
          </tr>
          <tr> 
            <td colspan="14" height="15"></td>
          </tr>
        </table>
    </tr>
  </table>
  </form>
</body>
</html>
