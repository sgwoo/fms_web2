<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_office.*, acar.cls.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "12"); }	
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String tint_no 	= request.getParameter("tint_no")==null?"":request.getParameter("tint_no");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//용품관리
	TintBean tint 	= t_db.getCarTint(tint_no);
	
	if(tint_no.equals("")){
		tint 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
		tint_no = tint.getTint_no();
	}
	
	if(rent_mng_id.equals("")){
		rent_mng_id 	= tint.getRent_mng_id();
		rent_l_cd 	= tint.getRent_l_cd();
	}
	
	//용품	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");	
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");	
	
	if(!tint.getDoc_code().equals(tint1.getDoc_code())){ tint1 = new TintBean(); }
	if(!tint.getDoc_code().equals(tint2.getDoc_code())){ tint2 = new TintBean(); }
	if(!tint.getDoc_code().equals(tint3.getDoc_code())){ tint3 = new TintBean(); }
	if(!tint.getDoc_code().equals(tint4.getDoc_code())){ tint4 = new TintBean(); }
	if(!tint.getDoc_code().equals(tint5.getDoc_code())){ tint5 = new TintBean(); }
	if(!tint.getDoc_code().equals(tint6.getDoc_code())){ tint6 = new TintBean(); }
	
	//문서관리
	DocSettleBean doc = d_db.getDocSettleCommi("6", tint.getDoc_code());
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
					"&tint_no="+tint_no+"&off_id="+off_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+
				   	"";
				   	
	String update_yn = "N";			   	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
<!--

	//모델 검색 팝업 열기
	function openSearchPop(){
		var SUBWIN="/fms2/blackbox/bb_search_model_pop.jsp?auth_rw="+<%= auth_rw %>
		window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=650, height=550, scrollbars=no");
	}

	//리스트
	function list(){
		var fm = document.form1;	
		if('<%=from_page%>' == ''){		
			fm.action = 'tint_i_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';
		}
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//등록
	function save(mode){
		var fm = document.form1;
		
		fm.mode.value = mode;
		
		<%if(tint.getRent_l_cd().equals("")){%>
		if(fm.sup_est_dt.value  != ''  && fm.sup_est_h.value  == '') 		fm.sup_est_h.value 	= '00';		
		<%}%>
		
		<%if(off_id.equals(tint3.getOff_id())){%>
			<%if(tint3.getTint_yn().equals("Y")){%>
				//VVV 블랙박스-제조사명, 모델명 밸리데이션 추가(2018.02.06)
				if($("#compName").val() == ''){	 alert('블랙박스 모델선택을 선택하거나 제조사명을 직접 입력하십시오.'); 	return;}
				if($("#compName").val() == ''){	 alert('블랙박스 모델선택을 선택하거나 모델명을 직접 입력하십시오.'); 	return;}
			<%}%>
		<%}%>
		
		<%if(tint.getOff_nm().equals("젤존코리아")){%>
		fm.tint_amt.value = parseDecimal( toInt(parseDigit(fm.b_tint_amt.value)) * toInt(parseDigit(fm.tint_su.value)) / 1.1 );		
		<%}%>
		
		
		if(!confirm('수정 하시겠습니까?'))	return;		
		
		fm.action='tint_reg_step2_a.jsp';		
		//fm.target='i_no';
		fm.target = 'd_content';
		fm.submit();
	}				
	
	//삭제
	function del_tint(){
		var fm = document.form1;
		
		if(!confirm('삭제 하시겠습니까?'))	return;
		if(!confirm('진짜로 삭제 하시겠습니까?'))	return;
		if(!confirm('마지막으로 묻습니다. 삭제 하시겠습니까?'))	return;				
		
		fm.action='tint_del_step2_a.jsp';		
		//fm.target='i_no';
		fm.target = 'd_content';
		fm.submit();
	}
		
	//스캔등록
	function scan_file(tint_st, content_code, content_seq){
		window.open("reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}				
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='from_page'	value='<%=from_page%>'>        
  <input type='hidden' name='mode' 	value='<%=mode%>'>    
  <input type='hidden' name='v_tint_no' value='<%=tint_no%>'>        
  <input type='hidden' name='v_off_id'  value='<%=off_id%>'>        
  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_nm" 		value="<%=cm_bean.getCar_nm()%>">
  <input type='hidden' name="rpt_no" 		value="<%=pur.getRpt_no()%>">
  
  <%if(tint.getOff_nm().equals("젤존코리아")){%>
  <input type='hidden' name="b_tint_amt" 	value="<%=tint.getB_tint_amt()%>">
  <input type='hidden' name="tint_amt" 		value="<%=tint.getTint_amt()%>">
  <%}%>
  
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 용품관리 > <span class=style5>용품내역</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
	<td align=right><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
    <tr> 	
    <%if(!tint.getRent_l_cd().equals("")){%>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>계약번호</td>
            <td width=15%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>상호</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%>차량구분</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
	  </tr>	
          <tr> 
            <td class=title width=10%>제작사명</td>
            <td width=15%>&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%></td>
            <td class=title width=10%>차명</td>
            <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
            <td class=title width=10%>색상</td>
            <td width=15%>&nbsp;외장:<%=car.getColo()%>/내장:<%=car.getIn_col()%>/가니쉬:<%=car.getGarnish_col()%></td>
	  </tr>	
          <tr> 
            <td class=title width=10%>차대번호</td>
            <td width=15%>&nbsp;<%=pur.getCar_num()%></td>
            <td class=title width=10%>차량번호</td>
            <td width=15%>&nbsp;<%=cr_bean.getCar_no()%></td>
            <td class=title width=10%>임시운행<br>허가번호</td>
            <td width=15%>&nbsp;<%=pur.getTmp_drv_no()%></td>
            <td class=title width=10%>인수지</td>
            <td width=15%>&nbsp;<%if(pur.getUdt_st().equals("1")){%>본사<%}%><%if(pur.getUdt_st().equals("2")){%>지점<%}%><%if(pur.getUdt_st().equals("3")){%>고객<%}%></td>
	  </tr>
          <tr> 
            <td class=title width=10%>출고예정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("DLV_EST_H"))%>시</td>
            <td class=title width=10%>인수예정일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%></td>
            <td class=title width=10%>등록예정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("REG_EST_H"))%>시</td>
            <td class=title width=10%>용품에정일시</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("RENT_EST_H"))%>시</td>
	  </tr>
          <tr> 
            <td class=title width=10%>출고일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
            <td class=title width=10%>인수일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
            <td class=title width=10%>등록일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
            <td class=title width=10%>대여개시일</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
	  </tr>
          <tr> 
            <td class=title width=10%>계출번호</td>
            <td colspan='7'>&nbsp;<%=pur.getRpt_no()%></td>
	  </tr>		  		  		  
	  <%if(base.getUse_yn().equals("N")){%>
          <tr> 
            <td class=title width=10%>해지일자</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
            <td class=title width=10%>해지구분</td>
            <td width=15%>&nbsp;<%=cls.getCls_st()%></td>
            <td class=title width=10%>해지내용</td>
            <td colspan='3'>&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
	  </tr>		  
	  <%}%>	  
        </table>
      </td>
    </tr>	 
    <tr>
	<td align="right">&nbsp;[최초영업자:<%=c_db.getNameById(base.getBus_id(),"USER")%>]&nbsp;&nbsp;&nbsp;[관리담당자:<%=c_db.getNameById(base.getBus_id2(),"USER")%>]</td>
    </tr>  

    
<%if(tint.getReg_st().equals("A")){%>

    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>추가설치 : <%if(tint.getTint_st().equals("3")){%>블랙박스 <%}else if(tint.getTint_st().equals("4")){%>내비게이션 <%}else if(tint.getTint_st().equals("5")){%>기타용품<%}else if(tint.getTint_st().equals("6")){%>이동형 충전기<%}%></span></td>
    </tr>  		
    <tr>
        <td class=line2></td>
    </tr>    
    <input type='hidden' name='tint_no' 	value='<%=tint.getTint_no()%>'>  
    <input type='hidden' name='tint_yn' 	value='<%=tint.getTint_yn()%>'>  
    <input type='hidden' name='tint_st' 	value='<%=tint.getTint_st()%>'>   	 	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint.getOff_nm()%></td>
                </tr>
                <%if(tint.getTint_yn().equals("Y")){

                %>
                <tr> 
                    <td class='title'>모델선택</td>
                    <td>&nbsp;
                        <%if(tint.getModel_st().equals("1")){%>추천모델<%}%>
                        <%if(!tint.getModel_st().equals("") && !tint.getModel_st().equals("1")){%>기타선택모델(<%=tint.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>채널선택</td>
                    <td>&nbsp;
                        <%if(tint.getChannel_st().equals("1")){%>1채널<%}%>
                        <%if(tint.getChannel_st().equals("2")){%>2채널<%}%>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='40' value='<%=tint.getCom_nm()%>' class='text' ></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='40' value='<%=tint.getModel_nm()%>' class='text' ></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint.getCost_st().equals("1")){%>없음
        		<%}else if(tint.getCost_st().equals("2")){%>고객(전액)
        		<%}else if(tint.getCost_st().equals("3")){%>고객(일부)
        		<%}else if(tint.getCost_st().equals("4")){%>당사
        		<%}else if(tint.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint.getEst_st().equals("Y")){%>반영
        		<%}else if(tint.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <input type='text' size='12' name='sup_dt' maxlength='12' class='text' <%if(tint.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='text' value=<%if(tint.getSup_dt().length()==10){%>'<%=tint.getSup_dt().substring(8)%>'<%}%>>
                        시	
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' class='whitenum' value='<%=AddUtil.parseDecimal(tint.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                </tr>            
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <input type='text' name='serial_no' size='40' value='<%=tint.getSerial_no()%>' class='text' ></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>&nbsp;&nbsp;
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    <%	}%>                                 
                    </td>
                </tr>  
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint.getEtc()%>' class='whitetext' ></td>
                </tr>                           
                
                <%}%>                                         
            </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>  

    
<%}else{%>

    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>출고후추가장착</td>
            <td>&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>원</td>
	  </tr>
          <tr> 
            <td class=title width=10%>서비스품목</td>
            <td>
            	&nbsp;<%=car.getExtra_set()%>&nbsp;<%if(car.getServ_b_yn().equals("Y")){%>블랙박스<%}%>
            	<%if(ej_bean.getJg_g_7().equals("3")){%>&nbsp;<%if(car.getServ_sc_yn().equals("Y")){%>고정형충전기<%}%><%}%>
            </td>
	  </tr>
      	
		<tr>
			<td class='title'><span class="title1">견적반영용품</span></td>
			<td colspan="5">&nbsp;
		    	<label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2채널 블랙박스</label>
			&nbsp;
				<label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> 전면 썬팅(기본형)</label>,
			가시광선투과율 :
				<input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
		   	% 
		  	&nbsp;
				<label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> 고급썬팅</label>
			&nbsp;&nbsp;내용 
				<input type="text" name="tint_ps_nm" size="9" value='<%=car.getTint_ps_nm()%>'>
			&nbsp; 금액 

				<input type="text" name="tint_ps_amt" size="9" value='<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>'onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'>
			원 (부가세별도)&nbsp;<br>&nbsp;
		        <label><input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> 거치형 내비게이션</label>
		        <%if(ej_bean.getJg_g_7().equals("3")){%><label><input type="checkbox" name="tint_ev_yn" value="Y" <%if(tint6.getTint_yn().equals("Y")){%>checked<%}%>> 이동형충전기</label><%}%>
		        &nbsp;<label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> 블랙박스 미제공 할인 (<%if(car.getTint_bn_nm().equals("1")){%>빌트인캠<%}else if(car.getTint_bn_nm().equals("2")){%>고객장착<%}else{%>빌트인캠,고객장착..<%}%>)</label>
			&nbsp;
		    </td>
		</tr>
          <tr> 
            <td class=title width=10%>제조사용품</td>
            <td>&nbsp;
                      <%if(pur.getCom_tint().equals("")){%>없음<%}%>
                      <%if(pur.getCom_tint().equals("1")){%>썬팅<%}%>                      
                      <%if(pur.getCom_tint().equals("2")){%>브랜드키트<%}%>
                      &nbsp;&nbsp;&nbsp;
                      		<%if(pur.getCom_film_st().equals("")){%>없음<%}%>
                		<%if(pur.getCom_film_st().equals("1")){%>루마<%}%>                      
        			<%if(pur.getCom_film_st().equals("2")){%>모비스<%}%>
				<%if(pur.getCom_film_st().equals("3")){%>SKC<%}%>
				<%if(pur.getCom_film_st().equals("4")){%>3M<%}%>
            </td>
		  </tr>		  
	</table>
      </td>
    </tr>     
    <tr>
	<td>&nbsp;</td>
    </tr>  	
    
    <%if(off_id.equals(tint1.getOff_id()) || off_id.equals(tint2.getOff_id())){%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>썬팅(측후면/전면)</span></td>
    </tr>  		
    <tr>
        <td class=line2></td>
    </tr> 
    <!--
    <input type='hidden' name='tint_no' 	value='<%=tint1.getTint_no()%>'>   	
    <input type='hidden' name='tint_no' 	value='<%=tint2.getTint_no()%>'> 
    -->
    <%if(tint1.getTint_no().equals("")){ tint1.setTint_yn("N"); }%>
    <%if(tint2.getTint_no().equals("")){ tint2.setTint_yn("N"); }%>    
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>시공구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){%>측후면<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){%>전면<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>시공하지않음<%}%>
                    </td>
                    <td colspan='2' class='title'>시공업체</td>
                    <td colspan='2' width='37%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>필름선택</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>루마
        		<%}else if(tint1.getFilm_st().equals("4")){%>기타			<!-- 추가 -->
        		<%}else if(tint1.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint1.getFilm_st().equals("6")){%>고급			<!-- 추가 -->
        		<%-- <%}else if(!tint1.getFilm_st().equals("")&&!tint1.getFilm_st().equals("2")&&!tint1.getFilm_st().equals("3")&&!tint1.getFilm_st().equals("5")){%>기타(<%=tint1.getFilm_st()%>) --%>
        		<%}else if(!tint1.getFilm_st().equals("")&&!tint1.getFilm_st().equals("2")&&!tint1.getFilm_st().equals("3")&&!tint1.getFilm_st().equals("4")&&!tint1.getFilm_st().equals("5")&&!tint1.getFilm_st().equals("6")){%>기타(<%=tint1.getFilm_st()%>)
        		<%}%>
                    </td>
                    <td rowspan='2' width='7%' class='title'>가시광선<br>투과율</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=tint1.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getFilm_st().equals("2")){%>3M
        		<%}else if(tint2.getFilm_st().equals("3")){%>루마
        		<%}else if(tint2.getFilm_st().equals("4")){%>기타			<!-- 추가 -->
        		<%}else if(tint2.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint2.getFilm_st().equals("6")){%>고급			<!-- 추가 -->	
        		<%-- <%}else if(!tint2.getFilm_st().equals("")&&!tint2.getFilm_st().equals("2")&&!tint2.getFilm_st().equals("3")&&!tint2.getFilm_st().equals("5")){%>기타(<%=tint2.getFilm_st()%>) --%>
        		<%}else if(!tint2.getFilm_st().equals("")&&!tint2.getFilm_st().equals("2")&&!tint2.getFilm_st().equals("3")&&!tint2.getFilm_st().equals("4")&&!tint2.getFilm_st().equals("5")&&!tint2.getFilm_st().equals("6")){%>기타(<%=tint2.getFilm_st()%>)
        		<%}%>                    
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=tint2.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>비용부담</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getCost_st().equals("1")){%>없음
        		<%}else if(tint1.getCost_st().equals("2")){%>고객
        		<%}else if(tint1.getCost_st().equals("4")){%>당사
        		<%}else if(tint1.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td rowspan='2' width='7%' class='title'>견적반영</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getEst_st().equals("Y")){%>반영
        		<%}else if(tint1.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getCost_st().equals("1")){%>없음
        		<%}else if(tint2.getCost_st().equals("2")){%>고객
        		<%}else if(tint2.getCost_st().equals("4")){%>당사
        		<%}else if(tint2.getCost_st().equals("5")){%>에이전트
        		<%}%>                                           
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getEst_st().equals("Y")){%>반영
        		<%}else if(tint2.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>마감요청일</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint1.getSup_est_dt())%>까지 요청함</td>
                    <td rowspan='2' width='7%' class='title'>설치비용</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint1.getTint_amt())%>원</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint2.getSup_est_dt())%>까지 요청함</td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint2.getTint_amt())%>원</td>
                </tr>
                <tr> 
                    <td colspan='2' class='title'>비고</td>
                    <td colspan='4'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint1.getEtc()%>' class='whitetext' ></td>
                </tr>                         
                <%}%>
            </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>   
    <%}%>       
         
    <%if(off_id.equals(tint3.getOff_id())){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>블랙박스</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <input type='hidden' name='tint_no' 	value='<%=tint3.getTint_no()%>'>  
    <%if(tint3.getTint_no().equals("")){ tint3.setTint_yn("N"); }%> 	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint3.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint3.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint3.getOff_nm()%></td>
                </tr>
                <%if(tint3.getTint_yn().equals("Y")){
                	update_yn = "Y";
                %>
                <tr> 
                    <td class='title'>모델선택</td>
                    <td>&nbsp;
                        <%if(tint3.getModel_st().equals("1")){%>추천모델<%}%>
                        <%if(!tint3.getModel_st().equals("") && !tint3.getModel_st().equals("1")){%>기타선택모델(<%=tint3.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>채널선택</td>
                    <td>&nbsp;
                        <%if(tint3.getChannel_st().equals("1")){%>1채널<%}%>
                        <%if(tint3.getChannel_st().equals("2")){%>2채널<%}%>                    
                    </td>
                </tr>
                <%if(tint3.getCom_nm().equals("") && tint3.getModel_st().equals("1") && tint3.getChannel_st().equals("2")){ 	  tint3.setCom_nm("이노픽스"); 		}%>
                <%if(tint3.getModel_nm().equals("") && tint3.getModel_st().equals("1") && tint3.getChannel_st().equals("2")){ 	tint3.setModel_nm("LX-100 ALPHA"); }%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%-- <input type='text' name='com_nm' size='40' value='<%=tint3.getCom_nm()%>' class='default input'  id="compName"></td> --%>
                        <input type='text' name='com_nm' size='40' value='<%=tint3.getCom_nm()%>' class='default input'  id="compName" <%if(tint3.getModel_st().equals("1")&&!(tint3.getOff_nm().equals("수입차")||tint3.getOff_nm().equals("고객장착"))){%>readOnly<%}%>></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                    	<%-- <input type='text' name='model_nm' size='30' value='<%=tint3.getModel_nm()%>' class='default input' id="modelName"> --%>
                        <input type='text' name='model_nm' size='30' value='<%=tint3.getModel_nm()%>' class='default input' id="modelName" <%if(tint3.getModel_st().equals("1")&&!(tint3.getOff_nm().equals("수입차")||tint3.getOff_nm().equals("고객장착"))){%>readOnly<%}%>>
                        <input type="hidden" name="model_id" value="<%=tint3.getModel_id()%>" id="modelId">
                        <input type="button" name="change-md-btn" class="button" value="모델 변경" onclick="openSearchPop()"/>
                    </td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint3.getCost_st().equals("1")){%>없음
        		<%}else if(tint3.getCost_st().equals("2")){%>고객(전액)
        		<%}else if(tint3.getCost_st().equals("3")){%>고객(일부)
        		<%}else if(tint3.getCost_st().equals("4")){%>당사
        		<%}else if(tint3.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint3.getEst_st().equals("Y")){%>반영
        		<%}else if(tint3.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <input type='text' size='12' name='sup_dt' maxlength='12' class='default' <%if(tint3.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint3.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint3.getSup_dt().length()==10){%>'<%=tint3.getSup_dt().substring(8)%>'<%}%>>
                        시	
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint3.getTint_amt())%>원
                    </td>
                </tr>     
                <%if(tint3.getCom_nm().equals("이노픽스") && (tint3.getModel_nm().indexOf("LX") != -1 || tint3.getModel_nm().indexOf("IX") != -1) && tint3.getSerial_no().equals("")) { tint3.setSerial_no("L10016"); }%>                
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <input type='text' name='serial_no' size='40' value='<%=tint3.getSerial_no()%>' class='default'  id="serialNo"></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint3.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint3.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                                        	&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
                                        	<br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint3.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    <%	}%>                                 
                    </td>
                </tr>  
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint3.getEtc()%>' class='whitetext' ></td>
                </tr>                           
                
                <%}%>                                         
            </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>  
    <%}%>       
          
    <%if(off_id.equals(tint4.getOff_id())){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>내비게이션</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <input type='hidden' name='tint_no' 	value='<%=tint4.getTint_no()%>'> 
    <%if(tint4.getTint_no().equals("")){ tint4.setTint_yn("N"); }%> 	  	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint4.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint4.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint4.getOff_nm()%></td>
                </tr>
                <%if(tint4.getTint_yn().equals("Y")){
                	update_yn = "Y";
                %>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='40' value='<%=tint4.getCom_nm()%>' class='default' ></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='40' value='<%=tint4.getModel_nm()%>' class='default' ></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint4.getCost_st().equals("1")){%>없음
        		<%}else if(tint4.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint4.getCost_st().equals("4")){%>당사
        		<%}else if(tint4.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint4.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint4.getEst_m_amt())%>원
        		<%}else if(tint4.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <input type='text' size='12' name='sup_dt' maxlength='12' class='default' <%if(tint4.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint4.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint4.getSup_dt().length()==10){%>'<%=tint4.getSup_dt().substring(8)%>'<%}%>>
                        시	                    
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint4.getTint_amt())%>원</td>
                </tr>            
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <input type='text' name='serial_no' size='40' value='<%=tint4.getSerial_no()%>' class='default' ></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint4.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint4.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                                        	&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
                                        	<br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint4.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    <%	}%>                     
                    </td>
                </tr>  
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint4.getEtc()%>' class='whitetext' ></td>
                </tr>
                <%}%>                                         
            </table>
	</td>
    </tr>               
    <tr>
	<td>&nbsp;</td>
    </tr> 
    <%}%>       
    
    <%if(off_id.equals(tint5.getOff_id())){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>기타용품</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>    
    <input type='hidden' name='tint_no' 	value='<%=tint5.getTint_no()%>'>      
    <input type='hidden' name='serial_no' 	value='<%=tint5.getSerial_no()%>'>      
    <%if(tint5.getTint_no().equals("")){ tint5.setTint_yn("N"); }%> 	  	 	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%'>&nbsp;
                        <%if(tint5.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint5.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint5.getOff_nm()%></td>
                </tr>    	    
                <%if(tint5.getTint_yn().equals("Y")){
                	update_yn = "Y";
                %>
                <tr> 
                    <td class='title'>상품명</td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='40' value='<%=tint5.getCom_nm()%>' class='default' ></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='40' value='<%=tint5.getModel_nm()%>' class='default' ></td>
                </tr>                   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint5.getCost_st().equals("1")){%>없음
        		<%}else if(tint5.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint5.getCost_st().equals("4")){%>당사
        		<%}else if(tint5.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint5.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint5.getEst_m_amt())%>원
        		<%}else if(tint5.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <input type='text' size='12' name='sup_dt' maxlength='12' class='default' <%if(tint5.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint5.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint5.getSup_dt().length()==10){%>'<%=tint5.getSup_dt().substring(8)%>'<%}%>>
                        시	                    
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint5.getTint_amt())%>원</td>
                </tr>            
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
                </tr>   
                
                <%}%>     
                                                    
            </table>
	</td>
    </tr>
    <%}%>
<!-- 이동형충전기 추가(2018.04.11) -->
<%if(ej_bean.getJg_g_7().equals("3")){ %>    
    <%if(off_id.equals(tint6.getOff_id())){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>이동형충전기</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <input type='hidden' name='tint_no' 	value='<%=tint6.getTint_no()%>'> 
    <%if(tint6.getTint_no().equals("")){ tint6.setTint_yn("N"); }%> 	  	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>설치구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint6.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint6.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='13%' class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <%=tint6.getOff_nm()%></td>
                </tr>
                <%if(tint6.getTint_yn().equals("Y")){
                	update_yn = "Y";
                %>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='40' value='<%=tint6.getCom_nm()%>' class='default' ></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='40' value='<%=tint6.getModel_nm()%>' class='default' ></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint6.getCost_st().equals("1")){%>없음
        		<%}else if(tint6.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint6.getCost_st().equals("4")){%>당사
        		<%}else if(tint6.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint6.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint6.getEst_m_amt())%>원
        		<%}else if(tint6.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <input type='text' size='12' name='sup_dt' maxlength='12' class='default' <%if(tint6.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint6.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint6.getSup_dt().length()==10){%>'<%=tint6.getSup_dt().substring(8)%>'<%}%>>
                        시	                    
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint6.getTint_amt())%>원</td>
                </tr>            
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <input type='text' name='serial_no' size='40' value='<%=tint6.getSerial_no()%>' class='default' ></td>
                    <td class='title'>첨부파일</td>
                    <td>&nbsp;
                    <%		
          		if(!tint6.getTint_no().equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = tint6.getTint_no(); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                                        	&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
                                        	<br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint6.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    <%	}%>                     
                    </td>
                </tr>  
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint6.getEtc()%>' class='whitetext' ></td>
                </tr>
                <%}%>                                         
            </table>
	</td>
    </tr>               
    <tr>
	<td>&nbsp;</td>
    </tr> 
    <%}%>   
<%}%>
    <%if(off_id.equals(tint1.getOff_id()) || off_id.equals(tint2.getOff_id())){%>          
	<%if(!pur.getCom_tint().equals("") && emp2.getCar_comp_id().equals("0001")){%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 현대차 용품지원 : ① 루마썬팅 또는 모비스썬팅 + 극세사먼지떨이 ② 브랜드키트(트렁크정리함+슈즈케이스+에어벤트방향제+세차용걸레+왁스걸레+먼지떨이+멀티담요+세정제)</font> </td>
	</tr>				
	<%}%>
    <%}%>
    
<%}%>
    
    <tr>
	<td>&nbsp;</td>
    </tr>  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width='13%' class=title>요청자</td>
            <td width='37%'>&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
<td class=title width=10%>실등록자</td>
                    <td>&nbsp;<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %><%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>&nbsp;(에이전트계약 계약진행담당자)<%}%></td>
			</td>			
          </tr>				  
	  
		</table>
	  </td>
	</tr> 
    <tr>
	<td>&nbsp;</td>
    </tr>  	
    <%if(update_yn.equals("Y")) {%>	
    <%	if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	<td align='center'>
	    
	    <a href="javascript:save('u')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>		
	    
	</td>
    </tr>	
    <%	}%>
    <%} %>
    
    <!--대량용품의뢰-->
    <%}else{%>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용품요청내역</span></td>
    </tr>  		
    <tr>
        <td class=line2></td>
    </tr>        	    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
	  <tr>
	    <td width="13%" class=title>용품번호</td>
	    <td>&nbsp;<%=tint.getTint_no()%><input type='hidden' name='tint_no' value='<%=tint_no%>'></td>
	  </tr>
          <tr>
	    <td class=title>설치업체</td>
	    <td >&nbsp;<%=tint.getOff_nm()%></td>
	  </tr>
          <tr>
            <td class=title>상품명</td>
            <td>&nbsp;<input type='text' name='com_nm' size='70' value='<%=tint.getCom_nm()%>' class='default' ></td>
	  </tr>
          <tr>
            <td class=title>모델명</td>
            <td>&nbsp;<input type='text' name='model_nm' size='105' value='<%=tint.getModel_nm()%>' class='default' ></td>
          </tr>					  
          <tr>
            <td class=title>수량</td>
            <td>&nbsp;<input type='text' name='tint_su' size='3' value='<%=tint.getTint_su()%>' class='defaultnum' >개</td>
	  </tr>
          <tr>
            <td class=title>비고</td>
            <td>&nbsp;<textarea name="etc" cols="105" rows="4" class="default"><%=tint.getEtc()%></textarea></td>
          </tr>					  
          <tr>
            <td class=title>작업마감요청일시</td>
            <td colspan="3">&nbsp;<input type='text' size='12' name='sup_est_dt' maxlength='12' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
              <input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>
              시	
	    </td>
          </tr>						
	</table>		  
      </td>
    </tr>  
    <tr>
	<td>&nbsp;</td>
    </tr>  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width='13%' class=title>요청자</td>
            <td width='37%'>&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
<td class=title width=10%>실등록자</td>
                    <td>&nbsp;<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %><%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>&nbsp;(에이전트계약 계약진행담당자)<%}%></td>
			</td>			
          </tr>				  
	  
		</table>
	  </td>
	</tr>            
    <tr>
	<td>&nbsp;</td>
    </tr>  	
    <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	<td align='center'>
	    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || tint.getReg_id().equals(user_id)){%>
	    <a href="javascript:save('u')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>		
	    <%}%>
	    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("부산출납",user_id) || nm_db.getWorkAuthUser("대전출납",user_id) || nm_db.getWorkAuthUser("대전지점장",user_id)){%>
	    &nbsp;&nbsp;&nbsp;
	    <a href="javascript:del_tint()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>		
	    <%}%>
	</td>
    </tr>	
    <%} %>		    
    <%}%>
				
  </table>
</form>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

