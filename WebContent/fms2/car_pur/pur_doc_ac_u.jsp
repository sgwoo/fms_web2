<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, card.*, acar.bill_mng.*, acar.car_sche.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	
		
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("4", rent_l_cd);
		doc_no = doc.getDoc_no();
	}
	
	//영업담당자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	
	CodeBean[] codes = c_db.getCodeAll("0017");
	int c_size2 = codes.length;
	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	Vector cards = CardDb.getCards("", "Y", "", "");
	int c_size = card_kinds.size();
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
			String content_code = "LC_SCAN";
			String content_seq  = rent_mng_id+""+rent_l_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;  										
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_ts.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
</head>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'pur_doc_ac_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//차량대금잔액계산
	function set_con_amt(){
		var fm = document.form1;
	}
		
	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) );
		fm.tot_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) );
		fm.tot_c_amt.value  	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
	}
	
	//차가 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;		
		
		fm.tot_fs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.commi_s_amt.value)) + toInt(parseDigit(fm.storage_s_amt.value)));
		fm.tot_fv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.commi_v_amt.value)) + toInt(parseDigit(fm.storage_v_amt.value)));
		fm.tot_f_amt.value 		= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)));
	}	
	
	
	//카드번호 조회
	function cng_input_card(value, idx){
		var fm = document.form1;
		
		//현금은 사용안함
		if(idx == '1' && fm.trf_st1.value == '1') return;
		if(idx == '2' && fm.trf_st2.value == '1') return;
		
		//대출
		if(idx == '1' && fm.trf_st1.value == '4') return;
		if(idx == '2' && fm.trf_st2.value == '4') return;
		
		//선불,후불카드
		var width = 500;
		window.open("s_cardno.jsp?go_url=/fms2/car_pur/pur_doc_u.jsp&value="+value+"&idx="+idx, "CARDNO", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//계좌번호
	function cng_input_bank(value, idx){
		var fm = document.form1;		
		var width = 800;	
		if(value == '1'){
			window.open("s_bankacc.jsp?go_url=/fms2/car_pur/pur_doc_u.jsp&emp_id=<%=emp2.getEmp_id()%>&car_off_id=<%=emp2.getCar_off_id()%>&value=<%=emp2.getCar_off_nm()%>&idx="+idx, "CARDNO", "left=10, top=10, width="+width+", height=600, scrollbars=yes, status=yes, resizable=yes");	
		}
	}
	
	//등록
	function save(){
		var fm = document.form1;
	
		if(fm.reg_est_dt.value  != ''  && fm.reg_est_h.value  == '') 		fm.reg_est_h.value 	= '00';		
		if(fm.reg_est_dt.value == '')		{	alert('등록예정일을 입력하여 주십시오.'); 			fm.reg_est_dt.focus(); 		return;		}
		if(fm.con_est_dt.value == '')		{	alert('지급처리요청일을 입력하여 주십시오.');			fm.con_est_dt.focus(); 		return;		}
		
		if(confirm('수정 하시겠습니까?')){	
			fm.action='pur_doc_ac_u_a.jsp';		
			fm.target='i_no';			
			fm.submit();
		}	
	}			
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '3'){
			if(fm.trf_st1.value == '')				{	alert('지급수단을 선택하십시오.');			return;		}
			if(toInt(parseDigit(fm.trf_amt1.value)) == 0)	{	alert('지급금액을 입력하십시오.');			return;		}
			if(fm.trf_st1.value == '2' || fm.trf_st1.value == '3' || fm.trf_st1.value == '7'){
				if(fm.card_kind1.value == '')		{	alert('카드종류를 선택하십시오.');			return;		}
				if(fm.cardno1.value == '')			{	alert('카드번호를 입력하십시오.');			return;		}
			}
			
			
			if(fm.pur_est_dt.value == '')			{	alert('처리예정일을 입력하십시오.');			return;		}
		}
		
		if(doc_bit == '3' && '<%=user_bean.getBr_nm()%>' == '본사'){
			if(fm.pur_est_dt.value == '')			{	alert('처리예정일을 입력하십시오.');			return;		}
		}
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='pur_doc_ac_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
		
	//스캔등록
	function scan_reg(file_st){
		window.open("/fms2/lc_rent/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//스캔관리 보기
	function view_scan(){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}					
//-->
</script>


<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>        
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_nm" 		value="<%=cm_bean.getCar_nm()%>">
  <input type='hidden' name="mode" 			value="<%=mode%>">      
  <input type='hidden' name="file_st" 		value="">
  <input type='hidden' name="doc_bit" 		value="">          
  <input type='hidden' name="trf_st" 		value="">      
  <input type='hidden' name="car_comp_id"	value="<%=emp2.getCar_comp_id()%>">       
  <input type='hidden' name='auto_yn' value='<%=cm_bean.getAuto_yn()%>'>
  <input type='hidden' name='car_b' value='<%=cm_bean.getCar_b()%>'>
  <input type='hidden' name='opt' value='<%=car.getOpt()%>'>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>중고차대금지급요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><%if(!mode.equals("view")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td></td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=37%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
    		    </tr>
    		</table>
	    </td>
	</tr> 	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문서스캔 &nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a></span></td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=10%>세금계산서</td>
                    <td width=40%>&nbsp;                    
                    <%
                    	String file_15_yn = ""; 
                    	String file_10_yn = ""; 
                    	
									content_seq  = rent_mng_id+""+rent_l_cd+"110";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
										for (int j = 0 ; j < attach_vt_size ; j++){
 											Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
 											file_10_yn = "Y";
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
                    <%	}else{%>      
        	    <span class="b"><a href="javascript:scan_reg('10')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
        	    <%}%>
        			</td>
                    <td class=title width=10%>중개수수료 세금계산서</td>
                    <td width=40%>&nbsp;
                    <%
			content_seq  = rent_mng_id+""+rent_l_cd+"125";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
 					file_10_yn = "Y";
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
                    <%	}else{%>      
        	    <span class="b"><a href="javascript:scan_reg('25')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
        	    <%}%>                                                                    			
        	    </td>
                </tr>	
                <tr> 
                    <td class=title width=10%>보관료 세금계산서</td>
                    <td colspan='3'>&nbsp;                    
                    <%
									content_seq  = rent_mng_id+""+rent_l_cd+"148";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
										for (int j = 0 ; j < attach_vt_size ; j++){
 											Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
 											file_10_yn = "Y";
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
                    <%	}else{%>      
        	    <span class="b"><a href="javascript:scan_reg('48')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
        	    <%}%>
        			</td>                   
                </tr>	                 
    		</table>
	    </td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>					
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량현황</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
    		  		<%if(!cr_bean.getCar_no().equals("")){%>
                <tr>
                    <td class=title>차량번호</td>
                    <td >&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td colspan="2" class=title>최초등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
                </tr>	
        		  <%}%>				
                <tr>
                    <td class=title>차명</td>
                    <td colspan="4">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>	
                <tr>                    
                    <td class=title>옵션</td>
                    <td colspan="4">
                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td style='height:3' colspan=3></td>
                            </tr>
                            <tr>
                                <td width=3>&nbsp;</td>
                                <td><%=car.getOpt()%></td>
                                <td width=3>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style='height:3' colspan=3></td>
                            </tr>
                        </table>
                    </td>
                </tr>	                				
                <tr> 
                    <td class=title width=13%>제작사명</td>
                    <td width=37%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%>
                      <%if(pur.getDir_pur_yn().equals("Y")){%>&nbsp;<b>[특판출고]</b><%}%></td>
                    <td width=3% rowspan="2" class=title>딜<br>러</td>
                    <td class=title width=7%>상호</td>
                    <td width=40%>&nbsp;<%=emp1.getCar_off_nm()%></td>
        	    </tr>
                <tr>
                    <td class=title width=10%>과세구분</td>
                    <td>
                        <%String purc_gu = car.getPurc_gu();%>
                        <%if(purc_gu.equals("1")){%>
                        &nbsp;과세
                        <%}else if(purc_gu.equals("0")){%>
                        &nbsp;면세
                        <%}%></td>
                    <td class=title>연락처</td>
                    <td>&nbsp;<%=emp1.getEmp_m_tel()%></td>
                </tr>
                <tr>
                    <td class=title width=10%>색상</td>
                    <td >&nbsp;외장:<%=car.getColo()%>/내장:<%=car.getIn_col()%>/가니쉬:<%=car.getGarnish_col()%></td>
                    <td rowspan="2" class=title>판<br>매<br>처</td>
                    <td class=title>상호</td>
                    <td>&nbsp;<%=emp2.getCar_off_nm()%></td>
                </tr>
                <tr>
                    <td class=title>배기량</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                    <td class=title>연락처</td>
                    <td>&nbsp;<%=emp2.getEmp_m_tel()%></td>
                </tr>
                <tr>
                    <td class=title>전차량번호</td>
                    <td>
                    &nbsp;<input type='text' name='est_car_no' maxlength='15' value='<%=pur.getEst_car_no()%>' class='default' size='15'></td>
                    <td rowspan="2" class=title>등<br>록</td>
                    <td class=title>등록지</td>
                    <td>
                      &nbsp;
                        <%=c_db.getNameByIdCode("0032", "", car.getCar_ext())%>
        			  <input type="hidden" name="car_ext" value="<%=car.getCar_ext()%>">
        			      </td>
                </tr>		
        	    <tr>
        		    <td class=title>차대번호</td>
        			<td>
        		    &nbsp;<input type='text' name='car_num' maxlength='20' value='<%=pur.getCar_num()%>' class='default' size='20'></td>
        		    <td class=title>예정일시</td>
        		    <td>
        		      &nbsp;<input type='text' size='12' name='reg_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='reg_est_h' class='default' value='<%=String.valueOf(est.get("REG_EST_H"))%>'>
                    시</td>
                </tr>
    		</table>
	    </td>
	</tr> 
    <tr></tr><tr></tr><tr></tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
                <tr>
                    <td width="13%" rowspan="2" class='title'>구분</td>
                    <td colspan="3" class='title'>소비자가격</td>
                    <td width="10%" rowspan="2" class='title'>구분</td>
                    <td colspan="3" class='title'>중고차구입가격</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>공급가</td>
                    <td width="12%" class='title'>부가세</td>
                    <td width="14%" class='title'>합계</td>
                    <td width="13%" class='title'>공급가</td>
                    <td width="11%" class='title'>부가세</td>
                    <td width="14%" class='title'>합계</td>
                </tr>
                <tr>
                    <td class='title'> 기본가격</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>매매금액</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>중개수수료</td>
                    <td align="center">&nbsp;
                      <input type='text' name='commi_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='commi_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_v_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='commi_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCommi_s_amt()+car.getCommi_v_amt())%>'  maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                                <td class=title>보관료</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_s_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_v_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_v_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td height="12">&nbsp;
                  <input type='text' name='storage_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getStorage_s_amt()+car.getStorage_v_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                </tr>
                <tr>
                    <td class='title'>합계</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                    <td class='title'>합계</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                </tr>
    		</table>
	    </td>
	</tr> 	
	<tr>
	    <td class=h></td>
	</tr>		  
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대금지출요청내역</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width="13%" class=title colspan='2'>지급요청일</td>
                    <td>&nbsp;
                    <input type='text' name='con_est_dt' size='15' value='<%=AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='default' >                    
                    <%=pur.getCon_pay_dt()%>
					</td>
                </tr>	
				<tr>
				  <td class=title width=3% rowspan='2'>계좌정보</td>
				  <td class=title width=10%>매매금액</td>
                    <td>&nbsp;
					  <select name='con_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='30' class='text'>
                    </td>
				</tr>				
				<tr>
                    <td class=title width=7%>중개수수료</td>
                    <td>&nbsp;
					  <select name='emp_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='emp_acc_no' value='<%=emp1.getEmp_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='emp_acc_nm' value='<%=emp1.getEmp_acc_nm()%>' size='20' class='text'>
                    </td>
				</tr>								
				<tr>
				  <td class=title colspan='2'>특이사항</td>
                    <td>&nbsp;
					  <textarea name="con_amt_cont" cols="100" rows="3" class="default"><%=pur.getCon_amt_cont()%></textarea>(고객선납,보증금승계등등)
                    </td>
				</tr>				
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지출처리예정내역</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="10%" class=title>지급수단</td>
                    <td width="15%" class=title>금액</td>
                    <td width="15%" class=title>카드종류/금융사</td>
                    <td width="10%" class=title>계좌종류</td>					
                    <td width="18%" class=title>카드/계좌번호</td>
                    <td width="20%" class=title>적요</td>
                    <td width="12%" class=title>지출일자</td>					
                </tr>
        		  <%
        		    String trf_st 		= "";
        		 	  int    trf_amt 		= 0;
        		  	String card_kind 	= "";
        		  	String cardno 		= "";
        		  	String trf_cont 	= "";
					      String trf_pay_dt 	= "";
					      String acc_st 		= "";
					      
        		  	for(int j=0; j<3; j++){
        				if(j==0){
        					trf_st 		= pur.getTrf_st1();
        					trf_amt 	= pur.getTrf_amt1();
        					card_kind = pur.getCard_kind1();
        					cardno 		= pur.getCardno1();
        					trf_cont 	= pur.getTrf_cont1();
									trf_pay_dt= pur.getTrf_pay_dt1();
									acc_st 		= pur.getAcc_st1();
									if(trf_st.equals("")) 	trf_st = "1";
									if(acc_st.equals("")) 	acc_st = "1";
									if(trf_amt==0) 					trf_amt = car.getCar_fs_amt()+car.getCar_fv_amt();
									if(card_kind.equals(""))card_kind = pur.getCon_bank();
									if(cardno.equals("")) 	cardno = pur.getCon_acc_no();
									if(trf_cont.equals("")) trf_cont = emp2.getCar_off_nm()+"-매매금액";
        				}else if(j==1){
        					trf_st 		= pur.getTrf_st2();
        					trf_amt 	= pur.getTrf_amt2();
        					card_kind = pur.getCard_kind2();
        					cardno 		= pur.getCardno2();
        					trf_cont 	= pur.getTrf_cont2();
									trf_pay_dt= pur.getTrf_pay_dt2();
									acc_st 		= pur.getAcc_st2();
									if(trf_st.equals("")) 	trf_st = "1";
									if(acc_st.equals("")) 	acc_st = "1";
									if(trf_amt==0) 					trf_amt = car.getCommi_s_amt()+car.getCommi_v_amt();
									if(card_kind.equals(""))card_kind = emp1.getEmp_bank();
									if(cardno.equals("")) 	cardno = emp1.getEmp_acc_no();
									if(trf_cont.equals("")) trf_cont = emp1.getCar_off_nm()+"-중개수수료";
        				}else if(j==2){
        					trf_st 		= pur.getTrf_st3();
        					trf_amt 	= pur.getTrf_amt3();
        					card_kind = pur.getCard_kind3();
        					cardno 		= pur.getCardno3();
        					trf_cont 	= pur.getTrf_cont3();
									trf_pay_dt= pur.getTrf_pay_dt3();
									acc_st 		= pur.getAcc_st3();
									if(trf_st.equals("")) 	trf_st = "1";
									if(acc_st.equals("")) 	acc_st = "1";
									if(trf_amt==0) 					trf_amt = car.getStorage_s_amt()+car.getStorage_v_amt();
									if(trf_amt > 0){
										if(card_kind.equals(""))card_kind = emp1.getEmp_bank();
										if(cardno.equals("")) 	cardno = emp1.getEmp_acc_no();
										if(trf_cont.equals("")) trf_cont = emp1.getCar_off_nm()+"-보관료";
									}
        				}
        		  		%>
                <tr>
                    <td align="center">
        			  <select name="trf_st<%=j+1%>" class='default' onChange="javascript:cng_input_bank(this.value, <%=j+1%>)">
                        <option value="">==선택==</option>
        				<option value="1" <%if(trf_st.equals("1")) out.println("selected");%>>현금</option>
        				<option value="2" <%if(trf_st.equals("2")) out.println("selected");%>>선불카드</option>
        				<option value="3" <%if(trf_st.equals("3")) out.println("selected");%>>후불카드</option>
        				<option value="4" <%if(trf_st.equals("4")) out.println("selected");%>>대출</option>
        				<option value="5" <%if(trf_st.equals("5")) out.println("selected");%>>포인트</option>
        				<option value="7" <%if(trf_st.equals("7")) out.println("selected");%>>카드할부</option>
        			  </select>
        			  </td>
                    <td align="center"><input type='text' size='10' maxlength='15' name='trf_amt<%=j+1%>' class='defaultnum' value='<%=AddUtil.parseDecimal(trf_amt)%>' onBlur='javascript:this.value=parseDecimal(this.value); set_trf_amt();'>
                      원</td>
                    <td align="center">
        			  <select name="card_kind<%=j+1%>" class='default' onChange="javascript:cng_input_card(this.value, <%=j+1%>)">
                  	    <option value=''>선택</option>
                  		<%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(card_kind.equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
        					
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(card_kind.equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>					
                	  </select>
        			</td>
                    <td align="center">
        			  <select name="acc_st<%=j+1%>" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(acc_st.equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(acc_st.equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
        			  </td>					
                    <td align="center">
        			  <input type='text' size='22' maxlength='100' name='cardno<%=j+1%>' class='default' value='<%=cardno%>'>
        			</td>
                    <td align="center"><input type='text' size='25' maxlength='100' name='trf_cont<%=j+1%>' class='default' value='<%=trf_cont%>'>
					</td>
                    <td align="center">
					  <%if(trf_amt>0 && !trf_pay_dt.equals("")){%>	
        			  <%=trf_pay_dt%>
					  <%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출금담당",user_id)){%>
					  <a href="javascript:trf_pay_cancel('<%=j+1%>')" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='출금재처리를 위해 지출취소처리합니다.'>[취소]</a>
					  <%	}%>
					  <%}%>
        			</td>					
                </tr>
        		  <%}%>
                <tr>
                    <td class=title>합계</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='tot_trf_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(pur.getTrf_amt1()+pur.getTrf_amt2()+pur.getTrf_amt3())%>'>
                      원</td>
                    <td class=title>처리예정일</td>
                    <td>&nbsp;
                      <input type='text' size='11' name='pur_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(pur.getPur_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>					  
					  </td>
                    <td colspan="3" align="center">&nbsp;
					(처리완료일 : <%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%>)
					  </td>
					  
                </tr>
            </table>
        </td>
	</tr>
	<%if((doc.getUser_id1().equals(user_id) || doc.getUser_id2().equals(user_id)) && doc.getUser_dt3().equals("")){%>
        <tr>
	    <td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    </td>
	</tr>
	<%}%>
	<%if(doc.getUser_id3().equals(user_id) || doc.getUser_id4().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id) || nm_db.getWorkAuthUser("차량대금기안자",user_id)|| nm_db.getWorkAuthUser("영업수당회계관리자",user_id)){%>
        <tr>
	    <td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    </td>
	</tr>
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차보험</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title>보험계약자</td>
                    <td>&nbsp;
                      <%String insurant = cont_etc.getInsurant();%>
                      <%if(insurant.equals("1") || insurant.equals("")){%>
                        아마존카
                      <%}else if(insurant.equals("2")){%>
                        고객
                      <%}%>
                    </td>                
                    <td  class=title>피보험자</td>
                    <td colspan="3">&nbsp;
                      <%String insur_per = cont_etc.getInsur_per();%>
                      <%if(insur_per.equals("1") || insur_per.equals("")){%>
                        아마존카
                      <%}else if(insur_per.equals("2")){%>
                        고객
                      <%}%>
                    </td>
                    <td class=title >임직원운전한정특약</td>
                    <td>&nbsp;
                      <%if(cont_etc.getCom_emp_yn().equals("Y")){%>가입<%}%>
                      <%if(cont_etc.getCom_emp_yn().equals("N")){%>미가입<%}%>
                    </td>                           
        	    </tr>
                <tr>
                    <td class=title>운전자범위</td>
                    <td class=''>&nbsp;
                      <%String driving_ext = base.getDriving_ext();%>
                      <%if(driving_ext.equals("1") || driving_ext.equals("")){%>
                         모든사람
                      <%}else if(driving_ext.equals("2")){%>
                         가족한정
                      <%}else if(driving_ext.equals("3")){%>
                         기타
                      <%}%></td>
                    <td class=title >운전자연령</td>
                    <td class=''>&nbsp;
                      <%String driving_age = base.getDriving_age();%>
                      <%if(driving_age.equals("0")){%>
                         만26세이상
                      <%}else if(driving_age.equals("3")){%>
                         만24세이상
                      <%}else if(driving_age.equals("1")){%>
                         만21세이상
                      <%}else if(driving_age.equals("2")){%>
                         모든운전자
                      <%}else if(driving_age.equals("5")){%>
               30세이상
                      <%}else if(driving_age.equals("6")){%>
               35세이상
                      <%}else if(driving_age.equals("7")){%>
               43세이상
                      <%}else if(driving_age.equals("8")){%>
               48세이상
                      <%}else if(driving_age.equals("9")){%>
               22세이상
                      <%}else if(driving_age.equals("10")){%>
               28세이상
                      <%}else if(driving_age.equals("11")){%>
               35세이상~49세이하
                      <%}%>
                    </td>
                    <td  class=title>대인배상</td>
                    <td width="15%">&nbsp;무한(대인배상Ⅰ,Ⅱ)</td>
                    <td width="10%" class=title>긴급출동</td>
                    <td width="15%" class=''>&nbsp;
                      <%String eme_yn = cont_etc.getEme_yn();%>
                      <%if(eme_yn.equals("Y")){%>
                        가입
                      <%}else if(eme_yn.equals("N")){%>
                        미가입
                      <%}%></td>
                </tr>
                <tr>
                     <td class=title>대물배상</td>
                     <td class=''>&nbsp;
					   <%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5천만원<%}else if(gcp_kd.equals("2")){%>1억원<%}else if(gcp_kd.equals("3")){%>5억원<%}else if(gcp_kd.equals("4")){%>2억원<%}else if(gcp_kd.equals("8")){%>3억원<%}%>
                       </td>
                     <td class=title >자기신체사고</td>
                     <td class=''>&nbsp;
                       <%String bacdt_kd = base.getBacdt_kd();%>
                       <%if(bacdt_kd.equals("1")){%>
                            5천만원
                       <%}else if(bacdt_kd.equals("2")){%>
                            1억원
                       <%}%></td>
                     <td  class=title>무보험차상해</td>
                     <td>&nbsp;
                       <%String canoisr_yn = cont_etc.getCanoisr_yn();%>
                       <%if(canoisr_yn.equals("Y")){%>
                              가입
                       <%}else if(canoisr_yn.equals("N")){%>
                              미가입
                       <%}%></td>
                     <td class=title>자기차량손해</td>
                     <td class=''>&nbsp;
                       <%String cacdt_yn = cont_etc.getCacdt_yn();%>
                       <%if(cacdt_yn.equals("Y")){%>
                              가입
                       <%}else if(cacdt_yn.equals("N")){%>
                              미가입
                       <%}%></td>
                </tr>
        		  <%if(!base.getOthers().equals("")){%>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="7">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>
        		  <%}%>
            </table>
        </td>
    </tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 		 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>  	
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">결재</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><!--기안자--><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                    <td align="center"><!--지점장--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_id2().equals("XXXXXX")){
					    if(!doc.getDoc_step().equals("3") && doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id2 = cs_bean.getWork_id();
        					%>
        			  <%	if(user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					  <%}else{%>
					    -<br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--출고담당자--><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getDoc_step().equals("3") && doc.getUser_dt3().equals("")){
        			  		String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id3 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id3 = nm_db.getWorkAuthUser("계약서류점검담당자");
        					%>
        			  <%	if(user_id3.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>
                    <td align="center"><!--회계담당자--><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>					  
        			  <%if(!doc.getUser_id4().equals("XXXXXX")){
					    if(!doc.getDoc_step().equals("3") && !doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){
        				  	String user_id4 = doc.getUser_id4();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id4);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id4 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id4 = nm_db.getWorkAuthUser("출고관리자");
        					%>
        			  <%	if(user_id4.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
        			    <a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					  <%}else{%>
					    -<br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--총무팀장--><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>
        			  <%if(!doc.getDoc_step().equals("3") && doc.getUser_dt5().equals("") && !doc.getUser_dt3().equals("")){
        			  		String user_id5 = doc.getUser_id5();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id5);
        					if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals(""))	user_id5 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id5 = nm_db.getWorkAuthUser("출고관리자");
        					%>
        			  <%	if(user_id5.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
        			    <a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	  
</table>
</form>
<script language="JavaScript">
<!--	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	var fm = document.form1;	
	
	sum_car_c_amt();
	sum_car_f_amt();

	//바로가기
	var s_fm = parent.top_menu.document.form1;
	s_fm.auth_rw.value 		= fm.auth_rw.value;
	s_fm.user_id.value 		= fm.user_id.value;
	s_fm.br_id.value 		= fm.br_id.value;		
	s_fm.m_id.value 		= fm.rent_mng_id.value;
	s_fm.l_cd.value 		= fm.rent_l_cd.value;	
	s_fm.c_id.value 		= "<%=base.getCar_mng_id()%>";
	s_fm.client_id.value 	= "<%=base.getClient_id()%>";	
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 		= "";
	s_fm.seq_no.value 		= "";
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

