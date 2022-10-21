<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, acar.client.*, tax.*, cust.member.*, acar.credit.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//메일관리 페이지
	
	String mtype 	= request.getParameter("mtype")==null?"":request.getParameter("mtype");
	
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
	String pur_email	= request.getParameter("pur_email")==null?"":request.getParameter("pur_email");
	int count2 = 0;
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//cont_view
	Hashtable base 			= a_db.getContViewCase(m_id, l_cd);
	
	if(c_id.equals("")) c_id = String.valueOf(base.get("CAR_MNG_ID"));
	
	CarHisBean ch_r [] = crd.getCarHisAll(c_id); 
	
	Vector attach_vt = new Vector();		
	int attach_vt_size = 0;		
    String attach_seq = "";			
	for(int i=0; i<ch_r.length; i++){
      	  ch_bean = ch_r[i];
	      attach_vt = c_db.getAcarAttachFileList("CAR_CHANGE", ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq(), 0);		 //차량정보변경시 등록증 스캔이 안되는 경우도 있음. 	
	      attach_vt_size = attach_vt.size();
		  Hashtable attach_ht = new Hashtable();
		  if(attach_vt_size > 0){					  		
		  		for (int j = 0 ; j < attach_vt_size ; j++){
		  			attach_ht = (Hashtable)attach_vt.elementAt(j);    	
		  		}		
		  		attach_seq = String.valueOf(attach_ht.get("SEQ"));
		  } 
	}
	
	
	//자동이체정보
	ContCmsBean cms 		= a_db.getCmsMng(m_id, l_cd);
	//거래처정보
	ClientBean client       = al_db.getClient(String.valueOf(base.get("CLIENT_ID")));
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(String.valueOf(base.get("CLIENT_ID")), String.valueOf(base.get("R_SITE")));
	//거래처담당자이메일
	Vector mgrs 			= al_db.getClientMgrEmailList(String.valueOf(base.get("CLIENT_ID")), l_cd);
	int mgr_size = mgrs.size();
	
	//대여갯수 카운터
	int fee_count	= af_db.getFeeCount(l_cd);
	if(rent_st.equals("")) rent_st = String.valueOf(fee_count);
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm 	= a_db.getMax_fee_tm(m_id, l_cd, rent_st);
	
	//고객FMS임시아이디 지정
	MemberBean m_bean = m_db.getMemberCase(String.valueOf(base.get("CLIENT_ID")), "", "");
	if(m_bean.getMember_id().equals("")){
		//회원정보 등록
		MemberBean no_m_bean = m_db.getNoMemberCase(String.valueOf(base.get("CLIENT_ID")), "", "");
		
		int idcnt = m_db.checkMemberIdPwd("amazoncar", no_m_bean.getPwd());
			
		if(idcnt==0){
				count2 = m_db.insertMember(String.valueOf(base.get("CLIENT_ID")), "", "amazoncar", no_m_bean.getPwd(), "");
		}else{
				count2 = m_db.updateMemberUseYN( String.valueOf(base.get("CLIENT_ID")) ); //기존 use_yn='N'를'Y'로 처리 
			//	count2 = m_db.insertMember(base.getClient_id(), "", "amazoncar", no_m_bean.getPwd()+String.valueOf(idcnt+1), "");
		}	
		
		
	}
	
	String cls_st = String.valueOf(base.get("CLS_ST"));
	
	//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(m_id, l_cd);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function ImEmail_Reg(){
		var fm = document.form1;
		if(fm.l_cd.value == '')				{	alert('선택된 계약이 없습니다. 확인하십시오.'); return; }
		if(fm.content.options[fm.content.selectedIndex].value == ''){	alert('메일종류를 선택하여 주십시오.'); return; }
		if(fm.content.selectedIndex == '1'){
			if(fm.max_fee_tm.value == '' || fm.max_fee_tm.value == '0')		{	alert('생성된 스케줄이 없습니다. 확인하십시오.'); return; }
		}
		if(fm.con_agnt_email.value == '')	{	alert('수신메일주소를 입력하십시오.'); return; }
		
		if (fm.pur_email.value == 'pur_opt') {
			if (fm.cls_dt.value == '') {
				alert('해지일자를 입력하십시오.');
				return;
			} else {
				if(confirm('해지일자 변경시 납입금액을 다시한번 확인 부탁드립니다. \n매입옵션 안내문을 발송 하시겠습니까?')) {
					var temp_cls_dt = fm.cls_dt.value;
					var replace_cls_dt = temp_cls_dt.replace(/\-/g,'');
					fm.content.options[fm.content.selectedIndex].value = "http://fms1.amazoncar.co.kr/acar/apply/pur_opt_email.jsp?mtype="+fm.mtype.value+"&m_id="+fm.m_id.value+"&l_cd="+fm.l_cd.value+"&cls_dt="+replace_cls_dt;
					fm.target = "i_no";
					fm.action = "rent_email_reg_a.jsp";
					fm.submit();
				}
			}
		} else {
			if(confirm('등록 하시겠습니까?')){
				if(fm.content.options[fm.content.selectedIndex].value.search('change_pay_way.jsp')!=-1){
					fm.content.options[fm.content.selectedIndex].value = fm.content.options[fm.content.selectedIndex].value+'&pay_way='+fm.pay_way.value;
				}
				fm.target = "i_no";
				fm.action = "rent_email_reg_a.jsp";
				fm.submit();						
			}	
		}
		
	}
	
	//미리보기
	function ImEmail_View(){
		var fm = document.form1;
		if(fm.l_cd.value == '')				{	alert('선택된 계약이 없습니다. 확인하십시오.'); return; }
		if(fm.content.options[fm.content.selectedIndex].value == ''){	alert('메일종류를 선택하여 주십시오.'); return; }		
		if(fm.content.selectedIndex == '1'){
			if(fm.max_fee_tm.value == '' || fm.max_fee_tm.value == '0')		{	alert('생성된 스케줄이 없습니다. 확인하십시오.'); return; }
		}
		
		window.open("about:blank", "ScdDocView", "left=150, top=150, width=800, height=650, scrollbars=yes");
				
		if (fm.pur_email.value == 'pur_opt') {
			var temp_cls_dt = fm.cls_dt.value;
			var replace_cls_dt = temp_cls_dt.replace(/\-/g,'');
			fm.content.options[fm.content.selectedIndex].value = "http://fms1.amazoncar.co.kr/acar/apply/pur_opt_email.jsp?mtype="+fm.mtype.value+"&m_id="+fm.m_id.value+"&l_cd="+fm.l_cd.value+"&cls_dt="+replace_cls_dt;
			fm.action = fm.content.options[fm.content.selectedIndex].value;
		} else {
			if(fm.content.options[fm.content.selectedIndex].value.search('change_pay_way.jsp')!=-1){
				fm.content.options[fm.content.selectedIndex].value = fm.content.options[fm.content.selectedIndex].value+'&pay_way='+fm.pay_way.value;
			}
			fm.action = fm.content.options[fm.content.selectedIndex].value;
		}
		fm.target = "ScdDocView";
		fm.submit();
	}
	
	//받는 메일 셋팅
	function Email_Set(nm, email){
		var fm = document.form1;
		fm.con_agnt_nm.value 	= nm;
		fm.con_agnt_email.value = email;
	}
	
	//메일종류에 따라 폼변경(20191111)
	function change_opt(val){
		var fm = document.form1;
		if(val.search("change_pay_way.jsp") == -1){
			$("#view_pay_way").css("display","none");
		}else{
			$("#view_pay_way").css("display","block");
		}
		
		if(val.search("scd_info.jsp") == -1){
			$("#scd_list_button").css("display", "none");
		}else{
			$("#scd_list_button").css("display", "");
		}
	}
	
	//전체이용차량리스트
	function list_view() {
		window.open("/acar/car_rent/scd_fee_rent_list.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>", "print_view", "left=100, top=100, width=1300, height=700, scrollbars=yes");
	}
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
.button_style {
	background-image: linear-gradient(#919191, #787878);
    font-size: 10px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 3px;
    color: #FFF;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
</style>
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='cls_st' value='<%=base.get("CLS_ST")%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='reg_yn' value='<%=reg_yn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='max_fee_tm' value='<%=max_fee_tm%>'>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='client_id' value='<%=base.get("CLIENT_ID")%>'>
<input type='hidden' name='bus_id2' value='<%=base.get("BUS_ID2")%>'>
<input type='hidden' name='pur_email' id="check_pur" value='<%=pur_email%>'>
<input type='hidden' name='mtype' value='<%=mtype%>'>
<input type='hidden' name='send_seq' value='<%=attach_seq%>'>
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;계약서관리 > <span class=style1><span class=style5>이메일관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='11%' class='title'>계약번호</td>
                    <td width='29%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='11%' class='title'>상호</td>
                    <td width="49%">
                        &nbsp;<%=base.get("FIRM_NM")%>
                        &nbsp;<%=base.get("R_SITE")%>
					</td>
                </tr>
                <tr>
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=base.get("CAR_NO")%></td>
                    <td width="11%" class='title'>차명</td>
                    <td>
                    	&nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span>
                    </td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                    <td width="11%" class='title'>CMS</td>
                    <td>
                    	&nbsp;
                    <%if (!cms.getCms_bank().equals("")) {%>
                    	<%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (매월 <%=cms.getCms_day()%>일)
                    <%} else {%>
    			      	-
    			    <%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td width="11%" class='title'>관리담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr> 
<% 	
	Vector vts = ImEmailDb.getMailHistoryList("4", l_cd);
	int vt_size = vts.size();
	if (vt_size > 0) {
%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>이메일 발송 리스트</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>		
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width="25%" class='title'>메일종류</td>			
                    <td width="25%" class='title'>발송일시</td>
                    <td width="29%" class='title'>이메일주소</td>
                    <td width="8%" class='title'>수신여부</td>
                    <td width="8%" class='title'>발송상태</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++) {
    				Hashtable ht = (Hashtable)vts.elementAt(i);%>
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'>                    	
						<%=ht.get("MAIL_TYPE")%>                    	
                    </td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
                    <td align='center'><%=ht.get("EMAIL")%></td>
                    <td align='center'><%=ht.get("OCNT_NM")%></td>
                    <td align='center'><%=ht.get("MSGFLAG_NM")%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
<%}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>거래처 담당자</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width="25%" class='title'>구분</td>
                    <td width="25%" class='title'>성명</td>
                    <td width="45%" class='title'>이메일주소</td>
                </tr>
               	<%for (int i = 0 ; i < mgr_size ; i++) {
    				Hashtable ht = (Hashtable)mgrs.elementAt(i);%>
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("MGR_ST")%></td>
                    <td align='center'><%=ht.get("MGR_NM")%></td>
                    <td align='center'><a href="javascript:Email_Set('<%=ht.get("MGR_NM")%>','<%=ht.get("MGR_EMAIL")%>');"><%=ht.get("MGR_EMAIL")%></a></td>
                </tr>
                <%}%>
    		    <%if (!client.getCon_agnt_email().equals("")) {%>
                <tr>
                    <td align='center'><%=mgr_size+1%></td>
                    <td align='center'>세금계산서</td>
                    <td align='center'><%=client.getCon_agnt_nm()%></td>
                    <td align='center'><a href="javascript:Email_Set('<%=client.getCon_agnt_nm()%>','<%=client.getCon_agnt_email()%>');"><%=client.getCon_agnt_email()%></a></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>	
    <tr>
        <td colspan="2" class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>   	    
                <tr>
                    <td width='11%' class='title'>메일종류</td>
                    <td width='89%'>&nbsp;
					<%if (pur_email.equals("pur_opt")) {%>
						<select name="content">
							<option value="https://fms1.amazoncar.co.kr/acar/apply/pur_opt_email.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&cls_dt=<%=cls.getCls_dt()%>&mtype=<%=mtype%>" selected>매입옵션안내문(양도증명서+정산서) </option>
						</select>
					<%} else if (pur_email.equals("rm_etc")) {%>
						<select name="content">
							<option value="https://fms1.amazoncar.co.kr/mailing/cls/cls_rm_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>">월렌트 해지정산서 </option>							
						</select>	
					<%} else if (pur_email.equals("cls_est")) {%>
						<select name="content">
							<option value="https://fms1.amazoncar.co.kr/mailing/cls/cls_est_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>">해지정산 사전정산서 </option>							
						</select>		
					<%} else {%>
        				<select name="content" onchange="javascript:change_opt(this.value);">
						<%if (!mtype.equals("cls")) {%>
							<option value="">선택</option>
							<option value="https://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">자동차 관리 서비스 안내문(통합)</option> 
			                <!--<option value="http://fms1.amazoncar.co.kr/mailing/rent/scd_fee.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">장기대여이용안내문(대여료납입)</option>*/
			                <option value="http://fms1.amazoncar.co.kr/mailing/fms/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>" <%if(gubun.equals("rent_i"))%>selected<%%>>고객FMS이용안내문</option>
			                <option value="http://fms1.amazoncar.co.kr/mailing/car_adm/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">차량관리안내문</option>
							<option value="http://fms1.amazoncar.co.kr/mailing/ins/sos.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>">마스타자동차긴급출동안내문</option>
							<option value="http://fms1.amazoncar.co.kr/mailing/cms/cms_fine.html">유료고속도로&주차장 미납통행료납부 안내문</option>
							<option value="http://fms1.amazoncar.co.kr/mailing/etc/notice_rep.html">스피드메이트 자동차협력업체 안내문</option>-->
							<option value="https://fms1.amazoncar.co.kr/mailing/cms/bank.html">통장사본</option>
							<option value="https://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%//=rent_st%>">장기대여스케줄안내문</option>
							<!--<option value="http://fms1.amazoncar.co.kr/mailing/etc/fine_receipt.html">과태료&통행료&주차요금 영수증발급기관 안내</option>-->
							<option value="https://fms1.amazoncar.co.kr/mailing/etc/bluemem.html">현대자동차 블루멤버스 안내</option>
							<!--<option value="http://fms1.amazoncar.co.kr/mailing/etc/2012_play.html">201204 고객사은행사 안내문</option>-->
							<!--	<option value="http://fms1.amazoncar.co.kr/mailing/etc/fine_receipt_t.html">과태료&통행료&주차요금 영수증발급기관 안내-FAX용</option> -->
							<!--		<option value="http://fms1.amazoncar.co.kr/mailing/cms/cms_m.jsp?client_id=<%=String.valueOf(base.get("CLIENT_ID"))%>">CMS 변경안내문</option> -->
							<option value="https://fms1.amazoncar.co.kr/mailing/rent/change_pay_way.jsp?client_id=<%=base.get("CLIENT_ID")%>&bus_id2=<%=base.get("BUS_ID2")%>">장기대여 대여료 결제수단 안내</option>							
						<%}%>					
						<%if (mtype.equals("cls_etc")) {%>  
							<option value="https://fms1.amazoncar.co.kr/mailing/cls/cls_con_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>">해지정산내역안내문 </option>
						<%}%>		
	             
				        <%if (client.getClient_st().equals("1")) {%>   
			                <%-- <option value="http://fms1.amazoncar.co.kr/mailing/ins/exp_info_c.jsp?client_id=<%=base.get("CLIENT_ID")%>">업무용승용차 손비처리 기준 변경 안내</option> --%>
				        <%}%>
				        <%if (client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {%>   
				            <!-- <option value="http://fms1.amazoncar.co.kr/mailing/ins/exp_info_p.jsp">업무용승용차 운행기록부 작성 안내</option> 20211124 미사용처리-->
				        <%}%>
				        
						<%if (AddUtil.getDate(1).equals("2011") && AddUtil.getDate(2).equals("04")) {//201104월 한시적 뮤지컬 사은행사메일%>
								<!--<option value="http://fms1.amazoncar.co.kr/mailing/etc/2012_play.html">201204 고객사은행사 안내문</option>-->
						<%}%>
			
						<%if (!String.valueOf(base.get("CAR_NO")).equals("")) {%>		
							<option value="https://fms1.amazoncar.co.kr/mailing/off_doc/select_scan_email_docs.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>">자동차등록증</option>
						<%}%>
		
                			<!-- <option value="http://fms1.amazoncar.co.kr/mailing/cms/cms_m.html">CMS변경사항안내문</option> -->   					
            			</select>
					<%}%>

						<%if (!mtype.equals("cls")) {%>
						&nbsp;&nbsp;<input type="button" class="button_style" id="scd_list_button" value="이용차량 리스트" onclick="list_view();" style="display: none;">
						<%}%>

						<span id="view_pay_way" style="display: none;">
							&nbsp;&nbsp;
			        		<input type="radio" name="pay_way" value="ARS" checked>ARS&nbsp;&nbsp;
			        		<input type="radio" name="pay_way" value="visit">방문	
						</span>
						
					</td>
                </tr>
                            
                <tr>
                	<td width='11%' class='title'>이름</td>
                    <td width='89%'>&nbsp;
                    <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
                </tr>
                <tr>
                    <td class='title'>EMAIL</td>
                    <td>&nbsp;
                        <input type='text' size='40' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'>
					</td>
                </tr>
                <%if (pur_email.equals("pur_opt")) {%>
                <tr>
                	<td class='title'>해지일자</td>
                    <td>&nbsp;
                        <input type='text' size='40' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' maxlength='30' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '>
                    </td>
                </tr>
                <%}%>
            </table>
         </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
	    <td><a href="javascript:ImEmail_View();"><img src=/acar/images/center/button_see_pre.gif align=absmiddle border=0></a></td>
        <td align="right">
        	<%if (!auth_rw.equals("1")) {%>
            <a href="javascript:ImEmail_Reg();"><img src=/acar/images/center/button_bh.gif align=absmiddle border=0></a>&nbsp;
            <%}%>
		  	<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe>
</body>
</html>
