<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.ext.*, acar.cls.*, acar.fee.*, acar.car_mst.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var gubun5 	= fm.gubun5.value;
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/fms2/con_cls/cls_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
	
	//통합채권이동관리
	function credit_move(){
		var fm = document.form1;
		
		if(!confirm("통합채권관리에서 관리하시겠습니까?"))	return;	
		
		fm.action = "/fms2/receive/rece_upd_null.jsp";
		fm.target = 'i_no';
		fm.submit();
						
	}
	
		

	//대여료 공급가,부가세 계산 세팅
	function cal_sv_amt(idx)
	{
		var fm = i_in2.form1;
		if(parseDigit(fm.t_fee_amt[idx].value).length > 8)
		{	alert('대여료금액을 확인하십시오');		return;	}
		fm.t_fee_amt[idx].value = parseDecimal(fm.t_fee_amt[idx].value);
		fm.t_fee_s_amt[idx].value = parseDecimal(sup_amt(toInt(parseDigit(fm.t_fee_amt[idx].value))));
		fm.t_fee_v_amt[idx].value = parseDecimal(toInt(parseDigit(fm.t_fee_amt[idx].value)) - toInt(parseDigit(fm.t_fee_s_amt[idx].value)));
	}
	
	
		//대여료 스케줄 인쇄화면
	function ext_print()
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var b_dt = fm.rent_end_dt.value;
		var cls_chk;
		cls_chk='Y';
		window.open("cls_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk, "PRINT_VIEW", "left=50, top=50, width=700, height=640, scrollbars=yes");
	}			
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "03");
	
	//해지정보
	Hashtable fee_base = af_db.getFeebasecls2(m_id, l_cd);
	
	ClsBean cls_info = ac_db.getClsCase(m_id, l_cd);
	
	//연체료 셋팅 (대여료)
	boolean flag = af_db.calDelayPrint(m_id, l_cd, cls_info.getCls_dt());
	
	//통계
	IncomingBean cls = ae_db.getClsScdCaseStat(m_id, l_cd);
	
	//실이용기간
	String mon_day = ac_db.getMonDay((String)fee_base.get("RENT_START_DT"), cls_info.getCls_dt());
	String mon = "0";
	String day = "0";
	if(mon_day.length() > 0){
		mon = mon_day.substring(0,mon_day.indexOf('/'));
		day = mon_day.substring(mon_day.indexOf('/')+1);
	}
	
	//휴/대차료 이름
	String h_title = "휴차료";
	if(!String.valueOf(fee_base.get("CAR_NO")).equals("")){
		if(String.valueOf(fee_base.get("CAR_NO")).indexOf("허") == -1)			h_title = "대차료";
		else																	h_title = "휴차료";
	}
	//건별 대여료 스케줄 통계
	Hashtable fee_stat = af_db.getFeeScdStat(m_id, l_cd, "2");
	int fee_stat_size = fee_stat.size();
	
	//회차연장위해 필요
	//기본정보
	Hashtable fee = af_db.getFeebase(m_id, l_cd);
	//건별 대여료 스케줄 리스트
	Vector fee_scd = af_db.getFeeScd(l_cd, "Y");
	int fee_scd_size = fee_scd.size();
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 13; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-10;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(height < 50) height = 150;
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='r_st' value='1'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='cls_tm' value=''>
<input type='hidden' name='pay_amt' value=''>
<input type='hidden' name='cls_s_amt' value=''>
<input type='hidden' name='cls_v_amt' value=''>
<input type='hidden' name='cls_est_dt' value=''>
<input type='hidden' name='pay_dt' value=''>
<input type='hidden' name='ext_dt' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='pay_yn' value=''>
<input type='hidden' name='vat_st' value='<%=cls_info.getVat_st()%>'>
<!--해지대여료-->
<input type='hidden' name='h_fee_tm' value=''>
<input type='hidden' name='h_tm_st1' value=''>
<input type='hidden' name='h_fee_amt' value=''>
<input type='hidden' name='h_fee_s_amt' value=''>
<input type='hidden' name='h_fee_v_amt' value=''>
<input type='hidden' name='h_rc_amt' value=''>
<input type='hidden' name='h_rc_dt' value=''>
<input type='hidden' name='h_fee_ext_dt' value=''>
<input type='hidden' name='h_ext_gubun' value=''>
<input type='hidden' name='prv_mon_yn' value=''>
<input type='hidden' name='credit_st' value=''>
<input type='hidden' name='page_gubun' value='cls'>
<input type='hidden' name='rent_end_dt' value='<%=cls_info.getCls_dt()%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='ht_rent_seq' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
	    <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 >해지채권관리 > 해지정산금 관리 <span class=style5>해지정산금 스케줄 조회 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align="right"> 

        	<a href="javascript:credit_move();">통합관리이관</a> 
              &nbsp;<a href="javascript:go_to_list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
			  &nbsp;<a href="javascript:history.go(-1);"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a>
	    </td> 
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='12%' class='title' height="91">해지구분</td>
                    <td width="17%" height="91">&nbsp;<%=cls_info.getCls_st()%> </td>
                    <td width='13%' class='title' height="91">계약번호</td>
                    <td height="25%">&nbsp;<%=fee_base.get("RENT_L_CD")%></td>
                    <td width='12%' class='title'>담당자</td>
                    <td height="21%">&nbsp;영업담당 : <%=c_db.getNameById((String)fee.get("BUS_ID2"),"USER")%> 
                      / 관리담당 : <%=c_db.getNameById((String)fee.get("MNG_ID"),"USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>상호</td>
                    <td>&nbsp;<%=fee_base.get("FIRM_NM")%></td>
                    <td class='title'>고객명</td>
                    <td>&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
                    <td class='title'>대여차명</td>
                    <td>&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
                    <td class='title'>등록일</td>
                    <td>&nbsp;<%=fee_base.get("INIT_REG_DT")%></td>
                    <td class='title'>대여기간</td>
                    <td>&nbsp;<%=fee_base.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cls_info.getCls_dt()%></td>
                </tr>
                <tr> 
                    <td class='title'>총대여기간</td>
                    <td>&nbsp;<%=fee_base.get("TOT_CON_MON")%>개월</td>
                    <td class='title'>실이용기간</td>
                    <td>&nbsp;<%=mon%>개월&nbsp;<%=day%>일</td>
                    <td class='title'>대여방식</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_WAY").equals("1")){%>
                      일반식 
                      <%}else if(fee_base.get("RENT_WAY").equals("2")){%>
                      맞춤식 
                      <%}else{%>
                      기본형 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>월대여료</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_ST").equals("1")){%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
                      <%}else{%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
                      <%}%>
                      원&nbsp;</td>
                    <td class='title'>선납금액</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_ST").equals("1")){%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT")))%> 
                      <%}else{%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_PP_AMT"))+AddUtil.parseInt((String)fee_base.get("EX_IFEE_AMT")))%> 
                      <%}%>
                      원&nbsp;</td>
                    <td class='title'>개시대여료</td>
                    <td>&nbsp; 
                      <%if(fee_base.get("RENT_ST").equals("1")){%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT")))%> 
                      <%}else{%>
                      <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_PP_AMT"))+AddUtil.parseInt((String)fee_base.get("EX_IFEE_AMT")))%> 
                      <%}%>
                      원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>선납금&nbsp;납입방식</td>
                    <td>&nbsp; 
                      <% if(cls_info.getPp_st().equals("1")){%>
                      3개월치대여료선납식 
                      <%}else{%>
                      고객선택형선납식 
                      <%}%>
                    </td>
                    <td class='title'>세금계산서 발행일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cls_info.getExt_dt())%></td>
                    <td class='title'>부가세포함여부</td>
                    <td>&nbsp; 
                      <% if(cls_info.getVat_st().equals("1")){%>
                      포함 
                      <%}else{%>
                      미포함 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title' style='height:44'>해지내역 </td>
                    <td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="3" width=100%>
                            <tr>
                                <td><%=cls_info.getCls_cau()%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align='left' colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지 정산금 수금 스케쥴</span>       
        <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:ext_print()"><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a>
        <%}%>	  
	    </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line' c> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=4% class='title'>연번</td>
                    <td width=8% class='title'>입금예정일</td>
                    <td width=8% class='title'>공급가</td>
                    <td width=8% class='title'>부가세</td>
                    <td width=8% class='title'>해지금</td>
                    <td width=8% class='title'>입금일자 </td>
                    <td width=8% class='title'>실입금액</td>
                    <td width=7% class='title'>연체일수 </td>
                    <td width=8% class='title'>연체료</td>
                    <td width=7% class='title'>입금/취소</td>
                    <td width=5% class='title'>수정</td>
                    <td width=5% class='title'>대손</td>			
                    <td width=15% class='title'>세금계산서 발행일자</td>						
                </tr>
            </table>
        </td>
        <td width='17'>&nbsp;</td>	  
    </tr>	
    <tr> 
        <td colspan="2"> <iframe src="/fms2/con_cls/cls_c_in.jsp?auth=1&auth_rw=1&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client_id%>&cls_dt=<%=cls_info.getCls_dt()%>&brch_id=<%=fee_base.get("BRCH_ID")%>" name="i_in" width="100%" height="80" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe> </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지정산 대여료 수금 스케쥴</span></td>
        <td align='right'>
    
	    </td>
    </tr>
    <tr> 
        <td colspan='2'><iframe src="/fms2/con_cls/fee_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&cls_dt=<%=cls_info.getCls_dt()%>&brch_id=<%=fee_base.get("BRCH_ID")%>" name="i_in2" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe> </td>
    </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>		
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지정산 통계</span></td>
    </tr>
    <tr>
	    <td>
	        <table width='100%'>
		        <tr>
        		    <td width=60%>
        			    <table border="0" cellspacing="0" cellpadding="0" width=100%>
        			        <tr>
            			        <td class=line2></td>
            			    </tr>
        			        <tr>
                				<td class='line'>
                				    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                        <tr> 
                                            <td class='title'>구분</td>
                                            <td class='title' colspan="2">해지 정산금</td>
                                            <td class='title' colspan="2">해지 대여료</td>
                                        </tr>
                                        <tr> 
                                            <td class='title' width='20%' height="24">구분</td>
                                            <td class='title' width='20%' height="24">건수</td>
                                            <td class='title' width='20%' height="24">청구금액</td>
                                            <td class='title' width="20%" height="24">건수</td>
                                            <td class='title' width="20%" height="24">청구금액</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>미수금</td>
                                            <td align='right'><%=cls.getTot_su1()%>건&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(cls.getTot_amt1()))%>원&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("NC")))%>건&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("N")))%>원&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>수금</td>
                                            <td align='right'><%=cls.getTot_su2()%>건&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(cls.getTot_amt2()))%>원&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("RC")))%>건&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("R")))%>원&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>합계</td>
                                            <td align='right'><%=cls.getTot_su1()+cls.getTot_su2()%>건&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(cls.getTot_amt1()+cls.getTot_amt2()))%>원&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("TC")))%>건&nbsp;</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("TOT")))%>원&nbsp;</td>
                                        </tr>
                                    </table>
                			    </td>
        				    </tr>
        			    </table>
        			<td width='8%'></td>
        			<td width='31%' valign='top'>
        			    <table border="0" cellspacing="0" cellpadding="0" width=100%>
        			        <tr>
            			        <td class=line2></td>
            			    </tr>
        				    <tr>
        				        <td class='line'>
        					        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                        <tr> 
                                            <td class='title' rowspan="2" width='25%'>정산금</td>
                                            <td class='title' width='25%'>연체건수</td>
                                            <td align='right' width="50%"><%=cls.getTot_su3()%>건&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>연체료계</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(cls.getTot_amt3()))%>원&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title' rowspan="2">대여료</td>
                                            <td class='title'>연체건수</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%>건&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td class='title'>연체료계</td>
                                            <td align='right'><%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%>원&nbsp;</td>
                                        </tr>
                                    </table>								
        				        </td>
				            </tr>
			            </table>
			        </td>
			        <td width=25>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--

	var fm = document.form1;

	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;				
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>

