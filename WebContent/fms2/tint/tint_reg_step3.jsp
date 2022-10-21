<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_office.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "12");	
	
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
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
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
				   	
	int update_cnt = 0;			   	
	
	//의뢰자
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
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
<script language="JavaScript">
<!--
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
		
		fm.mode.value 		= mode;
		fm.doc_bit.value 	= '';
		
		<%if(tint.getRent_l_cd().equals("")){%>
			if(fm.com_nm.value == "")			{ 	alert("상품명을 입력하십시오."); 		fm.com_nm.focus(); 		return;	}					
			if(toInt(parseDigit(fm.tint_su.value))==0)	{ 	alert("수량을 입력하십시오."); 			fm.tint_su.focus(); 		return;	}			
			if(fm.sup_dt.value == '' || fm.sup_h.value == '' ){	alert('설치일자를 입력하여 주십시오.');		fm.sup_dt.focus(); 		return;	}
			if(toInt(parseDigit(fm.tint_amt.value))==0)	{ 	alert('설치비용을 입력하십시오.'); 		fm.tint_amt.focus(); 		return; }
		<%}else{%>
			if(toInt(fm.update_cnt.value) > 1){
				for(i=0; i <toInt(fm.update_cnt.value) ; i++){				
					if(fm.tint_yn[i].value == 'Y'){
																
						//if(fm.tint_st[i].value == '3' || fm.tint_st[i].value == '4' || fm.tint_st[i].value == '5'){
						if(fm.tint_st[i].value == '3'){
							if(fm.com_nm[i].value == '')			{ alert('제조사를 입력하십시오.');			fm.com_nm[i].focus(); 		return;}
							
							//if(fm.tint_st[i].value == '3' || fm.tint_st[i].value == '4'){
								if(fm.model_nm[i].value == '')		{ alert('모델명을 입력하십시오.');			fm.model_nm[i].focus(); 	return;}					
								if(fm.serial_no[i].value == '')		{ alert('일련번호를 입력하십시오.');			fm.serial_no[i].focus(); 	return;}					
								
								if(fm.tint_st[i].value == '3'){
									//if(toInt(parseDigit(fm.file_cnt[i].value)) < 2){ 	alert('블랙박스 스캔파일을 등록하여 주십시오.'); 		return; }
								}	
							//}												

							if(fm.sup_dt[i].value == '' || fm.sup_h[i].value == '' ){	alert('설치일자를 입력하여 주십시오.');		fm.sup_dt[i].focus(); 		return;	}						

						}

														
					}
				
				}		
			}else{
					if(fm.tint_yn.value == 'Y'){
																
						//if(fm.tint_st.value == '3' || fm.tint_st.value == '4' || fm.tint_st.value == '5'){
						if(fm.tint_st.value == '3'){
							if(fm.com_nm.value == '')			{ alert('제조사를 입력하십시오.');			fm.com_nm.focus(); 		return;}
							
							//if(fm.tint_st.value == '3' || fm.tint_st.value == '4'){
								if(fm.model_nm.value == '')		{ alert('모델명을 입력하십시오.');			fm.model_nm.focus(); 	return;}					
								if(fm.serial_no.value == '')		{ alert('일련번호를 입력하십시오.');			fm.serial_no.focus(); 	return;}					
								
								if(fm.tint_st.value == '3'){
									//if(toInt(parseDigit(fm.file_cnt.value)) < 2){ 	alert('블랙박스 스캔파일을 등록하여 주십시오.'); 		return; }
								}	
							//}												

							if(fm.sup_dt.value == '' || fm.sup_h.value == '' ){	alert('설치일자를 입력하여 주십시오.');		fm.sup_dt.focus(); 		return;	}						

						}

														
					}			
			}	
		<%}%>
		
		if(!confirm('수정 하시겠습니까?'))	return;		
		
		fm.action='tint_reg_step3_a.jsp';		
		//fm.target='i_no';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//결재
	function doc_sanction(doc_bit){
		var fm = document.form1;
		
		fm.mode.value 		= '';
		fm.doc_bit.value 	= doc_bit;

		<%if(tint.getRent_l_cd().equals("")){%>
			if(fm.com_nm.value == "")			{ 	alert("상품명을 입력하십시오."); 		fm.com_nm.focus(); 		return;	}					
			if(toInt(parseDigit(fm.tint_su.value))==0)	{ 	alert("수량을 입력하십시오."); 			fm.tint_su.focus(); 		return;	}			
			if(fm.sup_dt.value == '' || fm.sup_h.value == '' ){	alert('설치일자를 입력하여 주십시오.');		fm.sup_dt.focus(); 		return;	}
			if(toInt(parseDigit(fm.tint_amt.value))==0)	{ 	alert('설치비용을 입력하십시오.'); 		fm.tint_amt.focus(); 		return; }
		<%}else{%>
		
			if(toInt(fm.update_cnt.value) > 1){
				for(i=0; i <toInt(fm.update_cnt.value) ; i++){				
					if(fm.tint_yn[i].value == 'Y'){
																
						if(fm.tint_st[i].value == '3' || fm.tint_st[i].value == '4' || fm.tint_st[i].value == '5'){
							if(fm.com_nm[i].value == '')			{ alert('제조사를 입력하십시오.');			fm.com_nm[i].focus(); 		return;}
							
							if(fm.tint_st[i].value == '3' || fm.tint_st[i].value == '4'){
								if(fm.model_nm[i].value == '')		{ alert('모델명을 입력하십시오.');			fm.model_nm[i].focus(); 	return;}					
								if(fm.serial_no[i].value == '')		{ alert('일련번호를 입력하십시오.');			fm.serial_no[i].focus(); 	return;}					
								
								if(fm.tint_st[i].value == '3'){
									//if(toInt(parseDigit(fm.file_cnt[i].value)) < 2){ 	alert('블랙박스 스캔파일을 등록하여 주십시오.'); 		return; }
								}	
							}												
						}

						if(fm.sup_dt[i].value == '' || fm.sup_h[i].value == '' ){	alert('설치일자를 입력하여 주십시오.');		fm.sup_dt[i].focus(); 		return;	}
						//if(fm.cost_st[i].value != '1' && toInt(parseDigit(fm.tint_amt[i].value))==0){ 	alert('설치비용을 입력하십시오.'); 		fm.tint_amt[i].focus(); 	return; }
														
					}
				
				}		
			}else{
					if(fm.tint_yn.value == 'Y'){
																
						if(fm.tint_st.value == '3' || fm.tint_st.value == '4' || fm.tint_st.value == '5'){
							if(fm.com_nm.value == '')			{ alert('제조사를 입력하십시오.');			fm.com_nm.focus(); 		return;}
							
							if(fm.tint_st.value == '3' || fm.tint_st.value == '4'){
								if(fm.model_nm.value == '')		{ alert('모델명을 입력하십시오.');			fm.model_nm.focus(); 	return;}					
								if(fm.serial_no.value == '')		{ alert('일련번호를 입력하십시오.');			fm.serial_no.focus(); 	return;}					
								
								if(fm.tint_st.value == '3'){
									//if(toInt(parseDigit(fm.file_cnt.value)) < 2){ 	alert('블랙박스 스캔파일을 등록하여 주십시오.'); 		return; }
								}	
							}												
						}

						if(fm.sup_dt.value == '' || fm.sup_h.value == '' ){	alert('설치일자를 입력하여 주십시오.');		fm.sup_dt.focus(); 		return;	}						
														
					}			
			}
		<%}%>
				
		if(confirm('결재하시겠습니까?')){	
			fm.action='tint_reg_step3_a.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
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
  <input type='hidden' name='v_doc_no'  value='<%=doc_no%>'>          
  <input type='hidden' name='doc_bit'  value=''>        
  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_nm" 		value="<%=cm_bean.getCar_nm()%>">
  <input type='hidden' name="rpt_no" 		value="<%=pur.getRpt_no()%>">
  
  
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
            <td width=15%>&nbsp;<%=car.getColo()%></td>
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
            <td>&nbsp;<%=car.getExtra_set()%>&nbsp;<%if(car.getServ_b_yn().equals("Y")){%>블랙박스<%}%></td>
	  </tr>
          <tr> 
            <td class=title width=10%>견적반영용품</td>
            <td>&nbsp;
                      <%if(car.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%>
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>전면 썬팅
                      &nbsp;
                      가시광선투과율 : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		      &nbsp;
                      <%if(car.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%>
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
    <%if(tint1.getTint_no().equals("")) tint1.setTint_yn("N"); %>
    <%if(tint2.getTint_no().equals("")) tint2.setTint_yn("N"); %>   
    <% update_cnt = 2;%> 
    <input type='hidden' name='tint_no' 	value='<%=tint1.getTint_no()%>'>   	
    <input type='hidden' name='com_nm' 		value='<%=tint1.getCom_nm()%>'>   	
    <input type='hidden' name='model_nm' 	value='<%=tint1.getModel_nm()%>'>     
    <input type='hidden' name='serial_no' 	value='<%=tint1.getSerial_no()%>'>         
    <input type='hidden' name='tint_no' 	value='<%=tint2.getTint_no()%>'>     
    <input type='hidden' name='com_nm' 		value='<%=tint2.getCom_nm()%>'>   	
    <input type='hidden' name='model_nm' 	value='<%=tint2.getModel_nm()%>'>     
    <input type='hidden' name='serial_no' 	value='<%=tint2.getSerial_no()%>'>         
    <input type='hidden' name='tint_yn' 	value='<%=tint1.getTint_yn()%>'>   	
    <input type='hidden' name='tint_yn' 	value='<%=tint2.getTint_yn()%>'>   	
    <input type='hidden' name='tint_st' 	value='<%=tint1.getTint_st()%>'>   	
    <input type='hidden' name='tint_st' 	value='<%=tint2.getTint_st()%>'>
    <input type='hidden' name='cost_st' 	value='<%=tint1.getCost_st()%>'>   	
    <input type='hidden' name='cost_st' 	value='<%=tint2.getCost_st()%>'>
    <input type='hidden' name='file_cnt' 	value=0> 	  	      
    <input type='hidden' name='file_cnt' 	value=0> 	  	         	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>시공구분</td>
                    <td width='37%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){ %>측후면<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){ %>전면<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>시공하지않음<%}%>
                    </td>
                    <td colspan='2' class='title'>시공업체</td>
                    <td colspan='2' width='37%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>플름선택</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>루마
        		<%}else if(!tint1.getFilm_st().equals("")&&!tint1.getFilm_st().equals("2")&&!tint1.getFilm_st().equals("3")){%>기타(<%=tint1.getFilm_st()%>)
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
        		<%}else if(!tint2.getFilm_st().equals("")&&!tint2.getFilm_st().equals("2")&&!tint2.getFilm_st().equals("3")){%>기타(<%=tint2.getFilm_st()%>)
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
                <%if(tint1.getSup_dt().equals("")) tint1.setSup_dt(tint1.getSup_est_dt());%>
                <%if(tint2.getSup_dt().equals("")) tint2.setSup_dt(tint2.getSup_est_dt());%>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>시공일자</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_dt' maxlength='10' class='default' <%if(tint1.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint1.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint1.getSup_dt().length()==10){%>'<%=tint1.getSup_dt().substring(8)%>'<%}%>>
                        시	                    
                    </td>
                    <td rowspan='2' width='7%' class='title'>설치비용</td>
                    <td width='6%' class='title'>측후면</td>
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint1.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_dt' maxlength='10' class='default' <%if(tint2.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint2.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint2.getSup_dt().length()==10){%>'<%=tint2.getSup_dt().substring(8)%>'<%}%>>
                        시	                                        
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint2.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원</td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;* 시공일자, 설치비용을 입력하고 정산처리하세요.</td>
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
    <%if(tint3.getTint_no().equals("")) tint3.setTint_yn("N"); %> 	
    <input type='hidden' name='tint_no' 	value='<%=tint3.getTint_no()%>'>  
    <input type='hidden' name='tint_yn' 	value='<%=tint3.getTint_yn()%>'>  
    <input type='hidden' name='tint_st' 	value='<%=tint3.getTint_st()%>'>  
    <input type='hidden' name='cost_st' 	value='<%=tint3.getCost_st()%>'> 	 	
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
                	update_cnt++;
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
                <%if(tint3.getCom_nm().equals("") && tint3.getModel_st().equals("1") && tint3.getChannel_st().equals("2")) 	tint3.setCom_nm("이노픽스"); 	%>
                <%if(tint3.getModel_nm().equals("") && tint3.getModel_st().equals("1") && tint3.getChannel_st().equals("2")) 	tint3.setModel_nm("IX200"); 	%>
                <%if(tint3.getTint_amt() == 0 && tint3.getCom_nm().equals("이노픽스") && (tint3.getModel_nm().equals("LX100")||tint3.getModel_nm().equals("IX200")||tint3.getModel_nm().equals("IX-200")) && tint3.getModel_st().equals("1")){%>
                	<%if(AddUtil.parseInt(tint3.getReg_dt().substring(0,8)) < 20160201) 	tint3.setTint_amt(104545); 	%>
                	<%if(AddUtil.parseInt(tint3.getReg_dt().substring(0,8)) >= 20160201) 	tint3.setTint_amt(92727); 	%>
                <%}%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='40' value='<%=tint3.getCom_nm()%>' class='default' ></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='40' value='<%=tint3.getModel_nm()%>' class='default' ></td>
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
                        <input type='text' size='11' name='sup_dt' maxlength='10' class='default' <%if(tint3.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint3.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint3.getSup_dt().length()==10){%>'<%=tint3.getSup_dt().substring(8)%>'<%}%>>
                        시	
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint3.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                </tr>
                <%if(tint3.getCom_nm().equals("이노픽스") && tint3.getModel_nm().equals("LX100") && tint3.getSerial_no().equals("")) 	tint3.setSerial_no("L10015"); 	%>
                <%if(tint3.getCom_nm().equals("이노픽스") && AddUtil.replace(tint3.getModel_nm(),"-","").equals("IX200") && tint3.getSerial_no().equals("")) 	tint3.setSerial_no("IX-200"); 	%>
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <input type='text' name='serial_no' size='40' value='<%=tint3.getSerial_no()%>' class='default' ></td>
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
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a><br>&nbsp;
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint3.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    		<input type='hidden' name='file_cnt' value='<%=attach_vt_size%>'> 
                    		(앞/실내사진 2장)  	 	
                    <%	}%>                                 
                    </td>
                </tr>  
                <%}%>                                         
            </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;* 제조사명, 모델명, 설치일자, 설치비용, 일련번호를 입력하고 블랙박스 장착된 차량의 앞사진과 실내사진을 스캔 등록후  정산처리하세요.</td>
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
    <%if(tint4.getTint_no().equals("")) tint4.setTint_yn("N"); %> 	  	
    <input type='hidden' name='tint_no' 	value='<%=tint4.getTint_no()%>'> 
    <input type='hidden' name='tint_yn' 	value='<%=tint4.getTint_yn()%>'> 
    <input type='hidden' name='tint_st' 	value='<%=tint4.getTint_st()%>'>   	  	    
    <input type='hidden' name='cost_st' 	value='<%=tint4.getCost_st()%>'>   	  	    
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
                	update_cnt++;
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
                        <input type='text' size='11' name='sup_dt' maxlength='10' class='default' <%if(tint4.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint4.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint4.getSup_dt().length()==10){%>'<%=tint4.getSup_dt().substring(8)%>'<%}%>>
                        시	                    
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint4.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
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
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a><br>&nbsp;
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint4.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>  
                    
                    		<input type='hidden' name='file_cnt' value='<%=attach_vt_size%>'>
                    
                    <%	}%>                     
                    </td>
                </tr>  
                <%}%>                                         
            </table>
	</td>
    </tr>               
    <tr>
	<td>&nbsp;* 제조사명, 모델명, 설치일자, 설치비용, 일련번호를 입력하고 정산처리하세요.</td>
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
    <%if(tint5.getTint_no().equals("")) tint5.setTint_yn("N"); %> 	  	 	
    <input type='hidden' name='tint_no' 	value='<%=tint5.getTint_no()%>'>      
    <input type='hidden' name='serial_no' 	value='<%=tint5.getSerial_no()%>'>    
    <input type='hidden' name='tint_yn' 	value='<%=tint5.getTint_yn()%>'> 
    <input type='hidden' name='tint_st' 	value='<%=tint5.getTint_st()%>'>  
    <input type='hidden' name='cost_st' 	value='<%=tint5.getCost_st()%>'>   	  	    
    <input type='hidden' name='file_cnt' 	value=0> 	  	      
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
                	update_cnt++;
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
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
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
                        <input type='text' size='11' name='sup_dt' maxlength='10' class='default' <%if(tint5.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint5.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='default' value=<%if(tint5.getSup_dt().length()==10){%>'<%=tint5.getSup_dt().substring(8)%>'<%}%>>
                        시	                    
                    </td>
                    <td class='title'>설치비용</td>
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint5.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                </tr>            
                <%}%>                                         
            </table>
	</td>
    </tr>
    <tr>
	<td>&nbsp;* 상품명, 설치일자, 설치비용을 입력하고 정산처리하세요.</td>
    </tr>  	    
    <%}%>   
    
    <%if(off_id.equals(tint1.getOff_id()) || off_id.equals(tint2.getOff_id())){%>          
	<%if(!pur.getCom_tint().equals("") && emp2.getCar_comp_id().equals("0001")){%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 현대차 용품지원 : ① 루마썬팅 또는 모비스썬팅 + 극세사먼지떨이 ② 브랜드키트(트렁크정리함+슈즈케이스+에어벤트방향제+세차용걸레+왁스걸레+먼지떨이+멀티담요+세정제)</font> </td>
	</tr>				
	<%}%>
    <%}%>
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width='13%' class=title>요청자</td>
            <td>&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
          </tr>				  
		</table>
	  </td>
	</tr> 
    <tr>
	<td>&nbsp;</td>
    </tr>  
    <%	if(doc.getDoc_bit().equals("2") || doc.getDoc_bit().equals("3")){%>	
    <%		if(update_cnt > 0) {%>	
    <%//			if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	<td align='center'>	    
	    <a href="javascript:save('u')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>			    
	</td>
    </tr>	
    <%//		}%>
    <%		} %>
    <%	} %>
    
    <input type='hidden' name='update_cnt'  value='<%=update_cnt%>'>        
    
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
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(tint.getSup_est_dt())%>	
	    </td>
          </tr>		
          <tr>
            <td class=title>설치일자</td>
            <td colspan="3">&nbsp;<input type='text' size='11' name='sup_dt' maxlength='10' class='default' <%if(tint.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
              <input type='text' size='2' name='sup_h' class='default' value=<%if(tint.getSup_dt().length()==10){%>'<%=tint.getSup_dt().substring(8)%>'<%}%>>
              시	
	    </td>
          </tr>		
          <tr>
            <td class=title>설치비용</td>
            <td>&nbsp;<input type='text' size='10' maxlength='10' name='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
            </td>
          </tr>		          
          
	</table>		  
      </td>
    </tr>  
    <tr>
	<td>&nbsp;* 상품명, 설치일자, 설치비용을 입력하고 정산처리하세요.</td>
    </tr>  	    	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width='13%' class=title>요청자</td>
            <td>&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
          </tr>				  
		</table>
	  </td>
	</tr>            
    <tr>
	<td>&nbsp;</td>
    </tr>  
    <%	if(doc.getDoc_bit().equals("2")){%>
    <%		if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	<td align='center'>
	    <a href="javascript:save('u')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>		
	</td>
    </tr>	
    <%		} %>		    
    <%	} %>		    
    
    <%}%>
		
	<tr>
	    <td></td>
	</tr>	
	<tr>
	  <td align="right" style='background-color:c5c5c5; height:1;'></td>
	</tr>	
	<tr>
	    <td><%=doc.getDoc_no()%></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>		
    <tr> 
      <td class='line'> 		
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td class=title width=13% rowspan="2">결재</td>
            <td class=title width=15%>지점명</td>
            <td class=title width=11%>의뢰</td>
            <td class=title width=11%>수신</td>
            <td class=title width=13%>정산</td>
            <td class=title width=12%>청구</td>
            <td class=title width=12%>의뢰자확인</td>
            <td class=title width=13%>용품관리자</td>
          </tr>
          <tr>
            <td align="center"><font color="#999999"><%=sender_bean.getBr_nm()%></font></td>
            <td align="center"><font color="#999999"><%=sender_bean.getUser_pos()%> <%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%></font></td>
            <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%></font></td>
            <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(doc.getUser_dt3().equals("") && (doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id))){%><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%></font></td>
            <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%></font></td>
	    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt5()%></font></td>
	    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%></font></td>
          </tr>
        </table>
	  </td>
    </tr>
	<tr>
	    <td align='right'>	    				
		<span class="b"><a href="javascript:location.reload()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a></span>&nbsp;	  		
	  </td>
	</tr>  			
    				
  </table>
</form>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

