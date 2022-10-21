<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_sche.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.ext.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();

	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, cont_etc.getSuc_rent_st());
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, cont_etc.getSuc_rent_st());
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//영업담당자
	user_bean 	= umd.getUsersBean(base.getBus_id());	
	
	//영업수당+영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "7");
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(user_bean.getSa_code());

	//에이전트관리 20131101
	CarOffBean a_co_bean = new CarOffBean();	
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}
	
	ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
	
	//원게약자 승계수수료 부담
	if(cont_etc.getRent_suc_commi_pay_st().equals("1") && cont_etc.getRent_suc_commi() != (suc2.getExt_s_amt()+suc2.getExt_v_amt())){
		suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//기존 등록 여부 조회
	}
	
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("1", rent_l_cd);
	}
	

	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&doc_no="+doc_no+"&mode="+mode+
				   	"";	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//리스트
	function list(){
		var fm = document.form1;			
		fm.action = 'suc_commi_doc_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//영업수당계산
	function set_amt(){
		var fm = document.form1;
		var per = 1;
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
			
			per = 0.1;
			
			fm.inc_per.value = 0;
			fm.res_per.value = 0;
			fm.vat_per.value = per*100;
			fm.tot_per.value = per*100;
						
			fm.inc_amt.value = 0; 
			fm.res_amt.value = 0;
			fm.vat_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.agent_commi.value))) * per ));
			fm.c_amt.value = fm.vat_amt.value; 
			
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.c_amt.value)));
			
			
		<%}else{%>
			
		if(fm.rec_incom_st.value == ''){			alert('소득구분을 선택하십시오.'); return;		}
						
		if(fm.rec_incom_st.value != ''){
					
			if(fm.rec_incom_st.value == '2'){
				per = 0.03;
			}else if(fm.rec_incom_st.value == '3'){
				per = 0.06;			//20180401부터 0.04->0.06 변경
				if(<%=AddUtil.getDate(4)%> > 20181231){
					per = 0.08;		//20190101부터 0.06->0.08 변경
				}
			}
			
			fm.inc_per.value = per*100;
			fm.res_per.value = per*10;
			fm.vat_per.value = 0;
			fm.tot_per.value = per*110;

			fm.inc_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.agent_commi.value))) * per )); 
			fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
			fm.vat_amt.value = 0;
			fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
						
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.agent_commi.value)) - toInt(parseDigit(fm.c_amt.value)) ); 
			
		}
		
		<%}%>
	}
	
	//주민등록번호 체크

 	var errfound = false;

	function jumin_No(){
		var fm = document.form1;
		
		var ssn = '';
		var ssn1 = '';
		var ssn2 = '';
		
		ssn = replaceString('-','',fm.rec_ssn.value);
		
		ssn1 = ssn.substr(0, 6);
		ssn2 = ssn.substr(6);
		
		var str_len ;
    		var str_no = ssn1+ssn2;

    		str_len = str_no.length;
    		
		var a1=str_no.substring(0,1);
		var a2=str_no.substring(1,2);
		var a3=str_no.substring(2,3);
		var a4=str_no.substring(3,4);
		var a5=str_no.substring(4,5);
		var a6=str_no.substring(5,6);

		var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7;

		var b1=str_no.substring(6,7);
		var b2=str_no.substring(7,8);
		var b3=str_no.substring(8,9);
		var b4=str_no.substring(9,10);
		var b5=str_no.substring(10,11);
		var b6=str_no.substring(11,12);
		var b7=str_no.substring(12,13);

		var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5; 

		check_digit = check_digit%11;
		check_digit = 11 - check_digit;
		check_digit = check_digit%10;
			
		if (check_digit != b7){
			alert('잘못된 주민등록번호입니다.');
			errfound = false;          
		}else{
			errfound = true;
		}    				
		
		return errfound;	
	}


	
	function save(mode){
		var fm = document.form1;
		
		<%if(a_co_bean.getDoc_st().equals("2")){%>
		
		<%}else{%>	
			if(fm.emp_acc_nm.value == '')		{	alert('실수령인 이름을 입력하여 주십시오.'); 				return;		}

			if(fm.emp_acc_nm.value.indexOf(',') != -1){	alert('실수령인 이름을 확인하여 주십시오. 소득신고를 하오니 성명만 입력하여 주십시오.');	return;		}
			if(fm.emp_acc_nm.value.indexOf('(') != -1){	alert('실수령인 이름을 확인하여 주십시오. 소득신고를 하오니 성명만 입력하여 주십시오.'); 	return;		}

			if(fm.rel.value == '')			{	alert('실수령인의 영업사원과의 관계를 입력하여 주십시오.'); 		return;		}
			if(fm.rec_incom_yn.value == '')		{	alert('실수령인의 타소득여부를 입력하여 주십시오.'); 			return;		}
			if(fm.rec_incom_st.value == '')		{	alert('실수령인의 소득구분를 입력하여 주십시오.'); 			return;		}
			if(fm.emp_bank_cd.value == '')		{	alert('실수령 은행을 입력하여 주십시오.'); 				return;		}
			if(fm.emp_acc_no.value == '')		{	alert('실수령 계좌번호를 입력하여 주십시오.'); 				return;		}
			if(fm.rec_ssn.value == '')		{	alert('실수령인의 주민번호를 입력하여 주십시오.'); 			return;		}
			if(fm.t_zip.value == '')		{	alert('실수령인의 우편번호를 입력하여 주십시오.'); 			return;		}
			if(fm.t_addr.value == '')		{	alert('실수령인의 주소를 입력하여 주십시오.'); 				return;		}
			
			//주민번호 세부 확인
			if(!jumin_No()){
				return;
			}
		<%}%>
		
		if(fm.d_amt.value == '0')		{	alert('세후지급액을 확인하십시오.'); 					return;		}
				
		fm.mode.value = mode;

		if(confirm('수정 하시겠습니까?')){	
			fm.action='suc_commi_doc_u_a.jsp';		
			fm.target='d_content';			
			fm.submit();
		}				
	}
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		set_amt();
				
		if(confirm('결재하시겠습니까?')){	
			fm.action='suc_commi_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}	
	
	//실수령인 조회
	function search_bank_acc(){
		var fm = document.form1;
		window.open("s_emp_bank_acc.jsp?from_page=/fms2/commi/commi_doc_u.jsp&emp_id=<%=emp1.getEmp_id()%>", "SEARCH_EMP_ACC", "left=50, top=50, width=950, height=600, scrollbars=yes");		
	}		

//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=coe_bean.getEmp_id()%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="mode" 		value="<%=mode%>">    
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="s_file_name1"	value="">      
  <input type='hidden' name="s_file_name2"	value="">      
  <input type='hidden' name="s_file_gubun1"	value="">      
  <input type='hidden' name="s_file_gubun2"	value="">        
  <input type="hidden" name="rent_dt" 		value="<%=base.getDlv_dt()%>">
  <input type="hidden" name="car_id" 		value="<%=car.getCar_id()%>">
  <input type="hidden" name="car_seq" 		value="<%=car.getCar_seq()%>">
  <input type="hidden" name="car_amt" 		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type="hidden" name="opt_amt" 		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">
  <input type="hidden" name="col_amt" 		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">
  <input type='hidden' name="agent_doc_st"	value="<%=a_co_bean.getDoc_st()%>">
  <input type='hidden' name="auto_set_amt"	value="Y">
  <input type='hidden' name="doc_bit" 		value="">      
  
  

  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;FMS운영관리 > 전자문서관리 > <span class=style5>승계업무수당지급요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'><a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
	</tr>
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
                    <td class=title width=10%>사업자번호</td>
                    <td width=15%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
		        </tr>	
                <tr> 
                    <td class=title width=10%>용도구분</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title width=10%>관리구분</td>
                    <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}else if(rent_way.equals("2")){%>맞춤식<%}%></td>
                    <td class=title width=10%>이용기간</td>
                    <td width=15%>&nbsp;<%=fee.getCon_mon()%>개월</td>
                    <td class=title width=10%>월대여료</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
		        </tr>	
                <tr>
                    <td class=title width=10%>제작사명</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class=title width=10%>차명</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%><%if(!cr_bean.getCar_no().equals("")){%>&nbsp;(<%=cr_bean.getCar_no()%>)<%}%></td>
                    <td class=title width=10%>배기량</td>
                    <td width=15%>&nbsp;<%=cm_bean.getDpm()%>cc</td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
	<tr>
	    <td align="right"></td>
	</tr> 
	<tr> 
        <td class=line2></td>
    </tr> 
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>계약승계일자</td>
                    <td width=40%>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%></td>
        			      <td class=title width=10%>담당자</td>		
                    <td width=40%>&nbsp;<%=c_db.getNameById(base.getBus_id(), "USER")%></td>
    		        </tr>	            	
                <tr> 
                    <td class=title width=10%>계약승계수수료</td>
                    <td width=40%>&nbsp;<input type='text' size='11' name='rent_suc_commi' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' readonly>원
                    &nbsp;( 
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);' readonly>원					  
                    	)
                    	</td>
        			      <td class=title width=10%>정상승계수수료</td>		
        			      <% int car_amt = car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();%>
                    <td width=40%>&nbsp;<%=AddUtil.parseDecimal(car_amt*0.8/100)%>원 (신차소비자가 <%=AddUtil.parseDecimal(car_amt)%>원의 0.8%, 부가세포함)</td>
    		        </tr>	
                <tr> 
                    <td class=title>승계수수료감면사유</td>
                    <td>&nbsp;
                    	<%if(cont_etc.getRent_suc_exem_cau().equals("1")){%>법인 전환 (전액감면)
                      <%}else if(cont_etc.getRent_suc_exem_cau().equals("2")){%>이용자 동일 (50%감면)
                      <%}else if(cont_etc.getRent_suc_exem_cau().equals("3")){%>기존고객과 특수관계
                      <%}else if(cont_etc.getRent_suc_exem_cau().equals("5")){%>에이전트 승계수당과 상계
                      <%}else{%><%=cont_etc.getRent_suc_exem_cau()%><%}%>
                    	</td>
        			      <td class=title>수수료감면 결재자</td>		
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getRent_suc_exem_id(), "USER")%></td>
    		        </tr>	
    	    </table>
	</td>
    </tr>  	  	
    <tr>
	<td>&nbsp;<%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>
                       ※ 에이전트 승계수당과 상계 : 정상승계수수료 11만원(VAT포함) 이하는 승계수수료 전액면제, 정상승계수수료 11만원(VAT포함) 이상은 승계수수료 11만원(VAT포함)이 감액됩니다.
                      <%}%></td>
  </tr> 
	<tr> 
        <td class=line2></td>
    </tr> 
    <%if(a_co_bean.getDoc_st().equals("2")){ //에이전트-세금계산서 발행분%>
    <input type="hidden" name="rel" value="에이전트">
    <input type="hidden" name="rec_incom_yn" value="">
    <input type="hidden" name="rec_incom_st" value="">
    <input type="hidden" name="rec_ssn" value="<%=a_co_bean.getEnp_no()%>">
    <input type="hidden" name="emp_bank" value="<%=a_co_bean.getBank()%>">
    <input type="hidden" name="emp_bank_cd" value="<%=a_co_bean.getBank_cd()%>">
    <input type="hidden" name="emp_acc_no" value="<%=a_co_bean.getAcc_no()%>">
    <input type="hidden" name="emp_acc_nm" value="<%=a_co_bean.getAcc_nm()%>">
    <input type="hidden" name="t_zip" value="<%=a_co_bean.getCar_off_post()%>">
    <input type="hidden" name="t_addr" value="<%=a_co_bean.getCar_off_addr()%>">
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>영<br>업<br>담<br>당</td>
                    <td class=title width=7%>상호/성명</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getCar_off_nm()%></td>
                    <td class=title width=10%>구분</td>
                    <td width=15%>&nbsp;
                        <%if(a_co_bean.getCar_off_st().equals("3")){%>법인<%}%>
                    	<%if(a_co_bean.getCar_off_st().equals("4")){%>개인사업자<%}%>
                    </td>
                    <td class=title width=10%>사업자/주민번호</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(a_co_bean.getEnp_no())%></td>
                    <td class=title width=10%>거래증빙</td>
                    <td width=15%>&nbsp;
        		<%if(a_co_bean.getDoc_st().equals("1")){%>원천징수<%}%>
                    	<%if(a_co_bean.getDoc_st().equals("2")){%>세금계산서<%}%>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getBank()%></td>
                    <td class=title width=10%>계좌번호</td>
                    <td>&nbsp;<%=a_co_bean.getAcc_no()%></td>
                    <td class=title width=10%>예금주</td>
                    <td colspan="3">&nbsp;<%=a_co_bean.getAcc_nm()%></td>                    
		</tr>	
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="7">&nbsp;<%=a_co_bean.getCar_off_post()%>
        			   &nbsp;<%=a_co_bean.getCar_off_addr()%></td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
    <tr> 
        <td class=h></td>
    </tr>	 				 	 	    
    <%}else{%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>영<br>업<br>담<br>당</td>
                    <td class=title width=7%>실수령인</td>
                    <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="12" class='text'>					  
					  <a href="javascript:search_bank_acc()"><span title="<%=emp1.getEmp_acc_nm()%> 영업사원의 실수령인을 조회합니다."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>					  
					</td>
                    <td class=title width=10%>관계</td>
                    <td width=15%>&nbsp;<input type='text' name="rel" value='<%=emp1.getRel()%>' size="16" class='text'></td>
                    <td class=title width=10%>타소득</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_yn">
                        <option value="">==선택==</option>
        				<option value="1" <%if(emp1.getRec_incom_yn().equals("1")){%> selected <%}%>>유</option>
        				<option value="2" <%if(emp1.getRec_incom_yn().equals("2")){%> selected <%}%>>무</option>							
        			  </select>
        			</td>
                    <td class=title width=10%>소득구분</td>
                    <td width=15%>&nbsp;
        			  <select name="rec_incom_st" onChange="javascript:set_amt()">
                        <option value="">==선택==</option>
        				<option value="2" <%if(emp1.getRec_incom_st().equals("2")){%> selected <%}%>>사업소득</option>
        				<option value="3" <%if(emp1.getRec_incom_st().equals("3")){%> selected <%}%>>기타사업소득</option>
        			  </select>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>거래은행</td>
                    <td width=15%>&nbsp;
                    	<input type='hidden' name="emp_bank" 			value="<%=emp1.getEmp_bank()%>">
                    	<select name='emp_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//신규인경우 미사용은행 제외
																if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select></td>
                    <td class=title width=10%>계좌번호</td>
                    <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="31" class='text'></td>
                    <td class=title width=10%>주민번호</td>
                    <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='<%= emp1.getRec_ssn() %>' size="16" class='text'></td>
		        </tr>	
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="7">&nbsp;<input type='text' name="t_zip" value='<%= emp1.getRec_zip() %>' size="7" class='text' readonly>
        			   &nbsp;<input type='text' name="t_addr" value='<%= emp1.getRec_addr() %>' size="40" class='text' style='IME-MODE: active' ></td>
		</tr>	
	    </table>
	</td>
    </tr>  	 	
    <tr> 
        <td class=h></td>
    </tr>	 		    
	<%}%>
	<tr> 
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <%if(a_co_bean.getDoc_st().equals("2")){%>
                <tr> 
                    <td class=title width=10%>구분</td>
                    <td class=title width=15%>금액</td>
                    <td class=title width=75%>세율</td>
                </tr>	
                <tr> 
                    <td class=title>업무진행수당</td>
                    <td align="center"><input type='text' name='agent_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getAgent_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();' readonly></td>
                    <td align="center">&nbsp;</td>
                </tr>                                          
                <tr>
                    <td class=title>VAT</td>
                    <td align="center"><input type='text' name='vat_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getVat_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='vat_per' maxlength='3' value='<%=emp1.getVat_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                </tr> 
                <input type="hidden" name="inc_amt" value="<%=Util.parseDecimal(emp1.getInc_amt())%>">
                <input type="hidden" name="inc_per" value="<%=emp1.getInc_per()%>">
                <input type="hidden" name="res_amt" value="<%=Util.parseDecimal(emp1.getRes_amt())%>">
                <input type="hidden" name="res_per" value="<%=emp1.getRes_per()%>">
                <input type="hidden" name="c_amt" value="<%=Util.parseDecimal(emp1.getTot_amt())%>">
                <input type="hidden" name="tot_per" value="<%=emp1.getTot_per()%>">
                <tr>
                  <td class=title>실지급액</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                  <td>&nbsp;실지급액  = 업무진행수당 + VAT</td>
                </tr>	
                <%}else{%>                
                <tr> 
                    <td colspan="2" class=title>구분</td>
                    <td class=title width=15%>금액</td>
                    <td class=title width=75%>세율</td>
                </tr>	
                <tr> 
                    <td colspan='2' class=title>업무진행수당</td>
                    <td align="center"><input type='text' name='agent_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getAgent_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();' readonly></td>
                    <td align="center">&nbsp;</td>
                </tr>                                          
                <tr>
                    <td rowspan="3" class=title>원<br>천<br>징<br>수</td>
                    <td class=title>소득세</td>
                    <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='inc_per' maxlength='3' value='<%=emp1.getInc_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                </tr>
                <tr>
                    <td class=title>지방세</td>
                    <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='res_per' maxlength='3' value='<%=emp1.getRes_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                </tr>
                <tr>
                    <td class=title>소계</td>
                    <td align="center"><input type='text' name='c_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                    <td>&nbsp;<input type='text' name='tot_per' maxlength='3' value='<%=emp1.getTot_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
                </tr>
                <input type="hidden" name="vat_amt" value="<%=Util.parseDecimal(emp1.getVat_amt())%>">
                <input type="hidden" name="vat_per" value="<%=emp1.getVat_per()%>">
                <tr>
                  <td colspan="2" class=title>실지급액</td>
                  <td align="center"><input type='text' name='d_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' readonly></td>
                  <td>&nbsp;실지급액  = 과세기준액 - 원천징수세액 + 세후가감액</td>
                </tr>	
                <%}%>
		    </table>
	    </td>
	</tr>  
	<%if((!acar_de.equals("1000") && doc.getUser_dt8().equals("")) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업수당회계관리자",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("에이전트관리",user_id)){%>
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 
	<%		if(!mode.equals("view") && !doc.getDoc_step().equals("3")){%> 	
    <tr>
	    <td align='center'>	 
	<%if(  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	        <a href="javascript:save('');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	 <% } %>       
	    </td>
	</tr>			  
	<%		}%>
	<%}%>
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
                    <td class=title width=10% rowspan="2">발신</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=18%><%=doc.getUser_nm1()%></td>
                    <td class=title width=18%><%=doc.getUser_nm2()%></td>
                    <td class=title width=18%><%=doc.getUser_nm3()%></td>
                    <td class=title width=21%><%=doc.getUser_nm4()%></td>
    		    </tr>	
                <tr> 
                    <td align="center"><%if(user_bean.getDept_id().equals("1000")){%><%=user_bean.getDept_nm()%><%}else{%><%=user_bean.getBr_nm()%><%}%></td>
                    <td align="center"><!--기안자--><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                    <td align="center"><!--지점장--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("") && !doc.getUser_id2().equals("XXXXXX")){%>
        			  <%	String user_id2 = doc.getUser_id2();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        			  		if(!cs_bean.getWork_id().equals("")) user_id2 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")){
        						user_id2 = doc.getUser_id3();
        						CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);
        			  			if(!cs_bean2.getWork_id().equals("")) user_id2 = cs_bean2.getWork_id();
        						if(!cs_bean2.getUser_id().equals("") && cs_bean2.getWork_id().equals(""))	user_id2 = "000004";//안보국
        					}
        					%>
        			  <%	if(doc.getUser_id2().equals(user_id) || user_id2.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>			
        			  </td>
                    <td align="center"><!--영업팀장--><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt3().equals("") && !doc.getUser_id3().equals("XXXXXX")){%>
        			  <%	String user_id3 = doc.getUser_id3();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        			  		if(!cs_bean.getWork_id().equals("")) user_id3 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id3 = "000004";//안보국
        					%>			  
        			  <%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>
        			  <%	}%><br>&nbsp;
        			  <%}%>
        			  </td>
                    <td align="center">&nbsp;<br>&nbsp;<br>&nbsp;<br></td>
    		    </tr>	
    		</table>
	    </td>
	</tr>  	 	
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
                    <td class=title width=10% rowspan="2">수신</td>
                    <td class=title width=15%><%=doc.getUser_nm6()%></td>
                    <td class=title width=18%><%=doc.getUser_nm7()%></td>
                    <td class=title width=18%><%=doc.getUser_nm8()%></td>
                    <td class=title width=18%>&nbsp;</td>
                    <td class=title width=21%><%=doc.getUser_nm9()%></td>
                </tr>	
                <tr> 
                    <td align="center"><!--회계관리자--><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%>
        			  <%if(doc.getUser_dt6().equals("")){%>
        			  <%	String user_id6 = doc.getUser_id6();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id6);
        			  		if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) 	user_id6 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id6 = nm_db.getWorkAuthUser("세금계산서담당자");
        					%>
        			  <%	if(doc.getUser_id6().equals(user_id) || user_id6.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("영업수당관리자",user_id)  || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)){%>
        			    <a href="javascript:doc_sanction('6')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>        			    
        			    <br>&nbsp;<br><a href="javascript:doc_id_cng('6', '<%=doc.getUser_id6()%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()">.</a>        			    
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>        			  
        			  
        			</td>
                    <td align="center"><!--채권관리자--><%=c_db.getNameById(doc.getUser_id7(),"USER_PO")%><br><%=doc.getUser_dt7()%>
        			  <%if(!doc.getUser_dt6().equals("") && doc.getUser_dt7().equals("")){%>
        			  <%	String user_id7 = doc.getUser_id7();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id7);
							if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) 	user_id7 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))		user_id7 = nm_db.getWorkAuthUser("계약서류점검담당자");
        					if(doc.getUser_id7().equals("000144") && !cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id7 = "000126";//장혁준
        					if(!doc.getUser_id7().equals("000144") && !cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id7 = "000144";//함윤원
        					if(doc.getUser_id7().equals("000070") && !cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id7 = "000056";//박연실->최은아
        					if(doc.getUser_id7().equals("000056") && !cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id7 = "000070";//박연실<-최은아
							if(doc.getUser_id7().equals("000121") && !cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id7 = "000070";//박연실<-최은숙
        					%>
        			  <%	if(doc.getUser_id7().equals(user_id) || user_id7.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("영업수당관리자",user_id) || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("대출관리자",user_id)){%>
        			    <a href="javascript:doc_sanction('7')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>        			    
        			    <br>&nbsp;<br><a href="javascript:doc_id_cng('7', '<%=doc.getUser_id7()%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()">.</a>        			    
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>
        			  
        			</td>
                    <td align="center"><!--팀장--><%=c_db.getNameById(doc.getUser_id8(),"USER_PO")%><br><%=doc.getUser_dt8()%>
					  <%if(!doc.getUser_id8().equals("XXXXXX")){%>
        			  <%if(!doc.getUser_dt7().equals("") && doc.getUser_dt8().equals("")){%>
        			  <%	String user_id8 = doc.getUser_id8();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id8);
        			  		if(!cs_bean.getWork_id().equals("")) user_id8 = cs_bean.getWork_id();
        					%>
        			  <%	if(doc.getUser_id8().equals(user_id) || user_id8.equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사영업팀장",user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id)){%>
        			    <a href="javascript:doc_sanction('8')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>        			    
        			    
        			    <%		if(nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("영업수당관리자",user_id)  || nm_db.getWorkAuthUser("채권관리팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)){%>
        			    <br>&nbsp;<br><a href="javascript:doc_id_cng('8', '<%=doc.getUser_id8()%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()">.</a>        			    
        			    <%		}%>
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>
					  <%}else{%>-<%}%>
        			</td>
                    <td align="center">&nbsp;<br>&nbsp;<br>&nbsp;<br></td>
                    <td align="center">&nbsp;</td>
    		    </tr>	
    		</table>
	    </td>
	</tr> 
</table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	<%if(a_co_bean.getDoc_st().equals("2")){%>
		fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.c_amt.value)) ); 
	<%}else{%>
		fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.agent_commi.value)) - toInt(parseDigit(fm.c_amt.value)) ); 
	<%}%>
	
	
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

