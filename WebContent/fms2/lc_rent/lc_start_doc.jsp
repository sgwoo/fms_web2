<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.con_ins.*, tax.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>

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
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode   = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
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
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
				
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
			
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//지연대차 스케줄 대여횟수 최대값
	int max_taecha_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd, "");
	int scd_count = a_db.getScdCount(rent_mng_id, rent_l_cd, "");
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//문서품의
	DocSettleBean doc_var = d_db.getDocSettleVar(doc_no, 1);
	
	//기안자
	user_bean 	= umd.getUsersBean(doc.getUser_id1());


	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&gubun4="+gubun4+"&gubun5="+gubun5+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					

	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";
	String scan17 = "";
	String scan18 = "";
	String scan38 = "";
	

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	

	Vector attach_vt2 = new Vector();
	int attach_vt_size2 = 0;	
	
	Vector attach_vt3 = new Vector();
	int attach_vt_size3 = 0;	
	
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"17";

	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size = attach_vt.size();	
		
	if(attach_vt_size > 0){
		for (int j = 0 ; j < attach_vt_size ; j++){
    			Hashtable ht = (Hashtable)attach_vt.elementAt(j);   
    			scan17 = String.valueOf(ht.get("FILE_NAME"));
    		}
    	}		
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"18";

	attach_vt2 = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size2 = attach_vt2.size();	
		
	if(attach_vt_size2 > 0){
		for (int j = 0 ; j < attach_vt_size2 ; j++){
    			Hashtable ht = (Hashtable)attach_vt2.elementAt(j);   
    			scan18 = String.valueOf(ht.get("FILE_NAME"));
    		}
    	}	
    	
  content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"38";

	attach_vt3 = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size3 = attach_vt3.size();	
		
	if(attach_vt_size3 > 0){
		for (int j = 0 ; j < attach_vt_size3 ; j++){
    			Hashtable ht = (Hashtable)attach_vt3.elementAt(j);   
    			scan38 = String.valueOf(ht.get("FILE_NAME"));
    		}
    	}	
    	
    	//발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdClient(base.getClient_id());
	int fee_scd_size = fee_scd.size();
	
	if(fee_scd_size > 15) fee_scd_size = 15;    
	
	//예비스케줄 리스트
	Vector fee_scd_est = af_db.getScdFeeEstList(rent_mng_id, rent_l_cd);
	int fee_scd_est_size = fee_scd_est.size();	
	
	//건별 대여료 스케줄 리스트
	Vector fee_scd1 = ScdMngDb.getFeeScdTaxScd("", "3", "", "", "", rent_mng_id, rent_l_cd, "", "", "");
	int fee_scd_size1 = fee_scd1.size();
	
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
	
	String taecha_scd_yn = "";
	
	String t_scd_reg_yn = "Y";
	if(fee.getPrv_dlv_yn().equals("Y") && max_taecha_tm == 0 && scd_count == 0 && (!taecha.getRent_mng_id().equals("") && taecha.getReq_st().equals("1") && taecha.getTae_st().equals("1"))){
		t_scd_reg_yn = "N";
	}
	
	String com_dir_pur_doc_yn = "";
	String com_dir_pur_doc_reg_yn = "";
	String com_dir_pur_doc_no = "";
	if(base.getCar_gu().equals("1") && AddUtil.parseInt(base.getRent_dt()) >= 20190610 && client.getClient_st().equals("1") && cm_bean.getCar_comp_id().equals("0001") && pur.getDir_pur_yn().equals("Y") && !pur.getPur_bus_st().equals("4")){ //법인고객 현대특판출고 에이전트영업 제외
		com_dir_pur_doc_yn = "Y";
		//문서품의
		DocSettleBean doc17 = d_db.getDocSettleCommi("17", rent_l_cd);
		com_dir_pur_doc_no = doc17.getDoc_no();
		if(doc17.getDoc_no().equals("")){
			com_dir_pur_doc_reg_yn = "N";
		}
	}	
	
	//변경이력
	Vector cng_vt = a_db.getLcRentCngHList(rent_mng_id, rent_l_cd, "fee_amt");
	int cng_vt_size = cng_vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		fm.action = '/fms2/lc_rent/lc_start_frame.jsp';				
		fm.target = 'd_content';	
		fm.submit();
	}	
	
	
	//결재하기
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='lc_start_doc_sanction.jsp';		
			fm.target='i_no';						
			fm.submit();
		}									
	}	
	
	//대여료스케줄관리로 이동	
	function move_fee_scd(){
		
		//요청내용 팝업 띄우고 대여료스케줄 이동
		window.open("/fms2/lc_rent/lc_start_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=1&doc_no=<%=doc_no%>&mode=view", "VIEW_INSDOC", "left=100, top=10, width=850, height=650, scrollbars=yes");		
		
		var fm = document.form1;		
		fm.target = 'd_content';	
		fm.action = '/fms2/con_fee/fee_scd_u_frame.jsp';
		fm.submit();								
	}
	
	//한회차씩 수정
	function tm_update(idx, rent_seq, rent_st, fee_tm, tm_st1, tm_st2){
		var fm = document.form1;
		window.open("about:blank", "SCDUPD", "left=50, top=0, width=750, height=600, scrollbars=yes");				
		fm.idx.value = idx;
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.fee_tm.value = fee_tm;
		fm.tm_st1.value = tm_st1;
		fm.tm_st2.value = tm_st2;		
		fm.action = "/fms2/con_fee/fee_scd_u_tm_est.jsp";
		fm.target = "SCDUPD";
		fm.submit();
	}		
	//변경화면
	function cng_schedule2(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD2", "left=50, top=50, width=650, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd2_est.jsp";
		fm.target = "CNGSCD2";
		fm.submit();
	}		
	
	//법인고객 자동차 영업직원 활동 보고서 보기
	function reg_doc(doc_no, doc_st){
		window.open("doc_com_dir_pur.jsp?doc_no="+doc_no+"&doc_st="+doc_st+"&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "VIEW_DOC", "left=100, top=0, width=650, height=950, scrollbars=yes");		
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">

<form action='lc_start_doc_sanction.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='/fms2/lc_rent/lc_c_u_start.jsp'>   

  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="c_id" 			value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="rent_st" 			value="<%=fee.getRent_st()%>">
  <input type='hidden' name="rent_way"			value="<%=fee.getRent_way()%>">
  <input type='hidden' name="fee_amt"			value="<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>">
  <input type='hidden' name="fee_s_amt"			value="<%=fee.getFee_s_amt()%>">
  <input type='hidden' name="fee_v_amt"			value="<%=fee.getFee_v_amt()%>">  
  <input type='hidden' name="pere_r_mth"		value="<%=fee.getPere_r_mth()%>">  
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_no"			value="<%=cr_bean.getCar_no()%>">
  <input type='hidden' name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name="doc_bit" 			value="">
  <input type='hidden' name="end_chk"			value="">
  <input type='hidden' name="idx"			value="">
  <input type='hidden' name="cng_st"			value="">
  <input type='hidden' name="rent_seq"			value="">
  <input type='hidden' name="fee_tm"			value="">
  <input type='hidden' name="tm_st1"			value="">
  <input type='hidden' name="tm_st2"			value="">
  
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>신차 대여개시 및 스케줄 생성</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
	<tr>
	    <td align="right"><%if(!mode.equals("view")){%><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td></td>
	<tr> 	    
    <tr>
	<td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=15%>계약번호</td>
                    <td width=35%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=15%>상호</td>
                    <td width=35%>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>차명</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
                <tr> 
                    <td class=title>월대여료납입방식</td>
                    <td>&nbsp;<%if(fee.getFee_chk().equals("0")){%>매월납입<%}else if(fee.getFee_chk().equals("1")){%>일시완납<%}else{%>-<%}%></td>
                    <td class=title>선납금계산서발행구분</td>
                    <td>&nbsp;<%if(fee.getPp_chk().equals("1")){%>납부일시발행<%}else if(fee.getPp_chk().equals("0")){%>매월균등발행<%}else{%>-<%}%></td>
                </tr>                        
    	    </table>
	</td>
    </tr>  
    <%	if(com_dir_pur_doc_yn.equals("Y")){%>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>법인고객 자동차 영업직원 활동 보고서</span></td>
	</tr>  	
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=15%>등록여부</td>
                    <td>&nbsp;
	<%		if(com_dir_pur_doc_reg_yn.equals("N")){%>
	        	미등록  &nbsp;<a href ="javascript:reg_doc('','17')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
	<%		}else{ %>	
	                     등록  &nbsp;<a href ="javascript:reg_doc('<%=com_dir_pur_doc_no%>','17')"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>			
	<%		} %>                    
        	    </td>
                </tr>	
    		</table>
	    </td>
	</tr> 	        
    <%	}%>        
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문서스캔</span></td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=15%>대여개시후계약서(앞)</td>
                    <td width=35%>&nbsp;
                    <%	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					 					
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>
        	    </td>
                    <td class=title width=15%>대여개시후계약서(뒤)</td>
                    <td width=35%>&nbsp;
                    <%  if(attach_vt_size2 > 0){
				for (int j = 0 ; j < attach_vt_size2 ; j++){
 					Hashtable ht = (Hashtable)attach_vt2.elementAt(j);     					 					
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>CMS이체신청서</span></td>
	</tr> 
	
	<tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=6.2%>CMS동의서</td>
                    <td width=35%>&nbsp;
                    <%	if(attach_vt_size3 > 0){
				for (int j = 0 ; j < attach_vt_size3 ; j++){
 					Hashtable ht = (Hashtable)attach_vt3.elementAt(j);     					 					
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>
        	   			 </td>
                   
                </tr>	
    		</table>
	    </td>
	</tr>	
<%		if(fee_scd_size>0){%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=client.getFirm_nm()%> 기존계약 발행예정일 확인</span></td>
	</tr>     
    <tr>
        <td class=line2></td>
    </tR>			
	<tr>
	    <td  class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>차량번호</td>
                    <td class='title'>차명</td>					
                    <td class='title'>회차</td>
                    <td colspan="2" class='title'>사용기간</td>
                    <td class='title'>월대여료</td>
                    <td class='title'>발행예정일</td>
                    <td class='title'>세금일자</td>
                    <td class='title'>입금예정일</td>
                </tr>
        <%			for(int j = 0 ; j < fee_scd_size ; j++){
        				Hashtable ht = (Hashtable)fee_scd.elementAt(j);%>
                <tr>
                    <td width="15%" align="center"><%=ht.get("CAR_NO")%></td>
                    <td width="15%" align="center"><%=ht.get("CAR_NM")%></td>					
                    <td width="10%" align="center"><%=ht.get("FEE_TM")%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;&nbsp;</td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
<%			}%>
            </table>
	    </td>
    </tr>
<%		}%>  
	
<%		if(cng_vt_size>0){%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료변경문서 이력</span></td>
	</tr>    
    <tr> 
        <td class=line2></td>
    </tr>		  	  
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="20%" class='title'>변경전 </td>
                    <td width="20%" class='title'>변경후</td>
                    <td width="30%" class='title' >변경사유</td>
                    <td width="15%" class='title' >변경일자</td>
                    <td width="15%" class='title' >변경자</td>			  
                </tr>
                <%for (int i = 0 ; i < cng_vt_size ; i++){
    					Hashtable ht = (Hashtable)cng_vt.elementAt(i);
    			%>
                <tr> 
                    <td align="center"><%=ht.get("OLD_VALUE")%></td>
                    <td align="center"><%=ht.get("NEW_VALUE")%></td>
                    <td align="center" ><%=ht.get("CNG_CAU")%></td>
                    <td align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%></td>
                    <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%></td>
                </tr>
    			<%}%>		               
            </table>
        </td>
    </tr>    
<%		}%>     	  
    <tr>
	<td align="right">&nbsp;</td>
    <tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여개시</span></td>
    </tr>
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="15%" align="center" class=title>계약일자</td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td width="15%" class='title'>출고일자</td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                </tr>
                <tr>
                    <td width="15%" align="center" class=title>대여기간</td>
                    <td width="35%">&nbsp;<%=fee.getCon_mon()%>개월</td>
                    <td width="15%" class='title'>차량인도일</td>
                    <td width="35%">&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></td>
                </tr>                
                <tr>                        
                    <td align="center" class=title>대여개시일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
                    <td align="center" class=title>대여만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
                </tr>
                <tr>                        
                    <td align="center" class=title>월대여료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
                    <td align="center" class=title>보증금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</td>
                </tr>       
                <tr>                        
                    <td align="center" class=title>개시대여료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원&nbsp;
                        <%if(fee.getFee_s_amt() >0){%>
                        <%	if(fee.getPere_r_mth() == 0){%>    
                        (<%=(fee.getIfee_s_amt()+fee.getIfee_v_amt())/(fee.getFee_s_amt()+fee.getFee_v_amt())%>회)
                        <%	}else{%>
                        (<%=fee.getPere_r_mth()%>회)
                        <%	}%>
                        <%}%>
                    </td>
                    <td align="center" class=title>선납금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>원</td>
                </tr>   
                <tr>
                    <td class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="3">&nbsp;<%=fee.getFee_cdt()%></td>
                </tr>			
                <tr>
                    <td class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="3">&nbsp;<%=fee_etc.getCon_etc()%></td>
                </tr>			        
                <tr>
                     <td class='title'>고객 특이사항</td>
                     <td colspan='3'>&nbsp;<%=Util.htmlBR(client.getEtc())%></td>                     
					 </td>
                </tr>		   		                            
            </table>
	</td>
    </tr>	 
    <tr>
	<td>&nbsp;</td>
    </tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 스케줄 생성</span></td>
    </tr>    
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="15%" align="center" class=title>구분</td>
                    <td>&nbsp;
                        <%if(doc_var.getVar01().equals("1")){%>대여개시일과 납입일자가 정상
                        <%}else if(doc_var.getVar01().equals("2")){%>납입일자변경(일할계산)
                        <%}else if(doc_var.getVar01().equals("3")){%>대여료 선납/분산청구 및 분산납부(다중스케줄)<%}%>
                        <input type='hidden' name="reg_type" value="<%=doc_var.getVar01()%>">
                        <input type='hidden' name="con_mon" value="<%=fee.getCon_mon()%>">
                        <input type='hidden' name="rent_start_dt" value="<%=fee.getRent_start_dt()%>">
                        <input type='hidden' name="rent_end_dt" value="<%=fee.getRent_end_dt()%>">
      			<input type='hidden' name='fee_pay_tm' value='<%=fee.getFee_pay_tm()%>'>  
			<input type='hidden' name='fee_est_day' value='<%=fee.getFee_est_day()%>'>  
			<input type='hidden' name='fee_fst_dt' value='<%=fee.getFee_fst_dt()%>'>  
			<input type='hidden' name='fee_fst_amt' value='<%=fee.getFee_fst_amt()%>'>  
			<input type='hidden' name='fee_pay_start_dt' value='<%=fee.getFee_pay_start_dt()%>'>  
			<input type='hidden' name='fee_pay_end_dt' value='<%=fee.getFee_pay_end_dt()%>'>      
			<input type='hidden' name='fee_est_day1' value='<%=doc_var.getVar02()%>'>      
			<input type='hidden' name='fee_est_day2' value='<%=doc_var.getVar09()%>'>      
			<input type='hidden' name='fee_est_day3' value='<%=doc_var.getVar16()%>'>      
			<input type='hidden' name='end_chk' value=''>      
                    </td>
                </tr>
            </table>
	</td>
    </tr>  
    <tr>
	<td>&nbsp;</td>
    </tr>
    <%if(doc_var.getVar01().equals("1")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                   
                <tr>
                    <td rowspan='2' width="15%" class='title'>월대여료</td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="75%">&nbsp;
                        매월 
                        <%if(doc_var.getVar02().equals("99")){%>말일
                        <%}else if(doc_var.getVar02().equals("98")){%>대여개시일
                        <%}else{%><%=doc_var.getVar02()%>일<%}%>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입기간</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt1' maxlength='10' size='11' value='<%=doc_var.getVar03()%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt1' maxlength='10' size='11' value='<%=doc_var.getVar04()%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>1회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt1' value='<%=doc_var.getVar05()%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt1' value='<%=doc_var.getVar06()%>' maxlength='10' size='10' class='whitenum'>원
                     </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>마지막회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt1' value='<%=doc_var.getVar07()%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt1' value='<%=doc_var.getVar08()%>' maxlength='10' size='10' class='whitenum'>원
                    </td>
                </tr>	                                	  		  		  		  
            </table>
	</td>
    </tr>  
    <%}%>
    <%if(doc_var.getVar01().equals("2")){%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%> 
                <tr>
                    <td colspan='3' class='title'>변경전</td>
                    <td colspan='3' class='title'>변경후</td>
                </tr>                              
                <tr>
                    <td rowspan='2' width="15%" class='title'>월대여료</td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="25%">&nbsp;
                        매월
                        <%if(doc_var.getVar09().equals("99")){%>말일
                        <%}else if(doc_var.getVar09().equals("98")){%>대여개시일
                        <%}else{%><%=doc_var.getVar09()%>일<%}%>
                    </td>
                    <td rowspan='2' width="15%" class='title'>월대여료</td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="25%">&nbsp;
                        매월
                        <%if(doc_var.getVar16().equals("99")){%>말일
                        <%}else if(doc_var.getVar16().equals("98")){%>대여개시일
                        <%}else{%><%=doc_var.getVar16()%>일<%}%>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입기간</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt2' maxlength='10' size='11' value='<%=doc_var.getVar10()%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt2' maxlength='10' size='11' value='<%=doc_var.getVar11()%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class='title'>납입기간</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt3' maxlength='10' size='11' value='<%=doc_var.getVar17()%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt3' maxlength='10' size='11' value='<%=doc_var.getVar18()%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>1회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt2' value='<%=doc_var.getVar12()%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td rowspan='2' class='title'>1회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt3' value='<%=doc_var.getVar19()%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value); '>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt2' value='<%=doc_var.getVar13()%>' maxlength='10' size='10' class='whitenum'>원
                     </td>
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt3' value='<%=doc_var.getVar20()%>' maxlength='10' size='10' class='whitenum'>원
                     </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>마지막회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt2' value='<%=doc_var.getVar14()%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td rowspan='2' class='title'>마지막회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt3' value='<%=doc_var.getVar21()%>' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt2' value='<%=doc_var.getVar15()%>' maxlength='10' size='10' class='whitenum'>원
                    </td>
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt3' value='<%=doc_var.getVar22()%>' maxlength='10' size='10' class='whitenum'>원
                    </td>
                </tr>	                                	  		  		  		  
            </table>
	</td>
    </tr>      
    <%}%>
    <%if(doc_var.getVar01().equals("3")){%>      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                   
                <tr>
                    <td colspan='2' class='title'>업무협조(총무팀) 메시지 발송</td>                    
                </tr>		  		  		  		                                    	  		  		  		  
                <tr>
                    <td width="15%" class='title'>내용</td>                    
                    <td>&nbsp;
                        <textarea rows='5' cols='90' name='etc'><%=doc_var.getEtc()%></textarea>                        
                    </td>                    
                </tr>		  		  		  		                                    	  		  		  		  
            </table>
	</td>
    </tr>      
    <%}%>
    <tr>
	<td>&nbsp;</td>
    </tr>    
<%		if(fee_scd_est_size>0){%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>예비 대여료 스케줄</span></td>
	</tr>     
    <tr>
        <td class=line2></td>
    </tR>			
	<tr>
	    <td  class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>회차</td>
                    <td colspan="2" class='title'>사용기간</td>
                    <td class='title'>공급가</td>
                    <td class='title'>부가세</td>
                    <td class='title'>월대여료</td>
                    <td class='title'>발행예정일</td>
                    <td class='title'>세금일자</td>
                    <td class='title'>입금예정일</td>
                </tr>
        	<%	for(int j = 0 ; j < fee_scd_est_size ; j++){
        			Hashtable ht = (Hashtable)fee_scd_est.elementAt(j);
        			total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
        			total_amt2 	= total_amt2 + Long.parseLong(String.valueOf(ht.get("FEE_V_AMT")));
        			total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(ht.get("FEE_S_AMT"))) + Long.parseLong(String.valueOf(ht.get("FEE_V_AMT")));
        	%>
                <tr>                    					
                    <td width="10%" align="center"><%if(doc.getUser_dt2().equals("")){%><a href="javascript:tm_update('<%=j%>','<%=ht.get("RENT_SEQ")%>', '<%=ht.get("RENT_ST")%>','<%=ht.get("FEE_TM")%>','<%=ht.get("TM_ST1")%>','<%=ht.get("TM_ST2")%>')"><%=ht.get("FEE_TM")%>회</a><%}else{%><%=ht.get("FEE_TM")%>회<%}%></td>                    
                    <td width="12%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="12%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT"))))%></td>
                    <td width="12%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td width="12%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td width="12%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
		<%	}%>
		        <tr>
				  <td class="title" colspan="3">합계</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title" colspan="3" style='text-align:left'>&nbsp;합계/납입횟수=<%=Util.parseDecimal(total_amt3/Long.parseLong(fee.getFee_pay_tm()))%></td>				  
				</tr>				
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">
		<%if(doc.getUser_dt2().equals("") && nm_db.getWorkAuthUser("회계업무",user_id)){%> 
		  <span class="b"><a href="javascript:cng_schedule2('1', '1', 2, 'use_dt');"><img src=/acar/images/center/button_ch_dep.gif border=0 align=absmiddle></a></span>&nbsp;&nbsp; 		  
		<%}%>		  		
	    </td>
	</tr>    
<%		}%>     	
    <tr>
	<td>&nbsp;<input type="checkbox" name="scd_fee_move_yn" value="Y" checked> 예비스케줄 이관 처리 (체크해제되면 문서 처리 및 메일발송만 합니다.)</td>
    </tr>       <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=10% rowspan="2">결재</td>
                    <td class=title width=20%>지점명</td>					
                    <td class=title width=20%>기안자</td>
                    <td class=title width=20%>스케줄담당</td>
                    <td class=title width=20%>총무팀장</td>
                    <td class=title width=10%>-</td>
                </tr>
                <tr>
                    <td align="center"><%=user_bean.getBr_nm()%></td>				
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(doc.getUser_dt2().equals("") && t_scd_reg_yn.equals("Y")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("부산스케줄생성자",user_id)){%><br><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("") && !doc.getUser_id3().equals("XXXXXX")){%><%if(doc.getUser_id3().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%><br><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"></td>
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td>
                * doc_no : [<%=doc_no%>]
        </td>
    </tr>
    <%		if(t_scd_reg_yn.equals("N")){%>
    <tr>
	<td><font color=red>* 출고지연대차 스케줄이 미생성되었습니다. 먼저 대차스케줄 생성후 승인하십시오.</font></td>
    </tr>	
    <%		}%>    	    
    <tr>
	<td align='center'>&nbsp;</td>
    </tr>
    
    
    <!-- 기 생성 스케줄이 있으면 보여준다.-->
    <%if(!doc.getDoc_step().equals("3")){%>
    <%		if(fee_scd_size1>0){%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>실스케줄 기등록분 확인</span></td>
	</tr>     
    <tr>
        <td class=line2></td>
    </tR>			
	<tr>
	    <td  class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>회차</td>
                    <td colspan="2" class='title'>사용기간</td>
                    <td class='title'>공급가</td>
                    <td class='title'>부가세</td>
                    <td class='title'>월대여료</td>
                    <td class='title'>발행예정일</td>
                    <td class='title'>세금일자</td>
                    <td class='title'>입금예정일</td>
                </tr>   
                <%
                	total_amt1 = 0;
                	total_amt2 = 0;
                	total_amt3 = 0;
                %> 
    		<%	for(int i = 0 ; i < fee_scd_size1 ; i++){
				Hashtable ht = (Hashtable)fee_scd1.elementAt(i);

        			total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
        			total_amt2 	= total_amt2 + Long.parseLong(String.valueOf(ht.get("FEE_V_AMT")));
        			total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(ht.get("FEE_S_AMT"))) + Long.parseLong(String.valueOf(ht.get("FEE_V_AMT")));
				
		%>	    
                <tr>
                    <td width="10%" align="center"><%=ht.get("FEE_TM")%>회</td>                    
                    <td width="12%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="12%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT"))))%></td>
                    <td width="12%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td width="12%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td width="12%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>								
    <%			}%>
		        <tr>
				  <td class="title" colspan="3">합계</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title" colspan="3" style='text-align:left'>&nbsp;</td>				  
				</tr>	    				
    <%		}%>
    <%}%>
    

    <%		if(doc.getDoc_step().equals("1")){%>
    <tr>
	      <td align="right">				  		  	    
	          <%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("부산스케줄생성자",user_id)){%>
	              <a href="javascript:doc_sanction('d');"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
	          <%}%>
	      </td>
    </tr>	
    <%	}%>

    
    <%if(!mode.equals("view")){%> 
    
            
    <%		if(doc.getDoc_step().equals("3")){%>
    <%			if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>
    <tr>
	<td align="right">* 메뉴이동 : <a href="javascript:move_fee_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_sch.gif align=absmiddle border="0"></a></td>
    </tr>	
    <%			}%>
    <%		}%>	
    
    <%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
