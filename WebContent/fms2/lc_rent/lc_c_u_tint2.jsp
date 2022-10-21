<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.user_mng.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();


	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String tint_st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String from_page2 	= request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());

	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//정상요금견적
	Hashtable esti_exam = e_db.getEstimateResultVar(f_fee_etc.getBc_est_id(), "esti_exam");
			
	//용품	
	TintBean tint 	= t_db.getCarTint(rent_mng_id, rent_l_cd, tint_st);	
	
	//영업담당자
	UsersBean user_bean 	= umd.getUsersBean(base.getBus_id());

	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
<!--

	//모델 검색 팝업 열기
	function openSearchPop(){
		var SUBWIN="/fms2/blackbox/bb_search_model_pop.jsp?auth_rw="+<%= auth_rw %>
		window.open(SUBWIN, "ServOffReg", "left=100, top=120, width=650, height=550, scrollbars=no");
	}
	
	//설치구분 선택시
	function cng_input(){		  
		var fm = document.form1;
		
		if(fm.tint_yn[0].checked == false && fm.tint_yn[1].checked == false){ alert('설치구분을 선택하십시오.'); return;}
		
		if(fm.tint_yn[1].checked == true){
			fm.off_id.value = '';
		}else{
			if('<%=tint.getTint_no()%>' == ''){
				<%if(user_bean.getBr_id().equals("B1")||user_bean.getBr_id().equals("U1")){%>		fm.off_id.value = '010255스마일TS'; 
				<%}else if(user_bean.getBr_id().equals("D1")){%>					fm.off_id.value = '010937주식회사미성테크';
				<%}else if(user_bean.getBr_id().equals("G1")){%>					fm.off_id.value = '008501아시아나상사';				
				<%}else if(user_bean.getBr_id().equals("J1")){%>					fm.off_id.value = '008680용용이자동차용품점';
				<%}else{%>															fm.off_id.value = '002849다옴방'; 
				<%}%>
			}			
		}				
	}
	
	//견적반영,비용부담 선택시
	function cngCostEst(st){
		var fm = document.form1;
		
		//에이전트,영업사원 계약
		<%if(base.getBus_st().equals("2") || base.getBus_st().equals("7")){%>
		
		if(st == 'est_st'){
			if(fm.est_st.value == 'Y'){
				fm.cost_st.value = '1';
			}else{
				fm.cost_st.value = '5';			
			}
		}
		
		if(st == 'cost_st'){
			if(fm.cost_st.value == '1'){
				fm.est_st.value = 'Y';
			}else{
				fm.est_st.value = 'N';			
			}
		}
		
		
		<%}else{%>
		
		<%}%>
	}
	
	//수정
	function update(){
		var fm = document.form1;
		
		if(fm.tint_yn[0].checked == false && fm.tint_yn[1].checked == false){ alert('설치구분을 선택하십시오.'); return;}
		
		if(fm.tint_yn[0].checked == true){
		
			if(fm.off_id.value == ''){ alert('설치업체를 선택하십시오.'); return;}
		
			<%if(tint_st.equals("3")){%>
				if(fm.model_st[0].checked == false && fm.model_st[1].checked == false)		{ alert('모델선택을 선택하십시오.'); return;}
				if(fm.channel_st[0].checked == false && fm.channel_st[1].checked == false)	{ alert('채널선택을 선택하십시오.'); return;}
				//VVV 블랙박스-제조사명, 모델명 밸리데이션 추가(2018.02.06)
				if(fm.com_nm.value == ''){		 alert('모델선택을 선택하거나 제조사명을 직접 입력하십시오.'); return;}
				if(fm.model_nm.value == ''){	 alert('모델선택을 선택하거나 모델명을 직접 입력하십시오.'); return;}
				
				if(fm.com_nm.value == '이노픽스' && fm.model_st[0].checked == 'true' && fm.est_st.value == 'Y'){
					fm.cost_st.value = '1';
					fm.est_st.value = 'N';
				}
				
			<%}%>
			
			<%if(car.getTint_bn_yn().equals("Y")){ //블랙박스 미제공 할인 (빌트인캠,고객장착..)%>
				<%if(tint_st.equals("3") || tint_st.equals("5")){%>
				if(fm.com_nm.value == '이노픽스'){
					alert('블랙박스 미제공 할인 (빌트인캠,고객장착..)이 있습니다. 블랙박스 입력을 할 수 없습니다.'); return;
				}
				<%}%>
			<%}%>
		
			if(fm.cost_st.value == '')		{ alert('비용부담을 선택하십시오.');		return;}
			if(fm.est_st.value == '')		{ alert('견적반영을 선택하십시오.');		return;}
			if(fm.est_st.value == 'Y' && toInt(fm.est_m_amt.value) == 0)	{ alert('견적반영이면 월반영금액을 입력해주세요.'); 	fm.est_m_amt.focus();  return;}					
			if(fm.sup_est_dt.value == '')		{ alert('작업마감요청일시를 입력하십시오.');		fm.sup_est_dt.focus();  return;}
			
		}

		
				
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_c_u_tint2_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}			
	
	//스캔등록
	function scan_file(tint_st, content_code, content_seq){
		window.open("/fms2/car_tint/reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//모델선택 : 추천모델  && 설치업체 : 수입차, 고객장착 아니면 입력불가 처리(2018.02.06)
	function check_b_box(){
		var model_st = $("input[name='model_st']:checked").val();
		var off_id = $("#off_id").val();
		if(model_st=="1" && !(off_id=="999991수입차" || off_id=="999992고객장착")){
			$("#compName, #modelName").val("");
			$("#compName, #modelName").attr("readOnly",true);
		}else{
			$("#compName, #modelName").attr("readOnly",false);
		}
		//이동형충전기 기본설치비용세팅(2018.04.24)
		if(off_id == "011281파워큐브코리아"){	$("#tint_amt").val(parseDecimal("181818"));	}
		else{								$("#tint_amt").val("0");					}
	}
			
	function update_serial_no(){
		var fm = document.form1;
		if(confirm('일련번호를 수정하시겠습니까?')){
			fm.action = 'lc_c_u_tint2_a.jsp';
			fm.cmd.value = 'update_serial_no';
			fm.target = 'i_no';
			fm.submit();
		}
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
<form action='lc_c_u_tint2_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='<%=from_page2%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="tint_st" 			value="<%=tint_st%>">
  <input type='hidden' name="cmd" 			value="">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>용품의뢰 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	<td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
  	    </table>
	 </td>
    </tr>  	  
    <tr>
	<td align="right">&nbsp;</td>
    <tr>
    <input type='hidden' name="tint_no"	 		value="<%=tint.getTint_no()%>">    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2><%if(tint_st.equals("3")){%>블랙박스 <%}else if(tint_st.equals("4")){%>내비게이션 <%}else if(tint_st.equals("5")){%>기타용품<%}else if(tint_st.equals("6")){%>이동형 충전기<%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>설치구분</td>
                    <td width='37%' >&nbsp;             
                        <%if(tint_st.equals("3")){%>           
                            <%if(tint.getTint_no().equals("")) tint.setTint_yn(car.getTint_b_yn()==""?"N":car.getTint_b_yn()); %>
                            <%if(tint.getTint_no().equals("") && tint.getTint_yn().equals("N")) tint.setTint_yn(car.getServ_b_yn()==""?"N":car.getServ_b_yn()); %>
                        <%}else if(tint_st.equals("4")){%>
                            <%if(tint.getTint_no().equals("")) tint.setTint_yn(car.getTint_n_yn()==""?"N":car.getTint_n_yn()); %>                            
                        <%}%>
                        <input type='radio' name="tint_yn" value='Y' onClick="javascript:cng_input()" <%if(tint.getTint_yn().equals("Y"))%>checked<%%>>설치
                        <input type='radio' name="tint_yn" value='N' onClick="javascript:cng_input()" <%if(tint.getTint_yn().equals("N"))%>checked<%%>>설치하지않음
                    </td>
                    <td class='title'>설치업체</td>
                    <td width='37%'>&nbsp;
                        <select name='off_id' id="off_id" class='default' onchange="javascript:check_b_box();">
                            <option value="">선택</option>
                            <option value="002849다옴방"       <%if(tint.getOff_id().equals("002849"))%>selected<%%>>다옴방(수도권)		</option>
                            <option value="010255스마일TS"     <%if(tint.getOff_id().equals("010255"))%>selected<%%>>스마일TS(부산)	</option>
                            <option value="002850유림카랜드"     <%if(tint.getOff_id().equals("002850"))%>selected<%%>>유림카랜드(부산)	</option>
                            <option value="010937주식회사미성테크" <%if(tint.getOff_id().equals("010937"))%>selected<%%>>주식회사미성테크(대전)</option>
                            <option value="008501아시아나상사"    <%if(tint.getOff_id().equals("008501"))%>selected<%%>>아시아나상사(대구)	</option>
                            <option value="008680용용이자동차용품점" <%if(tint.getOff_id().equals("008680"))%>selected<%%>>용용이자동차용품점(광주)	</option>
                            <option value="011281파워큐브코리아" <%if(tint.getOff_id().equals("011281"))%>selected<%%>>파워큐브코리아	</option>
                            <option value="999991수입차"       <%if(tint.getOff_id().equals("999991"))%>selected<%%>>수입차	        </option>
                            <option value="999992고객장착"      <%if(tint.getOff_id().equals("999992"))%>selected<%%>>고객장착	</option>	 
                            <%if(tint.getOff_id().equals("008692")){%>
				            	<option value="008692주식회사오토카샵" <%if(tint.getOff_id().equals("008692"))%>selected<%%>>주식회사 오토카샵</option>
	                        <%}%>
							<%if(tint.getOff_id().equals("002851")){%>
        		                <option value="002851웰스킨천연가죽"  <%if(tint.getOff_id().equals("002851"))%>selected<%%>>웰스킨천연가죽	</option>
			                <%}%>
							<%if(tint.getOff_id().equals("008514")){%>
			                    <option value="008514대호4WD상사"   <%if(tint.getOff_id().equals("008514"))%>selected<%%>>대호4WD상사	</option>
			                <%}%>
                        </select>
                    </td>
                </tr>  
                <%if(tint_st.equals("3")){%>
                <tr> 
                    <td class='title'>모델선택</td>
                    <td width='37%' >&nbsp;                        
                        <%if(tint.getTint_no().equals("")) tint.setModel_st("1"); %>                        
                        <input type='radio' name="model_st" value='1' <%if(tint.getModel_st().equals("1"))%>checked<%%> onclick="javascript:check_b_box();">추천모델
                        <input type='radio' name="model_st" value='2' <%if(!tint.getModel_st().equals("1"))%>checked<%%> onclick="javascript:check_b_box();">기타선택모델
                        (<input type='text' name='model_st_etc' size='17' <%if(!tint.getModel_st().equals("1")){%>value='<%=tint.getModel_st()%>'<%}%> class='default' >)
                    </td>
                    <td class='title'>채널선택</td>
                    <td width='37%'>&nbsp;
                        <%if(tint.getTint_no().equals("")){
                        		tint.setChannel_st("2"); 
  	                      		if(AddUtil.parseInt(cm_bean.getJg_code()) >= 9141 && AddUtil.parseInt(cm_bean.getJg_code()) <= 9242)							tint.setChannel_st("1"); //1톤~5톤 트럭
    	                    	if(cm_bean.getJg_code().equals("9331") || cm_bean.getJg_code().equals("9332") || cm_bean.getJg_code().equals("9421"))			tint.setChannel_st("1"); //라보,코란도스포츠
  	                      		if(AddUtil.parseInt(cm_bean.getJg_code()) >= 9017211 && AddUtil.parseInt(cm_bean.getJg_code()) <= 9025417)						tint.setChannel_st("1"); //1톤~5톤 트럭
    	                    	if(cm_bean.getJg_code().equals("9033111") || cm_bean.getJg_code().equals("9033112") || cm_bean.getJg_code().equals("9045021"))	tint.setChannel_st("1"); //라보,코란도스포츠
                          }                        
                        %>                                                
                        <input type='radio' name="channel_st" value='1' <%if(tint.getChannel_st().equals("1"))%>checked<%%>>1채널
                        <input type='radio' name="channel_st" value='2' <%if(tint.getChannel_st().equals("2"))%>checked<%%>>2채널
                    </td>
                </tr>   
                <%}%>                           
                <tr> 
                    <td width='13%' class='title'><%if(tint_st.equals("5")){%>상품명<%}else{%>제조사명<%}%></td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='40' value='<%=tint.getCom_nm()%>' class='default input' id="compName">
                        <br>* <%if(tint_st.equals("5")){%>상품명<%}else{%>제조사명<%}%> 이외의 내용을 입력하지 마십시오.
                    </td>
                    <td width='13%' class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='30' value='<%=tint.getModel_nm()%>' class='default input' id="modelName" >
                        <input type="hidden" name="model_id" value="<%=tint.getModel_id()%>" id="modelId">
                        <%if(tint_st.equals("3")){%>
                        <input type="button" name="change-md-btn" class="button" value="모델 선택" onclick="openSearchPop()"/>
                        <%}%>
                        <br>* 모델명 이외의 내용을 입력하지 마십시오.                        
                    </td>
                </tr>
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
                        <%if(tint.getTint_no().equals("")) tint.setCost_st("1"); %>
                        <select name='cost_st' class='default'>
                            <option value="">선택</option>
                            <option value="1" <%if(tint.getCost_st().equals("1"))%>selected<%%>>없음</option>
                            <%if(!base.getBus_st().equals("2") && !base.getBus_st().equals("7")){%>
        		    <option value="2" <%if(tint.getCost_st().equals("2"))%>selected<%%>>고객</option>
        		    <option value="4" <%if(tint.getCost_st().equals("4"))%>selected<%%>>당사</option>
        		    <%}%>
        		    <option value="5" <%if(tint.getCost_st().equals("5"))%>selected<%%>>에이전트</option>
                        </select>                                        
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;                        
                        <%if(tint_st.equals("3")){%>
                            <%if(tint.getTint_no().equals("") && car.getTint_b_yn().equals("Y")) tint.setEst_st("Y"); %>
                            <%if(tint.getTint_no().equals("") && car.getTint_b_yn().equals("Y") && AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_B"))==null?"":String.valueOf(esti_exam.get("AX117_B"))) >0) tint.setEst_m_amt(AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_B")))); %>
                        <%}else if(tint_st.equals("4")){%>
                            <%if(tint.getTint_no().equals("") && car.getTint_n_yn().equals("Y")) tint.setEst_st("Y"); %>
                            <%if(tint.getTint_no().equals("") && car.getTint_n_yn().equals("Y") && AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_N"))==null?"":String.valueOf(esti_exam.get("AX117_N"))) >0) tint.setEst_m_amt(AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_N")))); %>
                        <%}else{%>
                            <%if(tint.getTint_no().equals("")) tint.setEst_st("N"); %>
                        <%}%>
                        <select name='est_st' class='default'>
                            <option value="">선택</option>
                            <option value="Y" <%if(tint.getEst_st().equals("Y"))%>selected<%%>>반영</option>
        		    <option value="N" <%if(tint.getEst_st().equals("N"))%>selected<%%>>미반영</option>        		    
                        </select>     
                        (반영:월<input type='text' name='est_m_amt' size='10' class='defaultnum' value='<%=AddUtil.parseDecimal(tint.getEst_m_amt())%>'>원)
                    </td>
                </tr>
                <%//if(tint_st.equals("5")){%>
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint.getEtc()%>' class='default' ></td>
                </tr>                  
                <%//}%>                
                
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        		<input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>시까지 요청함                    
                    </td>
                </tr>                                          
                <tr> 
                    <td class='title'>설치일자</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_dt' maxlength='10' class='<%if(tint.getOff_id().equals("002849")){%>whitetext<%}else{%>default<%}%>' <%if(tint.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
                        <input type='text' size='2' name='sup_h' class='<%if(tint.getOff_id().equals("002849")){%>whitetext<%}else{%>default<%}%>' <%if(tint.getSup_dt().length()==10){%>value='<%=tint.getSup_dt().substring(8)%>'<%}%>>
                        시	
                    </td>
                    <td class='title'>설치비용</td>                    
                    <td>&nbsp;
                        <input type='text' size='10' maxlength='10' name='tint_amt' id='tint_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(tint.getTint_amt())%>'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>                        
                </tr>          
                <tr> 
                    <td class='title'>일련번호</td>
                    <td>&nbsp;
                        <input type='text' name='serial_no' id="serialNo" size='40' value='<%=tint.getSerial_no()%>' class='<%if(tint.getOff_id().equals("002849")){%>text<%}else{%>default<%}%>' >
                    	<%if(base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || nm_db.getWorkAuthUser("보험업무", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || nm_db.getWorkAuthUser("전산팀", user_id)){%>
                    		&nbsp;<a href="javascript:update_serial_no()" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
                    	<%}%> 
                    </td>
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
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a><br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('<%=tint.getTint_st()%>','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>  
                    
                    <%	}%>                             
                    </td>
                </tr>                
            </table>
	</td>
    </tr>    
    <tr>
	<td>* 비용부담 : 견적 미반영인 경우 별도 비용이 발생하면 그 비용을 부담할 주체가 누구 인지를 입력하세요. 제조사 썬팅은 없음입니다.</td>
    </tr>	
    <tr>
	<td>* 일련번호 : Serial number, 설치후 설치업체에서 등록합니다. 설치업체가 수입차이거나 고객장착인 경우에는 딜러사나 고객으로 부터 일련번호를 전달받아 최초영업자가 직접 입력합니다. </td>
    </tr>	
    <tr>
	<td>* 첨부파일 : 설치후 설치업체에서 등록한 파일</td>
    </tr>	
    <tr>
	<td align='center'>&nbsp;</td>
    </tr>	
    <tr>
        <td align='center'>
        <%if(tint.getReq_dt().equals("") && tint.getPay_dt().equals("")){%>
	    <%	if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	    <%	}%>
	    <%}%>
	    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
  	</td>
    </tr>            
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	<%if(!tint_st.equals("5")){%>
	cng_input();
	<%}%>
//-->
</script>
</body>
</html>