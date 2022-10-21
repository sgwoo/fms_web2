<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.car_register.*, acar.car_mst.*, acar.alink.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="cr_bean" scope="page" class="acar.car_register.CarRegBean"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	String link_table 	= request.getParameter("link_table")==null?"":request.getParameter("link_table");
	String link_type 	= request.getParameter("link_type")==null?"":request.getParameter("link_type");
	String link_rent_st 	= request.getParameter("link_rent_st")==null?"":request.getParameter("link_rent_st");
	String link_im_seq 	= request.getParameter("link_im_seq")==null?"":request.getParameter("link_im_seq");

	if(link_table.equals("rm_rent_link_m")) link_table = "rm_rent_link";
	if(link_table.equals("lc_rent_link")) link_table = "lc_rent_link_m";

	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//계약담당자
	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "계약담당자");
	//계약승계-기존임차인
	CarMgrBean suc_mgr = new CarMgrBean();
	
	if(link_type.equals("2")){	
		suc_mgr = a_db.getCarMgr(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "계약담당자");	
	}
	
	//고객관련자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
	
	//기전송 계약서가 있는지 확인한다.
	Vector vt = ln_db.getALinkHisList("lc_rent_link", link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size = vt.size();

	Vector vt2 = ln_db.getALinkHisListM("lc_rent_link_m", link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size2 = vt2.size();
	
	Vector vt3 = ln_db.getALinkHisStatList("lc_rent_link", link_type, rent_l_cd, link_rent_st, link_im_seq); 
	int vt_size3 = vt3.size();	
		
	Vector vt4 = ln_db.getALinkHisStatListM("lc_rent_link_m", link_type, rent_l_cd, link_rent_st, link_im_seq);
	int vt_size4 = vt4.size();
	
	String wait_yn = "N";	
	
	int wait_cnt = 0;

	int alink_y_count = ln_db.getALinkCntY(link_table, rent_l_cd, link_rent_st);
	
	String edoc_link_yn 		= e_db.getEstiSikVarCase("1", "", "edoc_link_yn");
	
	//이용개월수 & 납입회수 비교 위한 정보 fetch(20191010)	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
	.papy{	background-color: #FAF4C0;	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//이메일주소 점검
	function isEmail(str) {
		// regular expression? 지원 여부 점검
		var supported = 0;
		if (window.RegExp) {
			var tempStr = "a";
			var tempReg = new RegExp(tempStr);
			if (tempReg.test(tempStr)) supported = 1;
		}
		if (!supported) return (str.indexOf(".") > 2) && (str.indexOf("@") > 0);
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
		return (!r1.test(str) && r2.test(str));
	}
	
	//수신메일주소 셋팅
	function mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.s_mail_addr.options[fm.s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.mgr_nm.value 	= i_mail_addr_split[0];
			fm.mgr_email.value 	= i_mail_addr_split[1];
			fm.mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.mgr_nm.value 	= '';
			fm.mgr_email.value 	= '';
			fm.mgr_m_tel.value 	= '';
		}
	}	
	
	<%if(link_type.equals("2")){	%>
	//기존임차인 수신메일주소 셋팅
	function suc_mail_addr_set(){
		var fm = document.form1;
		var i_mail_addr = fm.suc_s_mail_addr.options[fm.suc_s_mail_addr.selectedIndex].value;
		
		if(i_mail_addr != ''){		
			var i_mail_addr_split 	= i_mail_addr.split("||");
			fm.suc_mgr_nm.value 	= i_mail_addr_split[0];
			fm.suc_mgr_email.value 	= i_mail_addr_split[1];
			fm.suc_mgr_m_tel.value 	= i_mail_addr_split[2];
		}else{
			fm.suc_mgr_nm.value 	= '';
			fm.suc_mgr_email.value 	= '';
			fm.suc_mgr_m_tel.value 	= '';
		}
	}
	<%}%>		
		
	function link_send(){	
		
		var fm = document.form1;
		
		var addr = fm.mgr_email.value;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('서버작업으로 서비스 중단합니다.');
			return;
		<%}%>
		
		<%if(link_table.equals("lc_rent_link_m") && client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1")){%>
			alert('장기계약서 법인일때는 대표자 연대보증 대신 대표자 공동임차로 해야 합니다. ');	
			return;
		<%}%>	
		
		<%if(link_table.equals("lc_rent_link_m") && client.getClient_st().equals("2") && client.getM_tel().equals("")){%>
			alert('장기계약서 개인일때는 휴대폰 번호가 입력되어야 합니다. 고객관리에서 입력하십시오.');	
			return;
		<%}%>			
		
		<%if(link_table.equals("rm_rent_link")){%>
		<%	if(fee_rm.getCms_type().equals("")){%>
		if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
			alert('2회차 청구방식을 선택하십시오.'); return;
		}
		<%	}%>
		<%}%>
		
		
						
		if(fm.rent_l_cd.value == '') 	{ alert('계약서가 선택되지 않았습니다. 메일발송이 안됩니다.'); 	return; }
		
		if(fm.doc_st != null && fm.doc_st.value != '2'){
			
		if(fm.email_chk.checked==false){ 
			if(isEmail(addr)==false)	{ alert("올바른 이메일주소를 입력해주세요"); 			return; }
		}
		if(addr=="" || addr=="@")	{ alert("메일주소를 입력해주세요!"); 				return; }
		if(addr.indexOf("@")<0)		{ alert("메일주소가 명확하지 않습니다!"); 			return; }
		if(addr.indexOf(".")<0)		{ alert("메일주소가 명확하지 않습니다!"); 			return; }
		if(get_length(addr) < 5)	{ alert("메일주소가 명확하지 않습니다!"); 			return; }
		
		//공동임차면 이메일정보필수입력(20190219)
		<%-- <%if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
		<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
			<%-- <%if(client.getRepre_email().equals("")){%> --%>
				if(fm.repre_email.value==""){					alert("공동임차인의 메일주소를 입력해주세요!");				return;	}
				if(fm.repre_email.value.indexOf("@")<0){ 	alert("공동임차인의 메일주소가 명확하지 않습니다!"); 		return; 	}
				if(fm.repre_email.value.indexOf(".")<0){ 	alert("공동임차인의 메일주소가 명확하지 않습니다!"); 		return; 	}
				if(get_length(fm.repre_email.value) < 5)	{ 	alert("공동임차인의 메일주소가 명확하지 않습니다!"); 		return; 	}
			<%-- <%}%> --%>	
		<%}%>
		
		//이용개월수보다 납입회수가 더 크면 전송불가(20191010)
<%	if(!fees.getFee_pay_tm().equals("")&&!fees.getCon_mon().equals("")){
			if(AddUtil.parseInt(fees.getFee_pay_tm()) > AddUtil.parseInt(fees.getCon_mon())){%>
				alert("납입횟수가 이용기간(개월수)보다 더 큽니다. 확인해주세요.");		return;
<%		}
		}	%>
		
		// 전자계약서 전송 시 상호+계약번호가 60자리가 넘으면 전자계약서 전송 불가
		<% if((rent_l_cd+client.getFirm_nm()).length() > 60){%>
			alert('계약번호+상호가 60자리가 넘으면 전자계약서를 전송할 수 없습니다.');
			return;
		<%}%>
		}
		
		// 자동이체 신청서 메일 발송 유무
		var vt_size2 = <%=vt_size2%>;
		if( vt_size2 == 0 ){	// 최초 발송 시 자동이체 신청서 발송.
			fm.cms_mail_send_yn.value = 'Y';			
		} else {		// 전자계약서 폐기 후 재발송 시 자동이체 신청서 메일 발송 항목 체크된 경우에만 발송.
			var check = fm.cms_mail_yn.checked;
			if(check){
				fm.cms_mail_send_yn.value = 'Y';	
			}else{
				fm.cms_mail_send_yn.value = 'N';
			}
		}
		
		if(!confirm("전자계약서 수정이 불가하므로 전송이후 수정이 필요할 시\n\n폐기>전송 하셔야합니다.\n\n전송하시겠습니까?")){
			return;
		}
		
	//	fm.action='reg_edoc_link_send.jsp';
		fm.action='reg_edoc_link_send2.jsp'; 
	//	fm.target='_self';
		fm.target='EDOC_LINK2';
		fm.submit();
	}
	
	<%-- function link_resend(link_com, doc_code){		
		var fm = document.form1;

		<%if(edoc_link_yn.equals("N")){%>
			alert('서버작업으로 서비스 중단합니다.');
			return;
		<%}%>

		<%if(link_table.equals("lc_rent_link") && client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1") && !cont_etc.getClient_share_st().equals("1")){%>
			alert('장기계약서 법인일때는 대표자 연대보증 대신 대표자 공동임차로 해야 합니다. ');	
			return;
		<%}%>
		
		//공동임차면 이메일정보필수입력(20190219)
		<%if(cont_etc.getClient_share_st().equals("1")){%>
			<%if(client.getRepre_email().equals("")){%>
				alert("공동임차인의 이메일 정보를 입력하세요. 고객관리에서 입력하십시오.");	return;
			<%}%>	
		<%}%>
		
		fm.doc_code.value = doc_code;	
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_resend.jsp';					
		fm.target='_self';		
		fm.submit();
	} --%>	

	//사용
	function link_delete(link_com, doc_code){		
		
		if(!confirm("메일재전송을 위해 폐기하시려면 에스폼에서 재전송 해주세요.\n\n이메일주소를 변경해서 재전송 할 수 있습니다.\n\n폐기하시겠습니까?")){
			return;
		}
		var fm = document.form1;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('서버작업으로 서비스 중단합니다.');
			return;
		<%}%>
		
		fm.doc_code.value = doc_code;			
		
		if(link_com == '2')		//fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_delete2.jsp';		
		fm.target='_self';
		fm.submit();
	}	

	//완료건폐기 
	<%-- function link_delete_admin(link_com, doc_code){		
		var fm = document.form1;
		
		<%if(edoc_link_yn.equals("N")){%>
			alert('서버작업으로 서비스 중단합니다.');
			return;
		<%}%>
		
		fm.doc_code.value = doc_code;			
		
		if(link_com == '2')		fm.link_table.value = fm.link_table.value+'_m';		
		
		fm.action='reg_edoc_link_delete_admin.jsp';		
		fm.target='_self';
		fm.submit();
	} --%>	
	
	var popObj = null;


	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
	}	
	
	function change_doc_st(val){
		var fm = document.form1;
		if(val == 2){
			document.getElementById('mgr_nm').readOnly = true;
			fm.mgr_nm.style.background = '#e0e0e0';
			document.getElementById('mgr_m_tel').readOnly = true;
			fm.mgr_m_tel.style.background = '#e0e0e0';
		} else{
			fm.s_mail_addr.readOnly = false;
			document.getElementById('mgr_nm').readOnly = false;
			fm.mgr_nm.style.background = '#ffffff';
			document.getElementById('mgr_m_tel').readOnly = false;
			fm.mgr_m_tel.style.background = '#ffffff';
		}
	}
//-->
</script>

</head>

<body>
<!-- <center> -->
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">   
  <input type='hidden' name="link_table" 	value="<%=link_table%>">  
  <input type='hidden' name="link_type" 	value="<%=link_type%>">  
  <input type='hidden' name="link_rent_st" 	value="<%=link_rent_st%>">  
  <input type='hidden' name="link_im_seq" 	value="<%=link_im_seq%>">  
  <input type='hidden' name="doc_code" 	        value="">  
  <input type='hidden' name="bus_id" 	value="<%=base.getBus_id()%>">  
  <input type='hidden' name="bus_st" 	value="<%=base.getBus_st()%>">  
  <input type='hidden' name="cms_mail_send_yn" 	value="">  
  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>전자문서 전송</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td style="font-size: 20px; font-weight: bold; padding-bottom: 10px; padding-top: 10px;">
    		에스폼(공인인증) 전자계약서 전송
    		<input type='button' class='button' value='전자계약서 이용 가이드' onclick="javascript:openPopF('application/pdf','8817658');">
    		<input type='button' class='button' value='비대면 이용 설명서' onclick="javascript:openPopF('application/pdf','9368137');">
    		<input type='button' class='button' value='메일수신불가 가이드' onclick="javascript:openPopF('application/pdf','8817659');">
    		<input type='button' class='button' value='sForm' onclick="javascript:window.open('https://www.sform.co.kr/index.jsp');">
    	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>계약번호</td>
                    <td width='40%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='10%'>상호</td>
                    <td width='40%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>문서구분</td>
                    <td width='90%'>&nbsp;
                        <%if(link_table.equals("lc_rent_link")||link_table.equals("lc_rent_link_m")){%>
                        장기대여 계약서
                            <%if(link_type.equals("2")){%>
                            (계약승계)
                            <%}else if(link_type.equals("3")){%>
                            (연장)
                            <%}%>
                        <%}else if(link_table.equals("rm_rent_link")){%>
                        월렌트 계약서
                        <%}else if(link_table.equals("cms_link")){%>
                        CMS 출금이체 신청서
                        <%}%>                    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <%if(vt_size >0 || vt_size2 >0){%>
   		<%	int list_num = 0; 	int stat_num = 0;		%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전자문서 전송내역</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>연번</td>
                    <td class="title" width='20%'>전송일자</td>
                    <td class="title" width='10%'>수신자</td>                    
                    <td class="title" width='25%'>수신자메일</td>
                    <td class="title" width='15%'>수신자휴대폰</td>
                    <td class="title" width='5%'>구분</td>
                    <td class="title" width='10%'>상태</td>
                    <td class="title" width='15%'>문서상태</td>
                    <!-- <td class="title" width='20%'>문서상태</td> -->                                        
                </tr>
                <%if(vt_size > 0){ %>                
                	<% 	for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
 		%>      
                <tr>
                    <td class='papy' align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%= i+1 %></td>
                    <td class='papy' align="center"><%=ht.get("REG_DT")%></td>					
                    <td class='papy' align="center"><%=ht.get("CLIENT_USER_NM")%></td>
                    <td class='papy' align="center"><%=ht.get("CLIENT_USER_EMAIL")%></td>
                    <td class='papy' align="center"><%=ht.get("CLIENT_USER_TEL")%></td>
                    <td class='papy' align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>-</td>
                    <td class='papy' align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>
                        <%if(String.valueOf(ht.get("DOC_STAT")).equals("완료") && !String.valueOf(ht.get("DOC_YN")).equals("D")){%>
                        		<%=ht.get("DOC_STAT")%>
                        <%}else{%>
                            <%if(String.valueOf(ht.get("DOC_YN")).equals("Y")){%>진행
                            <%}else if(String.valueOf(ht.get("DOC_YN")).equals("U")){%>수정
                            <%}else if(String.valueOf(ht.get("DOC_YN")).equals("D")){%>삭제
                            <%}%>
                        <%}%>
                   </td>
                   <%
                   //int rowSpan = 0;
                   //if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){
                	  // rowSpan = vt_size
                   //}
                   %>
                   <%if(i==0){ %>
                   <td class='papy' align="center" rowspan='<%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%><%=vt_size*2%><%}else{%><%=vt_size%><%}%>'>파피리스<br>(수정불가)</td>
                   <%} %>
                </tr>
                <%		if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>
                <tr>                                        
                    <td class='papy' align="center">기존임차인</td>
                    <td class='papy' align="center"><%=ht.get("RENT_SUC_CLIENT_USER_NM")%></td>
                    <td class='papy' align="center"><%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%></td>
                    <td class='papy' align="center"><%=ht.get("RENT_SUC_CLIENT_USER_TEL")%></td>                    
                </tr>
                <%		}%>
                <% 	}%>
            <%	}%>
            
            <%if(vt_size2 > 0){ %>
           		<% 	for (int i = 0 ; i < vt_size2 ; i++){
							Hashtable ht = (Hashtable)vt2.elementAt(i);
							wait_yn = "Y";
							if((i+1)==vt_size2 && ( !String.valueOf(ht.get("DOC_STAT")).equals("완료") )){
							    	wait_yn = "Y";
							}
							if((i+1)==vt_size2 && ( !String.valueOf(ht.get("DOC_YN")).equals("D") )){
							    	wait_yn = "Y";
							}
							if((i+1)==vt_size2 && ( String.valueOf(ht.get("DOC_YN_NM")).equals("취소") )){
							    	wait_yn = "Y";
							}else{
								wait_yn = "N"; //추가전송한다.
							}							
							if(String.valueOf(ht.get("DOC_YN")).equals("D")){
								wait_yn = "N"; //추가전송한다.
							}
 				%>
                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%= i+1+vt_size %></td>
                    <td align="center"><%=ht.get("REG_DT")%></td>					
                    <td align="center"><%=ht.get("CLIENT_USER_NM")%></td>
                    <td align="center"><%=ht.get("CLIENT_USER_EMAIL")%></td>
                    <td align="center"><%=ht.get("CLIENT_USER_TEL")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%=ht.get("DOC_YN_NM")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>><%=ht.get("DOC_STAT")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>rowspan='2'<%}%>>                                            
                        <%if(!String.valueOf(ht.get("DOC_YN")).equals("D")){%>
                            &nbsp;<a href="javascript:link_delete('2', '<%=ht.get("DOC_CODE")%>')" onMouseOver="window.status=''; return true">[폐  기]</a>
                        <%}else{%>
                            -
                        <%}%>
                    </td>
                </tr>
                <%		if(String.valueOf(ht.get("DOC_TYPE")).equals("2")){%>
                <tr>                                        
                    <td align="center">기존임차인</td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_NM")%></td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_EMAIL")%></td>
                    <td align="center"><%=ht.get("RENT_SUC_CLIENT_USER_TEL")%></td>                    
                </tr>
                <%		}%>
                <% 	}%>
            <%}%>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전자문서 전송내역 상태 이력 </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <!-- <td class="title" width='5%'>연번</td>
                    <td class="title" width='20%'>상태일시</td>
                    <td class="title" width='30%'>상태</td>                    
                    <td class="title" width='45%'>비고</td> -->
                    <td class="title" width='5%'>연번</td>
                    <td class="title" width='20%'>구분</td>
                    <td class="title" width='20%'>상태일시</td>
                    <td class="title" width='20%'>상태</td>                    
                    <td class="title" width='35%'>비고</td>
                </tr>        
     <% 	for (int i = 0 ; i < vt_size3 ; i++){
				Hashtable ht = (Hashtable)vt3.elementAt(i);  
				
				if((i+1)==vt_size3 && String.valueOf(ht.get("DOC_STAT")).equals("완료")){
				    //	wait_yn = "Y";
				    //	wait_cnt = 0;
				} 					
									
 		%>                               
                <tr>
                    <td class='papy' align="center"><%= i+1 %></td>
                    <td class='papy' align="center">-</td>
                    <td class='papy' align="center"><%=ht.get("REG_DATE")%></td>					
                    <td class='papy' align="center"><%=ht.get("INDEX_STATUS")%></td>
                    <td class='papy' align="center"><%=ht.get("ETC")%></td>
                </tr>
  <%		}	%>
  
     <% 	for (int i = 0 ; i < vt_size4 ; i++){
				Hashtable ht = (Hashtable)vt4.elementAt(i);  
				
				if((i+1)==vt_size4 && String.valueOf(ht.get("DOC_STAT")).equals("완료")){
				    	wait_yn = "Y";
				} 														
				if((i+1)==vt_size4 && String.valueOf(ht.get("TMSG_NM")).equals("장기대여계약서 삭제")){
				    	wait_yn = "N";
				} 														

 		%>                               
                <tr>
                    <td align="center"><%= i+1+vt_size3 %></td>
                    <td align="center"><%=ht.get("TMSG_NM")%></td>					
                    <td align="center"><%=ht.get("REG_DATE")%></td>					
                    <td align="center"><%=ht.get("DOC_STAT")%></td>
                    <td align="center">
                        <%if(String.valueOf(ht.get("TMSG_KNCD")).equals("AC711") || String.valueOf(ht.get("TMSG_KNCD")).equals("AC713")){%>
                            <a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME")%>','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><%=ht.get("FILE_NAME")%></a>
                        <%}%>
                    </td>
                </tr>
     <%	}	%>        
                
                
            </table>
        </td>
    </tr>    
    <%}%>
     
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <!--대기없이 바로 전송 가능-->
    <%if(!base.getUse_yn().equals("N") && wait_yn.equals("N") && wait_cnt == 0 && alink_y_count==0){%>
    <%    if(link_type.equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경 임차인 : <%=client.getFirm_nm()%></span></td>
	</tr>       
    <%    }else{%>    	    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전송</span></td>
	</tr>   
    <%    }%>	 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <% // 고객 구분이 개인, 개인사업자이고 개인 단독으로 진행할 경우에만 공동인증/비대면 중 계약서 구분 선택(1: 공동인증, 2: 비대면)하여 전송
	          	// 승계 건은 비대면 계약 진행 불가. 20210422
	          if( (client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5"))
	        		 && !link_type.equals("2") ){ %>
	          <tr>
	          	<td class='title'>계약서 구분</td>
	          	<td>&nbsp;
	          		<input type="radio" id="doc_st1" name="doc_st" value="1" onchange="javascript:change_doc_st(this.value);" checked>
	          		<label for="doc_st1">공동인증서</label>
	          		<input type="radio" id="doc_st2" name="doc_st" value="2" onchange="javascript:change_doc_st(this.value);">
	          		<label for="doc_st2">비대면</label>
	          	</td>
	          </tr>
	          <%} %>
	          <tr>
	            <td class='title'>수신자</td>
	            <td>&nbsp;
                        <select name="s_mail_addr"  onChange='javascript:mail_addr_set();'>
			    <option value="">선택</option>
        		    <%if(!client.getCon_agnt_email().equals("")){%>
        		    <option value="<%=client.getCon_agnt_nm()%>||<%=client.getCon_agnt_email()%>||<%=client.getCon_agnt_m_tel()%>">[세금계산서] <%=client.getCon_agnt_email()%> <%=client.getCon_agnt_nm()%></option>
        		    <%}%>
        		    <%if(!site.getAgnt_email().equals("")){%>
        		    <option value="<%=site.getAgnt_nm()%>||<%=site.getAgnt_email()%>||<%=site.getAgnt_m_tel()%>">[지점세금계산서] <%=site.getAgnt_email()%> <%=site.getAgnt_nm()%></option>
        		    <%}%>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr_bean.getMgr_email().equals("")){%>
        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("계약담당자")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
        		    <%}}%>	        			
        		    <%if(user_id.equals("000029")){ %>
        		    <option value="테스트||dev@amazoncar.co.kr||010-4602-1306">[임시테스트]</option>
        		    <%} %>	
        		</select>	            
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>이름</td>
	            <td width='90%'>&nbsp;
	                <input type='text' size='15' id='mgr_nm' name='mgr_nm' value='<%=mgr.getMgr_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='mgr_email' value='<%=mgr.getMgr_email()%>' maxlength='50' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>이동전화</td>
	            <td>&nbsp;
	              <input type='text' size='15' id='mgr_m_tel' name='mgr_m_tel' value='<%=mgr.getMgr_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
	          <tr>
	            <td class='title'>변경</td>
	            <td>&nbsp;
	              <input type="checkbox" name="mgr_cng" value="Y"> 전자문서 수신자 정보를 계약담당자에 업데이트 한다.</td>
	          </tr>
	          <% if(vt_size2 > 0){%>
	          <tr>
	            <td class='title'>자동이체<br>신청서</td>
	            <td>&nbsp;
	              <input type="checkbox" name="cms_mail_yn" value="Y"> 자동이체 신청서 메일을 발송합니다.</td>
	          </tr>
	          <% }%>
            </table>
        </td>
    </tr> 
    
<!-- 공동임차인 추가(20190613) -->
<%-- <%if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%> --%>
<%if(!base.getCar_st().equals("4") && cont_etc.getClient_share_st().equals("1")){%>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 
	    		<span class=style2>공동 임차인 : 
	    <%if(!client.getRepre_nm().equals("")){ %><%=client.getRepre_nm()%><%}else{ %><%=client.getClient_nm()%><%} %>
	    </span></td>
	</tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td class='title'>수신자</td>
	            <td>&nbsp;계약정보, 고객정보에 연동된 공동임차인 정보를 가져옵니다. <br>
	            	&nbsp;다른 이메일로 보내려면 아래에 직접 입력하거나 고객정보에 공동임차인 정보를 수정하세요.</td>                
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>이름</td>
	            <td width='90%'>&nbsp;
	                <%if(!client.getRepre_nm().equals("")){ %><%=client.getRepre_nm()%><%}else{ %><%=client.getClient_nm()%><%}%></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='repre_email' value='<%=client.getRepre_email()%>' maxlength='50' class='text' style='IME-MODE: inactive'><br>
	                &nbsp;&nbsp;* 이곳에 입력한 이메일은 전자계약서 전송에만 사용되며(1회성) 계약정보/고객정보의 공동임차인 이메일주소는 변경되지 않습니다.
	             </td>
	          </tr>
            </table>
        </td>
    </tr>
<%} %>
    
    
    <!-- 공동임차인 추가 끝 --> 
    <%    if(link_type.equals("2")){
    
   		//계약승계 혹은 차종변경일때 원계약 해지내용
		Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
		//기존 임차인 고객관련자
		car_mgrs = a_db.getCarMgrListNew(cont_etc.getRent_suc_m_id(), cont_etc.getRent_suc_l_cd(), "Y");
		mgr_size = car_mgrs.size();	    
    %>
    <tr>
        <td class=h></td>
    </tr>    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기존 임차인 : <%=begin.get("FIRM_NM")%></span></td>
	</tr>        
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td class='title'>수신자</td>
	            <td>&nbsp;
                        <select name="suc_s_mail_addr"  onChange='javascript:suc_mail_addr_set();'>
			    <option value="">선택</option>
        		    <%for(int i = 0 ; i < mgr_size ; i++){
        			CarMgrBean mgr_bean = (CarMgrBean)car_mgrs.elementAt(i);
        			if(!mgr_bean.getMgr_email().equals("")){%>
        		    <option value="<%=mgr_bean.getMgr_nm()%>||<%=mgr_bean.getMgr_email()%>||<%=mgr_bean.getMgr_m_tel()%>" <%if(mgr_bean.getMgr_st().equals("계약담당자")){%>selected<%}%>>[<%=mgr_bean.getMgr_st()%>] <%=mgr_bean.getMgr_email()%> <%=mgr_bean.getMgr_nm()%></option>
        		    <%}}%>	        				
        		</select>	            
	            
	            </td>
	          </tr>			  			  
	          <tr>
	            <td width='10%' class='title'>이름</td>
	            <td width='90%'>&nbsp;
	                <input type='text' size='15' name='suc_mgr_nm' value='<%=suc_mgr.getMgr_nm()%>' maxlength='20' class='text' style='IME-MODE: active'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td>&nbsp;
	                <input type='text' size='40' name='suc_mgr_email' value='<%=suc_mgr.getMgr_email()%>' maxlength='50' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>이동전화</td>
	            <td>&nbsp;
	              <input type='text' size='15' name='suc_mgr_m_tel' value='<%=suc_mgr.getMgr_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
            </table>
        </td>
    </tr>            
    <%    }%>
    <tr> 
        <td>&nbsp; 
            <%if(!link_type.equals("5")){%>* CMS출금이체 신청서는 전자계약서와 별도로 업무서식에 있는 자동이체신청서 양식이 아마존카 메일로 자동발송됩니다. 고객에게 답신받고 진행하시면 됩니다.<%}%>
        </td>
    </tr>
        <%	if( !( client.getClient_st().equals("1") || client.getClient_st().equals("2") ) && !client.getRepre_nm2().equals("") ){%>
    <tr>
    	<td align="right"></td>
    </tr>    
    <tr>
    	<td>
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표자 선택</span>
    	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
	          <tr>
	            <td width='10%' class='title'>대표자</td>
	            <td width='90%'>&nbsp;
	                <select name="client_repre_st">
	                	<option value="1">[대표자] <%= client.getClient_nm()%></option>
	                	<%if(!client.getRepre_nm2().equals("")){%><option value="2">[공동대표자] <%= client.getRepre_nm2() %></option><%} %>
	                </select>
	            </td>
	          </tr>
            </table>
        </td>
    </tr>
     <%} %>
    <tr>
        <td align="right">
		<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>		
		<%	if(!base.getCar_st().equals("4") && client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1") 
				&& (client.getRepre_ssn1().equals("") || AddUtil.parseInt(client.getRepre_ssn1()) == 0 || client.getRepre_addr().equals("") || client.getRepre_email().equals("") )){%>
		* 법인-공동임차인 있음인데. 대표자 생년월일나 주소, 이메일이 없습니다. 등록후 전자계약서 전송하세요.
		<%	}else{%>
		<a href='javascript:link_send()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_send_econt.gif align=absmiddle border=0></a>&nbsp;
		<%	}%>
		<%}%>
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>   
    <%}else{%>
    <tr> 
        <td>* 수신 대기 문서가 있습니다. </td>
    </tr>     
    <tr>
        <td align="right">
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <%}%>	    
    <tr> 
        <td>&nbsp; </td>
    </tr>   
    <tr>
    	<td><input type="checkbox" name="email_chk" value="Y"> 이메일주소 미점검</td>
    </tr>        
    <tr> 
        <td>&nbsp; </td>
    </tr>    
    <tr>         
        <td>
        	※ 전자계약서도 월렌트계약서처럼 에스폼에서 발송합니다.&nbsp;&nbsp;&nbsp;
        	(&nbsp;<span class='papy' style="border: 1px solid #B2CCFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> : 파피리스 기존 전송내역. 확인만 가능, 재전송/수정/삭제 불가)
        </td>
    </tr>
    <tr>
        <td>
        	<font color=red><b>※ 에스폼 사이트에서 이메일주소를 수정하여 재전송할 수 있습니다. (폐기는 계약서 내용이 변경되었을 때만 이용)</b></font> (2019-06-24 기준)
        </td>
    </tr>
    <tr>
        <td>
        	<b>※ 메일발송후 <font color=red>서명기한이 일주일</font>입니다. 기한 경과시 에스폼에서 이메일 재발송하여 진행하여 주십시오.</b>
        </td>
    </tr>    
    <tr> 
        <td>※ 온라인 전자계약서는 고객이 이메일을 통해 공인인증 진행 후 승인하면 됩니다. (주민등록번호 뒷자리 입력 후 공인인증 절차 진행)</td>
    </tr>
    <tr> 
        <td>※ PDF생성/이메일 전송 > 메일확인 > 메일 자체에서 공인인증 후 계약승인 진행 (고객이 웹사이트에 로그인할 필요 없음)방식이기 때문에 계약서 수정 시 <br> 
    </tr>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;폐기>전송해야 합니다. 가급적 무분별한 전자계약서 폐기>전송은 자제해 주시기 바랍니다.(과금 발생 가능성 있음)</td>
    </tr>      
    <tr>
    	<td>
    	※ 전자계약서 공인인증 시 '[ErrorProcess] code=5, errorMessage=모듈 생성 실패 tstoolkit' 메시지가 나온다면 PC 내 모듈의 재설치가 필요한 경우입니다.<br>
    	&nbsp;&nbsp;&nbsp;다른 PC에서 진행하시거나 제어판에서 SCORE CMP for OpenWeb을 삭제하고 재설치한 후 다시 진행해 주시기 바랍니다.<br>
    	&nbsp;&nbsp;&nbsp;(공인인증 페이지 접속 시 해당 모듈의 설치 안내 페이지가 나오도록 되어 있습니다)
    	</td>
    </tr>
    <%if( (client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5"))
    		&& !link_type.equals("2")	){ %>
    <tr>
    	<td>※ 계약서 구분 중 비대면은 개인 단독으로 진행되는 것으로 대표자 외 다른 사람(공동임차인 등)이 진행할 수 없습니다.</td>
    </tr>      
    <tr>
    	<td>※ 비대면은 휴대폰 인증 후 자필 서명을 통해 진행됩니다.</td>
    </tr>      
    <tr>
    	<td>※ 전자계약서 최초 발송 시 자동이체 신청서 메일이 함께 발송됩니다. 폐기 후 재발송 시에는 자동이체 신청서 항목이 체크된 경우에만 발송됩니다.</td>
    </tr>      
    <%} %>
    <!-- <tr> 
        <td>※ 파피리스 전자계약서 이용문의 : 파피리스 김승곤 팀장 02-2638-7224, HP 010-6652-1000</td>
    </tr> -->        
    <!-- <tr> 
        <td>※ 고객이 파피리스 전자계약서 이용하면서 공인인증서 호출 등 문제가 발생하면 위의 김승곤팀장에게 문의를 하면 전화상담 및 원격지원 등의 지원을 합니다.</td>
    </tr> -->        
    		  
</table>
</form>
<!-- </center> -->
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
